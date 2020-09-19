.binarymode TI8X
.nolist
#include "ti83plus.inc"
#define ProgStart $9D95
.list
.org ProgStart - 2
.db t2ByteTok, tAsmCmp

	ld HL, $1F1A
	ld (PenCol), HL
	ld HL, msg
	b_call(_VPutS)
	ret

msg:
	.db "Hello,   world!", 0

.end
