| !!! INSERT AT: 01FA12
| !!! LENGTH: 0x3A
| Hack identification
.ascii "\x0A\x24\x01 SUPER PUZZLE"
.ascii " FIGHTER 2  X' \x7F"
.ascii "\x12\x30\x01\x32 1 0 8 2 3\x7F\x14"
.ascii "<\x01K . S .\x00"


| =============================================================================
| GAME CONFIGURATION
| =============================================================================
| Default settings, etc.

| !!! INSERT AT: 01E936
| !!! LENGTH: 0x18
| Default soft dips
dc.b 0x12, 0x01             | Free Play, continue on
dc.b 0x00, 0x01
dc.b 0x01, 0x00
dc.b 0x00, 0x02
dc.b 0x00, 0x00
dc.b 0x00, 0x00
dc.b 0x00, 0x00
dc.b 0x00, 0x00
dc.b 0x03, 0x01
dc.b 0x01, 0x01
dc.b 0x01, 0x02
dc.b 0x01, 0x00             | Join-in on, Handicap off

| !!! INSERT AT: 010110
| !!! LENGTH: 0x50
| patching tables (data, not code)
                            | Margin time thresholds (shortened)
dc.w 0x005A, 0x0078         | 75 sec + 30 sec for each
dc.w 0x0096, 0x00B4
dc.w 0x00D2, 0x00F0
dc.w 0x010E, 0x0B9A
                            | Character receive rate table
dc.b 0x14, 0x14, 0x14, 0x14 | Morrigan, Chun-Li, Ryu, Ken
dc.b 0x14, 0x14, 0x14, 0x14 | Hsien-ko, Donovan, Felicia, Sakura
dc.b 0x14, 0x18, 0x14, 0x14 | Devilot, Akuma, Dan
dc.b 0x14, 0x14, 0x14, 0x14
                            | Margin time numerator (shortened)
dc.w 0x000A, 0x000B         | Numerators for n/10 multiplication
dc.w 0x000C, 0x000D
dc.w 0x000E, 0x000F
dc.w 0x0010, 0x0011
                            | Character send rate table
dc.b 0x14, 0x18, 0x14, 0x14 | Morrigan, Chun-Li, Ryu, Ken
dc.b 0x14, 0x14, 0x14, 0x14 | Hsien-ko, Donovan, Felicia, Sakura
dc.b 0x11, 0x14, 0x14, 0x14 | Devilot, Akuma, Dan
dc.b 0x14, 0x14, 0x14, 0x14
                            | Damage level numerator
dc.w 0x0008, 0x000A         | Numerators for n/10 multiplication
dc.w 0x000D, 0x000F
dc.w 0x000F, 0x000F
dc.w 0x000F, 0x000F


| =============================================================================
| DROP PATTERNS
| =============================================================================
| Blue:1 Yellow:2 Green:3 Red:4
| Read backwards; first row is the bottommost one

| !!! INSERT AT: 010188
| !!! LENGTH: 0xC0
| Morrigan's drop pattern
dc.w 1, 2, 4, 4, 2, 1, 0, 0
dc.w 1, 2, 3, 4, 2, 1, 0, 0
dc.w 2, 1, 3, 4, 1, 2, 0, 0
dc.w 2, 1, 3, 3, 1, 2, 0, 0
dc.w 1, 2, 4, 4, 2, 1, 0, 0
dc.w 1, 2, 3, 4, 2, 1, 0, 0
dc.w 2, 1, 3, 4, 1, 2, 0, 0
dc.w 2, 1, 3, 3, 1, 2, 0, 0
dc.w 1, 2, 4, 4, 2, 1, 0, 0
dc.w 1, 2, 3, 4, 2, 1, 0, 0
dc.w 2, 1, 3, 4, 1, 2, 0, 0
dc.w 2, 1, 3, 3, 1, 2, 0, 0

| !!! INSERT AT: 010308
| !!! LENGTH: 0xC0
| Ryu's drop pattern
dc.w 4, 3, 1, 2, 4, 3, 0, 0
dc.w 4, 3, 1, 2, 4, 3, 0, 0
dc.w 1, 2, 4, 3, 1, 2, 0, 0
dc.w 4, 3, 1, 2, 4, 3, 0, 0
dc.w 4, 3, 1, 2, 4, 3, 0, 0
dc.w 4, 3, 1, 2, 4, 3, 0, 0
dc.w 1, 2, 4, 3, 1, 2, 0, 0
dc.w 4, 3, 1, 2, 4, 3, 0, 0
dc.w 4, 3, 1, 2, 4, 3, 0, 0
dc.w 4, 3, 1, 2, 4, 3, 0, 0
dc.w 1, 2, 4, 3, 1, 2, 0, 0
dc.w 4, 3, 1, 2, 4, 3, 0, 0

