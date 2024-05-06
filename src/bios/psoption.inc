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

;*******************************************************************
; Parser Options set for IBMBIO SYSCONF module
;*******************************************************************
;
;**** Default assemble swiches definition **************************

IFNDEF	FarSW
FarSW	equ	0	; Near call expected
ENDIF

IFNDEF	DateSW
DateSW	equ	0	; Check date format
ENDIF

IFNDEF	TimeSW
TimeSW	equ	0	; Check time format
ENDIF

IFNDEF	FileSW
FileSW	equ	1	; Check file specification
ENDIF

IFNDEF	CAPSW
CAPSW	equ	0	; Perform CAPS if specified
ENDIF

IFNDEF	CmpxSW
CmpxSW	equ	0	; Check complex list
ENDIF

IFNDEF	NumSW
NumSW	equ	1	; Check numeric value
ENDIF

IFNDEF	KeySW
KeySW	equ	0	; Support keywords
ENDIF

IFNDEF	SwSW
SwSW	equ	1	; Support switches
ENDIF

IFNDEF	Val1SW
Val1SW	equ	1	; Support value definition 1
ENDIF

IFNDEF	Val2SW
Val2SW	equ	0	; Support value definition 2
ENDIF

IFNDEF	Val3SW
Val3SW	equ	1	; Support value definition 3
ENDIF

IFNDEF	DrvSW
DrvSW	equ	1	; Support drive only format
ENDIF

IFNDEF	QusSW
QusSW	equ	0	; Support quoted string format
ENDIF
