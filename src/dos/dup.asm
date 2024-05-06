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

;	SCCSID = @(#)dup.asm	1.1 85/04/10
TITLE	DOS_DUP - Internal SFT DUP (for network SFTs)
NAME	DOS_DUP
; Low level DUP routine for use by EXEC when creating a new process. Exports
;   the DUP to the server machine and increments the SFT ref count
;
; DOS_DUP
;
;   Modification history:
;
;	Created: ARR 30 March 1983
;

;
; get the appropriate segment definitions
;
.xlist
include dosseg.asm

CODE	SEGMENT BYTE PUBLIC  'CODE'
	ASSUME	SS:DOSGROUP,CS:DOSGROUP

.xcref
INCLUDE DOSSYM.INC
INCLUDE DEVSYM.INC
.cref
.list

	i_need	THISSFT,DWORD

BREAK <DOS_DUP -- DUP SFT across network>

; Inputs:
;	[THISSFT] set to the SFT for the file being DUPed
;		(a non net SFT is OK, in this case the ref
;		 count is simply incremented)
; Function:
;	Signal to the devices that alogical open is occurring
; Returns:
;	ES:DI point to SFT
;    Carry clear
;	SFT ref_count is incremented
; Registers modified: None.
; NOTE:
;	This routine is called from $CREATE_PROCESS_DATA_BLOCK at DOSINIT
;	time with SS NOT DOSGROUP. There will be no Network handles at
;	that time.

	procedure   DOS_DUP,NEAR
	ASSUME	ES:NOTHING,SS:NOTHING

	LES	DI,ThisSFT
	Entry	Dos_Dup_Direct
	Assert	ISSFT,<ES,DI>,"DOSDup"
	invoke	IsSFTNet
	JNZ	DO_INC
	invoke	DEV_OPEN_SFT
DO_INC:
	Assert	ISSFT,<ES,DI>,"DOSDup/DoInc"
	INC	ES:[DI.sf_ref_count]	; Clears carry (if this ever wraps
					;   we're in big trouble anyway)
	return

EndProc DOS_DUP

CODE	ENDS
    END
