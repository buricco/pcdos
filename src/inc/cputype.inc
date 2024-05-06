; Copyright 1981-1988
;     International Business Machines Corp. & Microsoft Corp.
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

; Note: this must be a macro, and not a subroutine in the BIOS since
; 	it is called from both CODE and SYSINITSEG.
;
;------GET_CPU_TYPE------------------------------------------------------------May, 88 by MW
;  Returns: AX = 0 if 8086 or 8088
;              = 1 if 80286
;              = 2 if 80386
;
Get_CPU_Type	macro
	pushf
	push	bx			; preserve bx
	xor	bx, bx			; init bx to zero

	xor	ax,ax			; 0000 into AX
	push	ax			; put it on the stack...
	popf				; ...then shove it into the flags
	pushf				; get it back out of the flags...
	pop	ax			; ...and into ax
	and	ax,0F000h		; mask off high four bits
	cmp	ax,0F000h		; was it all 1's?
	je	cpu_8086		; aye; it's an 8086 or 8088

	mov	ax,0F000h		; now try to set the high four bits..
	push	ax
	popf
	pushf
	pop	ax			; ...and see what happens
	and	ax,0F000h		; any high bits set ?
	jz	cpu_286			; nay; it's an 80286

cpu_386:				; bx starts as zero
	inc	bx			; inc twice if 386
cpu_286:				; just inc once if 286
	inc	bx
cpu_8086:				; don't inc at all if 086
	mov	ax, bx			; put CPU type value in ax
	pop	bx			; restore original bx
	popf
	endm
