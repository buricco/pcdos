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

;Structure, Equtes for DEVMARK for MEM command.

DEVMARK struc
DEVMARK_ID	  db	  0
DEVMARK_SEG	  dw	  0
DEVMARK_SIZE	  dw	  0
DEVMARK_DUM	  db	  3 dup (?)
DEVMARK_FILENAME  db	  8 dup (' ')
DEVMARK ends

DEVMARK_STK	equ	'S'
DEVMARK_DEVICE	equ	'D'
DEVMARK_IFS	equ	'I'
DEVMARK_BUF	equ	'B'
DEVMARK_CDS	equ	'L' ;lastdrive
DEVMARK_FILES	equ	'F'
DEVMARK_FCBS	equ	'X'
DEVMARK_INST	equ	'T' ;used for SYSINIT BASE for INSTALL= command.
DEVMARK_EMS_STUB equ	'E'

SETBRKDONE	equ	00000001b
FOR_DEVMARK	equ	00000010b
NOT_FOR_DEVMARK equ	11111101b
