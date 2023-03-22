run ENTRY,ENTRY
;
; CPC-FIRMWARE
;
KM_TEST_KEY 	equ #bb1e
KM_GET_JOYSTICK 	equ #bb24
KM_SET_REPEAT 	equ #bb39
TXT_OUTPUT 	equ #bb5a
TXT_WIN_ENABLE 	equ #bb66
TXT_SET_CURSOR	equ #bb75
TXT_SET_M_TABLE 	equ #bbab

;
;Programmstart
;
	org 25000 ;#61a8
ENTRY:	call SYMBOL
	jp TITELBILD

START:	call INIT
LOOP1: 	call BILD
MAIN:	call SSOUND
	call WURM
	call TEST
	call FEIND1
	call FEIND2
	call FEIND3
	call TEST
	call SYSTEM
	call WAIT
	call KEY
	jr MAIN

WURM:	ld hl,wartsp
	dec (hl)
	ret nz
	ld a,(wurmsp+26)
	srl a
	srl a
	add #04
	ld (wartsp),a
	ld ix,wurmsp
	ld a,#07
	ld (segm),a
	call GETKO
	call JOYST
	or a
	jr nz,WURM3
	ld a,(wurmsp+27)
WURM3:	ld c,a
	push hl
	call BEWEG
	call GETWER
	or a
	ld a,c
	pop hl
	jp z,BEWEGW
	ld a,(wurmsp+27)
	ld c,a
	call BEWEG
	call GETWER
	or a
	ld a,c
	jp nz,PRINTW
	jp BEWEGW
	
FEIND1:	ld hl,(wart1)
	dec hl
	ld (wart1),hl
	ld a,h
	or l
	ret nz
	ld a,(wurmf1+26)
	srl a
	srl a
	add #05
	ld (wart1),a
	ld ix,wurmf1
	jp FEINDBEW

FEIND2:	ld hl,(wart2)
	dec hl
	ld (wart2),hl
	ld a,h
	or l
	ret nz
	ld a,(wurmf2+26)
	srl a
	srl a
	add #05
	ld (wart2),a
	ld ix,wurmf2
	jp FEINDBEW

FEIND3:	ld hl,(wart3)
	dec hl
	ld (wart3),hl
	ld a,h
	or l
	ret nz
	ld a,(wurmf3+26)
	srl a
	srl a
	add #05
	ld (wart3),a
	ld ix,wurmf3

FEINDBEW:	ld a,12
	ld (segm),a
	ld a,(ix+26)
	cp #02
	ret c
	call GETKO
	call RND4
	ld b,#04
FEINDBEW1:	call NEXTRICH
	push hl
	ld d,a
	call BEWEG
	call GETWER
	pop hl
	or a
	ld a,d
	jp z,BEWEGW
	djnz FEINDBEW1
	ld a,#01
	jp BEWEGW

;
; Systemroutine
;
SYSTEM:	ld hl,#1001
	call GETWER
	cp 21
	jr nz,SYSTEM3
	ld ix,wurmf1
	ld b,#03
SYSTEMA:	call GETKO
	ld a,17
	cp h
	jr nz,SYSTEM1
	ld a,#01
	cp l
	jr z,SYSTEM2
SYSTEM1:	ld de,28
	add ix,de
	djnz SYSTEMA
	ld a,21
	ld hl,#1001
	call PRINTG
	jp SYSTEMB
SYSTEM2:	ld a,16
	ld hl,#1001
	call PUTWER
	call PRINTG
	xor a
	ld (flags1),a
	jp SYSTEMB
SYSTEM3:	or a
	jr z,SYSTEM4
	cp #20
	jr z,SYSTEM5
	ld a,(flags1)
	or a
	jr z,SYSTEM3A
	ld a,21
SYSTEM3A:	ld hl,#1001
	call PUTWER
	call PRINTG
	ld a,10
	ld (countoff1),a
	jp SYSTEMB
SYSTEM4:	ld hl,countoff1
	dec (hl)
	jp nz,SYSTEMB
	ld a,32
	ld hl,#1001
	call PUTWER
	ld a,90
	ld (countoff1),a
	jp SYSTEMB
SYSTEM5:	ld hl,countoff1
	dec (hl)
	jp nz,SYSTEMB
	ld a,#10
	ld hl,#1001
	call PUTWER
	call PRINTG
	or #ff
	ld (flags1),a

SYSTEMB:	ld hl,#1019
	call GETWER
	cp 21
	jr nz,SYSTEMB2
	;
	ld ix,wurmsp
	call GETKO
	ld a,17
	cp h
	jp nz,SYSTEMB5
	ld a,25
	cp l
	jp nz,SYSTEMB5
	ld a,16
	ld hl,#1019
	call PUTWER
	call PRINTG
	xor a
	ld (flags2),a
	jp SYSTEMC
SYSTEMB2:	or a
	jr z,SYSTEMB3
	cp 32
	jr z,SYSTEMB4
	ld a,(flags2)
	or a
	jr z,SYSTEMB2A
	ld a,21
SYSTEMB2A:	ld hl,#1019
	call PUTWER
	call PRINTG
	ld a,10
	ld (countoff2),a
	jp SYSTEMC
SYSTEMB3:	ld hl,countoff2
	dec (hl)
	jp nz,SYSTEMC
	ld a,32
	ld hl,#1019
	call PUTWER
	ld a,70
	ld (countoff2),a
	jp SYSTEMC
SYSTEMB4:	ld hl,countoff2
	dec (hl)
	jp nz,SYSTEMC
	ld a,16
	ld hl,#1019
	call PUTWER
	call PRINTG
	or #ff
	ld (flags2),a
	jr SYSTEMC
SYSTEMB5:	ld hl,#1019
	ld a,21
	call PRINTG

SYSTEMC:	ld a,(bonus)
	or a
	jr nz,SYSTEMC2
	call RND
	cp 100
	jp nz,SYSTEMD
