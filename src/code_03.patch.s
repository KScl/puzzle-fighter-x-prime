|
| Encryption keys for spf2t (euro):
| key1=$DDE26F09
| key2=$55821EE7
|


| =============================================================================
| GARBAGE REVAMP
| =============================================================================
| Allows for finer control of damage / per player send & receive rates
| Diamond trick patched out, powerset to 80%

| !!! INSERT AT: 00FDA4
| !!! LENGTH: 0xAC
| %d3 holds the total calculated score
| %a5 holds global settings
| %a6 holds the player structure
lea    0x36A(%pc), %a1      | ($10110) load in margin time table
lea    (%a1), %a2           | ($10110) see above (avoid working with the pc, ugh)

|
| MARGIN TIME
|
move.w 0x340(%a6), %d0      | move in amount of time in seconds
addi.w #0xF, %d0            | add 15 so margin time starts a bit earlier
margin_time_loop:
  move.w (%a1), %d1         | get margin time value
  cmp.w  %d1, %d0           | threshold vs. current time
  ble.b  margin_loop_exit   | branch out if time threshold not reached
  lea    2(%a1), %a1        | advance to next threshold
  bra.b  margin_time_loop
margin_loop_exit:
moveq  #0xA, %d1            | denominator for mul_frac (power/10)
move.w 0x20(%a1), %d2       | get margin time amount (already set up for mul_frac)
jsr    mul_frac

|
| OPPONENT RECEIVE POWER
|
moveq  #0x14, %d1           | denominator for mul_frac (power/20)
lea    0x10(%a2), %a2       | ($10120) load in character recv power table
movea.l 0x160(%a6),%a1      | get opponent's player structure
moveq  #0, %d2              | clean register
move.b 0x82(%a1), %d2       | load character num
move.b (%a2, %d2), %d2      | move character power in place of mul_frac numerator
jsr    mul_frac

|
| CHARACTER SEND POWER
|
lea    0x20(%a2), %a2       | ($10140) load in character send power table
moveq  #0, %d2              | clean register
move.b 0x82(%a6), %d2       | load character num
move.b (%a2, %d2), %d2      | move character power in place of mul_frac numerator
jsr    mul_frac

bra.b  over_mul_frac        | move past sub-function
| mul_frac: multiplies by an arbitrary fraction
| inputs:   [%d1: denominator, %d2: numerator, %d3: input number]
| returns:  [%d3: operation result]
| clobbers: [%d0: working variable]
mul_frac:
  moveq #0x0, %d0
  cmp.w %d1,%d2
  beq mf_early_exit
mf_loop_a:
    sub.w  %d1, %d3
    bmi.b  mf_loop_a_exit
    add.w  %d2, %d0
    bra.b  mf_loop_a
mf_loop_a_exit:
  move.w %d0, %d3
mf_early_exit:
  rts
over_mul_frac:

|
| DIAMOND PENALTY
|
moveq  #0xA, %d1            | denominator for mul_frac (power/10)
tst.b  0x1FA(%a6)           | Check if diamond used flag is set
beq diamond_penalty_skip
  moveq #0x8, %d2           | setup 8/10 mul
  jsr mul_frac
diamond_penalty_skip:

|
| DAMAGE LEVEL SOFT DIP
|
lea    0x10(%a2), %a2       | ($10150) load in soft dip table
move.b 0xA1(%a5), %d2       | load in soft dip value
andi.w #7, %d2
add.w  %d2, %d2             | left shift by 1 to index properly
move.w (%a2,%d2.w), %d2     | retrieve actual multiplier from soft dip value
jsr    mul_frac

|
| FINAL CALCULATION
|
moveq  #0x64, %d1           | setup final division
moveq  #0x1,  %d2           | by 1/100
jsr    mul_frac
move.w %d3, %d0             | move to where the game expects it
nop                         | nop until end

| !!! INSERT AT: 0119A6
| !!! LENGTH: 0x40
| Diamond trick patch
| %a0 (top) and %a1 (bottom) hold the location the pieces dropped
| %a6 holds the player structure
cmpi.w #0x5, 0x152(%a6)     | Bottom piece is diamond?
beq.b  bottom_diamond
cmpi.w #0x5, 0x154(%a6)     | Top piece is diamond?
bne.b  not_diamond          | Skip all this code then
move.w 0x10(%a0),%d2        | Set piece under diamond (top variant)
bra.b  top_diamond

bottom_diamond:
move.w 0x10(%a1),%d2        | Set piece under diamond (bottom variant)
top_diamond:                | Top diamond path merges here
move.b #0x1, 0x1FA(%a6)     | Set marker for damage calculations
move.b #0x1, 0x38C(%a6)     | (Unknown other diamond flag)
cmpi.w #0xFF, %d2           | Was the diamond teched?
bne.b  not_diamond
move.w #0x5, %d2            | Tell code after to do diamond stuff (not teched)

