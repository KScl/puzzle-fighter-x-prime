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

See [Releases](https://github.com/KScl/puzzle-fighter-x-prime/releases) for IPS patches.

## Compilation / Patching
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