SYSTEMC1:	call RND022
	ld h,a
	call RND026
	ld l,a
	call GETWER
	or a
	jr nz,SYSTEMC1
	ld (bonusxy),hl
	ld a,5
	call PRINTG
	ld a,120
	ld (bonus),a
	ld hl,soundbonus
	call SOUND
	jp SYSTEMD
SYSTEMC2:	ld hl,(bonusxy)
	ld a,5
	call PRINTG
	ld hl,bonus
	dec (hl)
	jr nz,SYSTEMD
	ld hl,(bonusxy)
	xor a
	call PRINTG
	call PRINTL

SYSTEMD:	ld a,(egg)
	or a
	jp z,SYSTEME
	cp 5
	jr z,SYSTEMD2
	cp 6
	jr z,SYSTEMD3
	ld hl,eggcount
	dec (hl)
	ret nz
	ld (hl),60
	ld ix,wurmsp
	ld de,28
	ld b,a
	ld a,7
	ld (segm),a
	jr SYSTEMD11
SYSTEMD1:	add ix,de
	ld a,12
	ld (segm),a
SYSTEMD11:	djnz SYSTEMD1
	inc (ix+25)
	ld a,(ix+25)
	cp 4
	ret nz
	ld (ix+25),0
	call GETEN
	ld (eggxy),hl
	push hl
	call KURZW
	pop hl
	ld a,1
	call PRINTG
	ld a,(egg)
	ld c,5
	cp 1
	jr z,SYSTEMD1A
	inc c
SYSTEMD1A:	ld a,c
	ld (egg),a
	ld hl,eggcount
	ld (hl),120
	ret
SYSTEMD2:	ld hl,(eggxy)
	ld a,1
	jp PRINTG
SYSTEMD3:	ld hl,(eggxy)
	ld a,1
	call PRINTG
	ld hl,eggcount
	dec (hl)
	ret nz
	xor a
	ld (egg),a
	ld ix,wurmsp
	ld de,28
	ld b,3
SYSTEMD4:	add ix,de
	ld a,(ix+26)
	or a
	jr z,SYSTEMD5
	djnz SYSTEMD4
	ret