not_diamond:
nop                         | Just a jump point


| =============================================================================
| CHARACTER SELECT
| =============================================================================
| Changes character select to allow selection of Akuma/Devilot/Dan freely

| !!! INSERT AT: 0789E
| !!! LENGTH: 0x56
| Revamped character select movement
| %d3 is the player's input (1:R 2:L 4:D 8:U)
lea    0x03F800.l, %a0      | Load in offset table table
moveq  #0, %d4              | Clear out d4 for byte use
move.b (%a0,%d3.w), %d4     | Get movement offset
beq.b  no_movement
add.b  0x1(%a4), %d4        | Add current cursor location to offset

| %d4 now holds a proper offset into the nav table we made
lea    0x40(%a0), %a0       | Move to navigation table
move.b (%a0,%d4.w), %d0     | Get character at new location
cmpi.b #0xFF, %d0           | Test for validity
beq    no_movement

| Replicate behavior of original select
move.b %d4, 0x1(%a4)
move.b %d0, (%a4)
move.b %d0, 0x82(%a6)
jsr    0x2B572.l
moveq  #0x17, %d0
jsr    0x14390.l
jsr    0x8532.l

no_movement:
rts                         | Exit function
nop                         | Erase everything else

| !!! INSERT AT: 075B8
| !!! LENGTH: 0xA
jsr    0x3F080.l            | Hook into function

| !!! INSERT AT: 3F080
| !!! LENGTH: 0x10
lea    0x03F880.l, %a0      | Load location table
move.b (%a0,%d0.w), -0x737d(%a5)
rts

| !!! INSERT AT: 076B4
| !!! LENGTH: 0xA
jsr    0x3F090.l            | Hook into function

| !!! INSERT AT: 3F090
| !!! LENGTH: 0x10
lea    0x03F880.l, %a0      | Load location table
move.b (%a0,%d0.w), -0x7379(%a5)
rts


| =============================================================================
| NEW TEXT DRAWING
| =============================================================================

| Draw X' to the screen during matches
| !!! INSERT AT: 16C0C
| !!! LENGTH: 0x6
jsr    0x3F000.l            | Hook into function (name drawing)

| !!! INSERT AT: 3F000
| !!! LENGTH: 0x3E
move.l %sp, %d0             | move stack pointer into d0
cmpi.l #0xFF0700, %d0       | compare location in stack
bpl.b  d_player_match       | over ff0700 -> human player match
lea    0x900EF0.l, %a0      | attract location (out of the way of the logo)
bra.b  d_ai_match
d_player_match:
lea    0x900BF0.l, %a0      | human player location (center)
d_ai_match:
move.l #0x00E80019, (%a0)
move.l #0x00F80019, 4(%a0)
lea    0x80(%a0), %a0       | move right 1 tile
move.l #0x00870019, (%a0)
move.l #0x00970019, 4(%a0)
jmp    0x2DAC6.l            | Jump back to intended jump point

| Hack identification on title screen
| !!! INSERT AT: 2DE8
| !!! LENGTH: 0x8
jsr    0x3F100.l            | Hook into function (trademark/copyright info draw)
nop                         | Clear extra bytes from overwriting previous jsr

| !!! INSERT AT: 3F100
| !!! LENGTH: 0x4A
lea    0x7FE(%pc), %a0      | ($3F900) load in text
lea    0x900870.l, %a1      | load in text location

id_text_loop:
  moveq  #0, %d0
  move.b (%a0), %d0
  beq.b  id_text_finish     | Leave loop on nul byte

  | Get start tile from character
  move.w %d0, %d1           | Move into working register
  andi.w #0x0F, %d0         | Keep lower 4 bits in original register
  andi.w #0xF0, %d1         | Keep higher 4 bits in working register
  add.w  %d1, %d1
  addi.w #0x40, %d1
  add.w  %d1, %d0           | Add registers together to get whole starting tile

  | Output character to screen
  move.w %d0, (%a1)         | Top text tile
  move.w #0x1F, 2(%a1)      | Palette info / flags
  addi.w #0x10, %d0         | Move to bottom tile
  move.w %d0, 4(%a1)        | Bottom text tile
  move.w #0x1F, 6(%a1)      | Palette info / flags
  lea    0x80(%a1), %a1     | Move right 1 tile
  lea    1(%a0), %a0        | Move to next character
  bra.b  id_text_loop

id_text_finish:
moveq  #0x53, %d0           | Load in TM text index
jmp    0x5670.l             | Jump to original text drawing function, let original function finish
