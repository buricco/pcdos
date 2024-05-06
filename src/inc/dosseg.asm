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

;	SCCSID = @(#)dosseg.asm	1.1 85/04/10
;
; segment ordering for MSDOS

START		SEGMENT BYTE PUBLIC 'START'
START		ENDS

CONSTANTS	SEGMENT WORD PUBLIC 'CONST'
CONSTANTS	ENDS

DATA		SEGMENT WORD PUBLIC 'DATA'
DATA		ENDS

TABLE		SEGMENT BYTE PUBLIC 'TABLE'
TABLE		ENDS

CODE		SEGMENT BYTE PUBLIC 'CODE'
CODE		ENDS

LAST		SEGMENT PARA PUBLIC 'LAST'
LAST		ENDS

DOSGROUP    GROUP   START,CONSTANTS,DATA,TABLE,CODE,LAST