SYSTEMD5:	push ix
	pop de
	ld hl,neuwurm
	ld bc,28
	ldir
	ld hl,(eggxy)
	ld (ix+#00),h
	ld (ix+#01),l
	ld (ix+#02),h
	ld (ix+#03),l
	call RND4
	ld (ix+27),a
	ret

SYSTEME:	call RND
	cp 250
	ret nz
	call RND4
	cp 4
	jr c,SYSTEME2
	ld a,1
SYSTEME1:	ld (egg),a
	ld hl,eggcount
	ld (hl),60
	ret
SYSTEME2:	call FEINDANZ
	cp 3
	ret z
	call GETFEIND
	ld b,a
	ld ix,wurmsp
	ld de,28
SYSTEME3:	add ix,de
	djnz SYSTEME3
SYSTEME3A:	ld b,a
	ld a,(ix+26)
	cp 3
	ld a,b
	jr nc,SYSTEME4
	inc a
	cp 4
	jr nz,SYSTEME3A
	ret
SYSTEME4:	inc a
	jr SYSTEME1

TEST:	ld a,(wurmsp+26)
	cp 2
	jp c,SPIELERTOD
	ld a,(bonus)
	or a
	jr z,TESTA
	ld b,4
	ld ix,wurmsp
	ld de,28
	ld a,7
	ld (segm),a
TEST1:	ld a,(ix+26)
	or a
	jr z,TEST2
	call GETKO
	ld a,(bonusxy)
	cp l
	jr nz,TEST2
	ld a,(bonusxy+1)
	cp h
	jr z,TEST3
TEST2:	add ix,de
	ld a,12
	ld (segm),a
	djnz TEST1
	jr TESTA
TEST3:	call LANGW
	ld hl,soundlang
	call SOUND
	xor a
	ld (bonus),a
	ld a,b
	cp 4
	jr nz,TESTA
	ld de,50
	call SCOADD
TESTA:	ld ix,wurmsp
	call GETKO
	ld (xy),hl
	ld iy,xy
	ld de,28
	ld b,3
TESTA1:	add ix,de
	ld a,(ix+26)
	or a
	jr z,TESTA2
	call GETKO
	ld a,l
	cp (iy+0)
	jr nz,TESTA2
	ld a,h
	cp (iy+1)
	jr z,TESTA3
TESTA2:	djnz TESTA1
	jr TESTB
TESTA3:	ld a,(wurmsp+26)
	cp (ix+26)
	jp z,SPIELERTOD
	jp c,SPIELERTOD
	ld a,5
	sub b
	ld b,a
	ld a,(egg)
	cp b
	jr nz,TESTA4
	xor a
	ld (egg),a
TESTA4:	ld de,100
	call SCOADD
	call KAPUTT
	ld ix,wurmsp
	ld a,7
	ld (segm),a
	call LANGW
	call FEINDANZ
	or a
	jp z,FERTIG
TESTB:	ld ix,wurmsp
	call GETKO
	ld de,28
	add ix,de
	ld b,3
TESTB1:	ld a,(ix+26)
	or a
	jr z,TESTB9
	push bc
	push ix
	ld b,10
TESTB1A:	ld a,(ix+0)
	cp h
	jr nz,TESTB2
	ld a,(ix+1)
	cp l
	jr z,TESTB3
TESTB2:	inc ix
	inc ix
	djnz TESTB1A
	pop ix
	pop bc
TESTB9:	add ix,de
	djnz TESTB1
	jp TESTC
TESTB3:	pop ix
	pop bc
	ld a,12
	ld (segm),a
	call KURZW
	ld a,5
	sub b
	ld b,a
	ld a,(egg)
	cp b
	jr nz,TESTB5
	xor a
	ld (egg),a
	ld de,10
	call SCOADD
TESTB5:	ld de,5
	call SCOADD
	ld hl,soundkurz
	call SOUND
	ld a,(ix+26)
	cp 2
	jr nc,TESTC
	ld de,20
	call SCOADD
	call KAPUTT
	call FEINDANZ
	or a
	jp z,FERTIG
	TESTC:
	ld ix,wurmf1
	ld de,28
	ld b,3
TESTC1:	ld a,(ix+26)
	or a
	jr z,TESTC3A
	call GETKO
	ld iy,wurmsp
	push bc
	ld b,10
TESTC2:	ld a,(iy+0)
	cp h
	jr nz,TESTC3
	ld a,(iy+1)
	cp l
	jr z,TESTC4
TESTC3:	inc iy
	inc iy
	djnz TESTC2
	pop bc
TESTC3A:	add ix,de
	djnz TESTC1
	jr TESTD
TESTC4:	pop bc
	ld ix,wurmsp
	ld a,7
	ld (segm),a
	call KURZW
	ld a,(egg)
	cp 1
	jr nz,TESTC5
	xor a
	ld (egg),a
TESTC5:	ld hl,soundkurz
	call SOUND
	ld a,(ix+26)
	cp 2
	jp c,SPIELERTOD
TESTD:	ld a,(egg)
	cp 6
	jr z,TESTD4
	cp 5
	ret nz
	ld iy,eggxy
	ld ix,wurmf1
	ld de,28
	ld b,3
TESTD1:	ld a,(ix+26)
	or a
	jr z,TESTD3
	call GETKO
	ld a,h
	cp (iy+1)
	jr nz,TESTD3
	ld a,l
	cp (iy+0)
	jr nz,TESTD3
	ld a,12
TESTD2:	ld (segm),a
	xor a
	ld (egg),a
	call LANGW
	ld hl,soundlang
	jp SOUND
TESTD3:	add ix,de
	djnz TESTD1
	ret
TESTD4:	ld ix,wurmsp
	call GETKO
	ld a,(eggxy)
	cp l
	ret nz
	ld a,(eggxy+1)
	cp h
	ret nz
	ld de,75
	call SCOADD
	ld a,7
	jr TESTD2
;
WAIT:	push hl
	push af
	ld hl,(waittime)
WAIT1:	dec hl
	ld a,h
	or l
	jr nz,WAIT1
	pop af
	pop hl
	ret
;
; Symbol-Definition
;
SYMBOL:	ld de,#0056
	ld hl,symtab
	call TXT_SET_M_TABLE
	ld hl,matrix
	ld de,symtab
	ld bc,8*37
	ldir
	ld a,47
	ld b,0
	call KM_SET_REPEAT
	ld a,(#0006)
	cp #80
	ret nz
	ld hl,mode464
	ld (modus),hl
	ret
;
TITELBILD:	ld hl,titelstr1
	ld b,45
	call PRINTSTR
	and a
	ld ix,frei51
	ld hl,(score)
	call ZERLEG
	ld ix,frei52
	ld hl,(hiscore)
	call ZERLEG
	ld a,1
	ld hl,(modus)
B_________:	ld (hl),a
	ld hl,#0000
	ld de,#2718
	call TXT_WIN_ENABLE ; (0,0)-(39,24)
	;------------------------ unterschied!
	ld hl,titlescr
	ld de,#c000
	ld bc,#4000
	ldir
	;------------------------ ende
	ld hl,titelstr2
	ld b,41
	call PRINTSTR
TITELBILD2:	call KM_GET_JOYSTICK
	bit 4,h
	jr z,TITELBILD2
	jp START
;
SPIELERTOD:	pop hl
	ld ix,wurmsp
	call KAPUTT
	ld hl,lives
	dec (hl)
	push af
	ld hl,2000
	ld (waittime),hl
	ld b,100
SPTOD1:	call WAIT
	djnz SPTOD1
	pop af
	jp z,GAMEOVER
	call INIT1
	jp LOOP1
;
GAMEOVER:	call PRINTL
	ld hl,gostr
	ld b,48
	call PRINTSTR
	ld b,100
GAMEOVER1:	call WAIT
	djnz GAMEOVER1
HIGH:	ld hl,(hiscore)
	ld a,(score+1)
	cp h
	jp c,TITELBILD
	jr nz,HIGH2
	ld a,(score)
	cp l
	jp c,TITELBILD
HIGH2:	ld hl,(score)
	ld (hiscore),hl
	jp TITELBILD
;
FERTIG:	pop hl
	ld ix,wurmsp
	ld (ix+25),0
	ld a,7
	ld (segm),a
fertig1:	ld hl,#1019
	ld a,16
	call PRINTG
	call WAIT
	xor a
	call PRINTG
	call PUTWER
	ld ix,wurmsp
	call PRINTW
FERTIG2:	ld b,3
FERTIG2A:	call WAIT
	djnz FERTIG2A
	call GETKO
	ld a,(ix+27)
	cp 4
	jr z,FERTIG3
	ld a,2
	push hl
	call BEWEG
	call GETWER
	pop hl
	or a
	jr nz,FERTIG3
	ld a,2
	call BEWEGW
	jp FERTIG6
FERTIG3:	ld a,(ix+27)
	cp #01
	jr z,FERTIG4
	ld a,3
	push hl
	call BEWEG
	call GETWER
	pop hl
	or a
	jr nz,FERTIG4
	ld a,#03
	call BEWEGW
	jp FERTIG6
FERTIG4:	ld a,(ix+27)
	cp #03
	jr z,FERTIG5
	ld a,#01
	push hl
	call BEWEG
	call GETWER
	pop hl
	or a
	jr nz,FERTIG5
	ld a,#01
	call BEWEGW
	jr FERTIG6
FERTIG5:	ld a,#04
	call BEWEGW
FERTIG6:	ld a,(egg)
	cp #05
	jr nz,FERTIG6A
	ld a,#01
	ld hl,(eggxy)
	call PRINTG
FERTIG6A:	call GETKO
	ld a,21
	cp h
	jr nz,FERTIG2
	ld a,25
	cp l
	jr nz,FERTIG2
	ld b,10
FERTIG7:	xor a
	call BEWEGW
	push bc
	ld b,#03
FERTIG7A:	call WAIT
	djnz FERTIG7A
	pop bc
	djnz FERTIG7
	ld (ix+27),#01
	ld a,(egg)
	cp #05
	jr nz,FERTIG8
	ld hl,lives
	inc (hl)
	call PRINTL
	xor a
	ld (egg),a
	ld ix,wurmf1
	ld de,wurmf1
	ld hl,neuwurm
	ld bc,28
	ldir
	ld hl,(eggxy)
	ld (ix+#00),h
	ld (ix+#01),l
	ld (ix+#02),h
	ld (ix+#03),l
	ld hl,soundlang
	call SOUND
	call PRINTW
	jp FERTIG2
FERTIG8:	ld hl,level
	inc (hl)
	call INIT2
	ld hl,#1019
	ld a,16
	call PRINTG
	call WAIT
	ld a,21
	call PRINTG
	call WAIT
	jp LOOP1
;
; Ständiger Sound
;
SSOUND:	ld a,(countso)
	dec a
	ld (countso),a
	jr z,SSOUND2
	cp 10
	ret nz
	ld c,63
	ld a,#07
	jp #bd34
SSOUND2:	ld hl,soundst
	call SOUND
	ld a,25
	ld (countso),a
	ret
;
; Unterprogramme
;

;
; 1) Stringausgabe
;
PRINTSTR:	push hl
	push bc
	push af
PRINT1:	ld a,(hl)
	call TXT_OUTPUT
	inc hl
	djnz PRINT1
	pop af
	pop bc
	pop hl
	ret
;
; 2) Joystickabfrage
;
JOYST:	push hl
	call KM_GET_JOYSTICK
	xor a
	bit 0,h
	jr z,JOY1
	ld a,#01
JOY1:	bit 3,h
	jr z,JOY2
	ld a,#02
JOY2:	bit 1,h
	jr z,JOY3
	ld a,#03
JOY3:	bit 2,h
	jr z,JOY4
	ld a,#04
JOY4:	pop hl
	ret
;
; 3) Bildschirmadresse berechnen
;
BILDAD:	push de
	push bc
	push af
	ex de,hl
	ld h,#00
	ld l,d
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	ld b,h
	ld c,l
	add hl,hl
	add hl,hl
	add hl,bc
	ld bc,#c05c
	add hl,bc
	ld d,#00
	sla e
	add hl,de
	pop af
	pop bc
	pop de
	ret
;
; 4) Grafikadresse berechnen
;
GRAADR:	push bc
	push af
	ld ix,grafik
	ld bc,16
	or a
	jr z,GRAADR2
GRAADR1:	add ix,bc
	dec a
	jr nz,GRAADR1
GRAADR2:	pop af
	pop bc
	ret
;
; 5) Grafikausgabe
;
PRINTG:	push ix
	push de
	push bc
	push af
	push hl
	call GRAADR
	call BILDAD
	ld de,#07ff
	ld b,#08
PRINTG1:	ld a,(ix+#00)
	ld (hl),a
	inc ix
	inc hl
	ld a,(ix+#00)
	ld (hl),a
	inc ix
	add hl,de
	djnz PRINTG1
	pop hl
	pop af
	pop bc
	pop de
	pop ix
	ret
;
; 6) Wert aus Speicher holen
;
GETWER:	push hl
	call FELBER
	ld a,(hl)
	pop hl
	ret
;
; 7) Wert in Speicher schreiben
;
PUTWER:	push hl
	call FELBER
	ld (hl),a
	pop hl
	ret
;
; UP zu 6/7: Feldberechnung
;
FELBER:	push de
	push bc
	push af
	ex de,hl
	ld hl,feld
	ld a,d
	or a
	jr z,FELBER2
	ld bc,27
FELBER1:	add hl,bc
	dec d
	jr nz,FELBER1
FELBER2:	add hl,de
	pop af
	pop bc
	pop de
	ret
;
; 8) Koordinaten bewegen
;
BEWEG:	push af
	dec a
	jr nz,BEWEG1
	dec h
BEWEG1:	dec a
	jr nz,BEWEG2
	inc l
BEWEG2:	dec a
	jr nz,BEWEG3
	inc h
BEWEG3:	dec a
	jr nz,BEWEG4
	dec l
BEWEG4:	pop af
	ret
;
; 9) Score addieren (und ausgeben)
;
SCOADD:	push hl
	ld hl,(score)
	add hl,de
	ld (score),hl
	pop hl
;
; 10) Score-Ausgabe
;
PRINTS:	push hl
	push de
	push bc
	push af
	push ix
	ld hl,(score)
	ld ix,frei5
	call ZERLEG
	ld hl,scostr
	ld b,#08
	call PRINTSTR
	pop ix
	pop af
	pop bc
	pop de
	pop hl
	ret
;
; Zerlegroutine zu 10 und Hiscore
;
ZERLEG:	ld de,10000
ZERLEG1:	ld (ix+#00),85
ZERLEG2:	inc (ix+#00)
	sbc hl,de
	jr nc,ZERLEG2
	add hl,de
	inc ix
	ld a,e
	cp 16
	jr nz,ZERLEG3
	ld de,1000
ZERLEG3:	cp 232
	jr nz,ZERLEG4
	ld de,100
ZERLEG4:	cp 100
	jr nz,ZERLEG5
	ld e,10
ZERLEG5:	cp 10
	jr nz,ZERLEG6
	ld e,#01
ZERLEG6:	cp #01
	ret z
	jr ZERLEG1
;
; 11) Live-Anzeige mit Korrektur
;
PRINTL:	push hl
	push bc
	push af
	ld a,(lives)
PRINTL1:	cp 10
	jr c,PRINTL2
	dec a
	jr PRINTL1
PRINTL2:	ld (lives),a
	add 86
	ld (ll1),a
	ld hl,livstr
	ld b,#04
	call PRINTSTR
	pop af
	pop bc
	pop hl
	ret
;
; 12) Kopieren des Orig.-Feldes nach 40000
;
COPY:	push hl
	push de
	push bc
	push af
	ld hl,orig
	ld de,500
	ld a,(level)
	and #0f
	jr z,COPY2
COPY1:	add hl,de
	dec a
	jr nz,COPY1
COPY2:	ld de,feld
COPY3:	ld a,(hl)
	or a
	jr z,COPY5
	and #1f
	ld b,(hl)
	srl b
	srl b
	srl b
	srl b
	srl b
COPY4:	ld (de),a
	inc de
	djnz COPY4
	inc hl
	jr COPY3
COPY5:	pop af
	pop bc
	pop de
	pop hl
	ret
;
; 13) WAIT-Wert ermitteln
;
BEWAIT:	push hl
	push af
	push bc
	push de
	ld a,(level)
	ld hl,#0001
	ld de,90
	ld b,a
	ld a,32
	sub b
	jr c,BEWAIT2
	jr z,BEWAIT2
	ld b,a
