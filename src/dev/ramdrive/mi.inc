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

BREAK <Machine instruction, flag definitions and character types>

mi_INT		EQU	0CDh
mi_Long_JMP	EQU	0EAh
mi_Long_CALL	EQU	09Ah
mi_Long_RET	EQU	0CBh
mi_Near_RET	EQU	0C3h

;			xxxxoditszxaxpxc
f_Overflow	EQU	0000100000000000B
f_Direction	EQU	0000010000000000B
f_Interrupt	EQU	0000001000000000B
f_Trace 	EQU	0000000100000000B
f_Sign		EQU	0000000010000000B
f_Zero		EQU	0000000001000000B
f_Aux		EQU	0000000000010000B
f_Parity	EQU	0000000000000100B
f_Carry 	EQU	0000000000000001B
