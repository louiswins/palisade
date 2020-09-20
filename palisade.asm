.binarymode TI8X
.nolist
#include "ti83plus.inc"
#define ProgStart $9D95
LineDispStart equ PlotSScreen + 3 * 12
.list
.org ProgStart - 2
.db t2ByteTok, tAsmCmp

	b_call(_GrBufClr)
	; display text on the graph screen
	set TextWrite, (IY + SGrFlags)
	; turn off run indicator
	res IndicRun, (IY + IndicFlags)
;	; allow drawing on last column
;	set FullScrnDraw, (IY + ApiFlg4)


; display lines

; vertical
	ld DE, LineDispStart
	ld A, 57 ; rows of vertical lines
VertRow:
	ld HL, VertLineMask
	ld BC, 12
	ldir
	dec A
	jr NZ, VertRow

; horizontal
	ld HL, LineDispStart
	ld C, 8
HorizLine:

	ld B, 12
HorizByte:
	ld (HL), $FF
	inc HL
	djnz HorizByte

	ld A, L
	add A, 84
	ld L, A
	jr NC, NoCarry
	inc H
NoCarry:
	dec C
	jr NZ, HorizLine

; print numbers

	ld HL, $0401
	ld (PenCol), HL
	ld HL, Puzzle
	ld B, 7
DispPuzzRow:
	push BC
	ld B, 19
DispPuzzCol:
	ld C, 5
	ld A, (HL)
	cp '.'
	jr Z, SkipClue
	ld C, 1 ; only bump PenCol by one because VPutMap adds 4
	b_call(_VPutMap)
SkipClue:
	inc HL
	ld A, (PenCol)
	add A, C
	ld (PenCol), A
	djnz DispPuzzCol

	; increment row
	ld A, (PenRow)
	add A, 8
	ld (PenRow), A
	; increment column
	ld A, 1
	ld (PenCol), A
	pop BC
	djnz DispPuzzRow

	b_call(_GrBufCpy)

	b_call(_GetKey)
	ret

Puzzle:
	.db "..112......1..1...."
	.db "22..3.....0......0."
	.db "..2..1..0.....11..3"
	.db ".....1222.........2"
	.db ".........1........1"
	.db "12..02.3..321....23"
	.db "..1..3.1...31....2."

VertLineMask:
	.db %10000100, %00100001, %00001000, %01000010, %00010000, %10000100, %00100001, %00001000, %01000010, %00010000, %10000100, %00100001

.end