BEWAIT1:	add hl,de
	djnz BEWAIT1
BEWAIT2:	ld (waittime),hl
	pop de
	pop bc
	pop af
	pop hl
	ret
;
; 14) SOUND-Ausgabe (hl enthält Adresse der Sound-Tabelle)
;
SOUND:	push bc
	push af
	push de
	xor a
	ld d,a
SOUND1:	ld c,(hl)
	call #bd34
	inc hl
	inc d
	ld a,d
	cp 14
	jr nz,SOUND1
	pop de
	pop af
	pop bc
	ret
;
; 15) Wurm verlängern (ix = Adresse des Wurmspeichers)
;
LANGW:	push af
	push bc
	push hl
	push ix
	pop hl
	ld a,(ix+26)
	cp 10
	jr nc,LANGW0
	call STAUCH
	ld a,(ix+22)
	dec a
	add a
	ld b,#00
	ld c,a
	add hl,bc
	ld c,(ix+22)
LANGW1:	ld a,c
	call ENDW
	ld c,a
	ld a,(hl)
	or a
	jr nz,LANGW1
	ld a,(ix+23)
	ld (hl),a
	ld a,(ix+24)
	inc hl
	ld (hl),a
	inc (ix+26)
	call ANFEND
	call PRINTW
LANGW0:	pop hl
	pop bc
	pop af
	ret
