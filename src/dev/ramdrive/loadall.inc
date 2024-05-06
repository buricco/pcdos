; Copyright 1985-1988 Microsoft Corp.
;
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the Software), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
;
; The above copyright notice and this permission notice shall be included in
; all copies or substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT,TORT OR OTHERWISE, ARISING FROM,
; OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
; THE SOFTWARE.

BREAK	<LOADALL descriptor caches>

DEF_ACCESS	EQU	92H
DEF_LIMIT	EQU	0FFFFH

SEGREG_DESCRIPTOR STRUC
SEG_BASE	DW	?
		DB	?
SEG_ACCESS	DB	DEF_ACCESS
SEG_LIMIT	DW	DEF_LIMIT
SEGREG_DESCRIPTOR ENDS

DTR_DESCRIPTOR STRUC
DTR_BASE	DW	?
		DB	?
		DB	0
DTR_LIMIT	DW	?
DTR_DESCRIPTOR ENDS
;
; 386 Descriptor template
;
desc	struc
lim_0_15	dw	0		; limit bits (0..15)
bas_0_15	dw	0		; base bits (0..15)
bas_16_23	db	0		; base bits (16..23)
access		db	0		; access byte
gran		db	0		; granularity byte
bas_24_31	db	0		; base bits (24..31)
desc	ends

gdt_descriptor	struc
gdt_limit	dw	?
gdt_base_0	dw	?
gdt_base_2	dw	?
gdt_descriptor	ends