| !!! INSERT AT: 010488
| !!! LENGTH: 0xC0
| Hsien-ko's drop pattern
dc.w 1, 2, 1, 3, 4, 3, 0, 0
dc.w 1, 1, 3, 4, 2, 3, 0, 0
dc.w 1, 3, 4, 2, 1, 3, 0, 0
dc.w 1, 4, 2, 1, 3, 3, 0, 0
dc.w 1, 2, 1, 3, 4, 3, 0, 0
dc.w 1, 1, 3, 4, 2, 3, 0, 0
dc.w 1, 3, 4, 2, 1, 3, 0, 0
dc.w 1, 4, 2, 1, 3, 3, 0, 0
dc.w 1, 2, 1, 3, 4, 3, 0, 0
dc.w 1, 1, 3, 4, 2, 3, 0, 0
dc.w 1, 3, 4, 2, 1, 3, 0, 0
dc.w 1, 4, 2, 1, 3, 3, 0, 0

| !!! INSERT AT: 010608
| !!! LENGTH: 0xC0
| Felicia's drop pattern
dc.w 3, 4, 4, 1, 1, 2, 0, 0
dc.w 2, 4, 1, 4, 1, 3, 0, 0
dc.w 3, 4, 1, 4, 1, 2, 0, 0
dc.w 2, 1, 1, 4, 4, 3, 0, 0
dc.w 3, 4, 4, 1, 1, 2, 0, 0
dc.w 2, 4, 1, 4, 1, 3, 0, 0
dc.w 3, 4, 1, 4, 1, 2, 0, 0
dc.w 2, 1, 1, 4, 4, 3, 0, 0
dc.w 3, 4, 4, 1, 1, 2, 0, 0
dc.w 2, 4, 1, 4, 1, 3, 0, 0
dc.w 3, 4, 1, 4, 1, 2, 0, 0
dc.w 2, 1, 1, 4, 4, 3, 0, 0

| !!! INSERT AT: 0106C8
| !!! LENGTH: 0xC0
| Sakura's drop pattern
dc.w 3, 4, 4, 4, 4, 2, 0, 0
dc.w 3, 1, 1, 1, 1, 2, 0, 0
dc.w 2, 4, 4, 4, 4, 3, 0, 0
dc.w 2, 1, 1, 1, 1, 3, 0, 0
dc.w 3, 4, 4, 4, 4, 2, 0, 0
dc.w 3, 1, 1, 1, 1, 2, 0, 0
dc.w 2, 4, 4, 4, 4, 3, 0, 0
dc.w 2, 1, 1, 1, 1, 3, 0, 0
dc.w 3, 4, 4, 4, 4, 2, 0, 0
dc.w 3, 1, 1, 1, 1, 2, 0, 0
dc.w 2, 4, 4, 4, 4, 3, 0, 0
dc.w 2, 1, 1, 1, 1, 3, 0, 0


| =============================================================================
| CHARACTER SELECT
| =============================================================================
| Tables for new character select behavior.

| !!! INSERT AT: 3F800
| !!! LENGTH: 0x10
| Menu navigation offsets
dc.b 0x00, 0x01, 0xFF, 0x00
dc.b 0x08, 0x00, 0x00, 0x00
dc.b 0xF8, 0x00, 0x00, 0x00
dc.b 0x00, 0x00, 0x00, 0x00

| !!! INSERT AT: 3F840
| !!! LENGTH: 0x28
| New character select navigation table
dc.b 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
dc.b 0x02, 0x01, 0x07, 0x03, 0xFF, 0xFF, 0xFF, 0xFF
dc.b 0x00, 0x04, 0x05, 0x06, 0xFF, 0xFF, 0xFF, 0xFF
dc.b 0x08, 0x09, 0x0A, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
dc.b 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF

| !!! INSERT AT: 3F880
| !!! LENGTH: 0x10
| Start points for characters in new table
dc.b 0x10, 0x09, 0x08, 0x0B | Morrigan, Chun-Li, Ryu, Ken
dc.b 0x11, 0x12, 0x13, 0x0A | Hsien-ko, Donovan, Felicia, Sakura
dc.b 0x18, 0x19, 0x1A, 0x08 | Devilot, Akuma, Dan
dc.b 0x08, 0x08, 0x08, 0x08

| =============================================================================
| NEW TEXT
| =============================================================================
| New text strings...

| !!! INSERT AT: 3F900
| !!! LENGTH: 0x12
.ascii "X'"
.ascii " BALANCE PATCH\x00\x00"