;
; 16) Wurm verkürzen
;
KURZW:	push af
	push bc
	push de
	push hl
	push ix
	ld b,(ix+21)
	jp KURZW2
KURZW1:	inc ix
	inc ix
KURZW2:	djnz KURZW1
	pop hl
	push hl
	ld d,(ix+#00)
	ld e,(ix+#01)
	ld bc,23
	add hl,bc
	ld (hl),d
	inc hl
	ld (hl),e
	ld (ix+#00),#00
	ld (ix+#01),#00
	pop ix
	dec (ix+26)
	xor a
	ld (ix+25),a
	call ANFEND
	call PRINTW
	pop hl
	pop de
	pop bc
	pop af
	ret
;
; 17) Ende des Wurmes ermitteln
;
ANFEND:	push hl
	push bc
	push af
	push ix
	pop hl
	ld a,(ix+22)
	dec a
	add a
	ld b,#00
	ld c,a
	add hl,bc
	ld a,(ix+22)
ANFEND1:	call ENDW
	ld c,a
	ld a,(hl)
	or a
	ld a,c
	jr z,ANFEND1
	ld (ix+21),a
	pop af
	pop bc
	pop hl
	ret
;
; UP zu 17)
;
ENDW:	inc hl
	inc hl
	inc a
	cp 11
	ret nz
	push bc
	ld a,#01
	ld bc,20
	and a
	sbc hl,bc
	pop bc
	ret
;
; 18) Wurm ausgeben
;
PRINTW:	push hl
	push bc
	push af
	push ix
	ld a,(ix+23)
	ld l,(ix+24)
	or a
	jr z,PRINTW1
	ld h,a
	xor a
	call PRINTG
PRINTW1:	pop hl
	ld b,10
PRINTW1A:	ld a,(hl)
	inc hl
	ld c,(hl)
	inc hl
	or a
	jr nz,PRINTW2
	djnz PRINTW1A
	jr PRINTW3
PRINTW2:	push hl
	ld h,a
	ld l,c
	ld a,(segm)
	call PRINTG
	pop hl
	djnz PRINTW1A
PRINTW3:	call GETEN
	ld a,(segm)
	ld c,(ix+25)
	add c
	call PRINTG
	call GETKO
	ld a,(segm)
	dec a
	call PRINTG
	pop af
	pop bc
	pop hl
	ret
;
; 19) Wurm bewegen
;
BEWEGW:	push hl
	push bc
	push de
	push af
	push ix
	pop hl
	push hl
	ld a,(ix+21)
	dec a
	add a
	ld d,#00
	ld e,a
	add hl,de
	ld d,(hl)
	inc hl
	ld e,(hl)
	ld (ix+23),d
	ld (ix+24),e
	ld a,(ix+22)
	dec a
	pop hl
	add a
	ld d,#00
	ld e,a
	add hl,de
	ld d,(hl)
	inc hl
	ld e,(hl)
	ld h,d
	ld l,e
	pop af
	call BEWEG
	ld (ix+27),a
	push hl
	push ix
	pop hl
	ld a,(ix+21)
	ld (ix+22),a
	dec a
	add a
	ld d,#00
	ld e,a
	add hl,de
	pop de
	ld (hl),d
	inc hl
	ld (hl),e
	call ANFEND
	call PRINTW
	pop de
	pop bc
	pop hl
	ret
;
; Zufallszahlengenerator:
;
RND:	push hl
	push de
	push bc
	call #b906
	ld hl,(rndzei)
	ld c,(hl)
	ld a,(altrnd)
	xor c
	ld b,#00
	ld c,a
	add hl,bc
	ld a,h
	cp 64
	jp c,RNDD1
	ld de,14000
	sbc hl,de
RNDD1:	ld (rndzei),hl
	call #b909
	ld a,r
	xor c
	ld (altrnd),a
	pop bc
	pop de
	pop hl
	ret
;
RND4:	call RND
	and #03
	inc a
	ret
