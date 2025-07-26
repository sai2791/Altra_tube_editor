; Constants
osbyte_acknowledge_escape       = 126
osbyte_code                     = 136
osbyte_enter_language           = 142
osbyte_read_high_order_address  = 130
osbyte_read_himem               = 132
osbyte_read_oshwm               = 131
osbyte_read_text_cursor_pos     = 134
osbyte_read_vdu_variable        = 160
osbyte_set_cursor_editing       = 4
osfile_read_catalogue_info      = 5
osfind_close                    = 0
osfind_open_input               = 64
osfind_open_output              = 128
osfind_open_random_access       = 192
osword_write_io_memory          = 6

; Memory locations
l0000           = &0000
l0001           = &0001
l0002           = &0002
l0003           = &0003
l0004           = &0004
l0005           = &0005
l0006           = &0006
l000a           = &000a
l000b           = &000b
l000c           = &000c
l000d           = &000d
l000e           = &000e
l000f           = &000f
l0010           = &0010
l0011           = &0011
l001e           = &001e
l001f           = &001f
to_x_pos        = &0024
l0025           = &0025
l0026           = &0026
l0027           = &0027
l0028           = &0028
l0029           = &0029
l002a           = &002a
l002b           = &002b
l002c           = &002c
l003a           = &003a
l003b           = &003b
l003c           = &003c
l003d           = &003d
l003e           = &003e
l003f           = &003f
l0041           = &0041
l0042           = &0042
l0043           = &0043
l0044           = &0044
l0045           = &0045
l0046           = &0046
l0047           = &0047
l0048           = &0048
l0050           = &0050
l0051           = &0051
l0052           = &0052
l0053           = &0053
l0054           = &0054
l0055           = &0055
l0056           = &0056
l0057           = &0057
l0058           = &0058
tube_flag       = &006b
l006d           = &006d
l006e           = &006e
l006f           = &006f
l0070           = &0070
l0071           = &0071
l0072           = &0072
l0073           = &0073
l0074           = &0074
l0075           = &0075
l0079           = &0079
l007b           = &007b
l007c           = &007c
l007d           = &007d
l007e           = &007e
l007f           = &007f
l0080           = &0080
l0081           = &0081
l0082           = &0082
l0083           = &0083
l0084           = &0084
l0085           = &0085
l0086           = &0086
l0087           = &0087
himem           = &0089
l008c           = &008c
ext_flag        = &008e
os_text_ptr     = &00f2
l00fd           = &00fd
l00ff           = &00ff
l0110           = &0110
brkv            = &0202
l03ff           = &03ff
l0400           = &0400
l0500           = &0500
l0600           = &0600
l0601           = &0601
l0602           = &0602
l0603           = &0603
l0605           = &0605
l0606           = &0606
l06ff           = &06ff
l0700           = &0700
l0701           = &0701
l0909           = &0909
l450a           = &450a
user_via_orb_irb = &fe60
user_via_ddrb   = &fe62
lff0b           = &ff0b
lff0e           = &ff0e
osrdsc          = &ffb9
oseven          = &ffbf
gsinit          = &ffc2
gsread          = &ffc5
osfind          = &ffce
osgbpb          = &ffd1
osbput          = &ffd4
osbget          = &ffd7
osargs          = &ffda
osfile          = &ffdd
osrdch          = &ffe0
osasci          = &ffe3
osnewl          = &ffe7
oswrch          = &ffee
osword          = &fff1
osbyte          = &fff4
oscli           = &fff7

    org &8000

; Sideways ROM header
.pydis_start
.rom_header
.language_entry
    jmp language_handler                                              ; 8000: 4c cf 9b    L..

.service_entry
    jmp service_handler                                               ; 8003: 4c 3c 80    L<.

.rom_type
    equb &c2                                                          ; 8006: c2          .
.copyright_offset
    equb copyright - rom_header                                       ; 8007: 1f          .
.binary_version
    equb 3                                                            ; 8008: 03          .
; &8009 referenced 1 time by &8086
.title
    equs "ALTRA TUBE EDITOR"                                          ; 8009: 41 4c 54... ALT
.version
    equb 0                                                            ; 801a: 00          .
    equs "1.03"                                                       ; 801b: 31 2e 30... 1.0
.copyright
    equb 0                                                            ; 801f: 00          .
    equs "(C)ALTRA ROMS A.M.Lord 1985", 0                             ; 8020: 28 43 29... (C)

; &803c referenced 1 time by &8003
.service_handler
    cmp #9                                                            ; 803c: c9 09       ..
    beq c8069                                                         ; 803e: f0 29       .)
    cmp #4                                                            ; 8040: c9 04       ..
    bne return_1                                                      ; 8042: d0 3f       .?
.unknown_star_command
    pha                                                               ; 8044: 48          H
    tya                                                               ; 8045: 98          .
    pha                                                               ; 8046: 48          H
    lda (os_text_ptr),y                                               ; 8047: b1 f2       ..
    cmp #&54 ; 'T'                                                    ; 8049: c9 54       .T             ; command to start is just T
    bne no_extended_help                                              ; 804b: d0 33       .3
    iny                                                               ; 804d: c8          .
    lda (os_text_ptr),y                                               ; 804e: b1 f2       ..
    cmp #&21 ; '!'                                                    ; 8050: c9 21       .!             ; any other alpha letter means its not me
    bcs no_extended_help                                              ; 8052: b0 2c       .,
.sub_c8054
l8055 = sub_c8054+1
    lda #&0f                                                          ; 8054: a9 0f       ..
; &8055 referenced 1 time by &9be7
    sta user_via_ddrb                                                 ; 8056: 8d 62 fe    .b.
    stx user_via_orb_irb                                              ; 8059: 8e 60 fe    .`.
    lda #0                                                            ; 805c: a9 00       ..
    nop                                                               ; 805e: ea          .
    nop                                                               ; 805f: ea          .
    nop                                                               ; 8060: ea          .
    nop                                                               ; 8061: ea          .
    nop                                                               ; 8062: ea          .
    nop                                                               ; 8063: ea          .
    lda #osbyte_enter_language                                        ; 8064: a9 8e       ..
    jmp osbyte                                                        ; 8066: 4c f4 ff    L..            ; Enter language ROM X

; &8069 referenced 1 time by &803e
.c8069
    pha                                                               ; 8069: 48          H
    tya                                                               ; 806a: 98          .
    pha                                                               ; 806b: 48          H
    lda (os_text_ptr),y                                               ; 806c: b1 f2       ..
    cmp #&0d                                                          ; 806e: c9 0d       ..
    bne no_extended_help                                              ; 8070: d0 0e       ..
    jsr osnewl                                                        ; 8072: 20 e7 ff     ..            ; Write newline (characters 10 and 13)
    jsr print_rom_title                                               ; 8075: 20 84 80     ..
    lda #&20 ; ' '                                                    ; 8078: a9 20       .
    jsr sub_c808b                                                     ; 807a: 20 8b 80     ..
    jsr osnewl                                                        ; 807d: 20 e7 ff     ..            ; Write newline (characters 10 and 13)
; ***************************************************************************************
; &8080 referenced 3 times by &804b, &8052, &8070
.no_extended_help
    pla                                                               ; 8080: 68          h
    tay                                                               ; 8081: a8          .
    pla                                                               ; 8082: 68          h
; &8083 referenced 2 times by &8042, &8089
.return_1
    rts                                                               ; 8083: 60          `

; ***************************************************************************************
; &8084 referenced 2 times by &8075, &9c08
.print_rom_title
    ldy #0                                                            ; 8084: a0 00       ..
; &8086 referenced 1 time by &808f
.loop_c8086
    lda title,y                                                       ; 8086: b9 09 80    ...
    beq return_1                                                      ; 8089: f0 f8       ..
; &808b referenced 1 time by &807a
.sub_c808b
    jsr oswrch                                                        ; 808b: 20 ee ff     ..            ; Write character
    iny                                                               ; 808e: c8          .
    bne loop_c8086                                                    ; 808f: d0 f5       ..
