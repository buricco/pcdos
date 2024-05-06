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

;	SCCSID = @(#)highsw.asm	1.1 85/04/10
TRUE	EQU	0FFFFH
FALSE	EQU	NOT TRUE

; Use the switches below to produce the standard Microsoft version or the IBM
; version of the operating system
MSVER	EQU	TRUE
IBM	EQU	FALSE
WANG	EQU	FALSE
ALTVECT EQU	FALSE

; Set this switch to cause DOS to move itself to the end of memory
HIGHMEM EQU	TRUE

	IF	IBM
ESCCH	EQU	0			; character to begin escape seq.
TOGLPRN EQU	TRUE			;One key toggles printer echo
ZEROEXT EQU	TRUE
	ELSE
	IF	WANG			;Are we assembling for WANG?
ESCCH	EQU	1FH			;Yes. Use 1FH for escape character
	ELSE
ESCCH	EQU	1BH
	ENDIF
CANCEL	EQU	"X"-"@" 		;Cancel with Ctrl-X
TOGLPRN EQU	FALSE			;Separate keys for printer echo on
					;and off
ZEROEXT EQU	TRUE
	ENDIF