;
RND026:	call RND
RND026A:	cp 27
	ret c
	sub 27
	jr RND026A
;
RND022:	call RND
RND022A:	cp 23
	ret c
	sub 23
	jr RND022A
;
; Level ausgeben
;
PRLEV:	ld a,(level)
	inc a
	call ZERLL
	ld hl,levstr
	ld b,#05
	jp PRINTSTR
;
ZERLL:	ld ix,frei2
	ld c,10
ZERLL1:	ld (ix+#00),85
ZERLL2:	inc (ix+#00)
	sub c
	jr nc,ZERLL2
	add c
	inc ix
	ld b,a
	ld a,c
	cp 10
	jr nz,ZERLL3
	ld c,#01
ZERLL3:	cp #01
	ld a,b
	ret z
	jr ZERLL1
;
; Initialisieren vor dem Spiel
;
INIT:	ld hl,initst
	ld b,41
	call PRINTSTR
	ld a,#01
	ld hl,(modus)
	ld (hl),a
	ld hl,#0000
	ld de,#2718 ; 10008
	call TXT_WIN_ENABLE ; (0,0)-(39,24)
	xor a
	ld (score),a
	ld (score+1),a
	ld (level),a
	ld a,#03
	ld (lives),a
INIT1:	call NEUERWURM
INIT2:	call NEUERFEIND
	xor a
	ld (bonus),a
	ld (egg),a
	jp FEINDINIT
;
; Bildaufbau
;
BILD:	call COPY
	call BEWAIT
	ld hl,bildstr
	ld b,29
	call PRINTSTR
	ld hl,farben
	ld a,(level)
	and #03
	add a
	add a
	ld c,a
	add a
	add c
	add a
	ld b,#00
	ld c,a
	add hl,bc
	ld b,24
	call PRINTSTR
;
	ld hl,#0000
FELDPR:	call GETWER
	call PRINTG
	inc l
	inc l
	ld a,l
	cp 28
	jr nz,FELDPR
	ld de,3000
L1:	dec de
	ld a,d
	or e
	jr nz,L1
	ld l,#00
	inc h
	ld a,h
	cp 23
	jr nz,FELDPR
	ld hl,#0001
FELDPR2:	call GETWER
	call PRINTG
	inc h
	ld a,h
	cp 23
	jr nz,FELDPR2
	ld de,6000
L2:	dec de
	ld a,d
	or e
	jr nz,L2
	ld h,#00
	inc l
	inc l
	ld a,l
	cp 27
	jr nz,FELDPR2
	call PRINTL
	ld a,10
	ld (countso),a
	ld ix,wurmsp
	ld a,#07
	ld (segm),a
	call PRINTW
	ld a,12
	ld (segm),a
	ld ix,wurmf1
	call PRINTW
	call PRLEV
	call PRINTS
	ld hl,(hiscore)
	ld ix,frei5a
	call ZERLEG
	ld hl,hiscstr
	ld b,#08
	jp PRINTSTR
;
FEINDINIT:	ld hl,#0001
	ld de,160
	ld (wart1),hl
	add hl,de
	ld (wart2),hl
	add hl,de
	ld (wart3),hl
	ld a,#01
	ld (wartsp),a
	ld hl,#0000
	ld (bonus),hl
	ld ix,wurmsp
	ld de,28
	ld b,#04
FEINDIN1:	ld (ix+25),#00
	add ix,de
	djnz FEINDIN1
	ld a,(egg)
	cp #01
	ret z
	xor a
	ld (egg),a
	ret
;
NEUERFEIND:	ld de,wurmf1
	ld b,#03
NEUF1:	push bc
	ld hl,fsource
	ld bc,28
	ldir
	pop bc
	djnz NEUF1
	ret
;
NEUERWURM:	ld de,wurmsp
	ld hl,ssource
	ld bc,28
	ldir
	ret
;
GETKO:	push bc
	push af
	ld a,(ix+22)
GET1:	dec a
	add a
	ld b,#00
	ld c,a
	push ix
	pop hl
	add hl,bc
	push de
	ld d,(hl)
	inc hl
	ld e,(hl)
	ld h,d
	ld l,e
	pop de
	pop af
	pop bc
	ret
GETEN:	push bc
	push af
	ld a,(ix+21)
	jr GET1
;
; Richtung für feindlichen Wurm
;
NEXTRICH:	push af
	ld a,(ix+27)
	inc a
	and #03
	inc a
	ld c,a
	pop af
	and #03
	inc a
	cp c
	jr z,NESTRICH1
	dec a
NESTRICH1:	and #03
	inc a
	ret
;
; Feindanzahl berechnen
;
FEINDANZ:	push ix
	push de
	push bc
	ld b,#03
	ld ix,wurmf1
	ld de,28
	ld c,#00
FEINDANZ1:	ld a,(ix+26)
	or a
	jr z,FEINDANZ2
	inc c
FEINDANZ2:	add ix,de
	djnz FEINDANZ1
	ld a,c
	pop bc
	pop de
	pop ix
	ret
;
; Lebenden Feind holen
;
GETFEIND:	push hl
	push de
	push bc
	ld b,#03
	ld hl,wurmf1+26
	ld de,28
	ld c,#00
GETFEIND1:	ld a,(hl)
	add hl,de
	inc c
	or a
	jr nz,GETFEIND2
	djnz GETFEIND1
	or #ff
	jr GETFEIND3
GETFEIND2:	ld a,c
GETFEIND3:	pop bc
	pop de
	pop hl
	ret
;
; Wurm ist kaputt
;
KAPUTT:	ld a,#02
	ld hl,soundfk
KAPUTT1:	call PRINTK
	call SOUND
	ld b,10
KAPUTT2:	call WAIT
	djnz KAPUTT2
	inc a
	cp #05
	jr nz,KAPUTT1
	xor a
	ld (ix+26),a
;
; Kaputten Wurm ausgeben
;
PRINTK:	push ix
	push hl
	push bc
	push af
	ld b,10
PRINTK0:	ld a,(ix+#00)
	ld l,(ix+#01)
	or a
	jr z,PRINTK1
	ld h,a
	pop af
	push af
	call PRINTG
PRINTK1:	inc ix
	inc ix
	djnz PRINTK0
	pop af
	pop bc
	pop hl
	pop ix
	ret
;
; Tastenabfrage
;
KEY:	ld a,47
	call KM_TEST_KEY
	jr nz,KEY1
	ld a,66		; Escape
	call KM_TEST_KEY
	ret z
	ld hl,soundoff
	call SOUND
	pop hl
	jp HIGH
KEY1:	ld hl,keystr
	ld b,35
	call PRINTSTR
	ld hl,soundoff
	call SOUND
KEY2:	ld a,76
	call KM_TEST_KEY
	jr z,KEY2
	ld hl,keyoff
	ld b,13
	call PRINTSTR
	jp PRLEV
;
; Konstanten
;
.feld	equ 40000
.symtab	equ 41000
.mode6128	equ #b7c3
.mode464	equ #b1c8
.ink1	equ 15
.ink4	equ 24
.ink5	equ 6

; wird immer nach dem Verlängern eines Wurms aufgerufen.
; Das hinzugefügte Element wird nämlisch scheinbar nicht
; korrekt berechnet und hier war Platz für eine nachträglich
; einfügbare Funktion, die das korrigieren sollte. Ist
; halt nie dazu gekommen.
STAUCH:	ret
	defs 200

scostr:	defb 31,14,1
frei5:	defb 0,0,0,0,0
hiscstr:	defb 31,28,1
frei5a:	defb 0,0,0,0,0
livstr:	defb 31,30,23
ll1:	defb 0
levstr:	defb 31,23,25
frei2:	defb 0,0
initst:	defb #04,#00,#1d,#00,#00
	defb #1c,#00,#00,#00
	defb #1c,#01,ink1,ink1
	defb #1c,#02,#1a,#1a
	defb #1c,#04,ink4,ink4
	defb #1c,#05,ink5,ink5
	defb #1c,#09,#02,#02
	defb #1c,#0a,#0d,#0d
	defb #1c,#0b,#03,#03
	defb #0e,#00,#0f,#01
titelstr1:	defb #04,#00,#1d,#00,#00
	defb #1c,#00,#00,#00
	defb #1c,#01,#0b,#0b
	defb #1c,#02,#15,#15
	defb #1c,#03,#03,#03
	defb #1c,#04,#14,#14
	defb #1c,#05,#02,#02
	defb #1c,#06,#0d,#0d
	defb #1c,#07,#06,#06
	defb #1c,#08,#13,#13
	defb #1c,#0a,#09,#09
	defb #1c,#0d,#18,#18
	defb #1c,#0e,#0f,#0f
	defb #1c,#0f,#0c,#0c
titelstr2a:	defb 15,1,31,12,2
	defm "softice presentsz"
	defb 31,8,16
	defm "wcx`W_"
	defb 94
	defm "_`by`zzzz`zzzzzzzz"
	defb 31,11,23
	defm "press`wfirex`to`play"
titelstr2:	defb #1f,#03,#17,#0f,#02
	defm "last`scorez"
frei51:	defb 0,0,0,0,0
	defm "````high`scorez"
frei52:	defb 0,0,0,0,0
; alter titel, als es noch keine Grafik gab:
titel:	defb 0,25,21,25,21,25,21,19,25,21,19,25
	defb 21,25,19,27,21,17,21,27,25,19
	defb 27,25,21,25,21
	defb 0,26,0,26,0,26,0,26,26,0,26,26,0
	defb 26,26,26,0,26,0,26,26,26,26,26,0
	defb 26,0,0,28,19,24,21,24,17,22,24,21
	defb 22,24,21,26,26,26,0,26,0,26,26,26
	defb 26,24,21,28,19,0,0,26,26,0,26,26
	defb 0,26,0,0,26,0,26,26,26,0,26,0,26
	defb 26,26,26,26,0,0,26,21,21,22,28
	defb 21,30,28,23,30,0,0,28,21,30,28,22
	defb 0,30,0,30,30,28,22,28,23,21,22
farben:	defb #1c,#03,#00,#00 ;1
	defb #1c,#06,#15,#15
	defb #1c,#07,#09,#09
	defb #1c,#0d,#14,#14
	defb #1c,#0e,#0b,#0b
	defb #1c,#0f,#02,#02
	defb #1c,#03,#00,#00 ;2
	defb #1c,#06,#18,#18
	defb #1c,#07,#0f,#0f
	defb #1c,#0d,#19,#19
	defb #1c,#0e,#15,#15
	defb #1c,#0f,#09,#09
	defb #1c,#03,#06,#06 ;3
	defb #1c,#06,#19,#19
	defb #1c,#07,#0d,#0d
	defb #1c,#0d,#11,#11
	defb #1c,#0e,#08,#08
	defb #1c,#0f,#04,#04
	defb #1c,#03,#19,#19 ;4
	defb #1c,#06,#0b,#0b
	defb #1c,#07,#02,#02
	defb #1c,#0d,#0f,#0f
	defb #1c,#0e,#06,#06
	defb #1c,#0f,#03,#03
fsource:	defb #15,#01,#15,#01
	defb #15,#01,#15,#01
	defb #15,#01,#15,#01
	defb #15,#01,#15,#01
	defb #15,#01,#15,#01
	defb #00,#01,#0a,#00
	defb #00,#00,#0a,#01
ssource:	defb #15,#19,#15,#19
	defb #15,#19,#00,#00
	defb #00,#00,#00,#00
	defb #00,#00,#00,#00
	defb #00,#00,#00,#00
	defb #00,#01,#03,#00
	defb #00,#00,#03,#01
neuwurm:	defb #00,#00,#00,#00
	defb #00,#00,#00,#00
	defb #00,#00,#00,#00
	defb #00,#00,#00,#00
	defb #00,#00,#00,#00
	defb #00,#01,#02,#00
	defb #00,#00,#02,#01
bildstr:	defb 12,15,1
	defb 31,8,1
	defm "scorez"
	defb 31,23,1
	defm "highz"
	defb 31,16,25
	defm "levelz"
gostr:	defb 31,14,12
	defm "             "
	defb 31,14,13
	defm "  game over  "
	defb 31,14,14
	defb "             "
soundoff:	defw 0,0,0
	defb 0,63,0,0,0
	defw 0
	defb 0
soundlang:	defw 0,350,0
	defb 1,%101101,0,16,0
	defw 1000
	defb 9
soundkurz:	defw 0,255,0
	defb 0,%111101,0,16,0
	defw 350
	defb 9
soundfk:	defb #be,#00,#00,#00
	defb #00,#00,#01,#36,#10,#00,#00,#a0
	defb #0f,#09,#ef,#00,#00,#00,#00,#00
	defb #01,#36,#10,#00,#00,#a0,#0f,#09
	defb #1c,#01,#00,#00,#00,#00,#01,#36
	defb #10,#00,#00,#e8,#03,#09
soundst:	defw 250,0,0
	defb 2,%110110,16,0,0
	defw 100
	defb 8
soundbonus:	defw 0,0,100
	defb 0,%111011,0,0,16
	defw 2000
	defb 9
matrix:	defb #00,#32,#22,#88,#88,#aa,#fa,#00 ;0 = ascii 86 = V
	defb #00,#02,#12,#88,#08,#0a,#0a,#00 ;1
	defb #00,#32,#02,#c8,#80,#a0,#fa,#00 ;2
	defb #00,#32,#02,#48,#08,#0a,#fa,#00 ;3
	defb #00,#22,#22,#c8,#08,#0a,#0a,#00 ;4 = ascii 90 = Z
	defb #00,#32,#20,#c0,#08,#0a,#f0,#00 ;5
	defb #00,#32,#20,#c8,#88,#aa,#fa,#00 ;6
	defb #00,#32,#02,#40,#40,#a0,#a0,#00 ;7
	defb #00,#32,#22,#c8,#88,#aa,#fa,#00 ;8
	defb #00,#32,#22,#c8,#08,#0a,#fa,#00 ;9
	defb #00,#00,#00,#00,#00,#00,#00,#00 ;SPACE = ascii 96 = `
	defb #00,#32,#22,#c8,#88,#aa,#aa,#00 ;A = ascii 97 = a
	defb #00,#32,#22,#c0,#88,#aa,#fa,#00 ;B
	defb #00,#32,#22,#80,#80,#aa,#fa,#00 ;C
	defb #00,#30,#22,#88,#88,#aa,#f0,#00 ;D
	defb #00,#32,#20,#c0,#80,#a0,#fa,#00 ;E
	defb #00,#32,#20,#c0,#80,#a0,#a0,#00 ;F
	defb #00,#32,#20,#88,#88,#aa,#fa,#00 ;G
	defb #00,#22,#22,#c8,#88,#aa,#aa,#00 ;H
	defb #00,#32,#10,#40,#40,#50,#fa,#00 ;I
	defb #00,#00,#00,#00,#00,#00,#00,#00 ;J = not used
	defb #00,#00,#00,#00,#00,#00,#00,#00 ;K = not used
	defb #00,#20,#20,#80,#80,#a0,#fa,#00 ;L
	defb #00,#22,#32,#c8,#88,#aa,#aa,#00 ;M
	defb #00,#32,#22,#88,#88,#aa,#aa,#00 ;N
	defb #00,#32,#22,#88,#88,#aa,#fa,#00 ;O
	defb #00,#32,#22,#c8,#80,#a0,#a0,#00 ;P
	defb #00,#00,#00,#00,#00,#00,#00,#00 ;Q = not used
	defb #00,#32,#22,#c8,#c0,#aa,#aa,#00 ;R
	defb #00,#32,#20,#c8,#08,#0a,#fa,#00 ;S
	defb #00,#32,#10,#40,#40,#50,#50,#00 ;T
	defb #00,#22,#22,#88,#88,#aa,#fa,#00 ;U
	defb #00,#22,#22,#88,#88,#50,#50,#00 ;V
	defb #00,#02,#10,#40,#40,#50,#0a,#00 ;W = Klammer auf
	defb #00,#10,#02,#08,#08,#0a,#50,#00 ;X = Klammer zu
	defb #00,#22,#22,#c8,#08,#0a,#fa,#00 ;Y
	defb #00,#00,#10,#40,#00,#50,#50,#00 ;Z = Doppelpunkt
keystr:	defb 31,5,25
	defm "game`paused ` wfirex`to`continue"
keyoff:	defb 31,5,25,18
	defb 31,16,25
	defm "levelz"
;
; Variablen
;
rndzei:	defw 1832
altrnd:	defb 111
modus:	defw mode6128
score:	defw 0
hiscore:	defw 0
lives:	defb 0
level:	defb 0
waittime:	defw 0
segm:	defb 0
wartsp:	defb 0
wart1:	defw 0
wart2:	defw 0
wart3:	defw 0
wurmsp:	defs 28
wurmf1:	defs 28
wurmf2:	defs 28
wurmf3:	defs 28
xy:	defw 0
countoff1:	defb 0
countoff2:	defb 0
countso:	defb 0
flags1:	defb 0
flags2:	defb 0
egg:	defb 0
eggxy:	defw 0
eggcount:	defb 0
bonus:	defb 0
bonusxy:	defw 0

;
; Binärdaten
;
.grafik	equ 39488 ; Grafik-Tabelle, 32 Zeichen a 16 Bytes (8 Zeilen a 2 Bytes im Mode 1)
	org 39488,grafik
	incbin "sprites.bin"
.orig	equ 31000 ; Level-Aufbau, je 500 Bytes reserviert pro Level, wird decodiert in BILD
	org 31000,orig
	incbin "mazedata.bin"
.titlescr	equ #2100 ; 16kb Screen zum direkten Kopieren in den Bildschirmspeicher
	org #2100,titlescr
	incbin "titlescreen.scr"
