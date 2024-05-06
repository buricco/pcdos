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

; The following structure defines the disk parameter table
; pointed to by Interrupt vector 1EH (location 0:78H)

DISK_PARMS	STRUC
DISK_SPECIFY_1	DB	?
DISK_SPECIFY_2	DB	?
DISK_MOTOR_WAIT DB	?	; Wait till motor off
DISK_SECTOR_SIZ DB	?	; Bytes/Sector (2 = 512)
DISK_EOT	DB	?	; Sectors per track (MAX)
DISK_RW_GAP	DB	?	; Read Write Gap
DISK_DTL	DB	?
DISK_FORMT_GAP	DB	?	; Format Gap Length
DISK_FILL	DB	?	; Format Fill Byte
DISK_HEAD_STTL	DB	?	; Head Settle Time (MSec)
DISK_MOTOR_STRT DB	?	; Motor start delay
DISK_PARMS	ENDS

ROMStatus	equ	1
ROMRead 	equ	2
ROMWrite	equ	3
ROMVerify	equ	4
ROMFormat	equ	5
