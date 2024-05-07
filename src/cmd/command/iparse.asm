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

 page 80,132
;	SCCSID = @(#)iparse.asm 4.1 87/04/28
TITLE	COMMAND interface to SYSPARSE

.xlist
.xcref
	INCLUDE comseg.asm		;AN000;
.list
.cref


INIT		SEGMENT PUBLIC PARA	;AN000;

ASSUME	CS:RESGROUP,DS:RESGROUP,ES:NOTHING,SS:NOTHING	;AN000;


;AD054; public	SYSPARSE		;AN000;

	DateSW	equ	0		;AN000; do not Check date format
	TimeSW	equ	0		;AN000; do not Check time format
	CmpxSW	equ	0		;AN000; do not check complex list
	KeySW	equ	0		;AN025; do not support keywords
	Val2SW	equ	0		;AN025; do not Support value definition 2
	Val3SW	equ	0		;AN000; do not Support value definition 3
	QusSW	equ	0		;AN025; do not include quoted string
	DrvSW	equ	0		;AN025; do not include drive only

.xlist
.xcref
;AD054; INCLUDE parse.asm		;AN000;
.list
.cref


INIT	    ends			;AN000;
	    end 			;AN000;
