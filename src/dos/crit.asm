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

;	SCCSID = @(#)crit.asm	1.1 85/04/10
TITLE CRIT - Critical Section Routines
NAME  CRIT
;
; Critical Section Routines
;
;   Critical section handlers
;
;   Modification history:
;
;       Created: ARR 30 March 1983
;

.xlist
;
; get the appropriate segment definitions
;
include dosseg.asm

CODE    SEGMENT BYTE PUBLIC  'CODE'
	ASSUME  SS:NOTHING,CS:DOSGROUP

.xcref
INCLUDE DOSSYM.INC
.cref
.list

	I_need  User_In_AX,WORD
	i_need  CurrentPDB,WORD
if debug
	I_need  BugLev,WORD
	I_need  BugTyp,WORD
include bugtyp.asm
endif

Break   <Critical section handlers>

;
;   Each handler must leave everything untouched; including flags!
;
;   Sleaze for time savings:  first instruction is a return.  This is patched
;   by the sharer to be a PUSH AX to complete the correct routines.
;
Procedure   EcritDisk,NEAR
	public  EcritMem
	public  EcritSFT
ECritMEM    LABEL   NEAR
ECritSFT    LABEL   NEAR
	RET
;       PUSH    AX
	fmt     TypSect,LevReq,<"PDB $x entering $x">,<CurrentPDB,sect>
	MOV     AX,8000h+critDisk
	INT     int_ibm
	POP     AX
	return
EndProc EcritDisk

Procedure   LcritDisk,NEAR
	public  LcritMem
	public  LcritSFT
LCritMEM    LABEL   NEAR
LCritSFT    LABEL   NEAR
	RET
;       PUSH    AX
	fmt     TypSect,LevReq,<"PDB $x entering $x">,<CurrentPDB,sect>
	MOV     AX,8100h+critDisk
	INT     int_ibm
	POP     AX
	return
EndProc LcritDisk

Procedure   EcritDevice,NEAR
	RET
;       PUSH    AX
	fmt     TypSect,LevReq,<"PDB $x entering $x">,<CurrentPDB,sect>
	MOV     AX,8000h+critDevice
	INT     int_ibm
	POP     AX
	return
EndProc EcritDevice

Procedure   LcritDevice,NEAR
	RET
;       PUSH    AX
	MOV     AX,8100h+critDevice
	INT     int_ibm
	POP     AX
	return
EndProc LcritDevice

CODE    ENDS
    END