; &8091 referenced 2 times by &8ae8, &9704
.c8091
    jmp refresh_screen_print_command_prompt                           ; 8091: 4c 4d 9c    LM.

    equb &0b, &23,   0, &ff, &ff, &23,   3, &ff, &25, &23,   3,   2   ; 8094: 0b 23 00... .#.
    equb &ff, &23,   3, &ff, &0a, &23, &3a, &ff, &ff, &23,   3, &ff   ; 80a0: ff 23 03... .#.
    equb &0e, &23, &22, &ff, &ff, &23,   3, &ff, &1d,   2,   0, &ff   ; 80ac: 0e 23 22... .#"
    equb   7,   2, &28, &ff, &27,   2, &28,   2,   7,   2, &28, &ff   ; 80b8: 07 02 28... ..(
    equb   8,   2,   0, &ff, &ff,   2, &28, &ff, &2d,   2, &22, &ff   ; 80c4: 08 02 00... ...
    equb &ff,   2, &28, &ff, &2a, &18,   0, &ff, &ff, &18, &21, &ff   ; 80d0: ff 02 28... ..(
    equb &24, &18, &21, &ff, &1c, &18, &21, &ff, &0c, &18,   0, &ff   ; 80dc: 24 18 21... $.!
    equb &ff, &18, &21, &ff, &10, &18, &22, &ff, &ff, &18, &21, &ff   ; 80e8: ff 18 21... ..!
    equb &2b,   1,   0, &ff, &ff,   1, &29,   0, &26,   1, &29,   0   ; 80f4: 2b 01 00... +..
    equb &1c,   1, &29, &ff, &0d,   1,   0, &ff, &ff,   1, &29, &ff   ; 8100: 1c 01 29... ..)
    equb &2f,   1, &22, &ff, &ff,   1, &29, &ff, &ff, &30, &ff        ; 810c: 2f 01 22... /."
    equs ":2019"                                                      ; 8117: 3a 32 30... :20
    equb &17, &3a, &36, &ff                                           ; 811c: 17 3a 36... .:6
    equs "2019"                                                       ; 8120: 32 30 31... 201
    equb 4, &30, 0                                                    ; 8124: 04 30 00    .0.
    equs ":2019807:;0:9 "                                             ; 8127: 3a 32 30... :20
    equb &1e, &1f, &ff, &20, &1e, &1f, &ff, &34, &1e                  ; 8135: 1e 1f ff... ...
    equs "3: "                                                        ; 813e: 33 3a 20    3:
    equb &1e, &1f, &ff, 5, &1e, 0, &ff, &20, &1e, &1f, &ff, &11, &1e  ; 8141: 1e 1f ff... ...
    equs "5: "                                                        ; 814e: 35 3a 20    5:
    equb &1e, &1f, &ff, &14, &12, &ff, &ff, &14, &12, &15, &ff, &1b   ; 8151: 1e 1f ff... ...
    equb &12, &16, &ff, &14, &12, &15, &ff,   9, &12,   0, &ff, &3a   ; 815d: 12 16 ff... ...
    equb &12, &15, &ff, &0f, &12, &22, &ff, &ff, &12, &15, &ff, &13   ; 8169: 12 15 ff... ...
    equb &2c, &ff, &ff, &13, &2c, &19, &ff, &1a                       ; 8175: 2c ff ff... ,..
    equs ",", '"', ","                                                ; 817d: 2c 22 2c    ,",
    equb &13, &2c, &19, &ff, 6, &2c, 0, &ff, &ff, &2c, &19, &ff       ; 8180: 13 2c 19... .,.
    equs ".,", '"'                                                    ; 818c: 2e 2c 22    .,"
    equb &ff, &ff, &2c, &19, &ff, &0a, &10, &0a, &ff, &ff,   0,   0   ; 818f: ff ff 2c... ..,
    equb &ff, &0a,   2,   9,   2, &ff,   1,   1, &ff, &12,   7, &0a   ; 819b: ff 0a 02... ...
    equb &ff, &ff,   3,   3, &ff, &0a,   6, &0a, &ff, &ff,   5,   5   ; 81a7: ff ff 03... ...
    equb &ff,   1, &10, &0a, &ff,   0,   0,   0, &ff, &0a,   2,   9   ; 81b3: ff 01 10... ...
    equb   2,   1,   1,   1, &ff, &12,   7, &0a, &ff, &ff,   3,   3   ; 81bf: 02 01 01... ...
    equb &ff, &0a,   6, &0a, &ff, &ff,   5,   5, &ff, &0a, &10, &0a   ; 81cb: ff 0a 06... ...
    equb &ff, &ff,   0,   0, &ff, &0a,   2,   9, &ff,   1,   1,   1   ; 81d7: ff ff 00... ...
    equb &ff, &12,   7, &0a, &ff, &ff,   3,   3, &ff, &0a,   6, &0a   ; 81e3: ff 12 07... ...
    equb &ff, &ff,   5,   5, &ff, &0a, &10, &0a, &ff, &ff,   0,   0   ; 81ef: ff ff 05... ...
    equb &ff, &0a,   2,   9, &ff,   8,   1,   1, &ff, &12,   7, &0a   ; 81fb: ff 0a 02... ...
    equb &ff, &ff,   3,   3, &ff, &0a,   6, &0a, &ff, &ff,   5,   5   ; 8207: ff ff 03... ...
    equb &ff, &ff, &10, &ff, &0a,   0,   0,   0,   0, &0a, &0a, &0a   ; 8213: ff ff 10... ...
    equb &ff,   1,   1,   1,   1, &12,   7, &0a, &0a,   3,   3,   4   ; 821f: ff 01 01... ...
    equb   4, &0a,   6, &0a, &0a,   1,   5, &0a,   5,   2, &10,   2   ; 822b: 04 0a 06... ...
    equb &ff,   0,   0,   0, &ff, &0a,   2, &0a, &0a,   1,   1,   1   ; 8237: ff 00 00... ...
    equb &ff, &12,   7, &0a, &ff,   3,   3,   4, &ff, &0a,   6, &0a   ; 8243: ff 12 07... ...
    equb &0a,   5,   5,   6, &ff,   2, &10, &ff, &ff,   0,   0,   0   ; 824f: 0a 05 05... ...
    equb &ff, &0a,   2, &0a, &ff,   1,   1,   1, &ff, &12,   7, &0a   ; 825b: ff 0a 02... ...
    equb &ff, &0a,   3,   3, &ff, &0a,   6, &0a, &ff, &ff,   5,   5   ; 8267: ff 0a 03... ...
    equb &ff,   2, &10, &ff, &ff,   0,   0,   0, &ff, &0a,   2, &0a   ; 8273: ff 02 10... ...
    equb   2,   1,   1,   1, &ff, &12,   7, &0a, &ff, &ff,   3,   3   ; 827f: 02 01 01... ...
    equb &ff, &0a,   6, &0a, &ff, &ff,   5,   5, &ff                  ; 828b: ff 0a 06... ...
; &8294 referenced 1 time by &8882
.opcodes
    equs "HLTADCANDASLBCCBCSBEQBITBMIBNEBPLBRKBVCBVSCLCCLDCLICLVCM"   ; 8294: 48 4c 54... HLT
    equs "PCPXCPYDECDEXDEYEORINCINXINYJMPJSRLDALDXLDYLSRNOPORAPHAP"   ; 82cc: 50 43 50... PCP
    equs "HPPLAPLPROLRORRTIRTSSBCSECSEDSEISTASTXSTYTAXTAYTSXTXATXS"   ; 8304: 48 50 50... HPP
    equs "TYASAX???STZBBRBBSBRAPHXPHYPLXPLYRMBSMBTRBTSB"              ; 833c: 54 59 41... TYA
; &8369 referenced 1 time by &8d1c
.table_7
    equb 2, 3, 2, 2, 2, 3, 3, 2, 3, 1, 1, 2, 2, 3, 2, 3, 2, 2, 2, 2   ; 8369: 02 03 02... ...
    equb 3, 2, 3                                                      ; 837d: 03 02 03    ...
; &8380 referenced 1 time by &8c10
.table_6
    equb &0c, &1c, &3c, &5c, &7c, &dc, &fc                            ; 8380: 0c 1c 3c... ..<
; &8387 referenced 1 time by &8c3a
.table_2
    equb &82, &c2, &e2, 7, &17                                        ; 8387: 82 c2 e2... ...
    equs "'7GWgw"                                                     ; 838c: 27 37 47... '7G
    equb &a7, &b7, &c7, &d7, &e7, &f7, 3, &13                         ; 8392: a7 b7 c7... ...
    equs "#3CScs"                                                     ; 839a: 23 33 43... #3C
    equb &a3, &b3, &c3, &d3, &e3, &f3, &0f, &1f                       ; 83a0: a3 b3 c3... ...
    equs "/?O_o"                                                      ; 83a8: 2f 3f 4f... /?O
    equb &7f, &af, &bf, &cf, &df, &ef, &ff, &1b                       ; 83ad: 7f af bf... ...
    equs ";K[k{"                                                      ; 83b5: 3b 4b 5b... ;K[
    equb &db, &fb, &80, 4, &14                                        ; 83ba: db fb 80... ...
    equs "4DTdt"                                                      ; 83bf: 34 44 54... 4DT
    equb &f4, &89, 0, &42                                             ; 83c4: f4 89 00... ...
; &83c8 referenced 1 time by &8c52
.table_3
    equs ":::"                                                        ; 83c8: 3a 3a 3a    :::
    equb 3, 3                                                         ; 83cb: 03 03       ..
    equs "((!!))"                                                     ; 83cd: 28 28 21... ((!
    equb &1f, &1f, &15, &15, &19, &19, 3, 3                           ; 83d3: 1f 1f 15... ...
    equs "((!!))"                                                     ; 83db: 28 28 21... ((!
    equb &1e, &1e, &15, &15, &19, &19, 3, 3                           ; 83e1: 1e 1e 15... ...
    equs "((!!))"                                                     ; 83e9: 28 28 21... ((!
    equb &1f, &1f, &15, &15, &19, &19, 3, &28, 2, &21, 2, &29, &15    ; 83ef: 1f 1f 15... ...
    equb &19                                                          ; 83fc: 19          .
    equs '"', '"', '"', '"', '"', '"', '"', '"', '"', '"'             ; 83fd: 22 22 22... """
    equb 0, &3f                                                       ; 8407: 00 3f       .?
; &8409 referenced 2 times by &8c55, &8c63
.table_4
    equb &0a, &0a, &0a,   0,   3,   0,   3,   0,   3,   0,   3,   0   ; 8409: 0a 0a 0a... ...
    equb   4,   0,   3,   0,   3, &10,   7, &10,   7, &10,   7, &10   ; 8415: 04 00 03... ...
    equb   7, &11,   7, &10,   7, &10,   7,   1,   5,   1,   5,   1   ; 8421: 07 11 07... ...
    equb   5,   1,   5,   1,   6,   1,   5,   1,   5,   6,   6,   2   ; 842d: 05 01 05... ...
    equb   6,   2,   6,   6,   6, &0a, &0a, &0a, &0a, &0a, &0a, &0a   ; 8439: 06 02 06... ...
    equb &0a, &0a, &0a,   0, &28                                      ; 8445: 0a 0a 0a... ...
; &844a referenced 1 time by &8c60
.table_5
    equs ":::##"                                                      ; 844a: 3a 3a 3a... :::
    equb 2, 2, &18, &18, 1, 1, &1e, &1e, &12, &12                     ; 844f: 02 02 18... ...
    equs ",,##"                                                       ; 8459: 2c 2c 23... ,,#
    equb 2, 2, &18, &18, 1, 1, &1f, &1f, &12, &12                     ; 845d: 02 02 18... ...
    equs ",,##"                                                       ; 8467: 2c 2c 23... ,,#
    equb 2, 2, &18, &18, 1, 1, &1e, &1e, &12, &12                     ; 846b: 02 02 18... ...
    equs ",,##!"                                                      ; 8475: 2c 2c 23... ,,#
    equb &18, &29, 1, &12                                             ; 847a: 18 29 01... .).
    equs ",", '"', '"', '"', '"', '"', '"', '"', '"', '"', '"'        ; 847e: 2c 22 22... ,""
    equb 0, 5, &0b                                                    ; 8489: 00 05 0b    ...
    equs "#::F#"                                                      ; 848c: 23 3a 3a... #::
    equb 3                                                            ; 8491: 03          .
    equs "C%#"                                                        ; 8492: 43 25 23    C%#
    equb 3                                                            ; 8495: 03          .
    equs ":F#"                                                        ; 8496: 3a 46 23    :F#
    equb 3, &3c, &0a                                                  ; 8499: 03 3c 0a    .<.
    equs "##:E#"                                                      ; 849c: 23 23 3a... ##:
    equb 3, &43, &0e, &23, &19                                        ; 84a1: 03 43 0e... .C.
    equs ":E#"                                                        ; 84a6: 3a 45 23    :E#
    equb 3, &3c, &1d, 2, &3a, &3a, 7, 2                               ; 84a9: 03 3c 1d... .<.
    equs "(C'"                                                        ; 84b1: 28 43 27    (C'
    equb 2, &28, &3a, 7, 2, &28, &3c, 8, 2, 2, &3a, 7, 2              ; 84b4: 02 28 3a... .(:
    equs "(C-"                                                        ; 84c1: 28 43 2d    (C-
    equb 2, &15, &3a, 7, 2                                            ; 84c4: 02 15 3a... ..:
    equs "(<*"                                                        ; 84c9: 28 3c 2a    (<*
    equb &18                                                          ; 84cc: 18          .
    equs ":::"                                                        ; 84cd: 3a 3a 3a    :::
    equb &18                                                          ; 84d0: 18          .
    equs "!C$"                                                        ; 84d1: 21 43 24    !C$
    equb &18, &21, &3a, &1c, &18, &21, &3c, &0c, &18, &18, &3a, &3a   ; 84d4: 18 21 3a... .!:
    equb &18, &21, &43, &10, &18                                      ; 84e0: 18 21 43... .!C
    equs "@::"                                                        ; 84e5: 40 3a 3a    @::
    equb &18                                                          ; 84e8: 18          .
    equs "!<+"                                                        ; 84e9: 21 3c 2b    !<+
    equb 1                                                            ; 84ec: 01          .
    equs "::;"                                                        ; 84ed: 3a 3a 3b    ::;
    equb 1                                                            ; 84f0: 01          .
    equs ")C&"                                                        ; 84f1: 29 43 26    )C&
    equb 1, &29, &3a, &1c, 1, &29, &3c, &0d, 1, 1, &3a, &3b, 1        ; 84f4: 01 29 3a... .):
    equs ")C/"                                                        ; 8501: 29 43 2f    )C/
    equb 1, &42, &3a, &1c, 1                                          ; 8504: 01 42 3a... .B:
    equs ")<>0::201D"                                                 ; 8509: 29 3c 3e... )<>
    equb &17, 7                                                       ; 8513: 17 07       ..
    equs "6:201="                                                     ; 8515: 36 3a 32... 6:2
    equb 4                                                            ; 851b: 04          .
    equs "00:201D807:;0;= "                                           ; 851c: 30 30 3a... 00:
    equb &1e, &1f, &3a, &20, &1e, &1f, &44, &34, &1e                  ; 852c: 1e 1f 3a... ..:
    equs "3: "                                                        ; 8535: 33 3a 20    3:
    equb &1e, &1f, &3d, 5, &1e, &1e, &3a, &20, &1e, &1f, &44, &11     ; 8538: 1e 1f 3d... ..=
    equb &1e                                                          ; 8544: 1e          .
    equs "5: "                                                        ; 8545: 35 3a 20    5:
    equb &1e, &1f, &3d, &14, &12, &3a, &3a, &14, &12, &15, &44, &1b   ; 8548: 1e 1f 3d... ..=
    equb &12, &16, &3a, &14, &12, &15, &3d,   9, &12, &12, &3a, &3a   ; 8554: 12 16 3a... ..:
    equb &12, &15, &44, &0f, &12                                      ; 8560: 12 15 44... ..D
    equs "?::"                                                        ; 8565: 3f 3a 3a    ?::
    equb &12, &15, &3d, &13                                           ; 8568: 12 15 3d... ..=
    equs ",::"                                                        ; 856c: 2c 3a 3a    ,::
    equb &13, &2c, &19, &44, &1a                                      ; 856f: 13 2c 19... .,.
    equs ",", '"', ":"                                                ; 8574: 2c 22 3a    ,":
    equb &13, &2c, &19, &3d, 6                                        ; 8577: 13 2c 19... .,.
    equs ",,::,"                                                      ; 857c: 2c 2c 3a... ,,:
    equb &19                                                          ; 8581: 19          .
    equs "D.,A::,"                                                    ; 8582: 44 2e 2c... D.,
    equb &19, &3d, &0a, &10, &0a, &0a,   0,   0,   0, &15, &0a,   2   ; 8589: 19 3d 0a... .=.
    equb   9, &0a,   1,   1,   1, &16, &12,   7, &13, &0a,   0,   3   ; 8595: 09 0a 01... ...
    equb   3, &15, &0a,   6,   9, &0a,   1,   5,   5, &16,   1, &10   ; 85a1: 03 15 0a... ...
    equb &0a, &0a,   0,   0,   0, &15, &0a,   2,   9, &0a,   1,   1   ; 85ad: 0a 0a 00... ...
    equb   1, &16, &12,   7, &13, &0a,   3,   3,   3, &15, &0a,   6   ; 85b9: 01 16 12... ...
    equb   9, &0a,   5,   5,   5, &16, &0a, &10, &0a, &0a, &0a,   0   ; 85c5: 09 0a 05... ...
    equb   0, &15, &0a,   2,   9, &0a,   1,   1,   1, &16, &12,   7   ; 85d1: 00 15 0a... ...
    equb &13, &0a, &0a,   3,   3, &15, &0a,   6, &0a, &0a, &0a,   5   ; 85dd: 13 0a 0a... ...
    equb   5, &16, &0a, &10, &0a, &0a,   0,   0,   0, &15, &0a,   2   ; 85e9: 05 16 0a... ...
    equb   9, &0a,   8,   1,   1, &16, &12,   7, &13, &0a,   3,   3   ; 85f5: 09 0a 08... ...
    equb   3, &15, &0a,   6, &0a, &0a, &14,   5,   5, &16, &12, &10   ; 8601: 03 15 0a... ...
    equb &0a, &0a,   0,   0,   0, &15, &0a,   2, &0a, &0a,   1,   1   ; 860d: 0a 0a 00... ...
    equb   1, &16, &12,   7, &13, &0a,   3,   3,   4, &15, &0a,   6   ; 8619: 01 16 12... ...
    equb &0a, &0a,   1,   5,   5, &16,   2, &10,   2, &0a,   0,   0   ; 8625: 0a 0a 01... ...
    equb   0, &15, &0a,   2, &0a, &0a,   1,   1,   1, &16, &12,   7   ; 8631: 00 15 0a... ...
    equb &13, &0a,   3,   3,   4, &15, &0a,   6, &0a, &0a,   5,   5   ; 863d: 13 0a 03... ...
    equb   6, &16,   2, &10, &0a, &0a,   0,   0,   0, &15, &0a,   2   ; 8649: 06 16 02... ...
    equb &0a, &0a,   1,   1,   1, &16, &12,   7, &13, &0a, &0a,   3   ; 8655: 0a 0a 01... ...
    equb   3, &15, &0a,   6, &0a, &0a, &0a,   5,   5, &16,   2, &10   ; 8661: 03 15 0a... ...
    equb &0a, &0a,   0,   0,   0, &15, &0a,   2, &0a, &0a,   1,   1   ; 866d: 0a 0a 00... ...
    equb   1, &16, &12,   7, &13, &0a, &0a,   3,   3, &15, &0a,   6   ; 8679: 01 16 12... ...
    equb &0a, &0a, &0a,   5,   5, &16                                 ; 8685: 0a 0a 0a... ...
; &868b referenced 1 time by &8d23
.os_entry_points
    equb &0c, &0f, &1b, &1c, &1f                                      ; 868b: 0c 0f 1b... ...
    equb &2f, &3b, &3c, &3f, &4f, &5b, &5c, &5f, &6f, &7b, &7c        ; 8690: 2f 3b 3c... /;<
    equb &7f, &af, &bf, &cf, &db, &dc, &df, &ef, &fb, &fc, &ff        ; 869b: 7f af bf... ...
    equs "brkv"                                                       ; 86a6: 62 72 6b... brk
    equb 0, 0, 0, 2, 2                                                ; 86aa: 00 00 00... ...
    equs "brkv+1"                                                     ; 86af: 62 72 6b... brk
    equb 0, 3, 2                                                      ; 86b5: 00 03 02    ...
    equs "oscli"                                                      ; 86b8: 6f 73 63... osc
    equb 0, 0                                                         ; 86bd: 00 00       ..
    equw oscli                                                        ; 86bf: f7 ff       ..
    equs "osbyte"                                                     ; 86c1: 6f 73 62... osb
    equb 0                                                            ; 86c7: 00          .
    equw osbyte                                                       ; 86c8: f4 ff       ..
    equs "osword"                                                     ; 86ca: 6f 73 77... osw
    equb 0                                                            ; 86d0: 00          .
    equw osword                                                       ; 86d1: f1 ff       ..
    equs "oswrch"                                                     ; 86d3: 6f 73 77... osw
    equb 0                                                            ; 86d9: 00          .
    equw oswrch                                                       ; 86da: ee ff       ..
    equs "osnewl"                                                     ; 86dc: 6f 73 6e... osn
    equb 0                                                            ; 86e2: 00          .
    equw osnewl                                                       ; 86e3: e7 ff       ..
    equs "osasci"                                                     ; 86e5: 6f 73 61... osa
    equb 0                                                            ; 86eb: 00          .
    equw osasci                                                       ; 86ec: e3 ff       ..
    equs "osrdch"                                                     ; 86ee: 6f 73 72... osr
    equb 0                                                            ; 86f4: 00          .
    equw osrdch                                                       ; 86f5: e0 ff       ..
    equs "osfile"                                                     ; 86f7: 6f 73 66... osf
    equb 0                                                            ; 86fd: 00          .
    equw osfile                                                       ; 86fe: dd ff       ..
    equs "osargs"                                                     ; 8700: 6f 73 61... osa
    equb 0                                                            ; 8706: 00          .
    equw osargs                                                       ; 8707: da ff       ..
    equs "osbget"                                                     ; 8709: 6f 73 62... osb
    equb 0                                                            ; 870f: 00          .
    equw osbget                                                       ; 8710: d7 ff       ..
    equs "osbput"                                                     ; 8712: 6f 73 62... osb
    equb 0                                                            ; 8718: 00          .
    equw osbput                                                       ; 8719: d4 ff       ..
    equs "osgbpb"                                                     ; 871b: 6f 73 67... osg
    equb 0                                                            ; 8721: 00          .
    equw osgbpb                                                       ; 8722: d1 ff       ..
    equs "osfind"                                                     ; 8724: 6f 73 66... osf
    equb 0                                                            ; 872a: 00          .
    equw osfind                                                       ; 872b: ce ff       ..
    equs "gsread"                                                     ; 872d: 67 73 72... gsr
    equb 0                                                            ; 8733: 00          .
    equw gsread                                                       ; 8734: c5 ff       ..
    equs "gsinit"                                                     ; 8736: 67 73 69... gsi
    equb 0                                                            ; 873c: 00          .
    equw gsinit                                                       ; 873d: c2 ff       ..
    equs "oseven"                                                     ; 873f: 6f 73 65... ose
    equb 0                                                            ; 8745: 00          .
    equw oseven                                                       ; 8746: bf ff       ..
    equs "osrdrm"                                                     ; 8748: 6f 73 72... osr
    equb 0                                                            ; 874e: 00          .
    equw osrdsc                                                       ; 874f: b9 ff       ..
    equb 0, 0                                                         ; 8751: 00 00       ..

; &8753 referenced 7 times by &88ab, &8fdb, &8feb, &9044, &906a, &947f, &95b0
.c8753
    lda l003c                                                         ; 8753: a5 3c       .<
    clc                                                               ; 8755: 18          .
    adc #9                                                            ; 8756: 69 09       i.
    sta l003c                                                         ; 8758: 85 3c       .<
    bcc return_2                                                      ; 875a: 90 02       ..
    inc l003d                                                         ; 875c: e6 3d       .=
; &875e referenced 1 time by &875a
.return_2
    rts                                                               ; 875e: 60          `

; &875f referenced 5 times by &8ac3, &8b27, &8f7b, &949a, &955e
.sub_c875f
    lda l0025                                                         ; 875f: a5 25       .%
    sta l003a                                                         ; 8761: 85 3a       .:
    lda l0026                                                         ; 8763: a5 26       .&
    sta l003b                                                         ; 8765: 85 3b       .;
; &8767 referenced 5 times by &889e, &8b01, &8b19, &8b93, &8fde
.sub_c8767
    lda #&a6                                                          ; 8767: a9 a6       ..
    sta l003c                                                         ; 8769: 85 3c       .<
    lda #&86                                                          ; 876b: a9 86       ..
    sta l003d                                                         ; 876d: 85 3d       .=
    jsr sub_c877c                                                     ; 876f: 20 7c 87     |.
    bcs return_3                                                      ; 8772: b0 3b       .;
    lda himem                                                         ; 8774: a5 89       ..
    sta l003c                                                         ; 8776: 85 3c       .<
    lda himem+1                                                       ; 8778: a5 8a       ..
    sta l003d                                                         ; 877a: 85 3d       .=
; &877c referenced 3 times by &876f, &88ae, &8fee
.sub_c877c
    ldy #0                                                            ; 877c: a0 00       ..
    lda (l003c),y                                                     ; 877e: b1 3c       .<
    beq c87ae                                                         ; 8780: f0 2c       .,
    lda l003c                                                         ; 8782: a5 3c       .<
    clc                                                               ; 8784: 18          .
    adc #7                                                            ; 8785: 69 07       i.
    sta l003c                                                         ; 8787: 85 3c       .<
    bcc c878d                                                         ; 8789: 90 02       ..
    inc l003d                                                         ; 878b: e6 3d       .=
; &878d referenced 2 times by &8789, &87ac
.c878d
    lda (l003c),y                                                     ; 878d: b1 3c       .<
    iny                                                               ; 878f: c8          .
    cmp l003a                                                         ; 8790: c5 3a       .:
    bne c879a                                                         ; 8792: d0 06       ..
    lda (l003c),y                                                     ; 8794: b1 3c       .<
    cmp l003b                                                         ; 8796: c5 3b       .;
    beq c87b0                                                         ; 8798: f0 16       ..
; &879a referenced 1 time by &8792
.c879a
    iny                                                               ; 879a: c8          .
    lda (l003c),y                                                     ; 879b: b1 3c       .<
    php                                                               ; 879d: 08          .
    lda l003c                                                         ; 879e: a5 3c       .<
    clc                                                               ; 87a0: 18          .
    adc #9                                                            ; 87a1: 69 09       i.
    sta l003c                                                         ; 87a3: 85 3c       .<
    bcc c87a9                                                         ; 87a5: 90 02       ..
    inc l003d                                                         ; 87a7: e6 3d       .=
; &87a9 referenced 1 time by &87a5
.c87a9
    ldy #0                                                            ; 87a9: a0 00       ..
    plp                                                               ; 87ab: 28          (
    bne c878d                                                         ; 87ac: d0 df       ..
; &87ae referenced 3 times by &8780, &87ee, &881f
.c87ae
    clc                                                               ; 87ae: 18          .
; &87af referenced 1 time by &8772
.return_3
    rts                                                               ; 87af: 60          `

; &87b0 referenced 1 time by &8798
.c87b0
    sec                                                               ; 87b0: 38          8
    lda l003c                                                         ; 87b1: a5 3c       .<
    sbc #7                                                            ; 87b3: e9 07       ..
    sta l003c                                                         ; 87b5: 85 3c       .<
    bcs c87bb                                                         ; 87b7: b0 02       ..
    dec l003d                                                         ; 87b9: c6 3d       .=
; &87bb referenced 1 time by &87b7
.c87bb
    sec                                                               ; 87bb: 38          8
    rts                                                               ; 87bc: 60          `

; ***************************************************************************************
; &87bd referenced 6 times by &8f72, &8f9f, &8fb0, &912f, &954f, &958c
.sub_m87bd
    lda l0600                                                         ; 87bd: ad 00 06    ...
    cmp #&0d                                                          ; 87c0: c9 0d       ..
    bcc c881d                                                         ; 87c2: 90 59       .Y
    ldy #7                                                            ; 87c4: a0 07       ..
; &87c6 referenced 1 time by &87d3
.loop_c87c6
    lda l0600,y                                                       ; 87c6: b9 00 06    ...
    cmp #&0d                                                          ; 87c9: c9 0d       ..
    bne c87d2                                                         ; 87cb: d0 05       ..
    lda #0                                                            ; 87cd: a9 00       ..
    sta l0600,y                                                       ; 87cf: 99 00 06    ...
; &87d2 referenced 1 time by &87cb
.c87d2
    dey                                                               ; 87d2: 88          .
    bpl loop_c87c6                                                    ; 87d3: 10 f1       ..
    lda #&a6                                                          ; 87d5: a9 a6       ..
    sta l003c                                                         ; 87d7: 85 3c       .<
    lda #&86                                                          ; 87d9: a9 86       ..
    sta l003d                                                         ; 87db: 85 3d       .=
    jsr c87ea                                                         ; 87dd: 20 ea 87     ..
    bcs return_4                                                      ; 87e0: b0 28       .(
    lda himem                                                         ; 87e2: a5 89       ..
    sta l003c                                                         ; 87e4: 85 3c       .<
    lda himem+1                                                       ; 87e6: a5 8a       ..
    sta l003d                                                         ; 87e8: 85 3d       .=
; &87ea referenced 3 times by &87dd, &8816, &881a
.c87ea
    ldy #0                                                            ; 87ea: a0 00       ..
    lda (l003c),y                                                     ; 87ec: b1 3c       .<
; &87ee referenced 1 time by &882d
.c87ee
    beq c87ae                                                         ; 87ee: f0 be       ..
; &87f0 referenced 1 time by &87fc
.loop_c87f0
    lda l0600,y                                                       ; 87f0: b9 00 06    ...
    beq c880b                                                         ; 87f3: f0 16       ..
    cmp (l003c),y                                                     ; 87f5: d1 3c       .<
    bne c880f                                                         ; 87f7: d0 16       ..
    iny                                                               ; 87f9: c8          .
    cpy #7                                                            ; 87fa: c0 07       ..
    bne loop_c87f0                                                    ; 87fc: d0 f2       ..
; &87fe referenced 2 times by &880d, &883b
.c87fe
    ldy #7                                                            ; 87fe: a0 07       ..
    lda (l003c),y                                                     ; 8800: b1 3c       .<
    sta l003a                                                         ; 8802: 85 3a       .:
    iny                                                               ; 8804: c8          .              ; Y=&08
    lda (l003c),y                                                     ; 8805: b1 3c       .<
    sta l003b                                                         ; 8807: 85 3b       .;
    sec                                                               ; 8809: 38          8
; &880a referenced 1 time by &87e0
.return_4
    rts                                                               ; 880a: 60          `

; &880b referenced 1 time by &87f3
.c880b
    lda (l003c),y                                                     ; 880b: b1 3c       .<
    beq c87fe                                                         ; 880d: f0 ef       ..
; &880f referenced 1 time by &87f7
.c880f
    lda l003c                                                         ; 880f: a5 3c       .<
    clc                                                               ; 8811: 18          .
    adc #9                                                            ; 8812: 69 09       i.
    sta l003c                                                         ; 8814: 85 3c       .<
    bcc c87ea                                                         ; 8816: 90 d2       ..
    inc l003d                                                         ; 8818: e6 3d       .=
    jmp c87ea                                                         ; 881a: 4c ea 87    L..

; &881d referenced 1 time by &87c2
.c881d
    cmp #1                                                            ; 881d: c9 01       ..
    bne c87ae                                                         ; 881f: d0 8d       ..
    lda himem                                                         ; 8821: a5 89       ..
    sta l003c                                                         ; 8823: 85 3c       .<
    lda himem+1                                                       ; 8825: a5 8a       ..
    sta l003d                                                         ; 8827: 85 3d       .=
; &8829 referenced 2 times by &8844, &8848
.c8829
    ldy #0                                                            ; 8829: a0 00       ..
    lda (l003c),y                                                     ; 882b: b1 3c       .<
    beq c87ee                                                         ; 882d: f0 bf       ..
; &882f referenced 1 time by &8839
.loop_c882f
    lda l0600,y                                                       ; 882f: b9 00 06    ...
    cmp (l003c),y                                                     ; 8832: d1 3c       .<
    bne c883d                                                         ; 8834: d0 07       ..
    iny                                                               ; 8836: c8          .
    cpy #7                                                            ; 8837: c0 07       ..
    bne loop_c882f                                                    ; 8839: d0 f4       ..
    beq c87fe                                                         ; 883b: f0 c1       ..             ; ALWAYS branch

; &883d referenced 1 time by &8834
.c883d
    lda l003c                                                         ; 883d: a5 3c       .<
    clc                                                               ; 883f: 18          .
    adc #9                                                            ; 8840: 69 09       i.
    sta l003c                                                         ; 8842: 85 3c       .<
    bcc c8829                                                         ; 8844: 90 e3       ..
    inc l003d                                                         ; 8846: e6 3d       .=
    jmp c8829                                                         ; 8848: 4c 29 88    L).

; ***************************************************************************************
; &884b referenced 9 times by &8b46, &8bc6, &8bda, &8be4, &8c1e, &8c2c, &8c4a, &8c58, &8c66
.sub_m884b
    sta l003e                                                         ; 884b: 85 3e       .>
    tya                                                               ; 884d: 98          .
    pha                                                               ; 884e: 48          H
    ldx #&87                                                          ; 884f: a2 87       ..
    ldy l0005                                                         ; 8851: a4 05       ..
    lda (l0042),y                                                     ; 8853: b1 42       .B
    cmp #&16                                                          ; 8855: c9 16       ..
    beq c885d                                                         ; 8857: f0 04       ..
    cmp #&12                                                          ; 8859: c9 12       ..
    bne c8861                                                         ; 885b: d0 04       ..
; &885d referenced 1 time by &8857
.c885d
    ldx #&86                                                          ; 885d: a2 86       ..
    bne c8875                                                         ; 885f: d0 14       ..             ; ALWAYS branch

; &8861 referenced 1 time by &885b
.c8861
    cpy #&4c ; 'L'                                                    ; 8861: c0 4c       .L
    beq c8869                                                         ; 8863: f0 04       ..
    cpy #&6c ; 'l'                                                    ; 8865: c0 6c       .l
    bne c886d                                                         ; 8867: d0 04       ..
; &8869 referenced 1 time by &8863
.c8869
    ldx #&85                                                          ; 8869: a2 85       ..
    bne c8875                                                         ; 886b: d0 08       ..             ; ALWAYS branch

; &886d referenced 1 time by &8867
.c886d
    lda (l0044),y                                                     ; 886d: b1 44       .D
    cmp #&3a ; ':'                                                    ; 886f: c9 3a       .:
    bne c8875                                                         ; 8871: d0 02       ..
    ldx #&81                                                          ; 8873: a2 81       ..
; &8875 referenced 3 times by &885f, &886b, &8871
.c8875
    txa                                                               ; 8875: 8a          .
    jsr sub_c8a50                                                     ; 8876: 20 50 8a     P.
    lda l003e                                                         ; 8879: a5 3e       .>
    asl a                                                             ; 887b: 0a          .
    clc                                                               ; 887c: 18          .
    adc l003e                                                         ; 887d: 65 3e       e>
    tay                                                               ; 887f: a8          .
    ldx #3                                                            ; 8880: a2 03       ..
; &8882 referenced 1 time by &888a
.loop_c8882
    lda opcodes,y                                                     ; 8882: b9 94 82    ...
    jsr oswrch                                                        ; 8885: 20 ee ff     ..            ; Write character
    iny                                                               ; 8888: c8          .
    dex                                                               ; 8889: ca          .
    bne loop_c8882                                                    ; 888a: d0 f6       ..
    lda #&20 ; ' '                                                    ; 888c: a9 20       .
    jsr oswrch                                                        ; 888e: 20 ee ff     ..            ; Write character 32
    pla                                                               ; 8891: 68          h
    bne c88dd                                                         ; 8892: d0 49       .I
; &8894 referenced 7 times by &88fe, &890c, &8931, &8958, &8968, &89a1, &89cd
.c8894
    clc                                                               ; 8894: 18          .
    php                                                               ; 8895: 08          .
    lda #0                                                            ; 8896: a9 00       ..
; &8898 referenced 1 time by &88e5
.c8898
    sta l003b                                                         ; 8898: 85 3b       .;
    lda l0001                                                         ; 889a: a5 01       ..
    sta l003a                                                         ; 889c: 85 3a       .:
; &889e referenced 1 time by &898a
.c889e
    jsr sub_c8767                                                     ; 889e: 20 67 87     g.
; &88a1 referenced 1 time by &88b1
.loop_c88a1
    bcc c88b9                                                         ; 88a1: 90 16       ..
    ldy #0                                                            ; 88a3: a0 00       ..
    lda (l003c),y                                                     ; 88a5: b1 3c       .<
    cmp #1                                                            ; 88a7: c9 01       ..
    bne c88b4                                                         ; 88a9: d0 09       ..
    jsr c8753                                                         ; 88ab: 20 53 87     S.
    jsr sub_c877c                                                     ; 88ae: 20 7c 87     |.
    jmp loop_c88a1                                                    ; 88b1: 4c a1 88    L..

; &88b4 referenced 1 time by &88a9
.c88b4
    jsr sub_c8c6c                                                     ; 88b4: 20 6c 8c     l.
    plp                                                               ; 88b7: 28          (
    rts                                                               ; 88b8: 60          `

; &88b9 referenced 1 time by &88a1
.c88b9
    lda #&26 ; '&'                                                    ; 88b9: a9 26       .&
    jsr oswrch                                                        ; 88bb: 20 ee ff     ..            ; Write character 38
    plp                                                               ; 88be: 28          (
    bcc c88c6                                                         ; 88bf: 90 05       ..
    lda l003b                                                         ; 88c1: a5 3b       .;
    jsr hex_to_digit                                                  ; 88c3: 20 c8 88     ..
; &88c6 referenced 1 time by &88bf
.c88c6
    lda l003a                                                         ; 88c6: a5 3a       .:
; ***************************************************************************************
; &88c8 referenced 22 times by &88c3, &88f7, &8a26, &8a48, &8a4d, &8b5d, &8c07, &8cf6, &8e73, &94c3, &94c9, &998e, &9aa1, &9aa6, &9ac7, &9acc, &9c96, &9c9a, &9ca6, &9cab, &9cb7, &9cbc
.hex_to_digit
    pha                                                               ; 88c8: 48          H
    lsr a                                                             ; 88c9: 4a          J
    lsr a                                                             ; 88ca: 4a          J
    lsr a                                                             ; 88cb: 4a          J
    lsr a                                                             ; 88cc: 4a          J
    jsr convert_and_print_decimal                                     ; 88cd: 20 d3 88     ..
    pla                                                               ; 88d0: 68          h
    and #&0f                                                          ; 88d1: 29 0f       ).
; ***************************************************************************************
; &88d3 referenced 3 times by &88cd, &95f9, &9c79
.convert_and_print_decimal
    sed                                                               ; 88d3: f8          .
    clc                                                               ; 88d4: 18          .
    adc #&90                                                          ; 88d5: 69 90       i.
    adc #&40 ; '@'                                                    ; 88d7: 69 40       i@
    cld                                                               ; 88d9: d8          .
    jmp oswrch                                                        ; 88da: 4c ee ff    L..            ; Write character

; &88dd referenced 1 time by &8892
.c88dd
    cmp #1                                                            ; 88dd: c9 01       ..
    bne print_hash_ampersand                                          ; 88df: d0 06       ..
; &88e1 referenced 4 times by &891a, &8924, &8941, &89ae
.sub_c88e1
    lda l0002                                                         ; 88e1: a5 02       ..
    sec                                                               ; 88e3: 38          8
    php                                                               ; 88e4: 08          .
    bcs c8898                                                         ; 88e5: b0 b1       ..             ; ALWAYS branch

; ***************************************************************************************
; &88e7 referenced 1 time by &88df
.print_hash_ampersand
    cmp #2                                                            ; 88e7: c9 02       ..
    bne c88fa                                                         ; 88e9: d0 0f       ..
    lda #&23 ; '#'                                                    ; 88eb: a9 23       .#
    jsr oswrch                                                        ; 88ed: 20 ee ff     ..            ; Write character 35
    lda #&26 ; '&'                                                    ; 88f0: a9 26       .&
    jsr oswrch                                                        ; 88f2: 20 ee ff     ..            ; Write character 38
    lda l0001                                                         ; 88f5: a5 01       ..
    jmp hex_to_digit                                                  ; 88f7: 4c c8 88    L..

; &88fa referenced 1 time by &88e9
.c88fa
    cmp #3                                                            ; 88fa: c9 03       ..
    bne c8908                                                         ; 88fc: d0 0a       ..
    jsr c8894                                                         ; 88fe: 20 94 88     ..
; ***************************************************************************************
; &8901 referenced 4 times by &891d, &895b, &896e, &89b1
.print_indexed_x
    jsr print_inline_string                                           ; 8901: 20 6b 8a     k.
    equs ",X"                                                         ; 8904: 2c 58       ,X
    equb &ff                                                          ; 8906: ff          .

    rts                                                               ; 8907: 60          `

; &8908 referenced 1 time by &88fc
.c8908
    cmp #4                                                            ; 8908: c9 04       ..
    bne c8916                                                         ; 890a: d0 0a       ..
    jsr c8894                                                         ; 890c: 20 94 88     ..
; ***************************************************************************************
; &890f referenced 2 times by &8927, &8937
.print_indexed_y
    jsr print_inline_string                                           ; 890f: 20 6b 8a     k.
    equs ",Y"                                                         ; 8912: 2c 59       ,Y
    equb &ff, &60                                                     ; 8914: ff 60       .`

; &8916 referenced 1 time by &890a
.c8916
    cmp #5                                                            ; 8916: c9 05       ..
    bne c8920                                                         ; 8918: d0 06       ..
    jsr sub_c88e1                                                     ; 891a: 20 e1 88     ..
    jmp print_indexed_x                                               ; 891d: 4c 01 89    L..

; &8920 referenced 1 time by &8918
.c8920
    cmp #6                                                            ; 8920: c9 06       ..
    bne c892a                                                         ; 8922: d0 06       ..
    jsr sub_c88e1                                                     ; 8924: 20 e1 88     ..
    jmp print_indexed_y                                               ; 8927: 4c 0f 89    L..

; &892a referenced 1 time by &8922
.c892a
    cmp #7                                                            ; 892a: c9 07       ..
    bne c893a                                                         ; 892c: d0 0c       ..
    jsr print_open_bracket                                            ; 892e: 20 e4 89     ..
    jsr c8894                                                         ; 8931: 20 94 88     ..
    jsr print_close_bracket                                           ; 8934: 20 44 89     D.
    jmp print_indexed_y                                               ; 8937: 4c 0f 89    L..

; &893a referenced 1 time by &892c
.c893a
    cmp #8                                                            ; 893a: c9 08       ..
    bne c8949                                                         ; 893c: d0 0b       ..
    jsr print_open_bracket                                            ; 893e: 20 e4 89     ..
    jsr sub_c88e1                                                     ; 8941: 20 e1 88     ..
; ***************************************************************************************
; &8944 referenced 5 times by &8934, &895e, &896b, &89a4, &89b4
.print_close_bracket
    lda #&29 ; ')'                                                    ; 8944: a9 29       .)
; &8946 referenced 1 time by &894f
.loop_c8946
    jmp oswrch                                                        ; 8946: 4c ee ff    L..            ; Write character 41

; &8949 referenced 1 time by &893c
.c8949
    cmp #9                                                            ; 8949: c9 09       ..
    bne c8951                                                         ; 894b: d0 04       ..
    lda #&41 ; 'A'                                                    ; 894d: a9 41       .A
    bne loop_c8946                                                    ; 894f: d0 f5       ..             ; ALWAYS branch

; &8951 referenced 1 time by &894b
.c8951
    cmp #&10                                                          ; 8951: c9 10       ..
    bne c8961                                                         ; 8953: d0 0c       ..
    jsr print_open_bracket                                            ; 8955: 20 e4 89     ..
    jsr c8894                                                         ; 8958: 20 94 88     ..
    jsr print_indexed_x                                               ; 895b: 20 01 89     ..
    jmp print_close_bracket                                           ; 895e: 4c 44 89    LD.

; &8961 referenced 1 time by &8953
.c8961
    cmp #&11                                                          ; 8961: c9 11       ..
    bne c8971                                                         ; 8963: d0 0c       ..
    jsr print_open_bracket                                            ; 8965: 20 e4 89     ..
    jsr c8894                                                         ; 8968: 20 94 88     ..
    jsr print_close_bracket                                           ; 896b: 20 44 89     D.
    jmp print_indexed_x                                               ; 896e: 4c 01 89    L..

; &8971 referenced 1 time by &8963
.c8971
    cmp #&12                                                          ; 8971: c9 12       ..
    bne c899a                                                         ; 8973: d0 25       .%
    lda l0001                                                         ; 8975: a5 01       ..
; &8977 referenced 1 time by &89e1
.c8977
    bmi c898d                                                         ; 8977: 30 14       0.
    clc                                                               ; 8979: 18          .
    adc #2                                                            ; 897a: 69 02       i.
    adc l0025                                                         ; 897c: 65 25       e%
    pha                                                               ; 897e: 48          H
    lda l0026                                                         ; 897f: a5 26       .&
    adc #0                                                            ; 8981: 69 00       i.
; &8983 referenced 1 time by &8997
.loop_c8983
    sta l003b                                                         ; 8983: 85 3b       .;
    pla                                                               ; 8985: 68          h
    sta l003a                                                         ; 8986: 85 3a       .:
    sec                                                               ; 8988: 38          8
    php                                                               ; 8989: 08          .
    jmp c889e                                                         ; 898a: 4c 9e 88    L..

; &898d referenced 1 time by &8977
.c898d
    clc                                                               ; 898d: 18          .
    adc #2                                                            ; 898e: 69 02       i.
    adc l0025                                                         ; 8990: 65 25       e%
    pha                                                               ; 8992: 48          H
    lda l0026                                                         ; 8993: a5 26       .&
    sbc #0                                                            ; 8995: e9 00       ..
    jmp loop_c8983                                                    ; 8997: 4c 83 89    L..

; &899a referenced 1 time by &8973
.c899a
    cmp #&13                                                          ; 899a: c9 13       ..
    bne c89a7                                                         ; 899c: d0 09       ..
    jsr print_open_bracket                                            ; 899e: 20 e4 89     ..
    jsr c8894                                                         ; 89a1: 20 94 88     ..
    jmp print_close_bracket                                           ; 89a4: 4c 44 89    LD.

; &89a7 referenced 1 time by &899c
.c89a7
    cmp #&14                                                          ; 89a7: c9 14       ..
    bne c89b7                                                         ; 89a9: d0 0c       ..
    jsr print_open_bracket                                            ; 89ab: 20 e4 89     ..
    jsr sub_c88e1                                                     ; 89ae: 20 e1 88     ..
    jsr print_indexed_x                                               ; 89b1: 20 01 89     ..
    jmp print_close_bracket                                           ; 89b4: 4c 44 89    LD.

; &89b7 referenced 1 time by &89a9
.c89b7
    cmp #&15                                                          ; 89b7: c9 15       ..
    bne c89d0                                                         ; 89b9: d0 15       ..
; &89bb referenced 1 time by &89d4
.sub_c89bb
    lda l0000                                                         ; 89bb: a5 00       ..
    and #&70 ; 'p'                                                    ; 89bd: 29 70       )p
    lsr a                                                             ; 89bf: 4a          J
    lsr a                                                             ; 89c0: 4a          J
    lsr a                                                             ; 89c1: 4a          J
    lsr a                                                             ; 89c2: 4a          J
    ora #&30 ; '0'                                                    ; 89c3: 09 30       .0
    jsr oswrch                                                        ; 89c5: 20 ee ff     ..            ; Write character
    lda #&2c ; ','                                                    ; 89c8: a9 2c       .,
    jsr oswrch                                                        ; 89ca: 20 ee ff     ..            ; Write character 44
    jmp c8894                                                         ; 89cd: 4c 94 88    L..

; &89d0 referenced 1 time by &89b9
.c89d0
    cmp #&16                                                          ; 89d0: c9 16       ..
    bne return_5                                                      ; 89d2: d0 15       ..
    jsr sub_c89bb                                                     ; 89d4: 20 bb 89     ..
    lda #&5d ; ']'                                                    ; 89d7: a9 5d       .]
    jsr oswrch                                                        ; 89d9: 20 ee ff     ..            ; Write character 93
    lda l0002                                                         ; 89dc: a5 02       ..
    clc                                                               ; 89de: 18          .
    adc #1                                                            ; 89df: 69 01       i.
    jmp c8977                                                         ; 89e1: 4c 77 89    Lw.

; ***************************************************************************************
; &89e4 referenced 6 times by &892e, &893e, &8955, &8965, &899e, &89ab
.print_open_bracket
    lda #&28 ; '('                                                    ; 89e4: a9 28       .(
    jmp oswrch                                                        ; 89e6: 4c ee ff    L..            ; Write character 40

; &89e9 referenced 1 time by &89d2
.return_5
    rts                                                               ; 89e9: 60          `

; ***************************************************************************************
; &89ea referenced 1 time by &8ba3
.sub_m89ea
    sec                                                               ; 89ea: 38          8
    lda l00ff                                                         ; 89eb: a5 ff       ..
    bmi return_6                                                      ; 89ed: 30 18       0.
    clc                                                               ; 89ef: 18          .
    lda l0056                                                         ; 89f0: a5 56       .V
    bne return_6                                                      ; 89f2: d0 13       ..
    sec                                                               ; 89f4: 38          8
    bit l00ff                                                         ; 89f5: 24 ff       $.
    bmi return_6                                                      ; 89f7: 30 0e       0.
    lda l0026                                                         ; 89f9: a5 26       .&
    cmp l0028                                                         ; 89fb: c5 28       .(
    bcc return_6                                                      ; 89fd: 90 08       ..
    bne return_6                                                      ; 89ff: d0 06       ..
    lda l0025                                                         ; 8a01: a5 25       .%
    cmp l0027                                                         ; 8a03: c5 27       .'
    beq c8a08                                                         ; 8a05: f0 01       ..
; &8a07 referenced 5 times by &89ed, &89f2, &89f7, &89fd, &89ff
.return_6
    rts                                                               ; 8a07: 60          `

; &8a08 referenced 1 time by &8a05
.c8a08
    clc                                                               ; 8a08: 18          .
    rts                                                               ; 8a09: 60          `

; ***************************************************************************************
; &8a0a referenced 3 times by &8b06, &8b1e, &8b21
.sub_m8a0a
    lda #7                                                            ; 8a0a: a9 07       ..
    jsr blank_from_x_if_required                                      ; 8a0c: 20 92 8c     ..
    jsr sub_c8a41                                                     ; 8a0f: 20 41 8a     A.
    jsr print_inline_string                                           ; 8a12: 20 6b 8a     k.
    equb &87, &3f, &44, &3f                                           ; 8a15: 87 3f 44... .?D
    equb &ff                                                          ; 8a19: ff          .

    lda #&1b                                                          ; 8a1a: a9 1b       ..
    jsr blank_from_x_if_required                                      ; 8a1c: 20 92 8c     ..
    lda #&83                                                          ; 8a1f: a9 83       ..
    jsr sub_c8a50                                                     ; 8a21: 20 50 8a     P.
    lda l0000                                                         ; 8a24: a5 00       ..
    jsr hex_to_digit                                                  ; 8a26: 20 c8 88     ..
    lda #&23 ; '#'                                                    ; 8a29: a9 23       .#
    jsr blank_from_x_if_required                                      ; 8a2b: 20 92 8c     ..
    lda l0000                                                         ; 8a2e: a5 00       ..
    jsr sub_c8a5d                                                     ; 8a30: 20 5d 8a     ].
    jsr osnewl                                                        ; 8a33: 20 e7 ff     ..            ; Write newline (characters 10 and 13)
    inc l0025                                                         ; 8a36: e6 25       .%
    bne c8a3c                                                         ; 8a38: d0 02       ..
    inc l0026                                                         ; 8a3a: e6 26       .&
; &8a3c referenced 1 time by &8a38
.c8a3c
    lda #3                                                            ; 8a3c: a9 03       ..
    jmp c8d47                                                         ; 8a3e: 4c 47 8d    LG.

; &8a41 referenced 7 times by &8a0f, &8b34, &8e5d, &8edb, &94b5, &94e8, &997c
.sub_c8a41
    lda #&82                                                          ; 8a41: a9 82       ..
    jsr sub_c8a50                                                     ; 8a43: 20 50 8a     P.
    lda l0026                                                         ; 8a46: a5 26       .&
    jsr hex_to_digit                                                  ; 8a48: 20 c8 88     ..
    lda l0025                                                         ; 8a4b: a5 25       .%
    jmp hex_to_digit                                                  ; 8a4d: 4c c8 88    L..

; &8a50 referenced 12 times by &8876, &8a21, &8a43, &8a79, &8b50, &8bf0, &8e67, &8e8d, &8ee0, &95f2, &95fe, &9981
.sub_c8a50
    bit l003f                                                         ; 8a50: 24 3f       $?
    bpl call_jmp_oswrch                                               ; 8a52: 10 06       ..
    ora #0                                                            ; 8a54: 09 00       ..
    bpl call_jmp_oswrch                                               ; 8a56: 10 02       ..
    lda #&20 ; ' '                                                    ; 8a58: a9 20       .
; ***************************************************************************************
; &8a5a referenced 4 times by &8a52, &8a56, &8a65, &8a69
.call_jmp_oswrch
    jmp oswrch                                                        ; 8a5a: 4c ee ff    L..

; &8a5d referenced 8 times by &8a30, &8b71, &8c7c, &8d0c, &8e9f, &8eec, &961c, &99a0
.sub_c8a5d
    and #&7f                                                          ; 8a5d: 29 7f       ).
    cmp #&20 ; ' '                                                    ; 8a5f: c9 20       .
    bcc c8a67                                                         ; 8a61: 90 04       ..
    cmp #&7f                                                          ; 8a63: c9 7f       ..
    bne call_jmp_oswrch                                               ; 8a65: d0 f3       ..
; &8a67 referenced 1 time by &8a61
.c8a67
    lda #&2e ; '.'                                                    ; 8a67: a9 2e       ..
    bne call_jmp_oswrch                                               ; 8a69: d0 ef       ..             ; ALWAYS branch

; ***************************************************************************************
; &8a6b referenced 38 times by &8901, &890f, &8a12, &8bf3, &8c85, &8f80, &8fb3, &8ff3, &9009, &94a7, &94b8, &94dc, &96e7, &9723, &9809, &9819, &9825, &9843, &988a, &98ad, &996d, &99e1, &9a93, &9b8e, &9bfe, &9c0b, &9c6e, &9c7c, &9c9d, &9cae, &9cbf, &9cd4, &9d46, &9e63, &9ea3, &9eaf, &9ec3, &9ed5
.print_inline_string
    pla                                                               ; 8a6b: 68          h
    sta l007f                                                         ; 8a6c: 85 7f       ..
    pla                                                               ; 8a6e: 68          h
    sta l0080                                                         ; 8a6f: 85 80       ..
    ldy #1                                                            ; 8a71: a0 01       ..
; &8a73 referenced 1 time by &8a7d
.loop_c8a73
    lda (l007f),y                                                     ; 8a73: b1 7f       ..
    cmp #&ff                                                          ; 8a75: c9 ff       ..
    beq fix_rts_address                                               ; 8a77: f0 06       ..
    jsr sub_c8a50                                                     ; 8a79: 20 50 8a     P.
    iny                                                               ; 8a7c: c8          .
    bne loop_c8a73                                                    ; 8a7d: d0 f4       ..
; ***************************************************************************************
; &8a7f referenced 1 time by &8a77
.fix_rts_address
    tya                                                               ; 8a7f: 98          .
    clc                                                               ; 8a80: 18          .
    adc l007f                                                         ; 8a81: 65 7f       e.
    tay                                                               ; 8a83: a8          .
    lda l0080                                                         ; 8a84: a5 80       ..
    adc #0                                                            ; 8a86: 69 00       i.
    pha                                                               ; 8a88: 48          H
    tya                                                               ; 8a89: 98          .
    pha                                                               ; 8a8a: 48          H
    rts                                                               ; 8a8b: 60          `

; &8a8c referenced 1 time by &9222
.c8a8c
    lda #&8b                                                          ; 8a8c: a9 8b       ..
    sta l0044                                                         ; 8a8e: 85 44       .D
    ldy #&84                                                          ; 8a90: a0 84       ..
    lda #&8b                                                          ; 8a92: a9 8b       ..
    ldx #&85                                                          ; 8a94: a2 85       ..
    bne c8aa2                                                         ; 8a96: d0 0a       ..             ; ALWAYS branch

; &8a98 referenced 1 time by &921f
.c8a98
    lda #&94                                                          ; 8a98: a9 94       ..
    sta l0044                                                         ; 8a9a: 85 44       .D
    ldy #&80                                                          ; 8a9c: a0 80       ..
    lda #&94                                                          ; 8a9e: a9 94       ..
    ldx #&81                                                          ; 8aa0: a2 81       ..
; &8aa2 referenced 1 time by &8a96
.c8aa2
    sta l0042                                                         ; 8aa2: 85 42       .B
    stx l0043                                                         ; 8aa4: 86 43       .C
    sty l0045                                                         ; 8aa6: 84 45       .E
; &8aa8 referenced 2 times by &8af1, &8bb1
.c8aa8
    lda #3                                                            ; 8aa8: a9 03       ..
    jsr c8d47                                                         ; 8aaa: 20 47 8d     G.
    ldy l0000                                                         ; 8aad: a4 00       ..
    bit ext_flag                                                      ; 8aaf: 24 8e       $.
    bmi c8ac1                                                         ; 8ab1: 30 0e       0.
    lda (l0042),y                                                     ; 8ab3: b1 42       .B
    bmi c8abf                                                         ; 8ab5: 30 08       0.
    lda (l0044),y                                                     ; 8ab7: b1 44       .D
    beq c8abf                                                         ; 8ab9: f0 04       ..
    cmp #&39 ; '9'                                                    ; 8abb: c9 39       .9
    bcc c8ac1                                                         ; 8abd: 90 02       ..
; &8abf referenced 2 times by &8ab5, &8ab9
.c8abf
    ldy #&12                                                          ; 8abf: a0 12       ..
; &8ac1 referenced 2 times by &8ab1, &8abd
.c8ac1
    sty l0005                                                         ; 8ac1: 84 05       ..
; &8ac3 referenced 2 times by &8b09, &8b24
.c8ac3
    jsr sub_c875f                                                     ; 8ac3: 20 5f 87     _.
    bcc c8af4                                                         ; 8ac6: 90 2c       .,
    ldy #0                                                            ; 8ac8: a0 00       ..
    lda (l003c),y                                                     ; 8aca: b1 3c       .<
    cmp #1                                                            ; 8acc: c9 01       ..
    bne c8b27                                                         ; 8ace: d0 57       .W
    lda l0027                                                         ; 8ad0: a5 27       .'
    pha                                                               ; 8ad2: 48          H
    lda l0028                                                         ; 8ad3: a5 28       .(
    pha                                                               ; 8ad5: 48          H
    ldy #5                                                            ; 8ad6: a0 05       ..
    lda (l003c),y                                                     ; 8ad8: b1 3c       .<
    sta l0027                                                         ; 8ada: 85 27       .'
    iny                                                               ; 8adc: c8          .              ; Y=&06
    lda (l003c),y                                                     ; 8add: b1 3c       .<
    sta l0028                                                         ; 8adf: 85 28       .(
    jsr c8e4f                                                         ; 8ae1: 20 4f 8e     O.
    bit l00ff                                                         ; 8ae4: 24 ff       $.
    bpl c8aeb                                                         ; 8ae6: 10 03       ..
    jmp c8091                                                         ; 8ae8: 4c 91 80    L..

; &8aeb referenced 1 time by &8ae6
.c8aeb
    pla                                                               ; 8aeb: 68          h
    sta l0028                                                         ; 8aec: 85 28       .(
    pla                                                               ; 8aee: 68          h
    sta l0027                                                         ; 8aef: 85 27       .'
    jmp c8aa8                                                         ; 8af1: 4c a8 8a    L..

; &8af4 referenced 1 time by &8ac6
.c8af4
    jsr sub_c8d15                                                     ; 8af4: 20 15 8d     ..
    cmp #1                                                            ; 8af7: c9 01       ..
    beq c8b27                                                         ; 8af9: f0 2c       .,
    inc l003a                                                         ; 8afb: e6 3a       .:
    bne c8b01                                                         ; 8afd: d0 02       ..
    inc l003b                                                         ; 8aff: e6 3b       .;
; &8b01 referenced 1 time by &8afd
.c8b01
    jsr sub_c8767                                                     ; 8b01: 20 67 87     g.
    bcc c8b0c                                                         ; 8b04: 90 06       ..
    jsr sub_m8a0a                                                     ; 8b06: 20 0a 8a     ..
    jmp c8ac3                                                         ; 8b09: 4c c3 8a    L..

; &8b0c referenced 1 time by &8b04
.c8b0c
    jsr sub_c8d15                                                     ; 8b0c: 20 15 8d     ..
    cmp #2                                                            ; 8b0f: c9 02       ..
    beq c8b27                                                         ; 8b11: f0 14       ..
    inc l003a                                                         ; 8b13: e6 3a       .:
    bne c8b19                                                         ; 8b15: d0 02       ..
    inc l003b                                                         ; 8b17: e6 3b       .;
; &8b19 referenced 1 time by &8b15
.c8b19
    jsr sub_c8767                                                     ; 8b19: 20 67 87     g.
    bcc c8b27                                                         ; 8b1c: 90 09       ..
    jsr sub_m8a0a                                                     ; 8b1e: 20 0a 8a     ..
    jsr sub_m8a0a                                                     ; 8b21: 20 0a 8a     ..
    jmp c8ac3                                                         ; 8b24: 4c c3 8a    L..

; &8b27 referenced 4 times by &8ace, &8af9, &8b11, &8b1c
.c8b27
    jsr sub_c875f                                                     ; 8b27: 20 5f 87     _.
    bcc c8b2f                                                         ; 8b2a: 90 03       ..
    jsr sub_c8c6c                                                     ; 8b2c: 20 6c 8c     l.
; &8b2f referenced 1 time by &8b2a
.c8b2f
    lda #7                                                            ; 8b2f: a9 07       ..
    jsr blank_from_x_if_required                                      ; 8b31: 20 92 8c     ..
    jsr sub_c8a41                                                     ; 8b34: 20 41 8a     A.
    ldy l0005                                                         ; 8b37: a4 05       ..
; &8b39 referenced 1 time by &8bbb
.c8b39
    sty l0005                                                         ; 8b39: 84 05       ..
    lda (l0042),y                                                     ; 8b3b: b1 42       .B
    bmi c8bb5                                                         ; 8b3d: 30 76       0v
    pha                                                               ; 8b3f: 48          H
    lda (l0044),y                                                     ; 8b40: b1 44       .D
    tax                                                               ; 8b42: aa          .
    pla                                                               ; 8b43: 68          h
    tay                                                               ; 8b44: a8          .
    txa                                                               ; 8b45: 8a          .
    jsr sub_m884b                                                     ; 8b46: 20 4b 88     K.
; &8b49 referenced 5 times by &8be7, &8c0a, &8c33, &8c4d, &8c69
.c8b49
    lda #&1b                                                          ; 8b49: a9 1b       ..
    jsr blank_from_x_if_required                                      ; 8b4b: 20 92 8c     ..
    lda #&83                                                          ; 8b4e: a9 83       ..
    jsr sub_c8a50                                                     ; 8b50: 20 50 8a     P.
    jsr sub_c8d15                                                     ; 8b53: 20 15 8d     ..
    tax                                                               ; 8b56: aa          .
    pha                                                               ; 8b57: 48          H
    ldy #0                                                            ; 8b58: a0 00       ..
; &8b5a referenced 1 time by &8b62
.loop_c8b5a
    lda l0000,y                                                       ; 8b5a: b9 00 00    ...
    jsr hex_to_digit                                                  ; 8b5d: 20 c8 88     ..
    iny                                                               ; 8b60: c8          .
    dex                                                               ; 8b61: ca          .
    bne loop_c8b5a                                                    ; 8b62: d0 f6       ..
    lda #&23 ; '#'                                                    ; 8b64: a9 23       .#
    jsr blank_from_x_if_required                                      ; 8b66: 20 92 8c     ..
    pla                                                               ; 8b69: 68          h
    pha                                                               ; 8b6a: 48          H
    tax                                                               ; 8b6b: aa          .
    ldy #0                                                            ; 8b6c: a0 00       ..
; &8b6e referenced 1 time by &8b76
.loop_c8b6e
    lda l0000,y                                                       ; 8b6e: b9 00 00    ...
    jsr sub_c8a5d                                                     ; 8b71: 20 5d 8a     ].
    iny                                                               ; 8b74: c8          .
    dex                                                               ; 8b75: ca          .
    bne loop_c8b6e                                                    ; 8b76: d0 f6       ..
    jsr osnewl                                                        ; 8b78: 20 e7 ff     ..            ; Write newline (characters 10 and 13)
    pla                                                               ; 8b7b: 68          h
    clc                                                               ; 8b7c: 18          .
    adc l0025                                                         ; 8b7d: 65 25       e%
    sta l0025                                                         ; 8b7f: 85 25       .%
    bcc c8b85                                                         ; 8b81: 90 02       ..
    inc l0026                                                         ; 8b83: e6 26       .&
; &8b85 referenced 1 time by &8b81
.c8b85
    lda l0000                                                         ; 8b85: a5 00       ..
    cmp #&20 ; ' '                                                    ; 8b87: c9 20       .
    bne c8ba3                                                         ; 8b89: d0 18       ..
    lda l0001                                                         ; 8b8b: a5 01       ..
    sta l003a                                                         ; 8b8d: 85 3a       .:
    lda l0002                                                         ; 8b8f: a5 02       ..
    sta l003b                                                         ; 8b91: 85 3b       .;
    jsr sub_c8767                                                     ; 8b93: 20 67 87     g.
    bcc c8ba3                                                         ; 8b96: 90 0b       ..
    ldy #0                                                            ; 8b98: a0 00       ..
    lda (l003c),y                                                     ; 8b9a: b1 3c       .<
    cmp #2                                                            ; 8b9c: c9 02       ..
    bne c8ba3                                                         ; 8b9e: d0 03       ..
    jsr sub_c8caf                                                     ; 8ba0: 20 af 8c     ..
; &8ba3 referenced 3 times by &8b89, &8b96, &8b9e
.c8ba3
    jsr sub_m89ea                                                     ; 8ba3: 20 ea 89     ..
    bcs return_7                                                      ; 8ba6: b0 0c       ..
    lda l0000                                                         ; 8ba8: a5 00       ..
    cmp #&60 ; '`'                                                    ; 8baa: c9 60       .`
    bne c8bb1                                                         ; 8bac: d0 03       ..
    jsr osnewl                                                        ; 8bae: 20 e7 ff     ..            ; Write newline (characters 10 and 13)
; &8bb1 referenced 1 time by &8bac
.c8bb1
    jmp c8aa8                                                         ; 8bb1: 4c a8 8a    L..

; &8bb4 referenced 1 time by &8ba6
.return_7
    rts                                                               ; 8bb4: 60          `

; &8bb5 referenced 1 time by &8b3d
.c8bb5
    bit ext_flag                                                      ; 8bb5: 24 8e       $.
    bmi c8bbe                                                         ; 8bb7: 30 05       0.
    ldy #&12                                                          ; 8bb9: a0 12       ..
    jmp c8b39                                                         ; 8bbb: 4c 39 8b    L9.

; &8bbe referenced 1 time by &8bb7
.c8bbe
    cpy #&4b ; 'K'                                                    ; 8bbe: c0 4b       .K
    bne c8bd2                                                         ; 8bc0: d0 10       ..
    lda #2                                                            ; 8bc2: a9 02       ..
    ldy #2                                                            ; 8bc4: a0 02       ..
    jsr sub_m884b                                                     ; 8bc6: 20 4b 88     K.
    jsr default_to_x_pos                                              ; 8bc9: 20 90 8c     ..
    lda #&21 ; '!'                                                    ; 8bcc: a9 21       .!
    ldy #9                                                            ; 8bce: a0 09       ..
    bne c8be4                                                         ; 8bd0: d0 12       ..             ; ALWAYS branch

; &8bd2 referenced 1 time by &8bc0
.c8bd2
    cpy #&8b                                                          ; 8bd2: c0 8b       ..
    bne c8bea                                                         ; 8bd4: d0 14       ..
    lda #&36 ; '6'                                                    ; 8bd6: a9 36       .6
    ldy #&0a                                                          ; 8bd8: a0 0a       ..
    jsr sub_m884b                                                     ; 8bda: 20 4b 88     K.
    jsr default_to_x_pos                                              ; 8bdd: 20 90 8c     ..
    lda #2                                                            ; 8be0: a9 02       ..
    ldy #2                                                            ; 8be2: a0 02       ..
; &8be4 referenced 1 time by &8bd0
.c8be4
    jsr sub_m884b                                                     ; 8be4: 20 4b 88     K.
    jmp c8b49                                                         ; 8be7: 4c 49 8b    LI.

; &8bea referenced 1 time by &8bd4
.c8bea
    cpy #&cb                                                          ; 8bea: c0 cb       ..
    bne c8c0d                                                         ; 8bec: d0 1f       ..
    lda #&87                                                          ; 8bee: a9 87       ..
    jsr sub_c8a50                                                     ; 8bf0: 20 50 8a     P.
    jsr print_inline_string                                           ; 8bf3: 20 6b 8a     k.
    equs "SBX(A.X)#"                                                  ; 8bf6: 53 42 58... SBX
    equb &ff                                                          ; 8bff: ff          .

    lda #&26 ; '&'                                                    ; 8c00: a9 26       .&
    jsr oswrch                                                        ; 8c02: 20 ee ff     ..            ; Write character 38
    lda l0001                                                         ; 8c05: a5 01       ..
    jsr hex_to_digit                                                  ; 8c07: 20 c8 88     ..
    jmp c8b49                                                         ; 8c0a: 4c 49 8b    LI.

; &8c0d referenced 1 time by &8bec
.c8c0d
    tya                                                               ; 8c0d: 98          .
    ldx #6                                                            ; 8c0e: a2 06       ..
; &8c10 referenced 1 time by &8c16
.loop_c8c10
    cmp table_6,x                                                     ; 8c10: dd 80 83    ...
    beq c8c1a                                                         ; 8c13: f0 05       ..
    dex                                                               ; 8c15: ca          .
    bpl loop_c8c10                                                    ; 8c16: 10 f8       ..
    bmi c8c36                                                         ; 8c18: 30 1c       0.             ; ALWAYS branch

; &8c1a referenced 1 time by &8c13
.c8c1a
    lda #&22 ; '"'                                                    ; 8c1a: a9 22       ."
    ldy #&0a                                                          ; 8c1c: a0 0a       ..
    jsr sub_m884b                                                     ; 8c1e: 20 4b 88     K.
    lda #2                                                            ; 8c21: a9 02       ..
    sta l006e                                                         ; 8c23: 85 6e       .n
; &8c25 referenced 1 time by &8c31
.loop_c8c25
    jsr default_to_x_pos                                              ; 8c25: 20 90 8c     ..
    lda #&22 ; '"'                                                    ; 8c28: a9 22       ."
    ldy #&0a                                                          ; 8c2a: a0 0a       ..
    jsr sub_m884b                                                     ; 8c2c: 20 4b 88     K.
    dec l006e                                                         ; 8c2f: c6 6e       .n
    bne loop_c8c25                                                    ; 8c31: d0 f2       ..
    jmp c8b49                                                         ; 8c33: 4c 49 8b    LI.

; &8c36 referenced 1 time by &8c18
.c8c36
    ldx #0                                                            ; 8c36: a2 00       ..
    sta l006d                                                         ; 8c38: 85 6d       .m
; &8c3a referenced 1 time by &8c44
.loop_c8c3a
    lda table_2,x                                                     ; 8c3a: bd 87 83    ...
    beq c8c46                                                         ; 8c3d: f0 07       ..
    cmp l006d                                                         ; 8c3f: c5 6d       .m
    beq c8c50                                                         ; 8c41: f0 0d       ..
    inx                                                               ; 8c43: e8          .
    bne loop_c8c3a                                                    ; 8c44: d0 f4       ..
; &8c46 referenced 1 time by &8c3d
.c8c46
    lda #&3a ; ':'                                                    ; 8c46: a9 3a       .:
    ldy #&0a                                                          ; 8c48: a0 0a       ..
    jsr sub_m884b                                                     ; 8c4a: 20 4b 88     K.
    jmp c8b49                                                         ; 8c4d: 4c 49 8b    LI.

; &8c50 referenced 1 time by &8c41
.c8c50
    stx l006f                                                         ; 8c50: 86 6f       .o
    lda table_3,x                                                     ; 8c52: bd c8 83    ...
    ldy table_4,x                                                     ; 8c55: bc 09 84    ...
    jsr sub_m884b                                                     ; 8c58: 20 4b 88     K.
    jsr default_to_x_pos                                              ; 8c5b: 20 90 8c     ..
    ldx l006f                                                         ; 8c5e: a6 6f       .o
    lda table_5,x                                                     ; 8c60: bd 4a 84    .J.
    ldy table_4,x                                                     ; 8c63: bc 09 84    ...
    jsr sub_m884b                                                     ; 8c66: 20 4b 88     K.
    jmp c8b49                                                         ; 8c69: 4c 49 8b    LI.

; &8c6c referenced 3 times by &88b4, &8b2c, &94f3
.sub_c8c6c
    ldy #0                                                            ; 8c6c: a0 00       ..
    lda (l003c),y                                                     ; 8c6e: b1 3c       .<
    cmp #2                                                            ; 8c70: c9 02       ..
    beq print_printm                                                  ; 8c72: f0 11       ..
    cmp #&20 ; ' '                                                    ; 8c74: c9 20       .
    bcc return_8                                                      ; 8c76: 90 0c       ..
; &8c78 referenced 1 time by &8c82
.loop_c8c78
    lda (l003c),y                                                     ; 8c78: b1 3c       .<
    beq return_8                                                      ; 8c7a: f0 08       ..
    jsr sub_c8a5d                                                     ; 8c7c: 20 5d 8a     ].
    iny                                                               ; 8c7f: c8          .
    cpy #7                                                            ; 8c80: c0 07       ..
    bne loop_c8c78                                                    ; 8c82: d0 f4       ..
; &8c84 referenced 2 times by &8c76, &8c7a
.return_8
    rts                                                               ; 8c84: 60          `

; ***************************************************************************************
; &8c85 referenced 1 time by &8c72
.print_printm
    jsr print_inline_string                                           ; 8c85: 20 6b 8a     k.
    equs "printm"                                                     ; 8c88: 70 72 69... pri
    equb &ff                                                          ; 8c8e: ff          .

    rts                                                               ; 8c8f: 60          `

; ***************************************************************************************
; &8c90 referenced 4 times by &8bc9, &8bdd, &8c25, &8c5b
.default_to_x_pos
    lda #&0c                                                          ; 8c90: a9 0c       ..
; ***************************************************************************************
; &8c92 referenced 9 times by &8a0c, &8a1c, &8a2b, &8b31, &8b4b, &8b66, &8d05, &8e88, &9f07
.blank_from_x_if_required
    sta to_x_pos                                                      ; 8c92: 85 24       .$
    lda #osbyte_read_text_cursor_pos                                  ; 8c94: a9 86       ..
    jsr osbyte                                                        ; 8c96: 20 f4 ff     ..            ; Read input cursor position (Sets X=POS and Y=VPOS)
    cpx to_x_pos                                                      ; 8c99: e4 24       .$             ; X is the horizontal text position ('POS')
    beq return_9                                                      ; 8c9b: f0 11       ..
    bcc overwrite_cursor_pos_with_space                               ; 8c9d: 90 05       ..
    jsr osnewl                                                        ; 8c9f: 20 e7 ff     ..            ; Write newline (characters 10 and 13)
    ldx #0                                                            ; 8ca2: a2 00       ..
; ***************************************************************************************
; &8ca4 referenced 1 time by &8c9d
.overwrite_cursor_pos_with_space
    lda #&20 ; ' '                                                    ; 8ca4: a9 20       .
; &8ca6 referenced 1 time by &8cac
.loop_c8ca6
    jsr oswrch                                                        ; 8ca6: 20 ee ff     ..            ; Write character 32
    inx                                                               ; 8ca9: e8          .
    cpx to_x_pos                                                      ; 8caa: e4 24       .$
    bne loop_c8ca6                                                    ; 8cac: d0 f8       ..
; &8cae referenced 1 time by &8c9b
.return_9
    rts                                                               ; 8cae: 60          `

; &8caf referenced 1 time by &8ba0
.sub_c8caf
    iny                                                               ; 8caf: c8          .
    lda (l003c),y                                                     ; 8cb0: b1 3c       .<
    sta l0046                                                         ; 8cb2: 85 46       .F
    iny                                                               ; 8cb4: c8          .
    lda (l003c),y                                                     ; 8cb5: b1 3c       .<
    sta l0047                                                         ; 8cb7: 85 47       .G
; &8cb9 referenced 1 time by &8cda
.c8cb9
    ldx #0                                                            ; 8cb9: a2 00       ..
; &8cbb referenced 1 time by &8cd5
.loop_c8cbb
    lda #1                                                            ; 8cbb: a9 01       ..
    jsr c8d47                                                         ; 8cbd: 20 47 8d     G.
    lda l0000                                                         ; 8cc0: a5 00       ..
    bit l0046                                                         ; 8cc2: 24 46       $F
    bmi c8cdd                                                         ; 8cc4: 30 17       0.
; &8cc6 referenced 1 time by &8cdf
.loop_c8cc6
    sta l0048,x                                                       ; 8cc6: 95 48       .H
    inc l0025                                                         ; 8cc8: e6 25       .%
    bne c8cce                                                         ; 8cca: d0 02       ..
    inc l0026                                                         ; 8ccc: e6 26       .&
; &8cce referenced 1 time by &8cca
.c8cce
    inx                                                               ; 8cce: e8          .
    cmp l0047                                                         ; 8ccf: c5 47       .G
    beq c8ce1                                                         ; 8cd1: f0 0e       ..
    cpx #8                                                            ; 8cd3: e0 08       ..
    bne loop_c8cbb                                                    ; 8cd5: d0 e4       ..
    jsr sub_c8cea                                                     ; 8cd7: 20 ea 8c     ..
    jmp c8cb9                                                         ; 8cda: 4c b9 8c    L..

; &8cdd referenced 1 time by &8cc4
.c8cdd
    ora #0                                                            ; 8cdd: 09 00       ..
    bpl loop_c8cc6                                                    ; 8cdf: 10 e5       ..
; &8ce1 referenced 1 time by &8cd1
.c8ce1
    jsr sub_c8cea                                                     ; 8ce1: 20 ea 8c     ..
    jsr osnewl                                                        ; 8ce4: 20 e7 ff     ..            ; Write newline (characters 10 and 13)
    jmp osnewl                                                        ; 8ce7: 4c e7 ff    L..            ; Write newline (characters 10 and 13)

; &8cea referenced 2 times by &8cd7, &8ce1
.sub_c8cea
    stx l006f                                                         ; 8cea: 86 6f       .o
    jsr osnewl                                                        ; 8cec: 20 e7 ff     ..            ; Write newline (characters 10 and 13)
    txa                                                               ; 8cef: 8a          .
    beq return_10                                                     ; 8cf0: f0 22       ."
    ldx #0                                                            ; 8cf2: a2 00       ..
; &8cf4 referenced 1 time by &8d01
.loop_c8cf4
    lda l0048,x                                                       ; 8cf4: b5 48       .H
    jsr hex_to_digit                                                  ; 8cf6: 20 c8 88     ..
    lda #&20 ; ' '                                                    ; 8cf9: a9 20       .
    jsr oswrch                                                        ; 8cfb: 20 ee ff     ..            ; Write character 32
    inx                                                               ; 8cfe: e8          .
    cpx l006f                                                         ; 8cff: e4 6f       .o
    bne loop_c8cf4                                                    ; 8d01: d0 f1       ..
    lda #&1b                                                          ; 8d03: a9 1b       ..
    jsr blank_from_x_if_required                                      ; 8d05: 20 92 8c     ..
    ldx #0                                                            ; 8d08: a2 00       ..
; &8d0a referenced 1 time by &8d12
.loop_c8d0a
    lda l0048,x                                                       ; 8d0a: b5 48       .H
    jsr sub_c8a5d                                                     ; 8d0c: 20 5d 8a     ].
    inx                                                               ; 8d0f: e8          .
    cpx l006f                                                         ; 8d10: e4 6f       .o
    bne loop_c8d0a                                                    ; 8d12: d0 f6       ..
; &8d14 referenced 1 time by &8cf0
.return_10
    rts                                                               ; 8d14: 60          `

; &8d15 referenced 3 times by &8af4, &8b0c, &8b53
.sub_c8d15
    ldy l0005                                                         ; 8d15: a4 05       ..
    lda (l0042),y                                                     ; 8d17: b1 42       .B
    bmi c8d20                                                         ; 8d19: 30 05       0.
    tay                                                               ; 8d1b: a8          .
    lda table_7,y                                                     ; 8d1c: b9 69 83    .i.
    rts                                                               ; 8d1f: 60          `

; &8d20 referenced 1 time by &8d19
.c8d20
    tya                                                               ; 8d20: 98          .
    ldy #&1a                                                          ; 8d21: a0 1a       ..
; &8d23 referenced 1 time by &8d29
.loop_c8d23
    cmp os_entry_points,y                                             ; 8d23: d9 8b 86    ...
    beq c8d2e                                                         ; 8d26: f0 06       ..
    dey                                                               ; 8d28: 88          .
    bpl loop_c8d23                                                    ; 8d29: 10 f8       ..
    lda #2                                                            ; 8d2b: a9 02       ..
    rts                                                               ; 8d2d: 60          `

; &8d2e referenced 1 time by &8d26
.c8d2e
    lda #3                                                            ; 8d2e: a9 03       ..
    rts                                                               ; 8d30: 60          `

; &8d31 referenced 6 times by &8d69, &8d7c, &8d8b, &8d92, &8da7, &8db0
.sub_c8d31
    lda #6                                                            ; 8d31: a9 06       ..
; &8d33 referenced 1 time by &8dba
.sub_c8d33
    ldx #<(l0050)                                                     ; 8d33: a2 50       .P
    ldy #>(l0050)                                                     ; 8d35: a0 00       ..
    jmp osword                                                        ; 8d37: 4c f1 ff    L..

; &8d3a referenced 1 time by &8d64
.l8d3a
    equb &a0, 0, &20, &b9, &ff, &85, &f6, &60                         ; 8d3a: a0 00 20... ..

; &8d42 referenced 6 times by &93e4, &95df, &9612, &976d, &977f, &97a0
.sub_c8d42
    sta l006d                                                         ; 8d42: 85 6d       .m
    jmp c8d59                                                         ; 8d44: 4c 59 8d    LY.

; &8d47 referenced 6 times by &8a3e, &8aaa, &8cbd, &8e62, &8ed5, &9a76
.c8d47
    bit l0086                                                         ; 8d47: 24 86       $.
    bpl c8d4e                                                         ; 8d49: 10 03       ..
    jmp c8de7                                                         ; 8d4b: 4c e7 8d    L..

; &8d4e referenced 4 times by &8d49, &8de7, &98f1, &9979
.c8d4e
    stx l0087                                                         ; 8d4e: 86 87       ..
    sta l006d                                                         ; 8d50: 85 6d       .m
    bit tube_flag                                                     ; 8d52: 24 6b       $k
    bpl c8d59                                                         ; 8d54: 10 03       ..
    jmp c8e39                                                         ; 8d56: 4c 39 8e    L9.

; &8d59 referenced 2 times by &8d44, &8d54
.c8d59
    ldx #1                                                            ; 8d59: a2 01       ..
    stx l0051                                                         ; 8d5b: 86 51       .Q
    dex                                                               ; 8d5d: ca          .              ; X=&00
    stx l0050                                                         ; 8d5e: 86 50       .P
    stx l0052                                                         ; 8d60: 86 52       .R
    stx l0053                                                         ; 8d62: 86 53       .S
; &8d64 referenced 1 time by &8d72
.loop_c8d64
    lda l8d3a,x                                                       ; 8d64: bd 3a 8d    .:.
    sta l0054                                                         ; 8d67: 85 54       .T
    jsr sub_c8d31                                                     ; 8d69: 20 31 8d     1.
    inc l0050                                                         ; 8d6c: e6 50       .P
    ldx l0050                                                         ; 8d6e: a6 50       .P
    cpx #&0a                                                          ; 8d70: e0 0a       ..
    bne loop_c8d64                                                    ; 8d72: d0 f0       ..
    ldy #1                                                            ; 8d74: a0 01       ..
    sty l0050                                                         ; 8d76: 84 50       .P
    lda l0055                                                         ; 8d78: a5 55       .U
    sta l0054                                                         ; 8d7a: 85 54       .T
    jsr sub_c8d31                                                     ; 8d7c: 20 31 8d     1.
    lda #0                                                            ; 8d7f: a9 00       ..
    sta l006e                                                         ; 8d81: 85 6e       .n
    sta l0054                                                         ; 8d83: 85 54       .T
    sta l0050                                                         ; 8d85: 85 50       .P
    lda #2                                                            ; 8d87: a9 02       ..
    sta l0051                                                         ; 8d89: 85 51       .Q
    jsr sub_c8d31                                                     ; 8d8b: 20 31 8d     1.
    inc l0050                                                         ; 8d8e: e6 50       .P
    inc l0054                                                         ; 8d90: e6 54       .T
    jsr sub_c8d31                                                     ; 8d92: 20 31 8d     1.
    lda l0025                                                         ; 8d95: a5 25       .%
    pha                                                               ; 8d97: 48          H
    lda l0026                                                         ; 8d98: a5 26       .&
    pha                                                               ; 8d9a: 48          H
; &8d9b referenced 1 time by &8dcf
.c8d9b
    lda #0                                                            ; 8d9b: a9 00       ..
    sta l0051                                                         ; 8d9d: 85 51       .Q
    lda #&f7                                                          ; 8d9f: a9 f7       ..
    sta l0050                                                         ; 8da1: 85 50       .P
    lda l0026                                                         ; 8da3: a5 26       .&
    sta l0054                                                         ; 8da5: 85 54       .T
    jsr sub_c8d31                                                     ; 8da7: 20 31 8d     1.
    dec l0050                                                         ; 8daa: c6 50       .P
    lda l0025                                                         ; 8dac: a5 25       .%
    sta l0054                                                         ; 8dae: 85 54       .T
    jsr sub_c8d31                                                     ; 8db0: 20 31 8d     1.
    lda #osbyte_code                                                  ; 8db3: a9 88       ..
    jsr osbyte                                                        ; 8db5: 20 f4 ff     ..            ; *CODE X,Y
    lda #5                                                            ; 8db8: a9 05       ..
    jsr sub_c8d33                                                     ; 8dba: 20 33 8d     3.
    lda l0054                                                         ; 8dbd: a5 54       .T
    ldx l006e                                                         ; 8dbf: a6 6e       .n
    sta l0000,x                                                       ; 8dc1: 95 00       ..
    inc l0025                                                         ; 8dc3: e6 25       .%
    bne c8dc9                                                         ; 8dc5: d0 02       ..
    inc l0026                                                         ; 8dc7: e6 26       .&
; &8dc9 referenced 1 time by &8dc5
.c8dc9
    inc l006e                                                         ; 8dc9: e6 6e       .n
    lda l006e                                                         ; 8dcb: a5 6e       .n
    cmp l006d                                                         ; 8dcd: c5 6d       .m
    bne c8d9b                                                         ; 8dcf: d0 ca       ..
    pla                                                               ; 8dd1: 68          h
    sta l0026                                                         ; 8dd2: 85 26       .&
    pla                                                               ; 8dd4: 68          h
    sta l0025                                                         ; 8dd5: 85 25       .%
; &8dd7 referenced 2 times by &8e37, &8e45
.c8dd7
    lda l0025                                                         ; 8dd7: a5 25       .%
    clc                                                               ; 8dd9: 18          .
    adc l006d                                                         ; 8dda: 65 6d       em
    sta l0050                                                         ; 8ddc: 85 50       .P
    lda l0026                                                         ; 8dde: a5 26       .&
    adc #0                                                            ; 8de0: 69 00       i.
    sta l0051                                                         ; 8de2: 85 51       .Q
    ldx l0087                                                         ; 8de4: a6 87       ..
; &8de6 referenced 5 times by &8dee, &8df6, &8dfe, &8e04, &8e2b
.return_11
    rts                                                               ; 8de6: 60          `

; &8de7 referenced 1 time by &8d4b
.c8de7
    jsr c8d4e                                                         ; 8de7: 20 4e 8d     N.
    lda l0026                                                         ; 8dea: a5 26       .&
    cmp l0082                                                         ; 8dec: c5 82       ..
    bcc return_11                                                     ; 8dee: 90 f6       ..
    bne c8df8                                                         ; 8df0: d0 06       ..
    lda l0025                                                         ; 8df2: a5 25       .%
    cmp l0081                                                         ; 8df4: c5 81       ..
    bcc return_11                                                     ; 8df6: 90 ee       ..
; &8df8 referenced 1 time by &8df0
.c8df8
    lda l0026                                                         ; 8df8: a5 26       .&
    cmp l0084                                                         ; 8dfa: c5 84       ..
    bcc c8e06                                                         ; 8dfc: 90 08       ..
    bne return_11                                                     ; 8dfe: d0 e6       ..
    lda l0025                                                         ; 8e00: a5 25       .%
    cmp l0083                                                         ; 8e02: c5 83       ..
    bcs return_11                                                     ; 8e04: b0 e0       ..
; &8e06 referenced 1 time by &8dfc
.c8e06
    lda l0025                                                         ; 8e06: a5 25       .%
    sec                                                               ; 8e08: 38          8
    sbc l0081                                                         ; 8e09: e5 81       ..
    sta l0029                                                         ; 8e0b: 85 29       .)
    lda l0026                                                         ; 8e0d: a5 26       .&
    sbc l0082                                                         ; 8e0f: e5 82       ..
    sta l002a                                                         ; 8e11: 85 2a       .*
    lda #0                                                            ; 8e13: a9 00       ..
    sta l002b                                                         ; 8e15: 85 2b       .+
    sta l002c                                                         ; 8e17: 85 2c       .,
    sta l006e                                                         ; 8e19: 85 6e       .n
    ldx #&29 ; ')'                                                    ; 8e1b: a2 29       .)             ; X=zero page address to write from
    ldy l0085                                                         ; 8e1d: a4 85       ..             ; Y=file handle
    lda #1                                                            ; 8e1f: a9 01       ..
    jsr osargs                                                        ; 8e21: 20 da ff     ..            ; Write sequential file pointer from zero page address X (A=1)
    ldx l006d                                                         ; 8e24: a6 6d       .m
; &8e26 referenced 1 time by &8e35
.loop_c8e26
    ldy l0085                                                         ; 8e26: a4 85       ..             ; Y=file handle
    jsr osbget                                                        ; 8e28: 20 d7 ff     ..            ; Read a single byte from an open file Y
    bcs return_11                                                     ; 8e2b: b0 b9       ..
    ldy l006e                                                         ; 8e2d: a4 6e       .n
    sta l0000,y                                                       ; 8e2f: 99 00 00    ...
    inc l006e                                                         ; 8e32: e6 6e       .n
    dex                                                               ; 8e34: ca          .
    bne loop_c8e26                                                    ; 8e35: d0 ef       ..
    beq c8dd7                                                         ; 8e37: f0 9e       ..             ; ALWAYS branch

; &8e39 referenced 1 time by &8d56
.c8e39
    tax                                                               ; 8e39: aa          .
    ldy #0                                                            ; 8e3a: a0 00       ..
; &8e3c referenced 1 time by &8e43
.loop_c8e3c
    lda (l0025),y                                                     ; 8e3c: b1 25       .%
    sta l0000,y                                                       ; 8e3e: 99 00 00    ...
    iny                                                               ; 8e41: c8          .
    dex                                                               ; 8e42: ca          .
    bpl loop_c8e3c                                                    ; 8e43: 10 f7       ..
    bmi c8dd7                                                         ; 8e45: 30 90       0.             ; ALWAYS branch

; &8e47 referenced 1 time by &9501
.c8e47
    lda l0056                                                         ; 8e47: a5 56       .V
    beq c8e4f                                                         ; 8e49: f0 04       ..
    sta l0027                                                         ; 8e4b: 85 27       .'
    sta l0028                                                         ; 8e4d: 85 28       .(
; &8e4f referenced 3 times by &8ae1, &8e49, &8ead
.c8e4f
    jsr sub_c8ebe                                                     ; 8e4f: 20 be 8e     ..
    bcs c8eaf                                                         ; 8e52: b0 5b       .[
    lda l0025                                                         ; 8e54: a5 25       .%
    pha                                                               ; 8e56: 48          H
    lda l0026                                                         ; 8e57: a5 26       .&
    pha                                                               ; 8e59: 48          H
    jsr osnewl                                                        ; 8e5a: 20 e7 ff     ..            ; Write newline (characters 10 and 13)
    jsr sub_c8a41                                                     ; 8e5d: 20 41 8a     A.
    lda #8                                                            ; 8e60: a9 08       ..
    jsr c8d47                                                         ; 8e62: 20 47 8d     G.
    lda #&87                                                          ; 8e65: a9 87       ..
    jsr sub_c8a50                                                     ; 8e67: 20 50 8a     P.
    ldx #0                                                            ; 8e6a: a2 00       ..
; &8e6c referenced 1 time by &8e84
.loop_c8e6c
    jsr sub_c8ebe                                                     ; 8e6c: 20 be 8e     ..
    bcs c8e86                                                         ; 8e6f: b0 15       ..
    lda l0000,x                                                       ; 8e71: b5 00       ..
    jsr hex_to_digit                                                  ; 8e73: 20 c8 88     ..
    lda #&20 ; ' '                                                    ; 8e76: a9 20       .
    jsr oswrch                                                        ; 8e78: 20 ee ff     ..            ; Write character 32
    inc l0025                                                         ; 8e7b: e6 25       .%
    bne c8e81                                                         ; 8e7d: d0 02       ..
    inc l0026                                                         ; 8e7f: e6 26       .&
; &8e81 referenced 1 time by &8e7d
.c8e81
    inx                                                               ; 8e81: e8          .
    cpx #8                                                            ; 8e82: e0 08       ..
    bne loop_c8e6c                                                    ; 8e84: d0 e6       ..
; &8e86 referenced 1 time by &8e6f
.c8e86
    lda #&1e                                                          ; 8e86: a9 1e       ..
    jsr blank_from_x_if_required                                      ; 8e88: 20 92 8c     ..
    lda #&83                                                          ; 8e8b: a9 83       ..
    jsr sub_c8a50                                                     ; 8e8d: 20 50 8a     P.
    pla                                                               ; 8e90: 68          h
    sta l0026                                                         ; 8e91: 85 26       .&
    pla                                                               ; 8e93: 68          h
    sta l0025                                                         ; 8e94: 85 25       .%
    ldx #0                                                            ; 8e96: a2 00       ..
; &8e98 referenced 1 time by &8eab
.loop_c8e98
    jsr sub_c8ebe                                                     ; 8e98: 20 be 8e     ..
    bcs c8eaf                                                         ; 8e9b: b0 12       ..
    lda l0000,x                                                       ; 8e9d: b5 00       ..
    jsr sub_c8a5d                                                     ; 8e9f: 20 5d 8a     ].
    inx                                                               ; 8ea2: e8          .
    inc l0025                                                         ; 8ea3: e6 25       .%
    bne c8ea9                                                         ; 8ea5: d0 02       ..
    inc l0026                                                         ; 8ea7: e6 26       .&
; &8ea9 referenced 1 time by &8ea5
.c8ea9
    cpx #8                                                            ; 8ea9: e0 08       ..
    bne loop_c8e98                                                    ; 8eab: d0 eb       ..
    beq c8e4f                                                         ; 8ead: f0 a0       ..             ; ALWAYS branch

; &8eaf referenced 2 times by &8e52, &8e9b
.c8eaf
    jsr osnewl                                                        ; 8eaf: 20 e7 ff     ..            ; Write newline (characters 10 and 13)
    jmp osnewl                                                        ; 8eb2: 4c e7 ff    L..            ; Write newline (characters 10 and 13)

; &8eb5 referenced 1 time by &8ee5
.sub_c8eb5
    sec                                                               ; 8eb5: 38          8
    bit l00ff                                                         ; 8eb6: 24 ff       $.
    bmi return_12                                                     ; 8eb8: 30 18       0.
    bit l0056                                                         ; 8eba: 24 56       $V
    bmi c8ed1                                                         ; 8ebc: 30 13       0.
; &8ebe referenced 4 times by &8e4f, &8e6c, &8e98, &9495
.sub_c8ebe
    sec                                                               ; 8ebe: 38          8
    bit l00ff                                                         ; 8ebf: 24 ff       $.
    bmi return_12                                                     ; 8ec1: 30 0f       0.
    lda l0026                                                         ; 8ec3: a5 26       .&
    cmp l0028                                                         ; 8ec5: c5 28       .(
    bcc return_12                                                     ; 8ec7: 90 09       ..
    bne return_12                                                     ; 8ec9: d0 07       ..
    lda l0025                                                         ; 8ecb: a5 25       .%
    cmp l0027                                                         ; 8ecd: c5 27       .'
    bne return_12                                                     ; 8ecf: d0 01       ..
; &8ed1 referenced 1 time by &8ebc
.c8ed1
    clc                                                               ; 8ed1: 18          .
; &8ed2 referenced 6 times by &8eb8, &8ec1, &8ec7, &8ec9, &8ecf, &8ee8
.return_12
    rts                                                               ; 8ed2: 60          `

; &8ed3 referenced 2 times by &8efa, &9507
.c8ed3
    lda #&20 ; ' '                                                    ; 8ed3: a9 20       .
    jsr c8d47                                                         ; 8ed5: 20 47 8d     G.
    jsr osnewl                                                        ; 8ed8: 20 e7 ff     ..            ; Write newline (characters 10 and 13)
    jsr sub_c8a41                                                     ; 8edb: 20 41 8a     A.
    lda #&87                                                          ; 8ede: a9 87       ..
    jsr sub_c8a50                                                     ; 8ee0: 20 50 8a     P.
    ldx #0                                                            ; 8ee3: a2 00       ..
; &8ee5 referenced 1 time by &8ef8
.loop_c8ee5
    jsr sub_c8eb5                                                     ; 8ee5: 20 b5 8e     ..
    bcs return_12                                                     ; 8ee8: b0 e8       ..
    lda l0000,x                                                       ; 8eea: b5 00       ..
    jsr sub_c8a5d                                                     ; 8eec: 20 5d 8a     ].
    inx                                                               ; 8eef: e8          .
    inc l0025                                                         ; 8ef0: e6 25       .%
    bne c8ef6                                                         ; 8ef2: d0 02       ..
    inc l0026                                                         ; 8ef4: e6 26       .&
; &8ef6 referenced 1 time by &8ef2
.c8ef6
    cpx #&20 ; ' '                                                    ; 8ef6: e0 20       .
    bne loop_c8ee5                                                    ; 8ef8: d0 eb       ..
    beq c8ed3                                                         ; 8efa: f0 d7       ..             ; ALWAYS branch

; overlapping: pha                                                    ; 8efc: 48          H
; &8efc referenced 1 time by &8f13
.string_hex
    equs "HEX"                                                        ; 8efc: 48 45 58    HEX
; &8eff referenced 1 time by &8f29
.string_printm
    equs "PRINTM"                                                     ; 8eff: 50 52 49... PRI

; &8f05 referenced 2 times by &8f68, &9542
.sub_c8f05
    ldy #1                                                            ; 8f05: a0 01       ..
    ldx #0                                                            ; 8f07: a2 00       ..
    lda l0603                                                         ; 8f09: ad 03 06    ...
    cmp #&21 ; '!'                                                    ; 8f0c: c9 21       .!
    bcs c8f1c                                                         ; 8f0e: b0 0c       ..
; &8f10 referenced 1 time by &8f19
.loop_c8f10
    jsr sub_c8f35                                                     ; 8f10: 20 35 8f     5.
    cmp string_hex,y                                                  ; 8f13: d9 fc 8e    ...
    bne c8f1c                                                         ; 8f16: d0 04       ..
    dey                                                               ; 8f18: 88          .
    bpl loop_c8f10                                                    ; 8f19: 10 f5       ..
    rts                                                               ; 8f1b: 60          `

; &8f1c referenced 2 times by &8f0e, &8f16
.c8f1c
    lda l0606                                                         ; 8f1c: ad 06 06    ...
    cmp #&21 ; '!'                                                    ; 8f1f: c9 21       .!
    bcs c8f32                                                         ; 8f21: b0 0f       ..
    ldy #5                                                            ; 8f23: a0 05       ..
    inx                                                               ; 8f25: e8          .
; &8f26 referenced 1 time by &8f2f
.loop_c8f26
    jsr sub_c8f35                                                     ; 8f26: 20 35 8f     5.
    cmp string_printm,y                                               ; 8f29: d9 ff 8e    ...
    bne c8f32                                                         ; 8f2c: d0 04       ..
    dey                                                               ; 8f2e: 88          .
    bpl loop_c8f26                                                    ; 8f2f: 10 f5       ..
    rts                                                               ; 8f31: 60          `

; &8f32 referenced 2 times by &8f21, &8f2c
.c8f32
    ldx #&ff                                                          ; 8f32: a2 ff       ..
    rts                                                               ; 8f34: 60          `

; &8f35 referenced 2 times by &8f10, &8f26
.sub_c8f35
    lda l0600,y                                                       ; 8f35: b9 00 06    ...
; ***************************************************************************************
; &8f38 referenced 2 times by &9225, &9d9e
.convert_to_uppercase_if_required
    cmp #&61 ; 'a'                                                    ; 8f38: c9 61       .a
    bcc return_13                                                     ; 8f3a: 90 06       ..
    cmp #&7b ; '{'                                                    ; 8f3c: c9 7b       .{
    bcs return_13                                                     ; 8f3e: b0 02       ..
    and #&df                                                          ; 8f40: 29 df       ).
; &8f42 referenced 2 times by &8f3a, &8f3e
.return_13
    rts                                                               ; 8f42: 60          `

; ***************************************************************************************
; &8f43 referenced 8 times by &970b, &9712, &9719, &9720, &9c35, &9c3c, &9c43, &9c4a
.set_y_zero_call_osbyte
    ldy #0                                                            ; 8f43: a0 00       ..
    beq call_jmp_osbyte                                               ; 8f45: f0 06       ..             ; ALWAYS branch

; ***************************************************************************************
; &8f47 referenced 3 times by &901f, &96fa, &9e74
.flush_all_buffers
    lda #&0f                                                          ; 8f47: a9 0f       ..
; &8f49 referenced 5 times by &95d6, &96d0, &9840, &9bf9, &9df7
.sub_c8f49
    ldx #0                                                            ; 8f49: a2 00       ..
    ldy #&ff                                                          ; 8f4b: a0 ff       ..
; ***************************************************************************************
; &8f4d referenced 1 time by &8f45
.call_jmp_osbyte
    jmp osbyte                                                        ; 8f4d: 4c f4 ff    L..

; ***************************************************************************************
; &8f50 referenced 2 times by &8f79, &952d
.error_os_label
    brk                                                               ; 8f50: 00          .

    equb 0                                                            ; 8f51: 00          .
    equs "O.S. Label"                                                 ; 8f52: 4f 2e 53... O.S
    equb 0                                                            ; 8f5c: 00          .

; &8f5d referenced 3 times by &928c, &9310, &93b3
.c8f5d
    jsr sub_c95ab                                                     ; 8f5d: 20 ab 95     ..
    lda l0025                                                         ; 8f60: a5 25       .%
    sta l003a                                                         ; 8f62: 85 3a       .:
    lda l0026                                                         ; 8f64: a5 26       .&
    sta l003b                                                         ; 8f66: 85 3b       .;
    jsr sub_c8f05                                                     ; 8f68: 20 05 8f     ..
    cpx #1                                                            ; 8f6b: e0 01       ..
    bne c8f72                                                         ; 8f6d: d0 03       ..
    jmp error_bad_label                                               ; 8f6f: 4c 21 95    L!.

; &8f72 referenced 1 time by &8f6d
.c8f72
    jsr sub_m87bd                                                     ; 8f72: 20 bd 87     ..
    bcc c8fde                                                         ; 8f75: 90 67       .g
    lda l003d                                                         ; 8f77: a5 3d       .=
    bmi error_os_label                                                ; 8f79: 30 d5       0.
    jsr sub_c875f                                                     ; 8f7b: 20 5f 87     _.
    bcc print_label_exists                                            ; 8f7e: 90 30       .0
.print_label_and_address_exists
    jsr print_inline_string                                           ; 8f80: 20 6b 8a     k.
    equs "Label & address exist"                                      ; 8f83: 4c 61 62... Lab
    equb &ff                                                          ; 8f98: ff          .

    jsr ask_user_to_replace                                           ; 8f99: 20 09 90     ..
    jsr c904d                                                         ; 8f9c: 20 4d 90     M.
    jsr sub_m87bd                                                     ; 8f9f: 20 bd 87     ..
    bcs c8fc6                                                         ; 8fa2: b0 22       ."
; &8fa4 referenced 2 times by &8fe1, &8ff1
.c8fa4
    jsr get_variable                                                  ; 8fa4: 20 34 90     4.
    jsr c8fc6                                                         ; 8fa7: 20 c6 8f     ..
    lda #0                                                            ; 8faa: a9 00       ..
    tay                                                               ; 8fac: a8          .              ; Y=&00
    sta (l003c),y                                                     ; 8fad: 91 3c       .<
    rts                                                               ; 8faf: 60          `

; ***************************************************************************************
; &8fb0 referenced 1 time by &8f7e
.print_label_exists
    jsr sub_m87bd                                                     ; 8fb0: 20 bd 87     ..
    jsr print_inline_string                                           ; 8fb3: 20 6b 8a     k.
    equs "Label exists"                                               ; 8fb6: 4c 61 62... Lab
    equb &ff                                                          ; 8fc2: ff          .

; &8fc3 referenced 1 time by &9006
.c8fc3
    jsr ask_user_to_replace                                           ; 8fc3: 20 09 90     ..
; &8fc6 referenced 2 times by &8fa2, &8fa7
.c8fc6
    ldy #0                                                            ; 8fc6: a0 00       ..
; &8fc8 referenced 1 time by &8fd0
.loop_c8fc8
    lda l0600,y                                                       ; 8fc8: b9 00 06    ...
    sta (l003c),y                                                     ; 8fcb: 91 3c       .<
    iny                                                               ; 8fcd: c8          .
    cpy #7                                                            ; 8fce: c0 07       ..
    bne loop_c8fc8                                                    ; 8fd0: d0 f6       ..
    lda l0025                                                         ; 8fd2: a5 25       .%
    sta (l003c),y                                                     ; 8fd4: 91 3c       .<
    iny                                                               ; 8fd6: c8          .
    lda l0026                                                         ; 8fd7: a5 26       .&
    sta (l003c),y                                                     ; 8fd9: 91 3c       .<
    jmp c8753                                                         ; 8fdb: 4c 53 87    LS.

; &8fde referenced 1 time by &8f75
.c8fde
    jsr sub_c8767                                                     ; 8fde: 20 67 87     g.
    bcc c8fa4                                                         ; 8fe1: 90 c1       ..
    ldy #0                                                            ; 8fe3: a0 00       ..
    lda (l003c),y                                                     ; 8fe5: b1 3c       .<
    cmp #1                                                            ; 8fe7: c9 01       ..
    bne print_address_labelled                                        ; 8fe9: d0 08       ..
    jsr c8753                                                         ; 8feb: 20 53 87     S.
    jsr sub_c877c                                                     ; 8fee: 20 7c 87     |.
    bcc c8fa4                                                         ; 8ff1: 90 b1       ..
; ***************************************************************************************
; &8ff3 referenced 1 time by &8fe9
.print_address_labelled
    jsr print_inline_string                                           ; 8ff3: 20 6b 8a     k.
    equs "Address labeled"                                            ; 8ff6: 41 64 64... Add
    equb &ff                                                          ; 9005: ff          .

    jmp c8fc3                                                         ; 9006: 4c c3 8f    L..

; ***************************************************************************************
; &9009 referenced 3 times by &8f99, &8fc3, &9b9d
.ask_user_to_replace
    jsr print_inline_string                                           ; 9009: 20 6b 8a     k.
    equb &81                                                          ; 900c: 81          .
    equs "--"                                                         ; 900d: 2d 2d       --
    equb &87                                                          ; 900f: 87          .
    equs "Replace ?"                                                  ; 9010: 52 65 70... Rep
    equb &83                                                          ; 9019: 83          .
    equs "Y/N"                                                        ; 901a: 59 2f 4e    Y/N

    stx l00ff                                                         ; 901d: 86 ff       ..
    jsr flush_all_buffers                                             ; 901f: 20 47 8f     G.
    jsr osrdch                                                        ; 9022: 20 e0 ff     ..            ; Read a character from the current input stream
    bcs c902d                                                         ; 9025: b0 06       ..
    and #&df                                                          ; 9027: 29 df       ).
    cmp #&59 ; 'Y'                                                    ; 9029: c9 59       .Y
    beq c9031                                                         ; 902b: f0 04       ..
; &902d referenced 1 time by &9025
.c902d
    pla                                                               ; 902d: 68          h
    pla                                                               ; 902e: 68          h
    lda #&4e ; 'N'                                                    ; 902f: a9 4e       .N
; &9031 referenced 1 time by &902b
.c9031
    jmp oswrch                                                        ; 9031: 4c ee ff    L..            ; Write character 78

; ***************************************************************************************
; &9034 referenced 6 times by &8fa4, &95ad, &9697, &96d8, &9c64, &9c83
.get_variable
    tya                                                               ; 9034: 98          .
    pha                                                               ; 9035: 48          H
    lda himem                                                         ; 9036: a5 89       ..
    sta l003c                                                         ; 9038: 85 3c       .<
    lda himem+1                                                       ; 903a: a5 8a       ..
    sta l003d                                                         ; 903c: 85 3d       .=
    ldy #0                                                            ; 903e: a0 00       ..
; &9040 referenced 1 time by &9047
.loop_c9040
    lda (l003c),y                                                     ; 9040: b1 3c       .<
    beq c904a                                                         ; 9042: f0 06       ..
    jsr c8753                                                         ; 9044: 20 53 87     S.
    jmp loop_c9040                                                    ; 9047: 4c 40 90    L@.

; &904a referenced 1 time by &9042
.c904a
    pla                                                               ; 904a: 68          h
    tay                                                               ; 904b: a8          .
; &904c referenced 1 time by &9068
.return_14
    rts                                                               ; 904c: 60          `

; &904d referenced 3 times by &8f9c, &906d, &9558
.c904d
    ldx #9                                                            ; 904d: a2 09       ..
    stx l003e                                                         ; 904f: 86 3e       .>
    ldy #0                                                            ; 9051: a0 00       ..
    sty l0041                                                         ; 9053: 84 41       .A
; &9055 referenced 1 time by &9062
.loop_c9055
    ldy l003e                                                         ; 9055: a4 3e       .>
    lda (l003c),y                                                     ; 9057: b1 3c       .<
    ldy l0041                                                         ; 9059: a4 41       .A
    sta (l003c),y                                                     ; 905b: 91 3c       .<
    inc l003e                                                         ; 905d: e6 3e       .>
    inc l0041                                                         ; 905f: e6 41       .A
    dex                                                               ; 9061: ca          .
    bne loop_c9055                                                    ; 9062: d0 f1       ..
    ldy #0                                                            ; 9064: a0 00       ..
    lda (l003c),y                                                     ; 9066: b1 3c       .<
    beq return_14                                                     ; 9068: f0 e2       ..
    jsr c8753                                                         ; 906a: 20 53 87     S.
    jmp c904d                                                         ; 906d: 4c 4d 90    LM.

; &9070 referenced 10 times by &91eb, &91fb, &92c6, &9383, &97db, &9a07, &9a49, &9a59, &9ac2, &9add
.c9070
    ldx #0                                                            ; 9070: a2 00       ..
; &9072 referenced 1 time by &907e
.loop_c9072
    lda l0700,y                                                       ; 9072: b9 00 07    ...
    sta l0400,x                                                       ; 9075: 9d 00 04    ...
    cmp #&21 ; '!'                                                    ; 9078: c9 21       .!
    bcc c9080                                                         ; 907a: 90 04       ..
    iny                                                               ; 907c: c8          .
    inx                                                               ; 907d: e8          .
    bne loop_c9072                                                    ; 907e: d0 f2       ..
; &9080 referenced 1 time by &907a
.c9080
    lda #&0d                                                          ; 9080: a9 0d       ..
    sta l0400,x                                                       ; 9082: 9d 00 04    ...
    sty l0070                                                         ; 9085: 84 70       .p
    lda l0400                                                         ; 9087: ad 00 04    ...
    ldx #0                                                            ; 908a: a2 00       ..
    cmp #&2b ; '+'                                                    ; 908c: c9 2b       .+
    bne c909d                                                         ; 908e: d0 0d       ..
    lda l0025                                                         ; 9090: a5 25       .%
    sta l0073                                                         ; 9092: 85 73       .s
    lda l0026                                                         ; 9094: a5 26       .&
    sta l0074                                                         ; 9096: 85 74       .t
    inx                                                               ; 9098: e8          .              ; X=&01
    lda #&2b ; '+'                                                    ; 9099: a9 2b       .+
    bne c90ad                                                         ; 909b: d0 10       ..             ; ALWAYS branch

; &909d referenced 1 time by &908e
.c909d
    jsr sub_c90e3                                                     ; 909d: 20 e3 90     ..
    pha                                                               ; 90a0: 48          H
    jsr sub_c9104                                                     ; 90a1: 20 04 91     ..
    lda l0071                                                         ; 90a4: a5 71       .q
    sta l0073                                                         ; 90a6: 85 73       .s
    lda l0072                                                         ; 90a8: a5 72       .r
    sta l0074                                                         ; 90aa: 85 74       .t
    pla                                                               ; 90ac: 68          h
; &90ad referenced 2 times by &909b, &90cd
.c90ad
    cmp #&0d                                                          ; 90ad: c9 0d       ..
    beq c90e0                                                         ; 90af: f0 2f       ./
    pha                                                               ; 90b1: 48          H
    jsr sub_c90e3                                                     ; 90b2: 20 e3 90     ..
    jsr sub_c9104                                                     ; 90b5: 20 04 91     ..
    pla                                                               ; 90b8: 68          h
    cmp #&2b ; '+'                                                    ; 90b9: c9 2b       .+
    bne c90d0                                                         ; 90bb: d0 13       ..
    clc                                                               ; 90bd: 18          .
    lda l0073                                                         ; 90be: a5 73       .s
    adc l0071                                                         ; 90c0: 65 71       eq
    sta l0073                                                         ; 90c2: 85 73       .s
    lda l0074                                                         ; 90c4: a5 74       .t
    adc l0072                                                         ; 90c6: 65 72       er
    sta l0074                                                         ; 90c8: 85 74       .t
; &90ca referenced 1 time by &90dd
.loop_c90ca
    lda l03ff,x                                                       ; 90ca: bd ff 03    ...
    jmp c90ad                                                         ; 90cd: 4c ad 90    L..

; &90d0 referenced 1 time by &90bb
.c90d0
    lda l0073                                                         ; 90d0: a5 73       .s
    sec                                                               ; 90d2: 38          8
    sbc l0071                                                         ; 90d3: e5 71       .q
    sta l0073                                                         ; 90d5: 85 73       .s
    lda l0074                                                         ; 90d7: a5 74       .t
    sbc l0072                                                         ; 90d9: e5 72       .r
    sta l0074                                                         ; 90db: 85 74       .t
    jmp loop_c90ca                                                    ; 90dd: 4c ca 90    L..

; &90e0 referenced 1 time by &90af
.c90e0
    ldy l0070                                                         ; 90e0: a4 70       .p
    rts                                                               ; 90e2: 60          `

; &90e3 referenced 2 times by &909d, &90b2
.sub_c90e3
    ldy #0                                                            ; 90e3: a0 00       ..
; &90e5 referenced 1 time by &90f9
.loop_c90e5
    lda l0400,x                                                       ; 90e5: bd 00 04    ...
    cmp #&0d                                                          ; 90e8: c9 0d       ..
    beq c90fb                                                         ; 90ea: f0 0f       ..
    cmp #&2b ; '+'                                                    ; 90ec: c9 2b       .+
    beq c90fb                                                         ; 90ee: f0 0b       ..
    cmp #&2d ; '-'                                                    ; 90f0: c9 2d       .-
    beq c90fb                                                         ; 90f2: f0 07       ..
    sta l0600,y                                                       ; 90f4: 99 00 06    ...
    iny                                                               ; 90f7: c8          .
    inx                                                               ; 90f8: e8          .
    bne loop_c90e5                                                    ; 90f9: d0 ea       ..
; &90fb referenced 3 times by &90ea, &90ee, &90f2
.c90fb
    pha                                                               ; 90fb: 48          H
    lda #&0d                                                          ; 90fc: a9 0d       ..
    sta l0600,y                                                       ; 90fe: 99 00 06    ...
    inx                                                               ; 9101: e8          .
    pla                                                               ; 9102: 68          h
    rts                                                               ; 9103: 60          `

; &9104 referenced 2 times by &90a1, &90b5
.sub_c9104
    ldy #0                                                            ; 9104: a0 00       ..
    lda l0600,y                                                       ; 9106: b9 00 06    ...
    sty l0071                                                         ; 9109: 84 71       .q
    sty l0072                                                         ; 910b: 84 72       .r
    cmp #&0d                                                          ; 910d: c9 0d       ..
    beq return_15                                                     ; 910f: f0 2e       ..
    cmp #&23 ; '#'                                                    ; 9111: c9 23       .#
    beq c9178                                                         ; 9113: f0 63       .c
    cmp #&26 ; '&'                                                    ; 9115: c9 26       .&
    beq c9142                                                         ; 9117: f0 29       .)
    jsr sub_c9225                                                     ; 9119: 20 25 92     %.
    bcs c912f                                                         ; 911c: b0 11       ..
; &911e referenced 1 time by &912d
.loop_c911e
    iny                                                               ; 911e: c8          .
    cpy #5                                                            ; 911f: c0 05       ..
    bcs c912f                                                         ; 9121: b0 0c       ..
    lda l0600,y                                                       ; 9123: b9 00 06    ...
    cmp #&0d                                                          ; 9126: c9 0d       ..
    beq c9140                                                         ; 9128: f0 16       ..
    jsr sub_c9225                                                     ; 912a: 20 25 92     %.
    bcc loop_c911e                                                    ; 912d: 90 ef       ..
; &912f referenced 2 times by &911c, &9121
.c912f
    jsr sub_m87bd                                                     ; 912f: 20 bd 87     ..
    bcs c9137                                                         ; 9132: b0 03       ..
    jmp error_no_such_label                                           ; 9134: 4c b4 91    L..

; &9137 referenced 1 time by &9132
.c9137
    lda l003a                                                         ; 9137: a5 3a       .:
    sta l0071                                                         ; 9139: 85 71       .q
    lda l003b                                                         ; 913b: a5 3b       .;
    sta l0072                                                         ; 913d: 85 72       .r
; &913f referenced 3 times by &910f, &914e, &917e
.return_15
    rts                                                               ; 913f: 60          `

; &9140 referenced 1 time by &9128
.c9140
    ldy #&ff                                                          ; 9140: a0 ff       ..
; &9142 referenced 1 time by &9117
.c9142
    iny                                                               ; 9142: c8          .
    tya                                                               ; 9143: 98          .
    clc                                                               ; 9144: 18          .
    adc #5                                                            ; 9145: 69 05       i.
    sta l003e                                                         ; 9147: 85 3e       .>
; &9149 referenced 1 time by &916c
.c9149
    lda l0600,y                                                       ; 9149: b9 00 06    ...
    cmp #&0d                                                          ; 914c: c9 0d       ..
    beq return_15                                                     ; 914e: f0 ef       ..
    jsr sub_c9225                                                     ; 9150: 20 25 92     %.
    bcs c916e                                                         ; 9153: b0 19       ..
    asl l0071                                                         ; 9155: 06 71       .q
    rol l0072                                                         ; 9157: 26 72       &r
    asl l0071                                                         ; 9159: 06 71       .q
    rol l0072                                                         ; 915b: 26 72       &r
    asl l0071                                                         ; 915d: 06 71       .q
    rol l0072                                                         ; 915f: 26 72       &r
    asl l0071                                                         ; 9161: 06 71       .q
    rol l0072                                                         ; 9163: 26 72       &r
    ora l0071                                                         ; 9165: 05 71       .q
    sta l0071                                                         ; 9167: 85 71       .q
    iny                                                               ; 9169: c8          .
    cpy l003e                                                         ; 916a: c4 3e       .>
    bne c9149                                                         ; 916c: d0 db       ..
; &916e referenced 1 time by &9153
.c916e
    brk                                                               ; 916e: 00          .

    equb 0                                                            ; 916f: 00          .
    equs "Bad Hex"                                                    ; 9170: 42 61 64... Bad
    equb 0                                                            ; 9177: 00          .

; &9178 referenced 3 times by &9113, &91ad, &91b1
.c9178
    iny                                                               ; 9178: c8          .
    lda l0600,y                                                       ; 9179: b9 00 06    ...
    cmp #&0d                                                          ; 917c: c9 0d       ..
    beq return_15                                                     ; 917e: f0 bf       ..
    sec                                                               ; 9180: 38          8
    sbc #&30 ; '0'                                                    ; 9181: e9 30       .0
    cmp #&0a                                                          ; 9183: c9 0a       ..
    bcs error_bad_decimal                                             ; 9185: b0 3d       .=
    pha                                                               ; 9187: 48          H
    asl l0071                                                         ; 9188: 06 71       .q
    rol l0072                                                         ; 918a: 26 72       &r
    lda l0072                                                         ; 918c: a5 72       .r
    pha                                                               ; 918e: 48          H
    lda l0071                                                         ; 918f: a5 71       .q
    pha                                                               ; 9191: 48          H
    asl l0071                                                         ; 9192: 06 71       .q
    rol l0072                                                         ; 9194: 26 72       &r
    asl l0071                                                         ; 9196: 06 71       .q
    rol l0072                                                         ; 9198: 26 72       &r
    pla                                                               ; 919a: 68          h
    clc                                                               ; 919b: 18          .
    adc l0071                                                         ; 919c: 65 71       eq
    sta l0071                                                         ; 919e: 85 71       .q
    pla                                                               ; 91a0: 68          h
    adc l0072                                                         ; 91a1: 65 72       er
    sta l0072                                                         ; 91a3: 85 72       .r
    bcs error_bad_decimal                                             ; 91a5: b0 1d       ..
    pla                                                               ; 91a7: 68          h
    clc                                                               ; 91a8: 18          .
    adc l0071                                                         ; 91a9: 65 71       eq
    sta l0071                                                         ; 91ab: 85 71       .q
    bcc c9178                                                         ; 91ad: 90 c9       ..
    inc l0072                                                         ; 91af: e6 72       .r
    jmp c9178                                                         ; 91b1: 4c 78 91    Lx.

; ***************************************************************************************
; &91b4 referenced 2 times by &9134, &9530
.error_no_such_label
    brk                                                               ; 91b4: 00          .

    equb 0                                                            ; 91b5: 00          .
    equs "No such label"                                              ; 91b6: 4e 6f 20... No
    equb 0                                                            ; 91c3: 00          .

; ***************************************************************************************
; &91c4 referenced 2 times by &9185, &91a5
.error_bad_decimal
    brk                                                               ; 91c4: 00          .

    equb 0                                                            ; 91c5: 00          .
    equs "Bad decimal"                                                ; 91c6: 42 61 64... Bad
    equb 0                                                            ; 91d1: 00          .

; ***************************************************************************************
; &91d2 referenced 3 times by &9214, &94fe, &9504
.enable_auto_paging_mode
    bit l003f                                                         ; 91d2: 24 3f       $?
    bmi c91db                                                         ; 91d4: 30 05       0.
    lda #&0e                                                          ; 91d6: a9 0e       ..
    jsr oswrch                                                        ; 91d8: 20 ee ff     ..            ; Write character 14
; &91db referenced 1 time by &91d4
.c91db
    jsr skip_spaces_find_CR                                           ; 91db: 20 08 92     ..
    bne c91eb                                                         ; 91de: d0 0b       ..
    lda l0057                                                         ; 91e0: a5 57       .W
    sta l0025                                                         ; 91e2: 85 25       .%
    lda l0058                                                         ; 91e4: a5 58       .X
    sta l0026                                                         ; 91e6: 85 26       .&
; &91e8 referenced 1 time by &91f9
.loop_c91e8
    dec l0056                                                         ; 91e8: c6 56       .V
    rts                                                               ; 91ea: 60          `

; &91eb referenced 2 times by &91de, &9432
.c91eb
    jsr c9070                                                         ; 91eb: 20 70 90     p.
    lda l0073                                                         ; 91ee: a5 73       .s
    sta l0025                                                         ; 91f0: 85 25       .%
    lda l0074                                                         ; 91f2: a5 74       .t
    sta l0026                                                         ; 91f4: 85 26       .&
    jsr skip_spaces_find_CR                                           ; 91f6: 20 08 92     ..
    beq loop_c91e8                                                    ; 91f9: f0 ed       ..
    jsr c9070                                                         ; 91fb: 20 70 90     p.
    lda l0073                                                         ; 91fe: a5 73       .s
    sta l0027                                                         ; 9200: 85 27       .'
    lda l0074                                                         ; 9202: a5 74       .t
    sta l0028                                                         ; 9204: 85 28       .(
    rts                                                               ; 9206: 60          `

; &9207 referenced 1 time by &920d
.loop_c9207
    iny                                                               ; 9207: c8          .
; ***************************************************************************************
; &9208 referenced 24 times by &91db, &91f6, &923d, &9257, &92c1, &9316, &9325, &9359, &9378, &93b9, &93c7, &942d, &950a, &9636, &97cb, &99ea, &9a19, &9a3d, &9a44, &9a54, &9aba, &9ad8, &9d75, &9f2a
.skip_spaces_find_CR
    lda l0700,y                                                       ; 9208: b9 00 07    ...
    cmp #&20 ; ' '                                                    ; 920b: c9 20       .
    beq loop_c9207                                                    ; 920d: f0 f8       ..
    cmp #&0d                                                          ; 920f: c9 0d       ..
    rts                                                               ; 9211: 60          `

; ***************************************************************************************
.cdis_command
    dec l0075                                                         ; 9212: c6 75       .u
; ***************************************************************************************
.dis_command
    jsr enable_auto_paging_mode                                       ; 9214: 20 d2 91     ..
    bit l0075                                                         ; 9217: 24 75       $u
    bmi c9222                                                         ; 9219: 30 07       0.
    bit tube_flag                                                     ; 921b: 24 6b       $k
    bmi c9222                                                         ; 921d: 30 03       0.
    jmp c8a98                                                         ; 921f: 4c 98 8a    L..

; &9222 referenced 2 times by &9219, &921d
.c9222
    jmp c8a8c                                                         ; 9222: 4c 8c 8a    L..

; &9225 referenced 5 times by &9119, &912a, &9150, &93c0, &98fa
.sub_c9225
    jsr convert_to_uppercase_if_required                              ; 9225: 20 38 8f     8.
    sec                                                               ; 9228: 38          8
    sbc #&30 ; '0'                                                    ; 9229: e9 30       .0
    cmp #&0a                                                          ; 922b: c9 0a       ..
    bcc return_16                                                     ; 922d: 90 0b       ..
    sbc #7                                                            ; 922f: e9 07       ..
    cmp #&10                                                          ; 9231: c9 10       ..
    bcs return_16                                                     ; 9233: b0 05       ..
    cmp #&0a                                                          ; 9235: c9 0a       ..
    bcc c923b                                                         ; 9237: 90 02       ..
    clc                                                               ; 9239: 18          .
; &923a referenced 2 times by &922d, &9233
.return_16
    rts                                                               ; 923a: 60          `

; &923b referenced 1 time by &9237
.c923b
    sec                                                               ; 923b: 38          8
    rts                                                               ; 923c: 60          `

; ***************************************************************************************
.let_command
    jsr skip_spaces_find_CR                                           ; 923d: 20 08 92     ..
; &9240 referenced 1 time by &9e23
.sub_c9240
    tya                                                               ; 9240: 98          .
    pha                                                               ; 9241: 48          H
    dey                                                               ; 9242: 88          .
; &9243 referenced 1 time by &9251
.loop_c9243
    iny                                                               ; 9243: c8          .
    lda l0700,y                                                       ; 9244: b9 00 07    ...
    cmp #&0d                                                          ; 9247: c9 0d       ..
    beq error_missing_expression                                      ; 9249: f0 50       .P
    cmp #&20 ; ' '                                                    ; 924b: c9 20       .
    beq ignore_space_find_equals_sign                                 ; 924d: f0 40       .@
    cmp #&3d ; '='                                                    ; 924f: c9 3d       .=
    bne loop_c9243                                                    ; 9251: d0 f0       ..
; &9253 referenced 1 time by &9299
.c9253
    iny                                                               ; 9253: c8          .
    jsr sub_c92c1                                                     ; 9254: 20 c1 92     ..
    jsr skip_spaces_find_CR                                           ; 9257: 20 08 92     ..
    bne error_bad_expression                                          ; 925a: d0 54       .T
    lda l0073                                                         ; 925c: a5 73       .s
    sta l0025                                                         ; 925e: 85 25       .%
    lda l0074                                                         ; 9260: a5 74       .t
    sta l0026                                                         ; 9262: 85 26       .&
    pla                                                               ; 9264: 68          h
    tay                                                               ; 9265: a8          .
    ldx #0                                                            ; 9266: a2 00       ..
; &9268 referenced 1 time by &927a
.loop_c9268
    lda l0700,y                                                       ; 9268: b9 00 07    ...
    cmp #&3d ; '='                                                    ; 926b: c9 3d       .=
    beq c927f                                                         ; 926d: f0 10       ..
    cmp #&20 ; ' '                                                    ; 926f: c9 20       .
    beq c927f                                                         ; 9271: f0 0c       ..
    sta l0600,x                                                       ; 9273: 9d 00 06    ...
    iny                                                               ; 9276: c8          .
    inx                                                               ; 9277: e8          .
    cpx #8                                                            ; 9278: e0 08       ..
    bne loop_c9268                                                    ; 927a: d0 ec       ..
; &927c referenced 1 time by &9280
.loop_c927c
    jmp error_bad_label                                               ; 927c: 4c 21 95    L!.

; &927f referenced 2 times by &926d, &9271
.c927f
    txa                                                               ; 927f: 8a          .
    beq loop_c927c                                                    ; 9280: f0 fa       ..
    lda #0                                                            ; 9282: a9 00       ..
; &9284 referenced 1 time by &928a
.loop_c9284
    sta l0600,x                                                       ; 9284: 9d 00 06    ...
    inx                                                               ; 9287: e8          .
    cpx #8                                                            ; 9288: e0 08       ..
    bcc loop_c9284                                                    ; 928a: 90 f8       ..
    jmp c8f5d                                                         ; 928c: 4c 5d 8f    L].

; ***************************************************************************************
; &928f referenced 2 times by &924d, &9295
.ignore_space_find_equals_sign
    iny                                                               ; 928f: c8          .
    lda l0700,y                                                       ; 9290: b9 00 07    ...
    cmp #&20 ; ' '                                                    ; 9293: c9 20       .
    beq ignore_space_find_equals_sign                                 ; 9295: f0 f8       ..
    cmp #&3d ; '='                                                    ; 9297: c9 3d       .=
    beq c9253                                                         ; 9299: f0 b8       ..
; ***************************************************************************************
; &929b referenced 8 times by &9249, &92c4, &9313, &93b6, &9533, &9633, &99ef, &9abf
.error_missing_expression
    brk                                                               ; 929b: 00          .

    equb 0                                                            ; 929c: 00          .
    equs "Missing expression"                                         ; 929d: 4d 69 73... Mis
    equb 0                                                            ; 92af: 00          .

; ***************************************************************************************
; &92b0 referenced 3 times by &925a, &92e3, &9a71
.error_bad_expression
    brk                                                               ; 92b0: 00          .

    equb 0                                                            ; 92b1: 00          .
    equs "Bad expression"                                             ; 92b2: 42 61 64... Bad
    equb 0                                                            ; 92c0: 00          .

; &92c1 referenced 7 times by &9254, &92c9, &92d4, &932f, &934e, &9570, &959f
.sub_c92c1
    jsr skip_spaces_find_CR                                           ; 92c1: 20 08 92     ..
    beq error_missing_expression                                      ; 92c4: f0 d5       ..
    jmp c9070                                                         ; 92c6: 4c 70 90    Lp.

; ***************************************************************************************
.hex_command
    jsr sub_c92c1                                                     ; 92c9: 20 c1 92     ..
    lda l0073                                                         ; 92cc: a5 73       .s
    sta l0025                                                         ; 92ce: 85 25       .%
    lda l0074                                                         ; 92d0: a5 74       .t
    sta l0026                                                         ; 92d2: 85 26       .&
    jsr sub_c92c1                                                     ; 92d4: 20 c1 92     ..
    lda l0074                                                         ; 92d7: a5 74       .t
    cmp l0026                                                         ; 92d9: c5 26       .&
    bcc c92e7                                                         ; 92db: 90 0a       ..
    bne c92f7                                                         ; 92dd: d0 18       ..
    lda l0073                                                         ; 92df: a5 73       .s
    cmp l0025                                                         ; 92e1: c5 25       .%
    beq error_bad_expression                                          ; 92e3: f0 cb       ..
    bcs c92f7                                                         ; 92e5: b0 10       ..
; &92e7 referenced 1 time by &92db
.c92e7
    ldx l0073                                                         ; 92e7: a6 73       .s
    lda l0025                                                         ; 92e9: a5 25       .%
    sta l0073                                                         ; 92eb: 85 73       .s
    stx l0025                                                         ; 92ed: 86 25       .%
    ldx l0074                                                         ; 92ef: a6 74       .t
    lda l0026                                                         ; 92f1: a5 26       .&
    sta l0074                                                         ; 92f3: 85 74       .t
    stx l0026                                                         ; 92f5: 86 26       .&
; &92f7 referenced 2 times by &92dd, &92e5
.c92f7
    ldy #7                                                            ; 92f7: a0 07       ..
    lda #0                                                            ; 92f9: a9 00       ..
; &92fb referenced 1 time by &92ff
.loop_c92fb
    sta l0600,y                                                       ; 92fb: 99 00 06    ...
    dey                                                               ; 92fe: 88          .
    bpl loop_c92fb                                                    ; 92ff: 10 fa       ..
    lda #1                                                            ; 9301: a9 01       ..
    sta l0600                                                         ; 9303: 8d 00 06    ...
    lda l0073                                                         ; 9306: a5 73       .s
    sta l0605                                                         ; 9308: 8d 05 06    ...
    lda l0074                                                         ; 930b: a5 74       .t
    sta l0606                                                         ; 930d: 8d 06 06    ...
    jmp c8f5d                                                         ; 9310: 4c 5d 8f    L].

; ***************************************************************************************
; &9313 referenced 3 times by &9319, &9328, &935c
.sub_m9313
    jmp error_missing_expression                                      ; 9313: 4c 9b 92    L..

; ***************************************************************************************
.mem_command
    jsr skip_spaces_find_CR                                           ; 9316: 20 08 92     ..
    beq sub_m9313                                                     ; 9319: f0 f8       ..
    sec                                                               ; 931b: 38          8
    sbc #&30 ; '0'                                                    ; 931c: e9 30       .0
    sta l0000                                                         ; 931e: 85 00       ..
    cmp #&0a                                                          ; 9320: c9 0a       ..
    bcs error_bad_memory                                              ; 9322: b0 1d       ..
    iny                                                               ; 9324: c8          .
    jsr skip_spaces_find_CR                                           ; 9325: 20 08 92     ..
    beq sub_m9313                                                     ; 9328: f0 e9       ..
    cmp #&3d ; '='                                                    ; 932a: c9 3d       .=
    bne error_bad_memory                                              ; 932c: d0 13       ..
    iny                                                               ; 932e: c8          .
    jsr sub_c92c1                                                     ; 932f: 20 c1 92     ..
    lda l0000                                                         ; 9332: a5 00       ..
    asl a                                                             ; 9334: 0a          .
    tay                                                               ; 9335: a8          .
    lda l0073                                                         ; 9336: a5 73       .s
    sta l0057,y                                                       ; 9338: 99 57 00    .W.
    lda l0074                                                         ; 933b: a5 74       .t
    sta l0058,y                                                       ; 933d: 99 58 00    .X.
    rts                                                               ; 9340: 60          `

; ***************************************************************************************
; &9341 referenced 2 times by &9322, &932c
.error_bad_memory
    brk                                                               ; 9341: 00          .

    equb 0                                                            ; 9342: 00          .
    equs "Bad memory"                                                 ; 9343: 42 61 64... Bad
    equb 0                                                            ; 934d: 00          .

; ***************************************************************************************
.printm_command
.sub_m934e
    jsr sub_c92c1                                                     ; 934e: 20 c1 92     ..
    lda l0073                                                         ; 9351: a5 73       .s
    sta l0025                                                         ; 9353: 85 25       .%
    lda l0074                                                         ; 9355: a5 74       .t
    sta l0026                                                         ; 9357: 85 26       .&
    jsr skip_spaces_find_CR                                           ; 9359: 20 08 92     ..
    beq sub_m9313                                                     ; 935c: f0 b5       ..
    sty l0070                                                         ; 935e: 84 70       .p
    lda l0700,y                                                       ; 9360: b9 00 07    ...
    cmp #&4e ; 'N'                                                    ; 9363: c9 4e       .N
    bne c9381                                                         ; 9365: d0 1a       ..
    iny                                                               ; 9367: c8          .
    lda l0700,y                                                       ; 9368: b9 00 07    ...
    cmp #&45 ; 'E'                                                    ; 936b: c9 45       .E
    bne c9381                                                         ; 936d: d0 12       ..
    iny                                                               ; 936f: c8          .
    lda l0700,y                                                       ; 9370: b9 00 07    ...
    cmp #&47 ; 'G'                                                    ; 9373: c9 47       .G
    bne c9381                                                         ; 9375: d0 0a       ..
    iny                                                               ; 9377: c8          .
    jsr skip_spaces_find_CR                                           ; 9378: 20 08 92     ..
    bne c9381                                                         ; 937b: d0 04       ..
    ldy #&ff                                                          ; 937d: a0 ff       ..
    bne c939c                                                         ; 937f: d0 1b       ..             ; ALWAYS branch

; &9381 referenced 4 times by &9365, &936d, &9375, &937b
.c9381
    ldy l0070                                                         ; 9381: a4 70       .p
    jsr c9070                                                         ; 9383: 20 70 90     p.
    lda l0074                                                         ; 9386: a5 74       .t
    beq c939a                                                         ; 9388: f0 10       ..
.error_bad_character
    brk                                                               ; 938a: 00          .

    equb 0                                                            ; 938b: 00          .
    equs "Bad character"                                              ; 938c: 42 61 64... Bad
    equb 0                                                            ; 9399: 00          .

; &939a referenced 1 time by &9388
.c939a
    ldy #0                                                            ; 939a: a0 00       ..
; &939c referenced 1 time by &937f
.c939c
    ldx #7                                                            ; 939c: a2 07       ..
    lda #0                                                            ; 939e: a9 00       ..
; &93a0 referenced 1 time by &93a4
.loop_c93a0
    sta l0600,x                                                       ; 93a0: 9d 00 06    ...
    dex                                                               ; 93a3: ca          .
    bpl loop_c93a0                                                    ; 93a4: 10 fa       ..
    lda #2                                                            ; 93a6: a9 02       ..
    sta l0600                                                         ; 93a8: 8d 00 06    ...
    sty l0601                                                         ; 93ab: 8c 01 06    ...
    lda l0073                                                         ; 93ae: a5 73       .s
    sta l0602                                                         ; 93b0: 8d 02 06    ...
    jmp c8f5d                                                         ; 93b3: 4c 5d 8f    L].

; ***************************************************************************************
; &93b6 referenced 1 time by &93bc
.sub_m93b6
    jmp error_missing_expression                                      ; 93b6: 4c 9b 92    L..

; ***************************************************************************************
; &93b9 referenced 1 time by &974d
.rom_command
    jsr skip_spaces_find_CR                                           ; 93b9: 20 08 92     ..
    beq sub_m93b6                                                     ; 93bc: f0 f8       ..
    sty l0070                                                         ; 93be: 84 70       .p
    jsr sub_c9225                                                     ; 93c0: 20 25 92     %.
    bcs c93cf                                                         ; 93c3: b0 0a       ..
    tax                                                               ; 93c5: aa          .
    iny                                                               ; 93c6: c8          .
    jsr skip_spaces_find_CR                                           ; 93c7: 20 08 92     ..
    bne c93cf                                                         ; 93ca: d0 03       ..
    stx l0055                                                         ; 93cc: 86 55       .U
    rts                                                               ; 93ce: 60          `

; &93cf referenced 2 times by &93c3, &93ca
.c93cf
    lda #&0f                                                          ; 93cf: a9 0f       ..
    sta l003e                                                         ; 93d1: 85 3e       .>
    lda l0055                                                         ; 93d3: a5 55       .U
    pha                                                               ; 93d5: 48          H
; &93d6 referenced 1 time by &940e
.c93d6
    lda #&80                                                          ; 93d6: a9 80       ..
    sta l0026                                                         ; 93d8: 85 26       .&
    lda #9                                                            ; 93da: a9 09       ..
    sta l0025                                                         ; 93dc: 85 25       .%
    lda l003e                                                         ; 93de: a5 3e       .>
    sta l0055                                                         ; 93e0: 85 55       .U
    lda #&1e                                                          ; 93e2: a9 1e       ..
    jsr sub_c8d42                                                     ; 93e4: 20 42 8d     B.
    ldx #0                                                            ; 93e7: a2 00       ..
    ldy l0070                                                         ; 93e9: a4 70       .p
; &93eb referenced 1 time by &93f8
.loop_c93eb
    lda l0000,x                                                       ; 93eb: b5 00       ..
    beq c93fc                                                         ; 93ed: f0 0d       ..
    cmp l0700,y                                                       ; 93ef: d9 00 07    ...
    bne c9405                                                         ; 93f2: d0 11       ..
    iny                                                               ; 93f4: c8          .
    inx                                                               ; 93f5: e8          .
    cpx #&1e                                                          ; 93f6: e0 1e       ..
    bne loop_c93eb                                                    ; 93f8: d0 f1       ..
; &93fa referenced 1 time by &9401
.loop_c93fa
    pla                                                               ; 93fa: 68          h
    rts                                                               ; 93fb: 60          `

; &93fc referenced 2 times by &93ed, &940a
.c93fc
    lda l0700,y                                                       ; 93fc: b9 00 07    ...
    cmp #&21 ; '!'                                                    ; 93ff: c9 21       .!
    bcc loop_c93fa                                                    ; 9401: 90 f7       ..
    bcs c940c                                                         ; 9403: b0 07       ..             ; ALWAYS branch

; &9405 referenced 1 time by &93f2
.c9405
    lda l0700,y                                                       ; 9405: b9 00 07    ...
    cmp #&0d                                                          ; 9408: c9 0d       ..
    beq c93fc                                                         ; 940a: f0 f0       ..
; &940c referenced 1 time by &9403
.c940c
    dec l003e                                                         ; 940c: c6 3e       .>
    bpl c93d6                                                         ; 940e: 10 c6       ..
    pla                                                               ; 9410: 68          h
    sta l0055                                                         ; 9411: 85 55       .U
.error_bad_rom
    brk                                                               ; 9413: 00          .

    equb 0                                                            ; 9414: 00          .
    equs "Bad rom"                                                    ; 9415: 42 61 64... Bad
    equb 0                                                            ; 941c: 00          .

; ***************************************************************************************
.lvar_command
    ldx #&ff                                                          ; 941d: a2 ff       ..
    stx l0027                                                         ; 941f: 86 27       .'
    stx l0028                                                         ; 9421: 86 28       .(
    inx                                                               ; 9423: e8          .              ; X=&00
    stx l0025                                                         ; 9424: 86 25       .%
    stx l0026                                                         ; 9426: 86 26       .&
    lda #&0e                                                          ; 9428: a9 0e       ..
    jsr oswrch                                                        ; 942a: 20 ee ff     ..            ; Write character 14
    jsr skip_spaces_find_CR                                           ; 942d: 20 08 92     ..
    beq c9435                                                         ; 9430: f0 03       ..
    jsr c91eb                                                         ; 9432: 20 eb 91     ..
; &9435 referenced 1 time by &9430
.c9435
    ldy #0                                                            ; 9435: a0 00       ..
    lda (himem),y                                                     ; 9437: b1 89       ..
    beq return_17                                                     ; 9439: f0 51       .Q
; &943b referenced 1 time by &94d5
.c943b
    ldy #0                                                            ; 943b: a0 00       ..
    sty l0079                                                         ; 943d: 84 79       .y
    dey                                                               ; 943f: 88          .              ; Y=&ff
    sty l003a                                                         ; 9440: 84 3a       .:
    sty l003b                                                         ; 9442: 84 3b       .;
    lda himem                                                         ; 9444: a5 89       ..
    sta l003c                                                         ; 9446: 85 3c       .<
    lda himem+1                                                       ; 9448: a5 8a       ..
    sta l003d                                                         ; 944a: 85 3d       .=
; &944c referenced 1 time by &9486
.c944c
    ldy #8                                                            ; 944c: a0 08       ..
    lda (l003c),y                                                     ; 944e: b1 3c       .<
    cmp l0026                                                         ; 9450: c5 26       .&
    bcc c947f                                                         ; 9452: 90 2b       .+
    bne c945f                                                         ; 9454: d0 09       ..
    dey                                                               ; 9456: 88          .              ; Y=&07
    lda (l003c),y                                                     ; 9457: b1 3c       .<
    cmp l0025                                                         ; 9459: c5 25       .%
    bcc c947f                                                         ; 945b: 90 22       ."
    beq c9495                                                         ; 945d: f0 36       .6
; &945f referenced 1 time by &9454
.c945f
    ldy #8                                                            ; 945f: a0 08       ..
    lda (l003c),y                                                     ; 9461: b1 3c       .<
    cmp l003b                                                         ; 9463: c5 3b       .;
    bcc c9470                                                         ; 9465: 90 09       ..
    bne c947f                                                         ; 9467: d0 16       ..
    dey                                                               ; 9469: 88          .              ; Y=&07
    lda (l003c),y                                                     ; 946a: b1 3c       .<
    cmp l003a                                                         ; 946c: c5 3a       .:
    bcs c947f                                                         ; 946e: b0 0f       ..
; &9470 referenced 1 time by &9465
.c9470
    lda #&ff                                                          ; 9470: a9 ff       ..
    sta l0079                                                         ; 9472: 85 79       .y
    ldy #8                                                            ; 9474: a0 08       ..
    lda (l003c),y                                                     ; 9476: b1 3c       .<
    sta l003b                                                         ; 9478: 85 3b       .;
    dey                                                               ; 947a: 88          .              ; Y=&07
    lda (l003c),y                                                     ; 947b: b1 3c       .<
    sta l003a                                                         ; 947d: 85 3a       .:
; &947f referenced 4 times by &9452, &945b, &9467, &946e
.c947f
    jsr c8753                                                         ; 947f: 20 53 87     S.
    ldy #0                                                            ; 9482: a0 00       ..
    lda (l003c),y                                                     ; 9484: b1 3c       .<
    bne c944c                                                         ; 9486: d0 c4       ..
    lda l0079                                                         ; 9488: a5 79       .y
    bne c948d                                                         ; 948a: d0 01       ..
; &948c referenced 2 times by &9439, &9498
.return_17
    rts                                                               ; 948c: 60          `

; &948d referenced 1 time by &948a
.c948d
    lda l003a                                                         ; 948d: a5 3a       .:
    sta l0025                                                         ; 948f: 85 25       .%
    lda l003b                                                         ; 9491: a5 3b       .;
    sta l0026                                                         ; 9493: 85 26       .&
; &9495 referenced 1 time by &945d
.c9495
    jsr sub_c8ebe                                                     ; 9495: 20 be 8e     ..
    bcs return_17                                                     ; 9498: b0 f2       ..
    jsr sub_c875f                                                     ; 949a: 20 5f 87     _.
    bcc c94cf                                                         ; 949d: 90 30       .0
    ldy #0                                                            ; 949f: a0 00       ..
    lda (l003c),y                                                     ; 94a1: b1 3c       .<
    cmp #1                                                            ; 94a3: c9 01       ..
    bne c94d8                                                         ; 94a5: d0 31       .1
    jsr print_inline_string                                           ; 94a7: 20 6b 8a     k.
    equb &86                                                          ; 94aa: 86          .
    equs "Hex dump="                                                  ; 94ab: 48 65 78... Hex
    equb &ff                                                          ; 94b4: ff          .

    jsr sub_c8a41                                                     ; 94b5: 20 41 8a     A.
    jsr print_inline_string                                           ; 94b8: 20 6b 8a     k.
    equs " - "                                                        ; 94bb: 20 2d 20     -
    equb &ff                                                          ; 94be: ff          .

    ldy #6                                                            ; 94bf: a0 06       ..
    lda (l003c),y                                                     ; 94c1: b1 3c       .<
    jsr hex_to_digit                                                  ; 94c3: 20 c8 88     ..
    dey                                                               ; 94c6: 88          .
    lda (l003c),y                                                     ; 94c7: b1 3c       .<
    jsr hex_to_digit                                                  ; 94c9: 20 c8 88     ..
; &94cc referenced 1 time by &94eb
.loop_c94cc
    jsr osnewl                                                        ; 94cc: 20 e7 ff     ..            ; Write newline (characters 10 and 13)
; &94cf referenced 1 time by &949d
.c94cf
    inc l0025                                                         ; 94cf: e6 25       .%
    bne c94d5                                                         ; 94d1: d0 02       ..
    inc l0026                                                         ; 94d3: e6 26       .&
; &94d5 referenced 1 time by &94d1
.c94d5
    jmp c943b                                                         ; 94d5: 4c 3b 94    L;.

; &94d8 referenced 1 time by &94a5
.c94d8
    cmp #2                                                            ; 94d8: c9 02       ..
    bne c94ee                                                         ; 94da: d0 12       ..
    jsr print_inline_string                                           ; 94dc: 20 6b 8a     k.
; overlapping: sta l0070                                              ; 94df: 85 70       .p
    equb &85                                                          ; 94df: 85          .
    equs "printm="                                                    ; 94e0: 70 72 69... pri
    equb &ff                                                          ; 94e7: ff          .

; &94e8 referenced 1 time by &94fb
.loop_c94e8
    jsr sub_c8a41                                                     ; 94e8: 20 41 8a     A.
    jmp loop_c94cc                                                    ; 94eb: 4c cc 94    L..

; &94ee referenced 1 time by &94da
.c94ee
    lda #&20 ; ' '                                                    ; 94ee: a9 20       .
    jsr oswrch                                                        ; 94f0: 20 ee ff     ..            ; Write character 32
    jsr sub_c8c6c                                                     ; 94f3: 20 6c 8c     l.
    lda #&3d ; '='                                                    ; 94f6: a9 3d       .=
    jsr oswrch                                                        ; 94f8: 20 ee ff     ..            ; Write character 61
    jmp loop_c94e8                                                    ; 94fb: 4c e8 94    L..

; ***************************************************************************************
.list_command
    jsr enable_auto_paging_mode                                       ; 94fe: 20 d2 91     ..
    jmp c8e47                                                         ; 9501: 4c 47 8e    LG.

; ***************************************************************************************
.dump_command
    jsr enable_auto_paging_mode                                       ; 9504: 20 d2 91     ..
    jmp c8ed3                                                         ; 9507: 4c d3 8e    L..

; ***************************************************************************************
.del_command
    jsr skip_spaces_find_CR                                           ; 950a: 20 08 92     ..
    beq c9533                                                         ; 950d: f0 24       .$
    ldx #0                                                            ; 950f: a2 00       ..
; &9511 referenced 1 time by &951f
.loop_c9511
    lda l0700,y                                                       ; 9511: b9 00 07    ...
    cmp #&21 ; '!'                                                    ; 9514: c9 21       .!
    bcc c9536                                                         ; 9516: 90 1e       ..
    sta l0600,x                                                       ; 9518: 9d 00 06    ...
    iny                                                               ; 951b: c8          .
    inx                                                               ; 951c: e8          .
    cpx #8                                                            ; 951d: e0 08       ..
    bne loop_c9511                                                    ; 951f: d0 f0       ..
; ***************************************************************************************
; &9521 referenced 2 times by &8f6f, &927c
.error_bad_label
    brk                                                               ; 9521: 00          .

    equb 0                                                            ; 9522: 00          .
    equs "Bad label"                                                  ; 9523: 42 61 64... Bad
    equb 0                                                            ; 952c: 00          .

; &952d referenced 1 time by &9556
.c952d
    jmp error_os_label                                                ; 952d: 4c 50 8f    LP.

; &9530 referenced 6 times by &9552, &9561, &956b, &958f, &9595, &959b
.c9530
    jmp error_no_such_label                                           ; 9530: 4c b4 91    L..

; &9533 referenced 1 time by &950d
.c9533
    jmp error_missing_expression                                      ; 9533: 4c 9b 92    L..

; &9536 referenced 1 time by &9516
.c9536
    tya                                                               ; 9536: 98          .
    pha                                                               ; 9537: 48          H
    lda #0                                                            ; 9538: a9 00       ..
; &953a referenced 1 time by &9540
.loop_c953a
    sta l0600,x                                                       ; 953a: 9d 00 06    ...
    inx                                                               ; 953d: e8          .
    cpx #8                                                            ; 953e: e0 08       ..
    bne loop_c953a                                                    ; 9540: d0 f8       ..
    jsr sub_c8f05                                                     ; 9542: 20 05 8f     ..
    pla                                                               ; 9545: 68          h
    tay                                                               ; 9546: a8          .
    cpx #1                                                            ; 9547: e0 01       ..
    beq c955b                                                         ; 9549: f0 10       ..
    cpx #0                                                            ; 954b: e0 00       ..
    beq c956d                                                         ; 954d: f0 1e       ..
    jsr sub_m87bd                                                     ; 954f: 20 bd 87     ..
    bcc c9530                                                         ; 9552: 90 dc       ..
    lda l003d                                                         ; 9554: a5 3d       .=
    bmi c952d                                                         ; 9556: 30 d5       0.
; &9558 referenced 2 times by &9569, &959d
.c9558
    jmp c904d                                                         ; 9558: 4c 4d 90    LM.

; &955b referenced 1 time by &9549
.c955b
    jsr sub_c959f                                                     ; 955b: 20 9f 95     ..
    jsr sub_c875f                                                     ; 955e: 20 5f 87     _.
    bcc c9530                                                         ; 9561: 90 cd       ..
    ldy #0                                                            ; 9563: a0 00       ..
    lda (l003c),y                                                     ; 9565: b1 3c       .<
    cmp #2                                                            ; 9567: c9 02       ..
    beq c9558                                                         ; 9569: f0 ed       ..
    bne c9530                                                         ; 956b: d0 c3       ..             ; ALWAYS branch

; &956d referenced 1 time by &954d
.c956d
    jsr sub_c959f                                                     ; 956d: 20 9f 95     ..
    jsr sub_c92c1                                                     ; 9570: 20 c1 92     ..
    lda l0073                                                         ; 9573: a5 73       .s
    sta l0605                                                         ; 9575: 8d 05 06    ...
    lda l0074                                                         ; 9578: a5 74       .t
    sta l0606                                                         ; 957a: 8d 06 06    ...
    ldx #4                                                            ; 957d: a2 04       ..
    lda #0                                                            ; 957f: a9 00       ..
; &9581 referenced 1 time by &9585
.loop_c9581
    sta l0600,x                                                       ; 9581: 9d 00 06    ...
    dex                                                               ; 9584: ca          .
    bpl loop_c9581                                                    ; 9585: 10 fa       ..
    lda #1                                                            ; 9587: a9 01       ..
    sta l0600                                                         ; 9589: 8d 00 06    ...
    jsr sub_m87bd                                                     ; 958c: 20 bd 87     ..
    bcc c9530                                                         ; 958f: 90 9f       ..
    lda l003a                                                         ; 9591: a5 3a       .:
    cmp l0025                                                         ; 9593: c5 25       .%
    bne c9530                                                         ; 9595: d0 99       ..
    lda l003b                                                         ; 9597: a5 3b       .;
    cmp l0026                                                         ; 9599: c5 26       .&
    bne c9530                                                         ; 959b: d0 93       ..
    beq c9558                                                         ; 959d: f0 b9       ..             ; ALWAYS branch

; &959f referenced 2 times by &955b, &956d
.sub_c959f
    jsr sub_c92c1                                                     ; 959f: 20 c1 92     ..
    lda l0073                                                         ; 95a2: a5 73       .s
    sta l0025                                                         ; 95a4: 85 25       .%
    lda l0074                                                         ; 95a6: a5 74       .t
    sta l0026                                                         ; 95a8: 85 26       .&
    rts                                                               ; 95aa: 60          `

; &95ab referenced 1 time by &8f5d
.sub_c95ab
    tya                                                               ; 95ab: 98          .
    pha                                                               ; 95ac: 48          H
    jsr get_variable                                                  ; 95ad: 20 34 90     4.
    jsr c8753                                                         ; 95b0: 20 53 87     S.
    lda #osbyte_read_himem                                            ; 95b3: a9 84       ..
    jsr osbyte                                                        ; 95b5: 20 f4 ff     ..            ; Read top of user memory (HIMEM)
    cpy l003d                                                         ; 95b8: c4 3d       .=             ; X and Y contain the address of HIMEM (low, high)
    bcc c95c4                                                         ; 95ba: 90 08       ..
    bne c95ce                                                         ; 95bc: d0 10       ..
    cpx l003c                                                         ; 95be: e4 3c       .<
    bcc c95c4                                                         ; 95c0: 90 02       ..
    bne c95ce                                                         ; 95c2: d0 0a       ..
; &95c4 referenced 2 times by &95ba, &95c0
.c95c4
    brk                                                               ; 95c4: 00          .

    equb 0                                                            ; 95c5: 00          .
    equs "No Room"                                                    ; 95c6: 4e 6f 20... No
    equb 0                                                            ; 95cd: 00          .

; &95ce referenced 2 times by &95bc, &95c2
.c95ce
    pla                                                               ; 95ce: 68          h
    tay                                                               ; 95cf: a8          .
    rts                                                               ; 95d0: 60          `

; ***************************************************************************************
.lrom_command
    lda l0055                                                         ; 95d1: a5 55       .U
    pha                                                               ; 95d3: 48          H
    lda #&aa                                                          ; 95d4: a9 aa       ..
    jsr sub_c8f49                                                     ; 95d6: 20 49 8f     I.
    stx l0025                                                         ; 95d9: 86 25       .%
    sty l0026                                                         ; 95db: 84 26       .&
    lda #&10                                                          ; 95dd: a9 10       ..
    jsr sub_c8d42                                                     ; 95df: 20 42 8d     B.
    ldy #&0f                                                          ; 95e2: a0 0f       ..
; &95e4 referenced 1 time by &95eb
.loop_c95e4
    lda l0000,y                                                       ; 95e4: b9 00 00    ...
    sta l0110,y                                                       ; 95e7: 99 10 01    ...
    dey                                                               ; 95ea: 88          .
    bpl loop_c95e4                                                    ; 95eb: 10 f7       ..
    iny                                                               ; 95ed: c8          .
    sty l003e                                                         ; 95ee: 84 3e       .>
; &95f0 referenced 1 time by &962d
.c95f0
    lda #&82                                                          ; 95f0: a9 82       ..
    jsr sub_c8a50                                                     ; 95f2: 20 50 8a     P.
    lda l003e                                                         ; 95f5: a5 3e       .>
    sta l0055                                                         ; 95f7: 85 55       .U
    jsr convert_and_print_decimal                                     ; 95f9: 20 d3 88     ..
    lda #&87                                                          ; 95fc: a9 87       ..
    jsr sub_c8a50                                                     ; 95fe: 20 50 8a     P.
    ldy l003e                                                         ; 9601: a4 3e       .>
    lda l0110,y                                                       ; 9603: b9 10 01    ...
    beq c9624                                                         ; 9606: f0 1c       ..
    lda #9                                                            ; 9608: a9 09       ..
    sta l0025                                                         ; 960a: 85 25       .%
    lda #&80                                                          ; 960c: a9 80       ..
    sta l0026                                                         ; 960e: 85 26       .&
    lda #&1e                                                          ; 9610: a9 1e       ..
    jsr sub_c8d42                                                     ; 9612: 20 42 8d     B.
    ldy #0                                                            ; 9615: a0 00       ..
; &9617 referenced 1 time by &9622
.loop_c9617
    lda l0000,y                                                       ; 9617: b9 00 00    ...
    beq c9624                                                         ; 961a: f0 08       ..
    jsr sub_c8a5d                                                     ; 961c: 20 5d 8a     ].
    iny                                                               ; 961f: c8          .
    cpy #&1e                                                          ; 9620: c0 1e       ..
    bne loop_c9617                                                    ; 9622: d0 f3       ..
; &9624 referenced 2 times by &9606, &961a
.c9624
    jsr osnewl                                                        ; 9624: 20 e7 ff     ..            ; Write newline (characters 10 and 13)
    inc l003e                                                         ; 9627: e6 3e       .>
    lda l003e                                                         ; 9629: a5 3e       .>
    cmp #&10                                                          ; 962b: c9 10       ..
    bcc c95f0                                                         ; 962d: 90 c1       ..
    pla                                                               ; 962f: 68          h
    sta l0055                                                         ; 9630: 85 55       .U
    rts                                                               ; 9632: 60          `

; ***************************************************************************************
; &9633 referenced 1 time by &9639
.sub_m9633
    jmp error_missing_expression                                      ; 9633: 4c 9b 92    L..

; ***************************************************************************************
; &9636 referenced 4 times by &966e, &974a, &9ad1, &9af6
.sub_m9636
    jsr skip_spaces_find_CR                                           ; 9636: 20 08 92     ..
    beq sub_m9633                                                     ; 9639: f0 f8       ..
    ldx #0                                                            ; 963b: a2 00       ..
    cmp #&22 ; '"'                                                    ; 963d: c9 22       ."
    beq c9653                                                         ; 963f: f0 12       ..
; &9641 referenced 1 time by &964b
.loop_c9641
    sta l0600,x                                                       ; 9641: 9d 00 06    ...
    iny                                                               ; 9644: c8          .
    inx                                                               ; 9645: e8          .
    lda l0700,y                                                       ; 9646: b9 00 07    ...
    cmp #&21 ; '!'                                                    ; 9649: c9 21       .!
    bcs loop_c9641                                                    ; 964b: b0 f4       ..
; &964d referenced 2 times by &965a, &965e
.c964d
    lda #&0d                                                          ; 964d: a9 0d       ..
    sta l0600,x                                                       ; 964f: 9d 00 06    ...
    rts                                                               ; 9652: 60          `

; &9653 referenced 1 time by &963f
.c9653
    iny                                                               ; 9653: c8          .
; &9654 referenced 1 time by &9664
.loop_c9654
    lda l0700,y                                                       ; 9654: b9 00 07    ...
    iny                                                               ; 9657: c8          .
    cmp #&0d                                                          ; 9658: c9 0d       ..
    beq c964d                                                         ; 965a: f0 f1       ..
    cmp #&22 ; '"'                                                    ; 965c: c9 22       ."
    beq c964d                                                         ; 965e: f0 ed       ..
    sta l0600,x                                                       ; 9660: 9d 00 06    ...
    inx                                                               ; 9663: e8          .
    bne loop_c9654                                                    ; 9664: d0 ee       ..
; &9666 referenced 3 times by &96a7, &96b3, &96c1
.sub_c9666
    lda #0                                                            ; 9666: a9 00       ..
    sta l0000                                                         ; 9668: 85 00       ..
    lda #6                                                            ; 966a: a9 06       ..
    sta l0001                                                         ; 966c: 85 01       ..
    jsr sub_m9636                                                     ; 966e: 20 36 96     6.
    lda #osbyte_read_high_order_address                               ; 9671: a9 82       ..
    jsr osbyte                                                        ; 9673: 20 f4 ff     ..            ; Read the filing system 'machine high order address'
    stx l0004                                                         ; 9676: 86 04       ..             ; X and Y contain the machine high order address (low, high)
    stx l000c                                                         ; 9678: 86 0c       ..
    stx l0010                                                         ; 967a: 86 10       ..
    sty l0005                                                         ; 967c: 84 05       ..
    sty l000d                                                         ; 967e: 84 0d       ..
    sty l0011                                                         ; 9680: 84 11       ..
    lda himem                                                         ; 9682: a5 89       ..
    sta l0002                                                         ; 9684: 85 02       ..
    sta l000a                                                         ; 9686: 85 0a       ..
    lda himem+1                                                       ; 9688: a5 8a       ..
    sta l0003                                                         ; 968a: 85 03       ..
    sta l000b                                                         ; 968c: 85 0b       ..
    ldx #3                                                            ; 968e: a2 03       ..
    lda #0                                                            ; 9690: a9 00       ..
; &9692 referenced 1 time by &9695
.loop_c9692
    sta l0006,x                                                       ; 9692: 95 06       ..
    dex                                                               ; 9694: ca          .
    bpl loop_c9692                                                    ; 9695: 10 fb       ..
    jsr get_variable                                                  ; 9697: 20 34 90     4.
    ldx l003c                                                         ; 969a: a6 3c       .<
    ldy l003d                                                         ; 969c: a4 3d       .=
    inx                                                               ; 969e: e8          .
    bne c96a2                                                         ; 969f: d0 01       ..
    iny                                                               ; 96a1: c8          .
; &96a2 referenced 1 time by &969f
.c96a2
    stx l000e                                                         ; 96a2: 86 0e       ..
    sty l000f                                                         ; 96a4: 84 0f       ..
    rts                                                               ; 96a6: 60          `

; ***************************************************************************************
.load_command
    jsr sub_c9666                                                     ; 96a7: 20 66 96     f.
; &96aa referenced 1 time by &96be
.loop_c96aa
    lda #&ff                                                          ; 96aa: a9 ff       ..
; &96ac referenced 1 time by &96cc
.c96ac
    ldx #<(l0000)                                                     ; 96ac: a2 00       ..
    ldy #>(l0000)                                                     ; 96ae: a0 00       ..
    jmp osfile                                                        ; 96b0: 4c dd ff    L..

; ***************************************************************************************
.append_command
    jsr sub_c9666                                                     ; 96b3: 20 66 96     f.
    ldx l003c                                                         ; 96b6: a6 3c       .<
    ldy l003d                                                         ; 96b8: a4 3d       .=
    stx l0002                                                         ; 96ba: 86 02       ..
    sty l0003                                                         ; 96bc: 84 03       ..
    jmp loop_c96aa                                                    ; 96be: 4c aa 96    L..

; ***************************************************************************************
.save_command
    jsr sub_c9666                                                     ; 96c1: 20 66 96     f.
    jsr sub_c9b7a                                                     ; 96c4: 20 7a 9b     z.
    jsr osnewl                                                        ; 96c7: 20 e7 ff     ..            ; Write newline (characters 10 and 13)
    lda #0                                                            ; 96ca: a9 00       ..
    beq c96ac                                                         ; 96cc: f0 de       ..             ; ALWAYS branch

; ***************************************************************************************
.quit_command
    lda #&bb                                                          ; 96ce: a9 bb       ..
    jsr sub_c8f49                                                     ; 96d0: 20 49 8f     I.
    txa                                                               ; 96d3: 8a          .
    sta l0000                                                         ; 96d4: 85 00       ..
    bmi error_no_basic                                                ; 96d6: 30 58       0X
    jsr get_variable                                                  ; 96d8: 20 34 90     4.
    lda l003c                                                         ; 96db: a5 3c       .<
    cmp himem                                                         ; 96dd: c5 89       ..
    bne print_are_you_sure                                            ; 96df: d0 06       ..
    lda l003d                                                         ; 96e1: a5 3d       .=
    cmp himem+1                                                       ; 96e3: c5 8a       ..
    beq c9707                                                         ; 96e5: f0 20       .
; ***************************************************************************************
; &96e7 referenced 1 time by &96df
.print_are_you_sure
    jsr print_inline_string                                           ; 96e7: 20 6b 8a     k.
    equb &86                                                          ; 96ea: 86          .
    equs "Are you sure"                                               ; 96eb: 41 72 65... Are
    equb &83, &3f, &ff                                                ; 96f7: 83 3f ff    .?.

; ***************************************************************************************
.sub_m96fa
    jsr flush_all_buffers                                             ; 96fa: 20 47 8f     G.
    jsr osrdch                                                        ; 96fd: 20 e0 ff     ..            ; Read a character from the current input stream
    cmp #&59 ; 'Y'                                                    ; 9700: c9 59       .Y             ; A=character read
    beq c9707                                                         ; 9702: f0 03       ..
    jmp c8091                                                         ; 9704: 4c 91 80    L..

; &9707 referenced 2 times by &96e5, &9702
.c9707
    lda #&e1                                                          ; 9707: a9 e1       ..
    ldx #1                                                            ; 9709: a2 01       ..
    jsr set_y_zero_call_osbyte                                        ; 970b: 20 43 8f     C.            ; expand ctrl-f10 key as softkey
    lda #&e2                                                          ; 970e: a9 e2       ..
    ldx #&80                                                          ; 9710: a2 80       ..
    jsr set_y_zero_call_osbyte                                        ; 9712: 20 43 8f     C.            ; expand ctrl-f11 key as softkey
    lda #&e3                                                          ; 9715: a9 e3       ..
    ldx #&90                                                          ; 9717: a2 90       ..
    jsr set_y_zero_call_osbyte                                        ; 9719: 20 43 8f     C.            ; expand ctrl-f12 key as softkey
    lda #&e4                                                          ; 971c: a9 e4       ..
    ldx #&a0                                                          ; 971e: a2 a0       ..
    jsr set_y_zero_call_osbyte                                        ; 9720: 20 43 8f     C.            ; expand ctrl-f13 key as softkey
    jsr print_inline_string                                           ; 9723: 20 6b 8a     k.
    equb &1a, &0c, &ff                                                ; 9726: 1a 0c ff    ...
; reset text window, cls

; ***************************************************************************************
.call_osbyte_enter_language
    ldx l0000                                                         ; 9729: a6 00       ..             ; X=ROM number
    lda #osbyte_enter_language                                        ; 972b: a9 8e       ..
    jmp osbyte                                                        ; 972d: 4c f4 ff    L..            ; Enter language ROM X

; ***************************************************************************************
; &9730 referenced 1 time by &96d6
.error_no_basic
    brk                                                               ; 9730: 00          .

    equb 0                                                            ; 9731: 00          .
    equs "No BASIC"                                                   ; 9732: 4e 6f 20... No
    equb 0                                                            ; 973a: 00          .

; ***************************************************************************************
; &973b referenced 1 time by &97de
.stop_output_to_printer
    lda #3                                                            ; 973b: a9 03       ..
    jmp oswrch                                                        ; 973d: 4c ee ff    L..            ; stop spooling to printer

; ***************************************************************************************
.rsave_command
    lda l0055                                                         ; 9740: a5 55       .U
    pha                                                               ; 9742: 48          H
    jsr sub_c974a                                                     ; 9743: 20 4a 97     J.
    pla                                                               ; 9746: 68          h
    sta l0055                                                         ; 9747: 85 55       .U
; &9749 referenced 1 time by &9762
.return_18
    rts                                                               ; 9749: 60          `

; &974a referenced 1 time by &9743
.sub_c974a
    jsr sub_m9636                                                     ; 974a: 20 36 96     6.
    jsr rom_command                                                   ; 974d: 20 b9 93     ..
    jsr sub_c9b7a                                                     ; 9750: 20 7a 9b     z.
    jsr osnewl                                                        ; 9753: 20 e7 ff     ..            ; Write newline (characters 10 and 13)
    lda #osfind_open_output                                           ; 9756: a9 80       ..
    ldx #<(l0600)                                                     ; 9758: a2 00       ..
    stx l0025                                                         ; 975a: 86 25       .%
    ldy #>(l0600)                                                     ; 975c: a0 06       ..
    jsr osfind                                                        ; 975e: 20 ce ff     ..            ; Open file for output (A=128)
    tax                                                               ; 9761: aa          .              ; A=file handle (or zero on failure)
    beq return_18                                                     ; 9762: f0 e5       ..
    sta l003e                                                         ; 9764: 85 3e       .>
    lda #&80                                                          ; 9766: a9 80       ..
    jsr sub_c979c                                                     ; 9768: 20 9c 97     ..
    lda #&10                                                          ; 976b: a9 10       ..
    jsr sub_c8d42                                                     ; 976d: 20 42 8d     B.
    ldx #&0f                                                          ; 9770: a2 0f       ..
; &9772 referenced 1 time by &9777
.loop_c9772
    lda l0000,x                                                       ; 9772: b5 00       ..
    sta l0010,x                                                       ; 9774: 95 10       ..
    dex                                                               ; 9776: ca          .
    bpl loop_c9772                                                    ; 9777: 10 f9       ..
    lda #&80                                                          ; 9779: a9 80       ..
    sta l0026                                                         ; 977b: 85 26       .&
    lda #&10                                                          ; 977d: a9 10       ..
    jsr sub_c8d42                                                     ; 977f: 20 42 8d     B.
    ldx #&0f                                                          ; 9782: a2 0f       ..
; &9784 referenced 1 time by &978b
.loop_c9784
    lda l0000,x                                                       ; 9784: b5 00       ..
    cmp l0010,x                                                       ; 9786: d5 10       ..
    bne c9794                                                         ; 9788: d0 0a       ..
    dex                                                               ; 978a: ca          .
    bpl loop_c9784                                                    ; 978b: 10 f7       ..
; &978d referenced 1 time by &9799
.loop_c978d
    ldy l003e                                                         ; 978d: a4 3e       .>
; &978f referenced 1 time by &9b8b
.sub_c978f
    lda #osfind_close                                                 ; 978f: a9 00       ..
    jmp osfind                                                        ; 9791: 4c ce ff    L..            ; Close one or all files

; &9794 referenced 1 time by &9788
.c9794
    lda #&a0                                                          ; 9794: a9 a0       ..
    jsr sub_c979c                                                     ; 9796: 20 9c 97     ..
    jmp loop_c978d                                                    ; 9799: 4c 8d 97    L..

; &979c referenced 2 times by &9768, &9796
.sub_c979c
    sta l0026                                                         ; 979c: 85 26       .&
; &979e referenced 2 times by &97be, &97c8
.c979e
    lda #&20 ; ' '                                                    ; 979e: a9 20       .
    jsr sub_c8d42                                                     ; 97a0: 20 42 8d     B.
    ldx #0                                                            ; 97a3: a2 00       ..
; &97a5 referenced 1 time by &97af
.loop_c97a5
    lda l0000,x                                                       ; 97a5: b5 00       ..
    ldy l003e                                                         ; 97a7: a4 3e       .>             ; Y=file handle
    jsr osbput                                                        ; 97a9: 20 d4 ff     ..            ; Write a single byte A to an open file Y
    inx                                                               ; 97ac: e8          .
    cpx #&20 ; ' '                                                    ; 97ad: e0 20       .
    bne loop_c97a5                                                    ; 97af: d0 f4       ..
    lda l0025                                                         ; 97b1: a5 25       .%
    clc                                                               ; 97b3: 18          .
    adc #&20 ; ' '                                                    ; 97b4: 69 20       i
    sta l0025                                                         ; 97b6: 85 25       .%
    bcc c97bc                                                         ; 97b8: 90 02       ..
    inc l0026                                                         ; 97ba: e6 26       .&
; &97bc referenced 1 time by &97b8
.c97bc
    lda l0025                                                         ; 97bc: a5 25       .%
    bne c979e                                                         ; 97be: d0 de       ..
    lda l0026                                                         ; 97c0: a5 26       .&
    cmp #&a0                                                          ; 97c2: c9 a0       ..
    beq return_19                                                     ; 97c4: f0 04       ..
    cmp #&c0                                                          ; 97c6: c9 c0       ..
    bne c979e                                                         ; 97c8: d0 d4       ..
; &97ca referenced 1 time by &97c4
.return_19
    rts                                                               ; 97ca: 60          `

; ***************************************************************************************
.edit_command
    jsr skip_spaces_find_CR                                           ; 97cb: 20 08 92     ..
    bne c97db                                                         ; 97ce: d0 0b       ..
    lda l0057                                                         ; 97d0: a5 57       .W
    sta l0073                                                         ; 97d2: 85 73       .s
    lda l0058                                                         ; 97d4: a5 58       .X
    sta l0074                                                         ; 97d6: 85 74       .t
    jmp c97de                                                         ; 97d8: 4c de 97    L..

; &97db referenced 1 time by &97ce
.c97db
    jsr c9070                                                         ; 97db: 20 70 90     p.
; &97de referenced 1 time by &97d8
.c97de
    jsr stop_output_to_printer                                        ; 97de: 20 3b 97     ;.
    lda l0073                                                         ; 97e1: a5 73       .s
    and #7                                                            ; 97e3: 29 07       ).
    sta l007b                                                         ; 97e5: 85 7b       .{
    lda l0073                                                         ; 97e7: a5 73       .s
    and #&f8                                                          ; 97e9: 29 f8       ).
    sta l0073                                                         ; 97eb: 85 73       .s
    lda #&0c                                                          ; 97ed: a9 0c       ..
    jsr oswrch                                                        ; 97ef: 20 ee ff     ..            ; Write character 12
    jsr sub_c99d0                                                     ; 97f2: 20 d0 99     ..
    ldx #1                                                            ; 97f5: a2 01       ..
    stx l007c                                                         ; 97f7: 86 7c       .|
    dex                                                               ; 97f9: ca          .              ; X=&00
; &97fa referenced 1 time by &9800
.loop_c97fa
    jsr sub_c996d                                                     ; 97fa: 20 6d 99     m.
    inx                                                               ; 97fd: e8          .
    cpx #&15                                                          ; 97fe: e0 15       ..
    bne loop_c97fa                                                    ; 9800: d0 f8       ..
    lda #osbyte_set_cursor_editing                                    ; 9802: a9 04       ..
    ldx #1                                                            ; 9804: a2 01       ..
    jsr osbyte                                                        ; 9806: 20 f4 ff     ..            ; Disable cursor editing (edit keys give ASCII 135-139) (X=1)
; &9809 referenced 1 time by &98dd
.c9809
    jsr print_inline_string                                           ; 9809: 20 6b 8a     k.
    equb &1a, &1f, &26, 1, &ff                                        ; 980c: 1a 1f 26... ..&

; ***************************************************************************************
.sub_m9811
    ldx l007c                                                         ; 9811: a6 7c       .|
    lda l9856,x                                                       ; 9813: bd 56 98    .V.
    jsr oswrch                                                        ; 9816: 20 ee ff     ..            ; Write character
    jsr print_inline_string                                           ; 9819: 20 6b 8a     k.
    equb &1c, 0, &18, &27, 4, &ff                                     ; 981c: 1c 00 18... ...

; ***************************************************************************************
; &9822 referenced 5 times by &9862, &987b, &98a3, &990c, &991c
.sub_m9822
    jsr sub_c99ba                                                     ; 9822: 20 ba 99     ..
    jsr print_inline_string                                           ; 9825: 20 6b 8a     k.
    eor l0909,x                                                       ; 9828: 5d 09 09    ]..
    equb &5b, &1f, &ff                                                ; 982b: 5b 1f ff    [..

; ***************************************************************************************
.sub_m982e
    lda l007b                                                         ; 982e: a5 7b       .{
    clc                                                               ; 9830: 18          .
    adc #&1f                                                          ; 9831: 69 1f       i.
    jsr oswrch                                                        ; 9833: 20 ee ff     ..            ; Write character
    jsr sub_c99cb                                                     ; 9836: 20 cb 99     ..
    jsr osrdch                                                        ; 9839: 20 e0 ff     ..            ; Read a character from the current input stream
    bcc c9859                                                         ; 983c: 90 1b       ..
    lda #4                                                            ; 983e: a9 04       ..
    jsr sub_c8f49                                                     ; 9840: 20 49 8f     I.
    jsr print_inline_string                                           ; 9843: 20 6b 8a     k.
    equb &1a, &1f, &26, 1, &20, &1c, 0, &18, &27, 4, &1f, 0, &14, &0a ; 9846: 1a 1f 26... ..&
    equb &ff                                                          ; 9854: ff          .

    rts                                                               ; 9855: 60          `

; &9856 referenced 1 time by &9813
.l9856
    equs "HAD"                                                        ; 9856: 48 41 44    HAD

; &9859 referenced 1 time by &983c
.c9859
    cmp #&88                                                          ; 9859: c9 88       ..
    bne c986a                                                         ; 985b: d0 0d       ..
; &985d referenced 1 time by &986c
.loop_c985d
    jsr sub_c99de                                                     ; 985d: 20 de 99     ..
    dec l007b                                                         ; 9860: c6 7b       .{
    bpl sub_m9822                                                     ; 9862: 10 be       ..
    lda #7                                                            ; 9864: a9 07       ..
    sta l007b                                                         ; 9866: 85 7b       .{
    bne c988a                                                         ; 9868: d0 20       .              ; ALWAYS branch

; &986a referenced 1 time by &985b
.c986a
    cmp #&7f                                                          ; 986a: c9 7f       ..
    beq loop_c985d                                                    ; 986c: f0 ef       ..
    cmp #&89                                                          ; 986e: c9 89       ..
    bne c9883                                                         ; 9870: d0 11       ..
; &9872 referenced 1 time by &9941
.c9872
    jsr sub_c99de                                                     ; 9872: 20 de 99     ..
    inc l007b                                                         ; 9875: e6 7b       .{
    lda l007b                                                         ; 9877: a5 7b       .{
    cmp #8                                                            ; 9879: c9 08       ..
    bcc sub_m9822                                                     ; 987b: 90 a5       ..
    lda #0                                                            ; 987d: a9 00       ..
    sta l007b                                                         ; 987f: 85 7b       .{
    beq c98ad                                                         ; 9881: f0 2a       .*             ; ALWAYS branch

; &9883 referenced 1 time by &9870
.c9883
    cmp #&8b                                                          ; 9883: c9 8b       ..
    bne c98a6                                                         ; 9885: d0 1f       ..
    jsr sub_c99de                                                     ; 9887: 20 de 99     ..
; &988a referenced 1 time by &9868
.c988a
    jsr print_inline_string                                           ; 988a: 20 6b 8a     k.
    asl lff0b,x                                                       ; 988d: 1e 0b ff    ...
    lda l0073                                                         ; 9890: a5 73       .s
    sec                                                               ; 9892: 38          8
    sbc #8                                                            ; 9893: e9 08       ..
    sta l0073                                                         ; 9895: 85 73       .s
    bcs c989b                                                         ; 9897: b0 02       ..
    dec l0074                                                         ; 9899: c6 74       .t
; &989b referenced 1 time by &9897
.c989b
    jsr sub_c99d0                                                     ; 989b: 20 d0 99     ..
    ldx #0                                                            ; 989e: a2 00       ..
; &98a0 referenced 1 time by &98cf
.c98a0
    jsr sub_c996d                                                     ; 98a0: 20 6d 99     m.
; &98a3 referenced 1 time by &98fd
.c98a3
    jmp sub_m9822                                                     ; 98a3: 4c 22 98    L".

; &98a6 referenced 1 time by &9885
.c98a6
    cmp #&8a                                                          ; 98a6: c9 8a       ..
    bne c98d1                                                         ; 98a8: d0 27       .'
    jsr sub_c99de                                                     ; 98aa: 20 de 99     ..
; &98ad referenced 1 time by &9881
.c98ad
    jsr print_inline_string                                           ; 98ad: 20 6b 8a     k.
    equb &1f, &27, &14, &0a, &ff                                      ; 98b0: 1f 27 14... .'.

    lda l0073                                                         ; 98b5: a5 73       .s
    clc                                                               ; 98b7: 18          .
    adc #8                                                            ; 98b8: 69 08       i.
    sta l0073                                                         ; 98ba: 85 73       .s
    bcc c98c0                                                         ; 98bc: 90 02       ..
    inc l0074                                                         ; 98be: e6 74       .t
; &98c0 referenced 1 time by &98bc
.c98c0
    lda l0073                                                         ; 98c0: a5 73       .s
    clc                                                               ; 98c2: 18          .
    adc #&58 ; 'X'                                                    ; 98c3: 69 58       iX
    sta l0025                                                         ; 98c5: 85 25       .%
    lda l0074                                                         ; 98c7: a5 74       .t
    adc #0                                                            ; 98c9: 69 00       i.
    sta l0026                                                         ; 98cb: 85 26       .&
    ldx #&14                                                          ; 98cd: a2 14       ..
    bne c98a0                                                         ; 98cf: d0 cf       ..             ; ALWAYS branch

; &98d1 referenced 1 time by &98a8
.c98d1
    cmp #9                                                            ; 98d1: c9 09       ..
    bne c98e0                                                         ; 98d3: d0 0b       ..
    dec l007c                                                         ; 98d5: c6 7c       .|
    bpl c98dd                                                         ; 98d7: 10 04       ..
    lda #2                                                            ; 98d9: a9 02       ..
    sta l007c                                                         ; 98db: 85 7c       .|
; &98dd referenced 1 time by &98d7
.c98dd
    jmp c9809                                                         ; 98dd: 4c 09 98    L..

; &98e0 referenced 1 time by &98d3
.c98e0
    sta l007d                                                         ; 98e0: 85 7d       .}
    lda l0073                                                         ; 98e2: a5 73       .s
    clc                                                               ; 98e4: 18          .
    adc l007b                                                         ; 98e5: 65 7b       e{
    sta l0025                                                         ; 98e7: 85 25       .%
    lda l0074                                                         ; 98e9: a5 74       .t
    adc #0                                                            ; 98eb: 69 00       i.
    sta l0026                                                         ; 98ed: 85 26       .&
    lda #1                                                            ; 98ef: a9 01       ..
    jsr c8d4e                                                         ; 98f1: 20 4e 8d     N.
    lda l007c                                                         ; 98f4: a5 7c       .|
    bne c990f                                                         ; 98f6: d0 17       ..
    lda l007d                                                         ; 98f8: a5 7d       .}
    jsr sub_c9225                                                     ; 98fa: 20 25 92     %.
    bcs c98a3                                                         ; 98fd: b0 a4       ..
    sta l007d                                                         ; 98ff: 85 7d       .}
    lda l0000                                                         ; 9901: a5 00       ..
    asl a                                                             ; 9903: 0a          .
    asl a                                                             ; 9904: 0a          .
    asl a                                                             ; 9905: 0a          .
    asl a                                                             ; 9906: 0a          .
    ora l007d                                                         ; 9907: 05 7d       .}
; &9909 referenced 2 times by &9934, &9939
.c9909
    jsr sub_c9944                                                     ; 9909: 20 44 99     D.
    jmp sub_m9822                                                     ; 990c: 4c 22 98    L".

; &990f referenced 1 time by &98f6
.c990f
    cmp #2                                                            ; 990f: c9 02       ..
    bne c993c                                                         ; 9911: d0 29       .)
    lda l007d                                                         ; 9913: a5 7d       .}
    sec                                                               ; 9915: 38          8
    sbc #&30 ; '0'                                                    ; 9916: e9 30       .0
    cmp #&0a                                                          ; 9918: c9 0a       ..
    bcc c991f                                                         ; 991a: 90 03       ..
    jmp sub_m9822                                                     ; 991c: 4c 22 98    L".

; &991f referenced 1 time by &991a
.c991f
    sta l007d                                                         ; 991f: 85 7d       .}
    lda l0000                                                         ; 9921: a5 00       ..
    asl a                                                             ; 9923: 0a          .
    bcs c9937                                                         ; 9924: b0 11       ..
    sta l003e                                                         ; 9926: 85 3e       .>
    asl a                                                             ; 9928: 0a          .
    bcs c9937                                                         ; 9929: b0 0c       ..
    asl a                                                             ; 992b: 0a          .
    bcs c9937                                                         ; 992c: b0 09       ..
    adc l003e                                                         ; 992e: 65 3e       e>
    bcs c9937                                                         ; 9930: b0 05       ..
    adc l007d                                                         ; 9932: 65 7d       e}
    jmp c9909                                                         ; 9934: 4c 09 99    L..

; &9937 referenced 4 times by &9924, &9929, &992c, &9930
.c9937
    lda l007d                                                         ; 9937: a5 7d       .}
    jmp c9909                                                         ; 9939: 4c 09 99    L..

; &993c referenced 1 time by &9911
.c993c
    lda l007d                                                         ; 993c: a5 7d       .}
    jsr sub_c9944                                                     ; 993e: 20 44 99     D.
    jmp c9872                                                         ; 9941: 4c 72 98    Lr.

; &9944 referenced 2 times by &9909, &993e
.sub_c9944
    bit tube_flag                                                     ; 9944: 24 6b       $k
    bmi c99b3                                                         ; 9946: 30 6b       0k
    sta l0004                                                         ; 9948: 85 04       ..
    ldy #>(l0000)                                                     ; 994a: a0 00       ..
    sty l0003                                                         ; 994c: 84 03       ..
    sty l0002                                                         ; 994e: 84 02       ..
    lda l0073                                                         ; 9950: a5 73       .s
    clc                                                               ; 9952: 18          .
    adc l007b                                                         ; 9953: 65 7b       e{
    sta l0000                                                         ; 9955: 85 00       ..
    tya                                                               ; 9957: 98          .              ; A=&00
    adc l0074                                                         ; 9958: 65 74       et
    sta l0001                                                         ; 995a: 85 01       ..
    ldx #<(l0000)                                                     ; 995c: a2 00       ..
    lda #osword_write_io_memory                                       ; 995e: a9 06       ..
    jsr osword                                                        ; 9960: 20 f1 ff     ..            ; Write byte of I/O processor memory
; &9963 referenced 1 time by &99b7
.c9963
    ldx #9                                                            ; 9963: a2 09       ..
    lda l0073                                                         ; 9965: a5 73       .s
    sta l0025                                                         ; 9967: 85 25       .%
    lda l0074                                                         ; 9969: a5 74       .t
    sta l0026                                                         ; 996b: 85 26       .&
; &996d referenced 2 times by &97fa, &98a0
.sub_c996d
    jsr print_inline_string                                           ; 996d: 20 6b 8a     k.
    equb &1f, 0, &ff                                                  ; 9970: 1f 00 ff    ...

    txa                                                               ; 9973: 8a          .
    jsr oswrch                                                        ; 9974: 20 ee ff     ..            ; Write character
    lda #8                                                            ; 9977: a9 08       ..
    jsr c8d4e                                                         ; 9979: 20 4e 8d     N.
    jsr sub_c8a41                                                     ; 997c: 20 41 8a     A.
    lda #&87                                                          ; 997f: a9 87       ..
    jsr sub_c8a50                                                     ; 9981: 20 50 8a     P.
    lda #&20 ; ' '                                                    ; 9984: a9 20       .
    jsr oswrch                                                        ; 9986: 20 ee ff     ..            ; Write character 32
    ldy #0                                                            ; 9989: a0 00       ..
; &998b referenced 1 time by &9999
.loop_c998b
    lda l0000,y                                                       ; 998b: b9 00 00    ...
    jsr hex_to_digit                                                  ; 998e: 20 c8 88     ..
    lda #&20 ; ' '                                                    ; 9991: a9 20       .
    jsr oswrch                                                        ; 9993: 20 ee ff     ..            ; Write character 32
    iny                                                               ; 9996: c8          .
    cpy #8                                                            ; 9997: c0 08       ..
    bne loop_c998b                                                    ; 9999: d0 f0       ..
    ldy #0                                                            ; 999b: a0 00       ..
; &999d referenced 1 time by &99a6
.loop_c999d
    lda l0000,y                                                       ; 999d: b9 00 00    ...
    jsr sub_c8a5d                                                     ; 99a0: 20 5d 8a     ].
    iny                                                               ; 99a3: c8          .
    cpy #8                                                            ; 99a4: c0 08       ..
    bne loop_c999d                                                    ; 99a6: d0 f5       ..
    tya                                                               ; 99a8: 98          .
    clc                                                               ; 99a9: 18          .
    adc l0025                                                         ; 99aa: 65 25       e%
    sta l0025                                                         ; 99ac: 85 25       .%
    bcc return_20                                                     ; 99ae: 90 02       ..
    inc l0026                                                         ; 99b0: e6 26       .&
; &99b2 referenced 1 time by &99ae
.return_20
    rts                                                               ; 99b2: 60          `

; &99b3 referenced 1 time by &9946
.c99b3
    ldy l007b                                                         ; 99b3: a4 7b       .{
    sta (l0073),y                                                     ; 99b5: 91 73       .s
    jmp c9963                                                         ; 99b7: 4c 63 99    Lc.

; &99ba referenced 2 times by &9822, &99de
.sub_c99ba
    lda l007b                                                         ; 99ba: a5 7b       .{
    asl a                                                             ; 99bc: 0a          .
    adc l007b                                                         ; 99bd: 65 7b       e{
    adc #6                                                            ; 99bf: 69 06       i.
    tax                                                               ; 99c1: aa          .
    lda #&1f                                                          ; 99c2: a9 1f       ..
    jsr oswrch                                                        ; 99c4: 20 ee ff     ..            ; Write character 31
    txa                                                               ; 99c7: 8a          .
    jsr oswrch                                                        ; 99c8: 20 ee ff     ..            ; Write character
; &99cb referenced 1 time by &9836
.sub_c99cb
    lda #9                                                            ; 99cb: a9 09       ..
    jmp oswrch                                                        ; 99cd: 4c ee ff    L..            ; Write character 9

; &99d0 referenced 2 times by &97f2, &989b
.sub_c99d0
    lda l0073                                                         ; 99d0: a5 73       .s
    sec                                                               ; 99d2: 38          8
    sbc #&48 ; 'H'                                                    ; 99d3: e9 48       .H
    sta l0025                                                         ; 99d5: 85 25       .%
    lda l0074                                                         ; 99d7: a5 74       .t
    sbc #0                                                            ; 99d9: e9 00       ..
    sta l0026                                                         ; 99db: 85 26       .&
    rts                                                               ; 99dd: 60          `

; &99de referenced 4 times by &985d, &9872, &9887, &98aa
.sub_c99de
    jsr sub_c99ba                                                     ; 99de: 20 ba 99     ..
    jsr print_inline_string                                           ; 99e1: 20 6b 8a     k.
    equb &20, 9, 9, &20, &ff                                          ; 99e4: 20 09 09...  ..

    rts                                                               ; 99e9: 60          `

; ***************************************************************************************
.find_command
    jsr skip_spaces_find_CR                                           ; 99ea: 20 08 92     ..
    bne c99f2                                                         ; 99ed: d0 03       ..
    jmp error_missing_expression                                      ; 99ef: 4c 9b 92    L..

; &99f2 referenced 1 time by &99ed
.c99f2
    ldx #0                                                            ; 99f2: a2 00       ..
    stx l0025                                                         ; 99f4: 86 25       .%
    stx l0026                                                         ; 99f6: 86 26       .&
    stx l007e                                                         ; 99f8: 86 7e       .~
    dex                                                               ; 99fa: ca          .              ; X=&ff
    stx l0027                                                         ; 99fb: 86 27       .'
    stx l0028                                                         ; 99fd: 86 28       .(
    cmp #&22 ; '"'                                                    ; 99ff: c9 22       ."
    beq c9a21                                                         ; 9a01: f0 1e       ..
; &9a03 referenced 1 time by &9a1c
.loop_c9a03
    cmp #&7c ; '|'                                                    ; 9a03: c9 7c       .|
    beq c9a43                                                         ; 9a05: f0 3c       .<
    jsr c9070                                                         ; 9a07: 20 70 90     p.
    lda l0073                                                         ; 9a0a: a5 73       .s
    ldx l007e                                                         ; 9a0c: a6 7e       .~
    sta l0500,x                                                       ; 9a0e: 9d 00 05    ...
    inc l007e                                                         ; 9a11: e6 7e       .~
    lda l007e                                                         ; 9a13: a5 7e       .~
    cmp #&20 ; ' '                                                    ; 9a15: c9 20       .
    bcs c9a1e                                                         ; 9a17: b0 05       ..
    jsr skip_spaces_find_CR                                           ; 9a19: 20 08 92     ..
    bne loop_c9a03                                                    ; 9a1c: d0 e5       ..
; &9a1e referenced 1 time by &9a17
.c9a1e
    jmp c9a64                                                         ; 9a1e: 4c 64 9a    Ld.

; &9a21 referenced 2 times by &9a01, &9a38
.c9a21
    iny                                                               ; 9a21: c8          .
    lda l0700,y                                                       ; 9a22: b9 00 07    ...
    cmp #&0d                                                          ; 9a25: c9 0d       ..
    beq c9a64                                                         ; 9a27: f0 3b       .;
    cmp #&22 ; '"'                                                    ; 9a29: c9 22       ."
    beq c9a3c                                                         ; 9a2b: f0 0f       ..
    ldx l007e                                                         ; 9a2d: a6 7e       .~
    sta l0500,x                                                       ; 9a2f: 9d 00 05    ...
    inc l007e                                                         ; 9a32: e6 7e       .~
    lda l007e                                                         ; 9a34: a5 7e       .~
    cmp #&20 ; ' '                                                    ; 9a36: c9 20       .
    bcc c9a21                                                         ; 9a38: 90 e7       ..
    bcs c9a64                                                         ; 9a3a: b0 28       .(             ; ALWAYS branch

; &9a3c referenced 1 time by &9a2b
.c9a3c
    iny                                                               ; 9a3c: c8          .
    jsr skip_spaces_find_CR                                           ; 9a3d: 20 08 92     ..
    beq c9a64                                                         ; 9a40: f0 22       ."
    dey                                                               ; 9a42: 88          .
; &9a43 referenced 1 time by &9a05
.c9a43
    iny                                                               ; 9a43: c8          .
    jsr skip_spaces_find_CR                                           ; 9a44: 20 08 92     ..
    beq c9a64                                                         ; 9a47: f0 1b       ..
    jsr c9070                                                         ; 9a49: 20 70 90     p.
    lda l0073                                                         ; 9a4c: a5 73       .s
    sta l0025                                                         ; 9a4e: 85 25       .%
    lda l0074                                                         ; 9a50: a5 74       .t
    sta l0026                                                         ; 9a52: 85 26       .&
    jsr skip_spaces_find_CR                                           ; 9a54: 20 08 92     ..
    beq c9a64                                                         ; 9a57: f0 0b       ..
    jsr c9070                                                         ; 9a59: 20 70 90     p.
    lda l0073                                                         ; 9a5c: a5 73       .s
    sta l0027                                                         ; 9a5e: 85 27       .'
    lda l0074                                                         ; 9a60: a5 74       .t
    sta l0028                                                         ; 9a62: 85 28       .(
; &9a64 referenced 6 times by &9a1e, &9a27, &9a3a, &9a40, &9a47, &9a57
.c9a64
    bit l003f                                                         ; 9a64: 24 3f       $?
    bmi c9a6d                                                         ; 9a66: 30 05       0.
    lda #&0e                                                          ; 9a68: a9 0e       ..
    jsr oswrch                                                        ; 9a6a: 20 ee ff     ..            ; Write character 14
; &9a6d referenced 1 time by &9a66
.c9a6d
    lda l007e                                                         ; 9a6d: a5 7e       .~
    bne c9a74                                                         ; 9a6f: d0 03       ..
    jmp error_bad_expression                                          ; 9a71: 4c b0 92    L..

; &9a74 referenced 2 times by &9a6f, &9ab7
.c9a74
    lda l007e                                                         ; 9a74: a5 7e       .~
    jsr c8d47                                                         ; 9a76: 20 47 8d     G.
    ldy l007e                                                         ; 9a79: a4 7e       .~
    dey                                                               ; 9a7b: 88          .
; &9a7c referenced 1 time by &9a85
.loop_c9a7c
    lda l0000,y                                                       ; 9a7c: b9 00 00    ...
    cmp l0500,y                                                       ; 9a7f: d9 00 05    ...
    bne c9aae                                                         ; 9a82: d0 2a       .*
    dey                                                               ; 9a84: 88          .
    bpl loop_c9a7c                                                    ; 9a85: 10 f5       ..
    lda #osbyte_read_text_cursor_pos                                  ; 9a87: a9 86       ..
    jsr osbyte                                                        ; 9a89: 20 f4 ff     ..            ; Read input cursor position (Sets X=POS and Y=VPOS)
    cpx #&25 ; '%'                                                    ; 9a8c: e0 25       .%             ; X is the horizontal text position ('POS')
    bcc print_found                                                   ; 9a8e: 90 03       ..
    jsr osnewl                                                        ; 9a90: 20 e7 ff     ..            ; Write newline (characters 10 and 13)
; ***************************************************************************************
; &9a93 referenced 1 time by &9a8e
.print_found
    jsr print_inline_string                                           ; 9a93: 20 6b 8a     k.
    equb &82                                                          ; 9a96: 82          .
    equs "Found"                                                      ; 9a97: 46 6f 75... Fou
    equb &83, &3a, &ff                                                ; 9a9c: 83 3a ff    .:.

    lda l0026                                                         ; 9a9f: a5 26       .&
    jsr hex_to_digit                                                  ; 9aa1: 20 c8 88     ..
    lda l0025                                                         ; 9aa4: a5 25       .%
    jsr hex_to_digit                                                  ; 9aa6: 20 c8 88     ..
    lda #&20 ; ' '                                                    ; 9aa9: a9 20       .
    jsr oswrch                                                        ; 9aab: 20 ee ff     ..            ; Write character 32
; &9aae referenced 1 time by &9a82
.c9aae
    inc l0025                                                         ; 9aae: e6 25       .%
    bne c9ab4                                                         ; 9ab0: d0 02       ..
    inc l0026                                                         ; 9ab2: e6 26       .&
; &9ab4 referenced 1 time by &9ab0
.c9ab4
    jsr sub_c9b5f                                                     ; 9ab4: 20 5f 9b     _.
    bcc c9a74                                                         ; 9ab7: 90 bb       ..
    rts                                                               ; 9ab9: 60          `

; ***************************************************************************************
.print_command
    jsr skip_spaces_find_CR                                           ; 9aba: 20 08 92     ..
    bne c9ac2                                                         ; 9abd: d0 03       ..
    jmp error_missing_expression                                      ; 9abf: 4c 9b 92    L..

; &9ac2 referenced 1 time by &9abd
.c9ac2
    jsr c9070                                                         ; 9ac2: 20 70 90     p.
    lda l0074                                                         ; 9ac5: a5 74       .t
    jsr hex_to_digit                                                  ; 9ac7: 20 c8 88     ..
    lda l0073                                                         ; 9aca: a5 73       .s
    jmp hex_to_digit                                                  ; 9acc: 4c c8 88    L..

; ***************************************************************************************
.file_command
    sty l001f                                                         ; 9acf: 84 1f       ..
    jsr sub_m9636                                                     ; 9ad1: 20 36 96     6.
    lda #0                                                            ; 9ad4: a9 00       ..
    sta l001e                                                         ; 9ad6: 85 1e       ..
    jsr skip_spaces_find_CR                                           ; 9ad8: 20 08 92     ..
    beq c9ae2                                                         ; 9adb: f0 05       ..
    jsr c9070                                                         ; 9add: 20 70 90     p.
    dec l001e                                                         ; 9ae0: c6 1e       ..
; &9ae2 referenced 1 time by &9adb
.c9ae2
    jsr sub_c9b71                                                     ; 9ae2: 20 71 9b     q.
    bcs c9af4                                                         ; 9ae5: b0 0d       ..
    brk                                                               ; 9ae7: 00          .

    equb 0                                                            ; 9ae8: 00          .
    equs "Bad system"                                                 ; 9ae9: 42 61 64... Bad
    equb 0                                                            ; 9af3: 00          .

; &9af4 referenced 1 time by &9ae5
.c9af4
    ldy l001f                                                         ; 9af4: a4 1f       ..
    jsr sub_m9636                                                     ; 9af6: 20 36 96     6.
    lda l0086                                                         ; 9af9: a5 86       ..
    beq c9b04                                                         ; 9afb: f0 07       ..
    lda #osfind_close                                                 ; 9afd: a9 00       ..
    ldy l0085                                                         ; 9aff: a4 85       ..
    jsr osfind                                                        ; 9b01: 20 ce ff     ..            ; Close one or all files
; &9b04 referenced 1 time by &9afb
.c9b04
    lda #6                                                            ; 9b04: a9 06       ..
    sta l0001                                                         ; 9b06: 85 01       ..
    ldy #>(l0000)                                                     ; 9b08: a0 00       ..
    sty l0000                                                         ; 9b0a: 84 00       ..
    ldx #<(l0000)                                                     ; 9b0c: a2 00       ..
    lda #osfile_read_catalogue_info                                   ; 9b0e: a9 05       ..
    jsr osfile                                                        ; 9b10: 20 dd ff     ..            ; Read catalogue information (A=5)
    ldy l0003                                                         ; 9b13: a4 03       ..
    ldx l0002                                                         ; 9b15: a6 02       ..
    lda l001e                                                         ; 9b17: a5 1e       ..
    beq c9b1f                                                         ; 9b19: f0 04       ..
    ldy l0074                                                         ; 9b1b: a4 74       .t
    ldx l0073                                                         ; 9b1d: a6 73       .s
; &9b1f referenced 1 time by &9b19
.c9b1f
    sty l0082                                                         ; 9b1f: 84 82       ..
    stx l0081                                                         ; 9b21: 86 81       ..
    txa                                                               ; 9b23: 8a          .
    clc                                                               ; 9b24: 18          .
    adc l000a                                                         ; 9b25: 65 0a       e.
    sta l0083                                                         ; 9b27: 85 83       ..
    lda l000b                                                         ; 9b29: a5 0b       ..
    adc l0082                                                         ; 9b2b: 65 82       e.
    sta l0084                                                         ; 9b2d: 85 84       ..
    ldx #<(l0600)                                                     ; 9b2f: a2 00       ..
    ldy #>(l0600)                                                     ; 9b31: a0 06       ..
    lda #osfind_open_random_access                                    ; 9b33: a9 c0       ..
    jsr osfind                                                        ; 9b35: 20 ce ff     ..            ; Open file for random access (A=192)
    tax                                                               ; 9b38: aa          .              ; A=file handle (or zero on failure)
    beq c9b42                                                         ; 9b39: f0 07       ..
    sta l0085                                                         ; 9b3b: 85 85       ..
    lda #&ff                                                          ; 9b3d: a9 ff       ..
    sta l0086                                                         ; 9b3f: 85 86       ..
; &9b41 referenced 1 time by &9b50
.return_21
    rts                                                               ; 9b41: 60          `

; &9b42 referenced 1 time by &9b39
.c9b42
    brk                                                               ; 9b42: 00          .

    equb 0                                                            ; 9b43: 00          .
    equs "Not found"                                                  ; 9b44: 4e 6f 74... Not
    equb 0                                                            ; 9b4d: 00          .

; ***************************************************************************************
.close_command
    lda l0086                                                         ; 9b4e: a5 86       ..
    bpl return_21                                                     ; 9b50: 10 ef       ..
    ldy l0085                                                         ; 9b52: a4 85       ..
; &9b54 referenced 1 time by &9b5d
.loop_c9b54
    lda #osfind_close                                                 ; 9b54: a9 00       ..
    sta l0086                                                         ; 9b56: 85 86       ..
    jmp osfind                                                        ; 9b58: 4c ce ff    L..            ; Close one or all files

; ***************************************************************************************
.sclose_command
    ldy #0                                                            ; 9b5b: a0 00       ..
    beq loop_c9b54                                                    ; 9b5d: f0 f5       ..             ; ALWAYS branch

; &9b5f referenced 1 time by &9ab4
.sub_c9b5f
    sec                                                               ; 9b5f: 38          8
    bit l00ff                                                         ; 9b60: 24 ff       $.
    bmi return_22                                                     ; 9b62: 30 0c       0.
    lda l0026                                                         ; 9b64: a5 26       .&
    cmp l0028                                                         ; 9b66: c5 28       .(
    bcc return_22                                                     ; 9b68: 90 06       ..
    bne return_22                                                     ; 9b6a: d0 04       ..
    lda l0025                                                         ; 9b6c: a5 25       .%
    cmp l0027                                                         ; 9b6e: c5 27       .'
; &9b70 referenced 3 times by &9b62, &9b68, &9b6a
.return_22
    rts                                                               ; 9b70: 60          `

; &9b71 referenced 2 times by &9ae2, &9b7a
.sub_c9b71
    lda #0                                                            ; 9b71: a9 00       ..
    tay                                                               ; 9b73: a8          .              ; Y=&00
    jsr osargs                                                        ; 9b74: 20 da ff     ..            ; Get filing system number (A=0, Y=0)
    ; A is the filing system number:
    ;     A=0, no filing system selected
    ;     A=1, 1200 baud CFS
    ;     A=2, 300 baud CFS
    ;     A=3, ROM filing system
    ;     A=4, Disc filing system
    ;     A=5, Network filing system
    ;     A=6, Teletext filing system
    ;     A=7, IEEE filing system
    ;     A=8, ADFS
    ;     A=9, Host filing system
    ;     A=10, Videodisc filing system
    cmp #3                                                            ; 9b77: c9 03       ..             ; A=filing system number
; &9b79 referenced 2 times by &9b7d, &9b89
.return_23
    rts                                                               ; 9b79: 60          `

; &9b7a referenced 2 times by &96c4, &9750
.sub_c9b7a
    jsr sub_c9b71                                                     ; 9b7a: 20 71 9b     q.
    bcc return_23                                                     ; 9b7d: 90 fa       ..
    ldx #<(l0600)                                                     ; 9b7f: a2 00       ..
    ldy #>(l0600)                                                     ; 9b81: a0 06       ..
    lda #osfind_open_input                                            ; 9b83: a9 40       .@
    jsr osfind                                                        ; 9b85: 20 ce ff     ..            ; Open file for input (A=64)
    tay                                                               ; 9b88: a8          .              ; A=file handle (or zero on failure)
    beq return_23                                                     ; 9b89: f0 ee       ..
    jsr sub_c978f                                                     ; 9b8b: 20 8f 97     ..
.print_file_exists
    jsr print_inline_string                                           ; 9b8e: 20 6b 8a     k.
    equs "File exists"                                                ; 9b91: 46 69 6c... Fil
    equb &ff                                                          ; 9b9c: ff          .

    jmp ask_user_to_replace                                           ; 9b9d: 4c 09 90    L..

; ***************************************************************************************
.sub_m9ba0
    lda #3                                                            ; 9ba0: a9 03       ..
    jsr oswrch                                                        ; 9ba2: 20 ee ff     ..            ; Write character 3
    lda #osbyte_read_text_cursor_pos                                  ; 9ba5: a9 86       ..
    jsr osbyte                                                        ; 9ba7: 20 f4 ff     ..            ; Read input cursor position (Sets X=POS and Y=VPOS)
    txa                                                               ; 9baa: 8a          .              ; X is the horizontal text position ('POS')
    beq c9bb0                                                         ; 9bab: f0 03       ..
    jsr osnewl                                                        ; 9bad: 20 e7 ff     ..            ; Write newline (characters 10 and 13)
; &9bb0 referenced 1 time by &9bab
.c9bb0
    lda #&86                                                          ; 9bb0: a9 86       ..
    ldy #1                                                            ; 9bb2: a0 01       ..
; &9bb4 referenced 1 time by &9bbc
.loop_c9bb4
    jsr oswrch                                                        ; 9bb4: 20 ee ff     ..            ; Write character 134
    lda (l00fd),y                                                     ; 9bb7: b1 fd       ..
    beq c9bbe                                                         ; 9bb9: f0 03       ..
    iny                                                               ; 9bbb: c8          .
    bne loop_c9bb4                                                    ; 9bbc: d0 f6       ..
; &9bbe referenced 1 time by &9bb9
.c9bbe
    jmp refresh_screen_print_command_prompt                           ; 9bbe: 4c 4d 9c    LM.

; ***************************************************************************************
; &9bc1 referenced 2 times by &9bd3, &9c55
.install_new_brkv
    lda #&a0                                                          ; 9bc1: a9 a0       ..
    sta brkv                                                          ; 9bc3: 8d 02 02    ...
    lda #&9b                                                          ; 9bc6: a9 9b       ..
    sta brkv+1                                                        ; 9bc8: 8d 03 02    ...
    ldy #0                                                            ; 9bcb: a0 00       ..
    cli                                                               ; 9bcd: 58          X
; &9bce referenced 1 time by &9bd1
.return_24
    rts                                                               ; 9bce: 60          `

; &9bcf referenced 1 time by &8000
.language_handler
    cmp #1                                                            ; 9bcf: c9 01       ..
    bne return_24                                                     ; 9bd1: d0 fb       ..
    jsr install_new_brkv                                              ; 9bd3: 20 c1 9b     ..
    sty l003f                                                         ; 9bd6: 84 3f       .?
    sty l0086                                                         ; 9bd8: 84 86       ..
    sty tube_flag                                                     ; 9bda: 84 6b       .k
    sty ext_flag                                                      ; 9bdc: 84 8e       ..
    lda #osbyte_read_oshwm                                            ; 9bde: a9 83       ..
    jsr osbyte                                                        ; 9be0: 20 f4 ff     ..            ; Read top of operating system RAM address (OSHWM)
    stx himem                                                         ; 9be3: 86 89       ..             ; X and Y contain the address of OSHWM (low, high)
    sty himem+1                                                       ; 9be5: 84 8a       ..
; &9be7 referenced 1 time by &9bec
.loop_c9be7
    lda l8055                                                         ; 9be7: ad 55 80    .U.
    cmp #&0f                                                          ; 9bea: c9 0f       ..
    bne loop_c9be7                                                    ; 9bec: d0 f9       ..
    ldy #0                                                            ; 9bee: a0 00       ..
    lda (himem),y                                                     ; 9bf0: b1 89       ..
    sta l008c                                                         ; 9bf2: 85 8c       ..
    tya                                                               ; 9bf4: 98          .              ; A=&00
    sta (himem),y                                                     ; 9bf5: 91 89       ..
    lda #&bb                                                          ; 9bf7: a9 bb       ..
    jsr sub_c8f49                                                     ; 9bf9: 20 49 8f     I.
    stx l0055                                                         ; 9bfc: 86 55       .U
; &9bfe referenced 1 time by &9e7a
.c9bfe
    jsr print_inline_string                                           ; 9bfe: 20 6b 8a     k.
; screen mode 7
    equb &16, 7, &1f                                                  ; 9c01: 16 07 1f    ...
; move cursor 10,0.  Cyan teletext colour
    equb &0a, 0, &86, &ff                                             ; 9c04: 0a 00 86... ...

    jsr print_rom_title                                               ; 9c08: 20 84 80     ..
    jsr print_inline_string                                           ; 9c0b: 20 6b 8a     k.
    equb &1f, 0, 1, &83                                               ; 9c0e: 1f 00 01... ...
; move cursor 0,1.  Yellow teletext colour
    equs "Rom  Mem left "                                             ; 9c12: 52 6f 6d... Rom
    equb &83                                                          ; 9c20: 83          .
    equs "Start  End"                                                 ; 9c21: 53 74 61... Sta
    equb &1c, 0, &18, &27, 4, &ff                                     ; 9c2b: 1c 00 18... ...
; define text window, ->0, -v 24, <- 39, -^ 4

    lda #&e1                                                          ; 9c31: a9 e1       ..
    ldx #&80                                                          ; 9c33: a2 80       ..
    jsr set_y_zero_call_osbyte                                        ; 9c35: 20 43 8f     C.
    lda #&e2                                                          ; 9c38: a9 e2       ..
    ldx #&90                                                          ; 9c3a: a2 90       ..
    jsr set_y_zero_call_osbyte                                        ; 9c3c: 20 43 8f     C.
    lda #&e3                                                          ; 9c3f: a9 e3       ..
    ldx #&a0                                                          ; 9c41: a2 a0       ..
    jsr set_y_zero_call_osbyte                                        ; 9c43: 20 43 8f     C.
    lda #&e4                                                          ; 9c46: a9 e4       ..
    ldx #1                                                            ; 9c48: a2 01       ..
    jsr set_y_zero_call_osbyte                                        ; 9c4a: 20 43 8f     C.
; ***************************************************************************************
; &9c4d referenced 6 times by &8091, &9bbe, &9d02, &9d86, &9de2, &9e26
.refresh_screen_print_command_prompt
    ldx #&ff                                                          ; 9c4d: a2 ff       ..
    txs                                                               ; 9c4f: 9a          .
    lda #osbyte_acknowledge_escape                                    ; 9c50: a9 7e       .~
    jsr osbyte                                                        ; 9c52: 20 f4 ff     ..            ; Clear escape condition and perform escape effects
    jsr install_new_brkv                                              ; 9c55: 20 c1 9b     ..
    jsr check_text_window                                             ; 9c58: 20 4b 9e     K.
    lda #osbyte_read_text_cursor_pos                                  ; 9c5b: a9 86       ..
    jsr osbyte                                                        ; 9c5d: 20 f4 ff     ..            ; Read input cursor position (Sets X=POS and Y=VPOS)
    tya                                                               ; 9c60: 98          .              ; Y is the vertical text position ('VPOS')
    pha                                                               ; 9c61: 48          H
    txa                                                               ; 9c62: 8a          .              ; X is the horizontal text position ('POS')
    pha                                                               ; 9c63: 48          H
    jsr get_variable                                                  ; 9c64: 20 34 90     4.
    ldy #0                                                            ; 9c67: a0 00       ..
    sty l003f                                                         ; 9c69: 84 3f       .?
    tya                                                               ; 9c6b: 98          .              ; A=&00
    sta (l003c),y                                                     ; 9c6c: 91 3c       .<
    jsr print_inline_string                                           ; 9c6e: 20 6b 8a     k.
    equb 3, &1a, &1f, 2, 2, &ff                                       ; 9c71: 03 1a 1f... ...
; turn off output to printer, restore text window, turn on output to printer

    lda l0055                                                         ; 9c77: a5 55       .U
    jsr convert_and_print_decimal                                     ; 9c79: 20 d3 88     ..
    jsr print_inline_string                                           ; 9c7c: 20 6b 8a     k.
    equb &1f, 7, 2, &ff                                               ; 9c7f: 1f 07 02... ...
; move text cursor to 7,2

    jsr get_variable                                                  ; 9c83: 20 34 90     4.
    lda #osbyte_read_himem                                            ; 9c86: a9 84       ..
    jsr osbyte                                                        ; 9c88: 20 f4 ff     ..            ; Read top of user memory (HIMEM)
    sty l003e                                                         ; 9c8b: 84 3e       .>             ; X and Y contain the address of HIMEM (low, high)
    txa                                                               ; 9c8d: 8a          .
    sec                                                               ; 9c8e: 38          8
    sbc l003c                                                         ; 9c8f: e5 3c       .<
    pha                                                               ; 9c91: 48          H
    lda l003e                                                         ; 9c92: a5 3e       .>
    sbc l003d                                                         ; 9c94: e5 3d       .=
    jsr hex_to_digit                                                  ; 9c96: 20 c8 88     ..
    pla                                                               ; 9c99: 68          h
    jsr hex_to_digit                                                  ; 9c9a: 20 c8 88     ..
    jsr print_inline_string                                           ; 9c9d: 20 6b 8a     k.
    equb &1f, &10, 2, &ff                                             ; 9ca0: 1f 10 02... ...
; move cursor 16,2

    lda himem+1                                                       ; 9ca4: a5 8a       ..
    jsr hex_to_digit                                                  ; 9ca6: 20 c8 88     ..
    lda himem                                                         ; 9ca9: a5 89       ..
    jsr hex_to_digit                                                  ; 9cab: 20 c8 88     ..
    jsr print_inline_string                                           ; 9cae: 20 6b 8a     k.
    equb &1f, &17, 2, &ff                                             ; 9cb1: 1f 17 02... ...
; move cursor 23,2

    lda l003d                                                         ; 9cb5: a5 3d       .=
    jsr hex_to_digit                                                  ; 9cb7: 20 c8 88     ..
    lda l003c                                                         ; 9cba: a5 3c       .<
    jsr hex_to_digit                                                  ; 9cbc: 20 c8 88     ..
    jsr print_inline_string                                           ; 9cbf: 20 6b 8a     k.
    equb &1c, 0, &18, &27, 4, &1f, &ff                                ; 9cc2: 1c 00 18... ...
; define text window ->0, -v 24, <-39, -^4, move cursor

    pla                                                               ; 9cc9: 68          h
; get x and y from stack
    jsr oswrch                                                        ; 9cca: 20 ee ff     ..            ; Write character
    pla                                                               ; 9ccd: 68          h
    jsr oswrch                                                        ; 9cce: 20 ee ff     ..            ; Write character
    jsr sub_c9e9a                                                     ; 9cd1: 20 9a 9e     ..
; &9cd4 referenced 1 time by &9ce8
.loop_c9cd4
    jsr print_inline_string                                           ; 9cd4: 20 6b 8a     k.
    equb &0f, &0a, &0d                                                ; 9cd7: 0f 0a 0d    ...
; page mode off, line down, carrage return
    equb &3d, &3e, &ff                                                ; 9cda: 3d 3e ff    =>.
; => prompt

; &9cdd referenced 6 times by &9cef, &9cf3, &9d27, &9d2d, &9d65, &9e97
.c9cdd
    jsr osrdch                                                        ; 9cdd: 20 e0 ff     ..            ; Read a character from the current input stream
    bcs escape_was_pressed                                            ; 9ce0: b0 20       .
    ora #0                                                            ; 9ce2: 09 00       ..
    bmi c9d2b                                                         ; 9ce4: 30 45       0E
    cmp #&0d                                                          ; 9ce6: c9 0d       ..
    beq loop_c9cd4                                                    ; 9ce8: f0 ea       ..
    jsr sub_c9e7d                                                     ; 9cea: 20 7d 9e     }.
    cmp #&20 ; ' '                                                    ; 9ced: c9 20       .
    bcc c9cdd                                                         ; 9cef: 90 ec       ..
    cmp #&7f                                                          ; 9cf1: c9 7f       ..
    beq c9cdd                                                         ; 9cf3: f0 e8       ..
    ldx #0                                                            ; 9cf5: a2 00       ..
; &9cf7 referenced 1 time by &9d20
.c9cf7
    sta l0700,x                                                       ; 9cf7: 9d 00 07    ...
    jsr oswrch                                                        ; 9cfa: 20 ee ff     ..            ; Write character
; &9cfd referenced 4 times by &9d0b, &9d12, &9d1c, &9d29
.c9cfd
    jsr osrdch                                                        ; 9cfd: 20 e0 ff     ..            ; Read a character from the current input stream
    bcc c9d05                                                         ; 9d00: 90 03       ..
; ***************************************************************************************
; &9d02 referenced 1 time by &9ce0
.escape_was_pressed
    jmp refresh_screen_print_command_prompt                           ; 9d02: 4c 4d 9c    LM.

; &9d05 referenced 1 time by &9d00
.c9d05
    cmp #&0d                                                          ; 9d05: c9 0d       ..
    beq check_for_star_command                                        ; 9d07: f0 5f       ._
    ora #0                                                            ; 9d09: 09 00       ..
    bmi c9cfd                                                         ; 9d0b: 30 f0       0.
    jsr sub_c9e7d                                                     ; 9d0d: 20 7d 9e     }.
    cmp #&20 ; ' '                                                    ; 9d10: c9 20       .
    bcc c9cfd                                                         ; 9d12: 90 e9       ..
    inx                                                               ; 9d14: e8          .
    bne c9d1e                                                         ; 9d15: d0 07       ..
    cmp #&7f                                                          ; 9d17: c9 7f       ..
    beq c9d22                                                         ; 9d19: f0 07       ..
    dex                                                               ; 9d1b: ca          .
    bne c9cfd                                                         ; 9d1c: d0 df       ..
; &9d1e referenced 1 time by &9d15
.c9d1e
    cmp #&7f                                                          ; 9d1e: c9 7f       ..
    bne c9cf7                                                         ; 9d20: d0 d5       ..
; &9d22 referenced 1 time by &9d19
.c9d22
    jsr oswrch                                                        ; 9d22: 20 ee ff     ..            ; Write character
    dex                                                               ; 9d25: ca          .
    dex                                                               ; 9d26: ca          .
    bmi c9cdd                                                         ; 9d27: 30 b4       0.
    bpl c9cfd                                                         ; 9d29: 10 d2       ..             ; ALWAYS branch

; &9d2b referenced 1 time by &9ce4
.c9d2b
    cmp #&aa                                                          ; 9d2b: c9 aa       ..
    bcs c9cdd                                                         ; 9d2d: b0 ae       ..
    pha                                                               ; 9d2f: 48          H
    and #&0f                                                          ; 9d30: 29 0f       ).
    cmp #&0a                                                          ; 9d32: c9 0a       ..
    bcs c9d64                                                         ; 9d34: b0 2e       ..
    asl a                                                             ; 9d36: 0a          .
    tay                                                               ; 9d37: a8          .
    lda l0057,y                                                       ; 9d38: b9 57 00    .W.
    sta l0025                                                         ; 9d3b: 85 25       .%
    lda l0058,y                                                       ; 9d3d: b9 58 00    .X.
    sta l0026                                                         ; 9d40: 85 26       .&
    lda #&ff                                                          ; 9d42: a9 ff       ..
    sta l0056                                                         ; 9d44: 85 56       .V
    jsr print_inline_string                                           ; 9d46: 20 6b 8a     k.
; overlapping: asl a                                                  ; 9d49: 0a          .
    equb &0a, &0d, &0e, &ff                                           ; 9d49: 0a 0d 0e... ...
; down a line, carrage return, paged mode on
; overlapping: ora lff0e                                              ; 9d4a: 0d 0e ff    ...

    pla                                                               ; 9d4d: 68          h
    and #&30 ; '0'                                                    ; 9d4e: 29 30       )0
    lsr a                                                             ; 9d50: 4a          J
    lsr a                                                             ; 9d51: 4a          J
    lsr a                                                             ; 9d52: 4a          J
    tay                                                               ; 9d53: a8          .
    lda extended_table_1,y                                            ; 9d54: b9 5e 9d    .^.
    sta l0001                                                         ; 9d57: 85 01       ..
    lda table_1,y                                                     ; 9d59: b9 5f 9d    ._.
    bne c9dc6                                                         ; 9d5c: d0 68       .h
; &9d5e referenced 1 time by &9d54
.extended_table_1
    equb &17                                                          ; 9d5e: 17          .
; &9d5f referenced 1 time by &9d59
.table_1
    equb &92, &47, &8e, &d3, &8e                                      ; 9d5f: 92 47 8e... .G.

; &9d64 referenced 1 time by &9d34
.c9d64
    pla                                                               ; 9d64: 68          h
    jmp c9cdd                                                         ; 9d65: 4c dd 9c    L..

; ***************************************************************************************
; &9d68 referenced 1 time by &9d07
.check_for_star_command
    sta l0701,x                                                       ; 9d68: 9d 01 07    ...
    ldy #0                                                            ; 9d6b: a0 00       ..
    sty l0056                                                         ; 9d6d: 84 56       .V
    sty l0075                                                         ; 9d6f: 84 75       .u
    sty l0025                                                         ; 9d71: 84 25       .%
    sty l0026                                                         ; 9d73: 84 26       .&
    jsr skip_spaces_find_CR                                           ; 9d75: 20 08 92     ..
    cmp #&2a ; '*'                                                    ; 9d78: c9 2a       .*
    bne not_a_star_command                                            ; 9d7a: d0 0d       ..
    tya                                                               ; 9d7c: 98          .
    tax                                                               ; 9d7d: aa          .
    ldy #7                                                            ; 9d7e: a0 07       ..
    jsr osnewl                                                        ; 9d80: 20 e7 ff     ..            ; Write newline (characters 10 and 13)
    jsr oscli                                                         ; 9d83: 20 f7 ff     ..
    jmp refresh_screen_print_command_prompt                           ; 9d86: 4c 4d 9c    LM.

; ***************************************************************************************
; &9d89 referenced 1 time by &9d7a
.not_a_star_command
    tya                                                               ; 9d89: 98          .
    pha                                                               ; 9d8a: 48          H
    sta l001f                                                         ; 9d8b: 85 1f       ..
    ldx #2                                                            ; 9d8d: a2 02       ..
    stx l001e                                                         ; 9d8f: 86 1e       ..
; &9d91 referenced 2 times by &9dfc, &9e05
.c9d91
    ldx #0                                                            ; 9d91: a2 00       ..
; &9d93 referenced 1 time by &9dba
.c9d93
    pla                                                               ; 9d93: 68          h
    pha                                                               ; 9d94: 48          H
    tay                                                               ; 9d95: a8          .
; &9d96 referenced 1 time by &9da8
.loop_c9d96
    lda command_list,x                                                ; 9d96: bd 3b 9f    .;.
    bmi c9de5                                                         ; 9d99: 30 4a       0J
    lda l0700,y                                                       ; 9d9b: b9 00 07    ...
    jsr convert_to_uppercase_if_required                              ; 9d9e: 20 38 8f     8.
    cmp command_list,x                                                ; 9da1: dd 3b 9f    .;.
    bne c9daa                                                         ; 9da4: d0 04       ..
    iny                                                               ; 9da6: c8          .
    inx                                                               ; 9da7: e8          .
    bne loop_c9d96                                                    ; 9da8: d0 ec       ..
; &9daa referenced 1 time by &9da4
.c9daa
    lda command_list,x                                                ; 9daa: bd 3b 9f    .;.
    cmp #&20 ; ' '                                                    ; 9dad: c9 20       .
    bcc c9dbc                                                         ; 9daf: 90 0b       ..
; &9db1 referenced 1 time by &9db7
.loop_c9db1
    inx                                                               ; 9db1: e8          .
    lda command_list,x                                                ; 9db2: bd 3b 9f    .;.
    cmp #&1f                                                          ; 9db5: c9 1f       ..
    bcs loop_c9db1                                                    ; 9db7: b0 f8       ..
    inx                                                               ; 9db9: e8          .
    bne c9d93                                                         ; 9dba: d0 d7       ..
; &9dbc referenced 1 time by &9daf
.c9dbc
    asl a                                                             ; 9dbc: 0a          .
    tax                                                               ; 9dbd: aa          .
    lda jump_table,x                                                  ; 9dbe: bd c9 9f    ...
    sta l0001                                                         ; 9dc1: 85 01       ..
    lda jump_table+1,x                                                ; 9dc3: bd ca 9f    ...
; &9dc6 referenced 1 time by &9d5c
.c9dc6
    sta l0002                                                         ; 9dc6: 85 02       ..
    lda #&4c ; 'L'                                                    ; 9dc8: a9 4c       .L
    sta l0000                                                         ; 9dca: 85 00       ..
    jsr osnewl                                                        ; 9dcc: 20 e7 ff     ..            ; Write newline (characters 10 and 13)
    tya                                                               ; 9dcf: 98          .
    pha                                                               ; 9dd0: 48          H
    jsr sub_c9e9a                                                     ; 9dd1: 20 9a 9e     ..
    pla                                                               ; 9dd4: 68          h
    tay                                                               ; 9dd5: a8          .
    lda l003f                                                         ; 9dd6: a5 3f       .?
    beq c9ddf                                                         ; 9dd8: f0 05       ..
    lda #2                                                            ; 9dda: a9 02       ..
    jsr oswrch                                                        ; 9ddc: 20 ee ff     ..            ; Write character 2
; &9ddf referenced 1 time by &9dd8
.c9ddf
    jsr l0000                                                         ; 9ddf: 20 00 00     ..
    jmp refresh_screen_print_command_prompt                           ; 9de2: 4c 4d 9c    LM.

; &9de5 referenced 1 time by &9d99
.c9de5
    pla                                                               ; 9de5: 68          h
    tay                                                               ; 9de6: a8          .
    iny                                                               ; 9de7: c8          .
    tya                                                               ; 9de8: 98          .
    pha                                                               ; 9de9: 48          H
    dec l001e                                                         ; 9dea: c6 1e       ..
    bmi c9e0f                                                         ; 9dec: 30 21       0!
    lda l06ff,y                                                       ; 9dee: b9 ff 06    ...
    cmp #&53 ; 'S'                                                    ; 9df1: c9 53       .S
    bne c9dff                                                         ; 9df3: d0 0a       ..
    lda #&ea                                                          ; 9df5: a9 ea       ..
    jsr sub_c8f49                                                     ; 9df7: 20 49 8f     I.
; &9dfa referenced 1 time by &9e0d
.loop_c9dfa
    stx tube_flag                                                     ; 9dfa: 86 6b       .k
    jmp c9d91                                                         ; 9dfc: 4c 91 9d    L..

; &9dff referenced 1 time by &9df3
.c9dff
    cmp #&50 ; 'P'                                                    ; 9dff: c9 50       .P
    bne c9e07                                                         ; 9e01: d0 04       ..
    dec l003f                                                         ; 9e03: c6 3f       .?
    bne c9d91                                                         ; 9e05: d0 8a       ..
; &9e07 referenced 1 time by &9e01
.c9e07
    cmp #&42 ; 'B'                                                    ; 9e07: c9 42       .B
    bne c9e0f                                                         ; 9e09: d0 04       ..
    ldx #0                                                            ; 9e0b: a2 00       ..
    beq loop_c9dfa                                                    ; 9e0d: f0 eb       ..             ; ALWAYS branch

; &9e0f referenced 2 times by &9dec, &9e09
.c9e0f
    pla                                                               ; 9e0f: 68          h
    ldy l001f                                                         ; 9e10: a4 1f       ..
; &9e12 referenced 1 time by &9e1c
.loop_c9e12
    lda l0700,y                                                       ; 9e12: b9 00 07    ...
    iny                                                               ; 9e15: c8          .
    cmp #&20 ; ' '                                                    ; 9e16: c9 20       .
    bcc c9e29                                                         ; 9e18: 90 0f       ..
    cmp #&3d ; '='                                                    ; 9e1a: c9 3d       .=
    bne loop_c9e12                                                    ; 9e1c: d0 f4       ..
    jsr osnewl                                                        ; 9e1e: 20 e7 ff     ..            ; Write newline (characters 10 and 13)
    ldy l001f                                                         ; 9e21: a4 1f       ..
    jsr sub_c9240                                                     ; 9e23: 20 40 92     @.
; &9e26 referenced 2 times by &9e37, &9e3b
.c9e26
    jmp refresh_screen_print_command_prompt                           ; 9e26: 4c 4d 9c    LM.

; &9e29 referenced 1 time by &9e18
.c9e29
    ldy l001f                                                         ; 9e29: a4 1f       ..
    lda l0701,y                                                       ; 9e2b: b9 01 07    ...
    cmp #&20 ; ' '                                                    ; 9e2e: c9 20       .
    bcs error_bad_command                                             ; 9e30: b0 0b       ..
    lda l0700,y                                                       ; 9e32: b9 00 07    ...
    cmp #&53 ; 'S'                                                    ; 9e35: c9 53       .S
    beq c9e26                                                         ; 9e37: f0 ed       ..
    cmp #&42 ; 'B'                                                    ; 9e39: c9 42       .B
    beq c9e26                                                         ; 9e3b: f0 e9       ..
; &9e3d referenced 2 times by &9e30, &9f2f
.error_bad_command
    brk                                                               ; 9e3d: 00          .

    equb 0                                                            ; 9e3e: 00          .
    equs "Bad command"                                                ; 9e3f: 42 61 64... Bad
    equb 0                                                            ; 9e4a: 00          .

; ***************************************************************************************
; &9e4b referenced 1 time by &9c58
.check_text_window
    lda #osbyte_read_vdu_variable                                     ; 9e4b: a9 a0       ..
    ldx #8                                                            ; 9e4d: a2 08       ..
    jsr osbyte                                                        ; 9e4f: 20 f4 ff     ..            ; Read the text window left position (VDU variable X=8)
    cpy #&18                                                          ; 9e52: c0 18       ..             ; Y is the text window bottom position
    bne c9e63                                                         ; 9e54: d0 0d       ..
    ldx #&0a                                                          ; 9e56: a2 0a       ..
    jsr osbyte                                                        ; 9e58: 20 f4 ff     ..
    cpx #&27 ; '''                                                    ; 9e5b: e0 27       .'
    bne c9e63                                                         ; 9e5d: d0 04       ..
    cpy #4                                                            ; 9e5f: c0 04       ..
    beq return_25                                                     ; 9e61: f0 26       .&
; &9e63 referenced 2 times by &9e54, &9e5d
.c9e63
    jsr print_inline_string                                           ; 9e63: 20 6b 8a     k.
    equb &0a, &0d                                                     ; 9e66: 0a 0d       ..
    equs "Press a key"                                                ; 9e68: 50 72 65... Pre
    equb &ff                                                          ; 9e73: ff          .

    jsr flush_all_buffers                                             ; 9e74: 20 47 8f     G.
    jsr osrdch                                                        ; 9e77: 20 e0 ff     ..            ; Read a character from the current input stream
    jmp c9bfe                                                         ; 9e7a: 4c fe 9b    L..

; &9e7d referenced 2 times by &9cea, &9d0d
.sub_c9e7d
    cmp #&0e                                                          ; 9e7d: c9 0e       ..
    beq c9ed2                                                         ; 9e7f: f0 51       .Q
    cmp #&0f                                                          ; 9e81: c9 0f       ..
    beq c9ed2                                                         ; 9e83: f0 4d       .M
    cmp #&15                                                          ; 9e85: c9 15       ..
    beq c9e8a                                                         ; 9e87: f0 01       ..
; &9e89 referenced 2 times by &9e61, &9e8b
.return_25
    rts                                                               ; 9e89: 60          `

; &9e8a referenced 1 time by &9e87
.c9e8a
    txa                                                               ; 9e8a: 8a          .
    beq return_25                                                     ; 9e8b: f0 fc       ..
    lda #&7f                                                          ; 9e8d: a9 7f       ..
; &9e8f referenced 1 time by &9e93
.loop_c9e8f
    jsr oswrch                                                        ; 9e8f: 20 ee ff     ..            ; Write character 127
    dex                                                               ; 9e92: ca          .
    bpl loop_c9e8f                                                    ; 9e93: 10 fa       ..
    pla                                                               ; 9e95: 68          h
    pla                                                               ; 9e96: 68          h
    jmp c9cdd                                                         ; 9e97: 4c dd 9c    L..

; &9e9a referenced 2 times by &9cd1, &9dd1
.sub_c9e9a
    lda #osbyte_read_text_cursor_pos                                  ; 9e9a: a9 86       ..
    jsr osbyte                                                        ; 9e9c: 20 f4 ff     ..            ; Read input cursor position (Sets X=POS and Y=VPOS)
    tya                                                               ; 9e9f: 98          .              ; Y is the vertical text position ('VPOS')
    pha                                                               ; 9ea0: 48          H
    txa                                                               ; 9ea1: 8a          .              ; X is the horizontal text position ('POS')
    pha                                                               ; 9ea2: 48          H
    jsr print_inline_string                                           ; 9ea3: 20 6b 8a     k.
    equb &1a, &1f, &1d, 2, &ff                                        ; 9ea6: 1a 1f 1d... ...
; move cursor 29,2

    lda tube_flag                                                     ; 9eab: a5 6b       .k
    bne second_processor                                              ; 9ead: d0 26       .&
.io_processor
    jsr print_inline_string                                           ; 9eaf: 20 6b 8a     k.
    equs "BBC  "                                                      ; 9eb2: 42 42 43... BBC
    equb &ff                                                          ; 9eb7: ff          .

    lda #&45 ; 'E'                                                    ; 9eb8: a9 45       .E
    bit ext_flag                                                      ; 9eba: 24 8e       $.
    bmi c9ec0                                                         ; 9ebc: 30 02       0.
    lda #&20 ; ' '                                                    ; 9ebe: a9 20       .
; &9ec0 referenced 1 time by &9ebc
.c9ec0
    jsr oswrch                                                        ; 9ec0: 20 ee ff     ..            ; Write character 32
; &9ec3 referenced 1 time by &9edf
.loop_c9ec3
    jsr print_inline_string                                           ; 9ec3: 20 6b 8a     k.
    equb &1c, 0, &18, &27, 4, &1f, &ff                                ; 9ec6: 1c 00 18... ...
; define text window, ->0, -v 24, <- 39, -^ 4, move cursor to

; pull the x and y coordinate from the stack
    pla                                                               ; 9ecd: 68          h
    jsr oswrch                                                        ; 9ece: 20 ee ff     ..            ; Write character
    pla                                                               ; 9ed1: 68          h
; &9ed2 referenced 2 times by &9e7f, &9e83
.c9ed2
    jmp oswrch                                                        ; 9ed2: 4c ee ff    L..            ; Write character

; ***************************************************************************************
; &9ed5 referenced 1 time by &9ead
.second_processor
    jsr print_inline_string                                           ; 9ed5: 20 6b 8a     k.
    equs "Second"                                                     ; 9ed8: 53 65 63... Sec
    equb &ff                                                          ; 9ede: ff          .

    jmp loop_c9ec3                                                    ; 9edf: 4c c3 9e    L..

; ***************************************************************************************
.help_command
    jsr osnewl                                                        ; 9ee2: 20 e7 ff     ..            ; Write newline (characters 10 and 13)
    ldy #0                                                            ; 9ee5: a0 00       ..
    sty l003e                                                         ; 9ee7: 84 3e       .>
    lda #&1b                                                          ; 9ee9: a9 1b       ..
    sta l001e                                                         ; 9eeb: 85 1e       ..
; &9eed referenced 2 times by &9ef8, &9f13
.c9eed
    lda command_list,y                                                ; 9eed: b9 3b 9f    .;.
    cmp #&20 ; ' '                                                    ; 9ef0: c9 20       .
    bcc c9efa                                                         ; 9ef2: 90 06       ..
    jsr oswrch                                                        ; 9ef4: 20 ee ff     ..            ; Write character
    iny                                                               ; 9ef7: c8          .
    bne c9eed                                                         ; 9ef8: d0 f3       ..
; &9efa referenced 1 time by &9ef2
.c9efa
    iny                                                               ; 9efa: c8          .
    lda l003e                                                         ; 9efb: a5 3e       .>
    equb &49, &ff                                                     ; 9efd: 49 ff       I.             ; EOR #&ff

    sta l003e                                                         ; 9eff: 85 3e       .>
    beq c9f0e                                                         ; 9f01: f0 0b       ..
    tya                                                               ; 9f03: 98          .
    pha                                                               ; 9f04: 48          H
    lda #&14                                                          ; 9f05: a9 14       ..
    jsr blank_from_x_if_required                                      ; 9f07: 20 92 8c     ..
    pla                                                               ; 9f0a: 68          h
    tay                                                               ; 9f0b: a8          .
    bne c9f11                                                         ; 9f0c: d0 03       ..
; &9f0e referenced 1 time by &9f01
.c9f0e
    jsr osnewl                                                        ; 9f0e: 20 e7 ff     ..            ; Write newline (characters 10 and 13)
; &9f11 referenced 1 time by &9f0c
.c9f11
    dec l001e                                                         ; 9f11: c6 1e       ..
    bne c9eed                                                         ; 9f13: d0 d8       ..
    jmp osnewl                                                        ; 9f15: 4c e7 ff    L..            ; Write newline (characters 10 and 13)

; ***************************************************************************************
.ext_command
    lda ext_flag                                                      ; 9f18: a5 8e       ..
    eor #&ff                                                          ; 9f1a: 49 ff       I.
    sta ext_flag                                                      ; 9f1c: 85 8e       ..
    rts                                                               ; 9f1e: 60          `

; ***************************************************************************************
.old_command
    lda l008c                                                         ; 9f1f: a5 8c       ..
    bne c9f25                                                         ; 9f21: d0 02       ..
    lda #&ff                                                          ; 9f23: a9 ff       ..
; &9f25 referenced 1 time by &9f21
.c9f25
    ldy #0                                                            ; 9f25: a0 00       ..
; &9f27 referenced 1 time by &9f39
.loop_c9f27
    sta (himem),y                                                     ; 9f27: 91 89       ..
    rts                                                               ; 9f29: 60          `

; ***************************************************************************************
.new_command
    jsr skip_spaces_find_CR                                           ; 9f2a: 20 08 92     ..
    beq c9f32                                                         ; 9f2d: f0 03       ..
    jmp error_bad_command                                             ; 9f2f: 4c 3d 9e    L=.

; &9f32 referenced 1 time by &9f2d
.c9f32
    ldy #0                                                            ; 9f32: a0 00       ..
    lda (himem),y                                                     ; 9f34: b1 89       ..
    sta l008c                                                         ; 9f36: 85 8c       ..
    tya                                                               ; 9f38: 98          .              ; A=&00
    beq loop_c9f27                                                    ; 9f39: f0 ec       ..             ; ALWAYS branch

; &9f3b referenced 5 times by &9d96, &9da1, &9daa, &9db2, &9eed
.command_list
    equs "APPEND"                                                     ; 9f3b: 41 50 50... APP
    equb &0d                                                          ; 9f41: 0d          .
    equs "LOAD"                                                       ; 9f42: 4c 4f 41... LOA
    equb &0c                                                          ; 9f46: 0c          .
    equs "CDIS"                                                       ; 9f47: 43 44 49... CDI
    equb 5                                                            ; 9f4b: 05          .
    equs "LROM"                                                       ; 9f4c: 4c 52 4f... LRO
    equb 7                                                            ; 9f50: 07          .
    equs "CLOSE"                                                      ; 9f51: 43 4c 4f... CLO
    equb &15                                                          ; 9f56: 15          .
    equs "LVAR"                                                       ; 9f57: 4c 56 41... LVA
    equb 8                                                            ; 9f5b: 08          .
    equs "DEL"                                                        ; 9f5c: 44 45 4c    DEL
    equb &0b                                                          ; 9f5f: 0b          .
    equs "MEM"                                                        ; 9f60: 4d 45 4d    MEM
    equb 3                                                            ; 9f63: 03          .
    equs "DIS"                                                        ; 9f64: 44 49 53    DIS
    equb 0                                                            ; 9f67: 00          .
    equs "NEW"                                                        ; 9f68: 4e 45 57    NEW
    equb &18                                                          ; 9f6b: 18          .
    equs "DUMP"                                                       ; 9f6c: 44 55 4d... DUM
    equb 9                                                            ; 9f70: 09          .
    equs "OLD"                                                        ; 9f71: 4f 4c 44    OLD
    equb &17                                                          ; 9f74: 17          .
    equs "EDIT"                                                       ; 9f75: 45 44 49... EDI
    equb &11                                                          ; 9f79: 11          .
    equs "PRINTM"                                                     ; 9f7a: 50 52 49... PRI
    equb 4                                                            ; 9f80: 04          .
    equs "EXT"                                                        ; 9f81: 45 58 54    EXT
    equb &1a                                                          ; 9f84: 1a          .
    equs "PRINT"                                                      ; 9f85: 50 52 49... PRI
    equb &13                                                          ; 9f8a: 13          .
    equs "FILE"                                                       ; 9f8b: 46 49 4c... FIL
    equb &14                                                          ; 9f8f: 14          .
    equs "QUIT"                                                       ; 9f90: 51 55 49... QUI
    equb &0f                                                          ; 9f94: 0f          .
    equs "FIND"                                                       ; 9f95: 46 49 4e... FIN
    equb &12                                                          ; 9f99: 12          .
    equs "ROM"                                                        ; 9f9a: 52 4f 4d    ROM
    equb 6                                                            ; 9f9d: 06          .
    equs "HELP"                                                       ; 9f9e: 48 45 4c... HEL
    equb &16                                                          ; 9fa2: 16          .
    equs "RSAVE"                                                      ; 9fa3: 52 53 41... RSA
    equb &10                                                          ; 9fa8: 10          .
    equs "HEX"                                                        ; 9fa9: 48 45 58    HEX
    equb 2                                                            ; 9fac: 02          .
    equs "SAVE"                                                       ; 9fad: 53 41 56... SAV
    equb &0e                                                          ; 9fb1: 0e          .
    equs "LET"                                                        ; 9fb2: 4c 45 54    LET
    equb 1                                                            ; 9fb5: 01          .
    equs "SCLOSE"                                                     ; 9fb6: 53 43 4c... SCL
    equb &19                                                          ; 9fbc: 19          .
    equs "LIST"                                                       ; 9fbd: 4c 49 53... LIS
    equb &0a, &44, 0                                                  ; 9fc1: 0a 44 00    .D.

; ***************************************************************************************
.sub_m9fc4
    jmp l450a                                                         ; 9fc4: 4c 0a 45    L.E

; ***************************************************************************************
.sub_m9fc7
    ora (l00ff),y                                                     ; 9fc7: 11 ff       ..
; &9fc9 referenced 1 time by &9dbe
.jump_table
    equw    dis_command,    let_command,  hex_command,   mem_command  ; 9fc9: 14 92 3d... ..=
    equw printm_command,   cdis_command,  rom_command,  lrom_command  ; 9fd1: 4e 93 12... N..
    equw   lvar_command,   dump_command, list_command,   del_command  ; 9fd9: 1d 94 04... ...
    equw   load_command, append_command, save_command,  quit_command  ; 9fe1: a7 96 b3... ...
    equw  rsave_command,   edit_command, find_command, print_command  ; 9fe9: 40 97 cb... @..
    equw   file_command,  close_command, help_command,   old_command  ; 9ff1: cf 9a 4e... ..N
    equw    new_command, sclose_command,  ext_command                 ; 9ff9: 2a 9f 5b... *.[
; &9fca referenced 1 time by &9dc3
    equb &4c                                                          ; 9fff: 4c          L
.pydis_end


save pydis_start, pydis_end

; Label references by decreasing frequency:
;     l003c:                                66
;     l0025:                                61
;     l0026:                                58
;     oswrch:                               46
;     l0073:                                38
;     print_inline_string:                  38
;     l0000:                                35
;     l0074:                                31
;     l003e:                                26
;     l0600:                                26
;     osnewl:                               25
;     skip_spaces_find_CR:                  24
;     hex_to_digit:                         22
;     l003d:                                21
;     l0071:                                19
;     l0700:                                19
;     osbyte:                               17
;     l003a:                                16
;     l003b:                                16
;     l0072:                                16
;     himem:                                14
;     himem+0:                              14
;     l0055:                                12
;     l007b:                                12
;     sub_c8a50:                            12
;     l0027:                                11
;     l0028:                                11
;     c9070:                                10
;     l0001:                                10
;     l007e:                                10
;     blank_from_x_if_required:              9
;     himem+1:                               9
;     l0050:                                 9
;     l006e:                                 9
;     l007d:                                 9
;     sub_m884b:                             9
;     error_missing_expression:              8
;     l0002:                                 8
;     l00ff:                                 8
;     set_y_zero_call_osbyte:                8
;     sub_c8a5d:                             8
;     c8753:                                 7
;     c8894:                                 7
;     l001e:                                 7
;     l003f:                                 7
;     l0054:                                 7
;     l006d:                                 7
;     sub_c8a41:                             7
;     sub_c92c1:                             7
;     c8d47:                                 6
;     c9530:                                 6
;     c9a64:                                 6
;     c9cdd:                                 6
;     ext_flag:                              6
;     get_variable:                          6
;     l0005:                                 6
;     l001f:                                 6
;     l0056:                                 6
;     l0070:                                 6
;     l0086:                                 6
;     osfind:                                6
;     osrdch:                                6
;     print_open_bracket:                    6
;     refresh_screen_print_command_prompt:   6
;     return_12:                             6
;     sub_c8d31:                             6
;     sub_c8d42:                             6
;     sub_m87bd:                             6
;     tube_flag:                             6
;     c8b49:                                 5
;     command_list:                          5
;     l0042:                                 5
;     l0044:                                 5
;     l006f:                                 5
;     l007c:                                 5
;     l0085:                                 5
;     print_close_bracket:                   5
;     return_11:                             5
;     return_6:                              5
;     sub_c875f:                             5
;     sub_c8767:                             5
;     sub_c8f49:                             5
;     sub_c9225:                             5
;     sub_m9822:                             5
;     c8b27:                                 4
;     c8d4e:                                 4
;     c9381:                                 4
;     c947f:                                 4
;     c9937:                                 4
;     c9cfd:                                 4
;     call_jmp_oswrch:                       4
;     default_to_x_pos:                      4
;     l0003:                                 4
;     l0051:                                 4
;     l0057:                                 4
;     l0058:                                 4
;     l0082:                                 4
;     l0400:                                 4
;     print_indexed_x:                       4
;     sub_c88e1:                             4
;     sub_c8ebe:                             4
;     sub_c99de:                             4
;     sub_m9636:                             4
;     ask_user_to_replace:                   3
;     c87ae:                                 3
;     c87ea:                                 3
;     c8875:                                 3
;     c8ba3:                                 3
;     c8e4f:                                 3
;     c8f5d:                                 3
;     c904d:                                 3
;     c90fb:                                 3
;     c9178:                                 3
;     convert_and_print_decimal:             3
;     enable_auto_paging_mode:               3
;     error_bad_expression:                  3
;     flush_all_buffers:                     3
;     l0010:                                 3
;     l0041:                                 3
;     l0048:                                 3
;     l0075:                                 3
;     l0079:                                 3
;     l007f:                                 3
;     l0081:                                 3
;     l008c:                                 3
;     l0500:                                 3
;     l0606:                                 3
;     no_extended_help:                      3
;     os_text_ptr:                           3
;     return_15:                             3
;     return_22:                             3
;     sub_c877c:                             3
;     sub_c8c6c:                             3
;     sub_c8d15:                             3
;     sub_c9666:                             3
;     sub_m8a0a:                             3
;     sub_m9313:                             3
;     to_x_pos:                              3
;     c8091:                                 2
;     c878d:                                 2
;     c87fe:                                 2
;     c8829:                                 2
;     c8aa8:                                 2
;     c8abf:                                 2
;     c8ac1:                                 2
;     c8ac3:                                 2
;     c8d59:                                 2
;     c8dd7:                                 2
;     c8eaf:                                 2
;     c8ed3:                                 2
;     c8f1c:                                 2
;     c8f32:                                 2
;     c8fa4:                                 2
;     c8fc6:                                 2
;     c90ad:                                 2
;     c912f:                                 2
;     c91eb:                                 2
;     c9222:                                 2
;     c927f:                                 2
;     c92f7:                                 2
;     c93cf:                                 2
;     c93fc:                                 2
;     c9558:                                 2
;     c95c4:                                 2
;     c95ce:                                 2
;     c9624:                                 2
;     c964d:                                 2
;     c9707:                                 2
;     c979e:                                 2
;     c9909:                                 2
;     c9a21:                                 2
;     c9a74:                                 2
;     c9d91:                                 2
;     c9e0f:                                 2
;     c9e26:                                 2
;     c9e63:                                 2
;     c9ed2:                                 2
;     c9eed:                                 2
;     convert_to_uppercase_if_required:      2
;     error_bad_command:                     2
;     error_bad_decimal:                     2
;     error_bad_label:                       2
;     error_bad_memory:                      2
;     error_no_such_label:                   2
;     error_os_label:                        2
;     ignore_space_find_equals_sign:         2
;     install_new_brkv:                      2
;     l0004:                                 2
;     l000a:                                 2
;     l000b:                                 2
;     l0046:                                 2
;     l0047:                                 2
;     l0080:                                 2
;     l0083:                                 2
;     l0084:                                 2
;     l0087:                                 2
;     l0110:                                 2
;     l0605:                                 2
;     l0701:                                 2
;     osargs:                                2
;     osfile:                                2
;     osword:                                2
;     print_indexed_y:                       2
;     print_rom_title:                       2
;     return_1:                              2
;     return_13:                             2
;     return_16:                             2
;     return_17:                             2
;     return_23:                             2
;     return_25:                             2
;     return_8:                              2
;     sub_c8cea:                             2
;     sub_c8f05:                             2
;     sub_c8f35:                             2
;     sub_c90e3:                             2
;     sub_c9104:                             2
;     sub_c959f:                             2
;     sub_c979c:                             2
;     sub_c9944:                             2
;     sub_c996d:                             2
;     sub_c99ba:                             2
;     sub_c99d0:                             2
;     sub_c9b71:                             2
;     sub_c9b7a:                             2
;     sub_c9e7d:                             2
;     sub_c9e9a:                             2
;     table_4:                               2
;     brkv:                                  1
;     c8069:                                 1
;     c879a:                                 1
;     c87a9:                                 1
;     c87b0:                                 1
;     c87bb:                                 1
;     c87d2:                                 1
;     c87ee:                                 1
;     c880b:                                 1
;     c880f:                                 1
;     c881d:                                 1
;     c883d:                                 1
;     c885d:                                 1
;     c8861:                                 1
;     c8869:                                 1
;     c886d:                                 1
;     c8898:                                 1
;     c889e:                                 1
;     c88b4:                                 1
;     c88b9:                                 1
;     c88c6:                                 1
;     c88dd:                                 1
;     c88fa:                                 1
;     c8908:                                 1
;     c8916:                                 1
;     c8920:                                 1
;     c892a:                                 1
;     c893a:                                 1
;     c8949:                                 1
;     c8951:                                 1
;     c8961:                                 1
;     c8971:                                 1
;     c8977:                                 1
;     c898d:                                 1
;     c899a:                                 1
;     c89a7:                                 1
;     c89b7:                                 1
;     c89d0:                                 1
;     c8a08:                                 1
;     c8a3c:                                 1
;     c8a67:                                 1
;     c8a8c:                                 1
;     c8a98:                                 1
;     c8aa2:                                 1
;     c8aeb:                                 1
;     c8af4:                                 1
;     c8b01:                                 1
;     c8b0c:                                 1
;     c8b19:                                 1
;     c8b2f:                                 1
;     c8b39:                                 1
;     c8b85:                                 1
;     c8bb1:                                 1
;     c8bb5:                                 1
;     c8bbe:                                 1
;     c8bd2:                                 1
;     c8be4:                                 1
;     c8bea:                                 1
;     c8c0d:                                 1
;     c8c1a:                                 1
;     c8c36:                                 1
;     c8c46:                                 1
;     c8c50:                                 1
;     c8cb9:                                 1
;     c8cce:                                 1
;     c8cdd:                                 1
;     c8ce1:                                 1
;     c8d20:                                 1
;     c8d2e:                                 1
;     c8d9b:                                 1
;     c8dc9:                                 1
;     c8de7:                                 1
;     c8df8:                                 1
;     c8e06:                                 1
;     c8e39:                                 1
;     c8e47:                                 1
;     c8e81:                                 1
;     c8e86:                                 1
;     c8ea9:                                 1
;     c8ed1:                                 1
;     c8ef6:                                 1
;     c8f72:                                 1
;     c8fc3:                                 1
;     c8fde:                                 1
;     c902d:                                 1
;     c9031:                                 1
;     c904a:                                 1
;     c9080:                                 1
;     c909d:                                 1
;     c90d0:                                 1
;     c90e0:                                 1
;     c9137:                                 1
;     c9140:                                 1
;     c9142:                                 1
;     c9149:                                 1
;     c916e:                                 1
;     c91db:                                 1
;     c923b:                                 1
;     c9253:                                 1
;     c92e7:                                 1
;     c939a:                                 1
;     c939c:                                 1
;     c93d6:                                 1
;     c9405:                                 1
;     c940c:                                 1
;     c9435:                                 1
;     c943b:                                 1
;     c944c:                                 1
;     c945f:                                 1
;     c9470:                                 1
;     c948d:                                 1
;     c9495:                                 1
;     c94cf:                                 1
;     c94d5:                                 1
;     c94d8:                                 1
;     c94ee:                                 1
;     c952d:                                 1
;     c9533:                                 1
;     c9536:                                 1
;     c955b:                                 1
;     c956d:                                 1
;     c95f0:                                 1
;     c9653:                                 1
;     c96a2:                                 1
;     c96ac:                                 1
;     c9794:                                 1
;     c97bc:                                 1
;     c97db:                                 1
;     c97de:                                 1
;     c9809:                                 1
;     c9859:                                 1
;     c986a:                                 1
;     c9872:                                 1
;     c9883:                                 1
;     c988a:                                 1
;     c989b:                                 1
;     c98a0:                                 1
;     c98a3:                                 1
;     c98a6:                                 1
;     c98ad:                                 1
;     c98c0:                                 1
;     c98d1:                                 1
;     c98dd:                                 1
;     c98e0:                                 1
;     c990f:                                 1
;     c991f:                                 1
;     c993c:                                 1
;     c9963:                                 1
;     c99b3:                                 1
;     c99f2:                                 1
;     c9a1e:                                 1
;     c9a3c:                                 1
;     c9a43:                                 1
;     c9a6d:                                 1
;     c9aae:                                 1
;     c9ab4:                                 1
;     c9ac2:                                 1
;     c9ae2:                                 1
;     c9af4:                                 1
;     c9b04:                                 1
;     c9b1f:                                 1
;     c9b42:                                 1
;     c9bb0:                                 1
;     c9bbe:                                 1
;     c9bfe:                                 1
;     c9cf7:                                 1
;     c9d05:                                 1
;     c9d1e:                                 1
;     c9d22:                                 1
;     c9d2b:                                 1
;     c9d64:                                 1
;     c9d93:                                 1
;     c9daa:                                 1
;     c9dbc:                                 1
;     c9dc6:                                 1
;     c9ddf:                                 1
;     c9de5:                                 1
;     c9dff:                                 1
;     c9e07:                                 1
;     c9e29:                                 1
;     c9e8a:                                 1
;     c9ec0:                                 1
;     c9efa:                                 1
;     c9f0e:                                 1
;     c9f11:                                 1
;     c9f25:                                 1
;     c9f32:                                 1
;     call_jmp_osbyte:                       1
;     check_for_star_command:                1
;     check_text_window:                     1
;     error_no_basic:                        1
;     escape_was_pressed:                    1
;     extended_table_1:                      1
;     fix_rts_address:                       1
;     jump_table:                            1
;     jump_table+1:                          1
;     l0006:                                 1
;     l000c:                                 1
;     l000d:                                 1
;     l000e:                                 1
;     l000f:                                 1
;     l0011:                                 1
;     l0029:                                 1
;     l002a:                                 1
;     l002b:                                 1
;     l002c:                                 1
;     l0043:                                 1
;     l0045:                                 1
;     l0052:                                 1
;     l0053:                                 1
;     l00fd:                                 1
;     l03ff:                                 1
;     l0601:                                 1
;     l0602:                                 1
;     l0603:                                 1
;     l06ff:                                 1
;     l0909:                                 1
;     l450a:                                 1
;     l8055:                                 1
;     l8d3a:                                 1
;     l9856:                                 1
;     language_handler:                      1
;     lff0b:                                 1
;     loop_c8086:                            1
;     loop_c87c6:                            1
;     loop_c87f0:                            1
;     loop_c882f:                            1
;     loop_c8882:                            1
;     loop_c88a1:                            1
;     loop_c8946:                            1
;     loop_c8983:                            1
;     loop_c8a73:                            1
;     loop_c8b5a:                            1
;     loop_c8b6e:                            1
;     loop_c8c10:                            1
;     loop_c8c25:                            1
;     loop_c8c3a:                            1
;     loop_c8c78:                            1
;     loop_c8ca6:                            1
;     loop_c8cbb:                            1
;     loop_c8cc6:                            1
;     loop_c8cf4:                            1
;     loop_c8d0a:                            1
;     loop_c8d23:                            1
;     loop_c8d64:                            1
;     loop_c8e26:                            1
;     loop_c8e3c:                            1
;     loop_c8e6c:                            1
;     loop_c8e98:                            1
;     loop_c8ee5:                            1
;     loop_c8f10:                            1
;     loop_c8f26:                            1
;     loop_c8fc8:                            1
;     loop_c9040:                            1
;     loop_c9055:                            1
;     loop_c9072:                            1
;     loop_c90ca:                            1
;     loop_c90e5:                            1
;     loop_c911e:                            1
;     loop_c91e8:                            1
;     loop_c9207:                            1
;     loop_c9243:                            1
;     loop_c9268:                            1
;     loop_c927c:                            1
;     loop_c9284:                            1
;     loop_c92fb:                            1
;     loop_c93a0:                            1
;     loop_c93eb:                            1
;     loop_c93fa:                            1
;     loop_c94cc:                            1
;     loop_c94e8:                            1
;     loop_c9511:                            1
;     loop_c953a:                            1
;     loop_c9581:                            1
;     loop_c95e4:                            1
;     loop_c9617:                            1
;     loop_c9641:                            1
;     loop_c9654:                            1
;     loop_c9692:                            1
;     loop_c96aa:                            1
;     loop_c9772:                            1
;     loop_c9784:                            1
;     loop_c978d:                            1
;     loop_c97a5:                            1
;     loop_c97fa:                            1
;     loop_c985d:                            1
;     loop_c998b:                            1
;     loop_c999d:                            1
;     loop_c9a03:                            1
;     loop_c9a7c:                            1
;     loop_c9b54:                            1
;     loop_c9bb4:                            1
;     loop_c9be7:                            1
;     loop_c9cd4:                            1
;     loop_c9d96:                            1
;     loop_c9db1:                            1
;     loop_c9dfa:                            1
;     loop_c9e12:                            1
;     loop_c9e8f:                            1
;     loop_c9ec3:                            1
;     loop_c9f27:                            1
;     not_a_star_command:                    1
;     opcodes:                               1
;     os_entry_points:                       1
;     osbget:                                1
;     osbput:                                1
;     oscli:                                 1
;     overwrite_cursor_pos_with_space:       1
;     print_address_labelled:                1
;     print_are_you_sure:                    1
;     print_found:                           1
;     print_hash_ampersand:                  1
;     print_label_exists:                    1
;     print_printm:                          1
;     return_10:                             1
;     return_14:                             1
;     return_18:                             1
;     return_19:                             1
;     return_2:                              1
;     return_20:                             1
;     return_21:                             1
;     return_24:                             1
;     return_3:                              1
;     return_4:                              1
;     return_5:                              1
;     return_7:                              1
;     return_9:                              1
;     rom_command:                           1
;     second_processor:                      1
;     service_handler:                       1
;     stop_output_to_printer:                1
;     string_hex:                            1
;     string_printm:                         1
;     sub_c808b:                             1
;     sub_c89bb:                             1
;     sub_c8caf:                             1
;     sub_c8d33:                             1
;     sub_c8eb5:                             1
;     sub_c9240:                             1
;     sub_c95ab:                             1
;     sub_c974a:                             1
;     sub_c978f:                             1
;     sub_c99cb:                             1
;     sub_c9b5f:                             1
;     sub_m89ea:                             1
;     sub_m93b6:                             1
;     sub_m9633:                             1
;     table_1:                               1
;     table_2:                               1
;     table_3:                               1
;     table_5:                               1
;     table_6:                               1
;     table_7:                               1
;     title:                                 1
;     user_via_ddrb:                         1
;     user_via_orb_irb:                      1

; Stats:
;     Total size (Code + Data) = 8192 bytes
;     Code                     = 5685 bytes (69%)
;     Data                     = 2507 bytes (31%)
;
;     Number of instructions   = 2741
;     Number of data bytes     = 1365 bytes
;     Number of data words     = 88 bytes
;     Number of string bytes   = 1054 bytes
;     Number of strings        = 136
