## Super Puzzle Fighter 2 X' (X Prime)

This patch aims to recreate all of the balance changes Sirlin made to Super Puzzle Fighter 2 HD Remix's X' mode in the original game.

What this entails is:
* Ryu, Sakura, Morrigan, Hsien-ko, and Felicia have had their drop patterns changed.
* Chun-li now sends 120% of normal garbage.
* Devilot now sends 85% of normal garbage (increased from ⌊¼x⌋ + ⌊½x⌋).
* Akuma now sends 100% of normal garbage (increased from ⌊¼x⌋ + ⌊½x⌋), but receives 120% of normal garbage.
* Diamonds always send 80% of normal garbage. The diamond trick has been removed.
* The handicap system has been disabled by default, due to it not being present in HD Remix.

For a more detailed rundown on all of the balance changes,
you can read [Sirlin's own writeup](https://www.sirlin.net/articles/balancing-puzzle-fighter)
of his balance changes on his website.

In addition, a few extra changes for ease of use have been made:
* Devilot, Akuma, and Dan can be selected by moving the cursor down from the bottom row—no codes necessary.
* Free Play has been enabled by default.
* `X'` is displayed on screen during gameplay (between the win counters) to differentiate from vanilla.

## Download

_If you just want to play, not make any further modifications to the code:_

See [Releases](https://github.com/KScl/puzzle-fighter-x-prime/releases) for IPS patches. Unzip the `spf2t` rom set into a folder, and apply each patch to the rom that it's named after. After patching, zip all of the roms together again.

If you want to play on Fightcade, you'll need to rename the roms to match the names given below, and ensure that each rom matches the hashes listed below. Then zip just these six roms together into an archive called `spf2xpri.zip`.

```
pzfe.03 -> pzfxp.03   CRC32(f205a7da) SHA1(3fa4b7ecc54d239061148781ecdc469f975122af)
pzf.04  -> pzfxp.04   CRC32(4177aadd) SHA1(c218d2446f3fc348a952a8b7a75dace864fed0f9)
pzf.14m -> pzfxp.14m  CRC32(930b0ec7) SHA1(60b786dca5a943010b0273a5f6d084453a3bd121)
pzf.16m -> pzfxp.16m  CRC32(769377ad) SHA1(eb86026999ab01e74a975d03305d637899615bf4)
pzf.18m -> pzfxp.18m  CRC32(5a79233f) SHA1(31ca4744be2d7860351dc56fbb3e03e0ddf35b09)
pzf.20m -> pzfxp.20m  CRC32(42cfc9e2) SHA1(04cadb017163732f5ba022733d0cb442ce3cada3)
```

## Compiling from Scratch

_You only need to do this if you've made changes to the code. If you just want to play, look at the above section instead._

The included Python script was tested with Python 3.7, and requires `binutils-m68k-linux-gnu` to function.

You'll need X.C.O.P.Y. or any other tool that can decrypt the CPS2 ROMs to be able to patch it.

1. Decrypt `pzfe.03` with X.C.O.P.Y. (or whatever other tool you're using).<br />
This step is required to be able to patch program data.

2. Patch the decrypted program ROM from above with code_03.patch.s.<br />
The command for this is `python3.7 patch.py ./src/code_03.patch.s [decrypted.rom]`.<br />
If you're not using X.C.O.P.Y., you may need to append the `-b` flag to byte swap the patch output.

3. Re-encrypt the patched ROM.<br />
This step is necessary because data is *not* encrypted in CPS2 ROMs.

4. Patch the re-encrypted `pzfe.03` with data_03.patch.s. Make sure to enable byte-swap mode.<br />
The command for this is `python3.7 patch.py -b ./src/data_03.patch.s [pzfe.03]`.

5. Patch `pzf.04` with data_04.patch.s. Make sure to enable byte-swap mode.<br />
The command for this is `python3.7 patch.py -b ./src/data_04.patch.s [pzf.04]`.<br />
Decrypting this ROM is not necessary as it contains only data.

6. Apply the IPS patches in the `gfx` folder to their respective graphics ROMs.

If everything went correctly, the title screen should show `X' Rebalance Patch`,
and `X'` will be shown on screen during gameplay.
