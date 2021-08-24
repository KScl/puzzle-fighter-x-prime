import subprocess
import os
import re
import argparse

argp = argparse.ArgumentParser(description="Patch arbitrary 68k program roms.")
argp.add_argument('file', help="source file")
argp.add_argument('target', help="file to patch")
argp.add_argument('-b', '--byteswap', action='store_true', help="swap bytes (required for most roms?)")
arguments = argp.parse_args()

if not os.path.exists(arguments.target):
	print("patch.py: target file doesn't exist -- aborting")
	exit()

if not os.path.exists("obj"):
	os.makedirs("obj")

subprocess.run(["m68k-linux-gnu-as", "-ahln=obj/patchdata.lst", "-oobj/asm.out", arguments.file])

if not os.path.exists("obj/asm.out"):
	print("patch.py: assembler errors found -- aborting")
	exit()

lst_file = open("obj/patchdata.lst")
lst = lst_file.readlines()
lst_file.close()

sta_ptrn = re.compile("\t\s*\|\s*!!!\s*INSERT AT:\s([0-9A-F]*)")
len_ptrn = re.compile("\t\s*\|\s*!!!\s*LENGTH:\s0x([0-9A-F]*)")
byte_ptrn = re.compile("^([0-9A-F]{2})([0-9A-F]{2})(?:\s{1,5}|\s([0-9A-F]{2})([0-9A-F]{2}))$")

patch_start = -1
patch_length = -1
patch_in_progress = False
patch_count = 0

patches = {}
cur_patch = b''

def patch_end():
	global cur_patch, patches, patch_start, patch_length, patch_in_progress

	if len(cur_patch) < patch_length:
		print("patch %d: padding with nops" % patch_count)
		while len(cur_patch) < patch_length:
			cur_patch += b'\x71\x4E' if arguments.byteswap else b'\x4E\x71'

	if len(cur_patch) > patch_length:
		print("patch.py: patch %d: patch exceeds given length -- aborting" % patch_count)
		exit()

	patches[patch_start] = cur_patch

	patch_in_progress = False
	patch_start = -1
	patch_length = -1
	cur_patch = b''

for line in lst:
	if line[10] == ' ':
		sta_res = sta_ptrn.search(line)
		len_res = len_ptrn.search(line)
		if not sta_res and not len_res:
			continue

		if patch_in_progress:
			patch_end()

		if sta_res:
			patch_start = int(sta_res.group(1), 16)
		if len_res:
			patch_length = int(len_res.group(1), 16)
	else:
		if not patch_in_progress:
			patch_count += 1
			patch_in_progress = True

			if patch_start == -1:
				print("patch.py: patch %d: start not set -- aborting" % patch_count)
				exit()
			if patch_length == -1:
				print("patch.py: patch %d: length not set -- aborting" % patch_count)
				exit()
			print("patch %d: [%06x-%06x)" % (patch_count, patch_start, patch_start+patch_length))

		byte_res = byte_ptrn.search(line[10:19])
		if not byte_res:
			print("patch.py: patch %d: unknown sequence found -- aborting" % patch_count)
			exit()

		blist = []
		if arguments.byteswap:
			blist = [int(i, 16) for i in byte_res.group(2, 1, 4, 3) if i is not None]
		else:
			blist = [int(i, 16) for i in byte_res.group(1, 2, 3, 4) if i is not None]
		cur_patch += bytes(blist)

if patch_in_progress:
	patch_end()

target_file = open(arguments.target, "r+b")
for p in patches:
	target_file.seek(p)
	target_file.write(patches[p])
target_file.close()
