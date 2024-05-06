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

	PAGE ,132 ;
	TITLE MSBIO2 - BIOS

	%OUT	...MSBIO2.ASM

;==============================================================================
;REVISION HISTORY:
;AN000 - New for DOS Version 4.00 - J.K.
;AC000 - Changed for DOS Version 4.00 - J.K.
;AN00x - PTM number for DOS Version 4.00 - J.K.
;==============================================================================
;AN001; - P1820 New Message SKL file				  10/20/87 J.K.
;AN002; - P5045 New INT 2fh for Get BDS table vector for EMS	  06/06/88 J.K.
;==============================================================================

ROMSEGMENT	EQU	0F000H
MODELBYTE	EQU	DS:BYTE PTR [0FFFEH]
MODELPCJR	EQU	0FDH

	itest=0

	INCLUDE MSGROUP.INC	;DEFINE CODE SEGMENT
	INCLUDE MSEQU.INC
	INCLUDE DEVSYM.INC
	INCLUDE PUSHPOP.INC
	INCLUDE MSMACRO.INC

	ASSUME	DS:NOTHING,ES:NOTHING

	EXTRN	DSK$IN:NEAR
	EXTRN	SETPTRSAV:NEAR
	EXTRN	OUTCHR:NEAR
	EXTRN	SETDRIVE:NEAR
	EXTRN	FLUSH:NEAR
	EXTRN	HARDERR:NEAR
	EXTRN	HARDERR2:NEAR
	EXTRN	MAPERROR:NEAR
	EXTRN	GETBP:NEAR
	EXTRN	CHECKSINGLE:NEAR
	EXTRN	CHECK_TIME_OF_ACCESS:NEAR
	EXTRN	EXIT:NEAR
	EXTRN	HAS1:NEAR
	EXTRN	READ_SECTOR:NEAR
	EXTRN	INT_2F_13:FAR

	EXTRN	OLD13:DWORD

;DATA
	EXTRN	PTRSAV:DWORD		;IBMBIO1
	EXTRN	START_BDS:WORD
	EXTRN	FDRIVE1:WORD
	EXTRN	FDRIVE2:WORD
	EXTRN	FDRIVE3:WORD
	EXTRN	FDRIVE4:WORD
	EXTRN	FLAGBITS:WORD
	EXTRN	TIM_DRV:BYTE
	EXTRN	MEDBYT:BYTE
	EXTRN	DRVMAX:BYTE
	extrn	Ext_Boot_Sig:byte		;AN000; ibmbdata
	extrn	SecPerClusInSector:byte 	;AN000; ibmbdata
	extrn	Boot_Serial_L:word		;AN000; ibmbdata
	extrn	Boot_Serial_H:word		;AN000; ibmbdata

	PATHSTART 005,DISK
	EVENB
	public	Model_Byte
MODEL_BYTE DB	0FFH			; MODEL BYTE. SET UP AT INIT TIME.
					; FF - PC1
					; FE - XT (64/256K PLANAR)
					; FD - PC-JR
					; FC - PC/AT
	public	Secondary_Model_Byte
Secondary_Model_Byte db 0

	PUBLIC	ORIG19
ORIG19	DD	?

	PUBLIC	INT19SEM
INT19SEM DB	0			; INDICATE THAT ALL INT 19
					; INITIALIZATION IS COMPLETE

	IRP	AA,<02,08,09,0A,0B,0C,0D,0E,70,72,73,74,76,77>
	public	Int19OLD&AA
Int19OLD&AA	dd	-1		;Orignal hardware int. vectors for INT 19h.
	ENDM

	EVENB
	PUBLIC	DSKDRVS
DSKDRVS DW	FDRIVE1
	DW	FDRIVE2
	DW	FDRIVE3
	DW	FDRIVE4
	PUBLIC	HDSKTAB
HDSKTAB DW	HDRIVE
	DW	DRIVEX
;* Next area is reseved for mini disk BPB pointers *** J.K. 4/7/86
;* Don't change this position. Should be addressible from DskDrvs *** J.K. 4/7/86
MINI_DISK_BPB_PTRS DB 40 dup (?)   ;J.K. 4/7/86 - memory reserved for Mini disk.

	EVENB
	PUBLIC	INT_2F_NEXT
INT_2F_NEXT DD	   ?

RET_ADDR    DD	   ?

	PATHEND 005,DISK
; = = = = = = = = = = = = = = = = = = = =

;  INT19
;
;	WE "HOOK" THE INT 19 VECTOR, BECAUSE CONTRARY TO IBM DOCUMENTATION,
;  IT DOES NOT "BOOTSTRAP" THE MACHINE.  IT LEAVES MEMORY ALMOST UNTOUCHED.
;  SINCE THE BIOS_INIT CODE ASSUMES THAT CERTAIN INTERRUPT VECTORS POINT TO
;  THE ROM_BIOS  WE MUST "UNHOOK" THEM BEFORE ISSUING THE ACTUAL INT_19.
;  CURRENTLY THE ONLY VECTORS THAT NEED TO BE UNHOOKED ARE INT_19, INT_13,
;  AND THE HARDWARE INTERRUPTS.
;
	PUBLIC	INT19
INT19	PROC	FAR
	XOR	AX,AX
	MOV	DS,AX
	assume	ds:nothing
	assume	es:nothing

	LES	DI,OLD13
	MOV	DS:[13H*4],DI
	MOV	DS:[13H*4+2],ES

	CMP	BYTE PTR INT19SEM, 0
	JNZ	INT19VECS
	JMP	DOINT19

;	ON THE PCJR, DON'T REPLACE ANY VECTORS
;	MODEL BYTE DEFINITIONS FROM IBMSTACK.ASM
	MOV	AX,ROMSEGMENT
	MOV	DS,AX
	MOV	AL,MODELPCJR

	CMP	AL,MODELBYTE
	JNE	INT19VECS
	JMP	DOINT19

;Stacks code has changed these hardware interrupt vectors
;STKINIT in SYSINIT1 will initialzie Int19hOLDxx values.
INT19VECS:
	XOR	AX,AX
	MOV	DS,AX

	IRP	AA,<02,08,09,0A,0B,0C,0D,0E,70,72,73,74,76,77>

	LES	DI,Int19OLD&AA
;SB33103******************************************************************

	mov	ax,es		;
	cmp	ax,-1		;OPT 0ffffh is unlikely segment
	je	skip_int&AA	;OPT no need to check selector too 
	cmp	di,-1		;OPT 0ffffh is unlikely offset
	je	skip_int&AA

;SB33103******************************************************************
	MOV	DS:[AA&H*4],DI
	MOV	DS:[AA&H*4+2],ES
skip_int&AA:
	ENDM

DOINT19:
	LES	DI,ORIG19
	MOV	DS:[19H*4],DI
	MOV	DS:[19H*4+2],ES

	INT	19H
INT19	ENDP

	ASSUME	DS:CODE
	PUBLIC	DSK$INIT
DSK$INIT PROC	NEAR
	PUSH	CS
	POP	DS
	MOV	AH,BYTE PTR DRVMAX
	MOV	DI,OFFSET DSKDRVS
	JMP	SETPTRSAV
DSK$INIT ENDP

;
; INT 2F HANDLER FOR EXTERNAL BLOCK DRIVERS TO COMMUNICATE WITH THE INTERNAL
; BLOCK DRIVER IN IBMDISK. THE MULTIPLEX NUMBER CHOSEN IS 8. THE HANDLER
; SETS UP THE POINTER TO THE REQUEST PACKET IN [PTRSAV] AND THEN JUMPS TO
; DSK$IN, THE ENTRY POINT FOR ALL DISK REQUESTS.
; ON EXIT FROM THIS DRIVER (AT EXIT), WE WILL RETURN TO THE EXTERNAL DRIVER
; THAT ISSUED THIS INT 2F, AND CAN THEN REMOVE THE FLAGS FROM THE STACK.
; THIS SCHEME ALLOWS US TO HAVE A SMALL EXTERNAL DEVICE DRIVER, AND MAKES
; THE MAINTAINANCE OF THE VARIOUS DRIVERS (DRIVER AND IBMBIO) MUCH EASIER,
; SINCE WE ONLY NEED TO MAKE CHANGES IN ONE PLACE (MOST OF THE TIME).
;
; 06/03/88 J.K. When AL=3, return DS:DI -> Start of BDS table.
;	   (EMS device driver hooks INT 13h to handle 16KB DMA overrun
;	    problem.  BDS table is going to be used to get head/sector
;	    informations without calling Generic IOCTL Get Device Parm call.)
;
; AL CONTAINS THE INT2F FUNCTION:
;   0 - CHECK FOR INSTALLED HANDLER - RESERVED
;   1 - INSTALL THE BDS INTO THE LINKED LIST
;   2 - DOS REQUEST
;   3 - Get BDS vector				;06/03/88 J.K.
;	Return BDS table starting pointer in DS:DI

MYNUM	EQU	8

	PUBLIC	INT2F_DISK
INT2F_DISK PROC FAR
	CMP	AH,MYNUM
	JE	MINE
	JMP	CS:[INT_2F_NEXT]	; CHAIN TO NEXT INT 2F HANDLER
MINE:
	CMP	AL,0F8H 		; IRET ON RESERVED FUNCTIONS
	JB	DO_FUNC
	IRET
DO_FUNC:
	OR	AL,AL			; A GET INSTALLED STATE REQUEST?
	JNE	DISP_FUNC
	MOV	AL,0FFH
	IRET
DISP_FUNC:
	MESSAGE FTESTINIT,<"INT2F_DISK",CR,LF>
	CMP	AL,1			; REQUEST FOR INSTALLING BDS?
	JNE	DO_DOS_REQ
	CALL	INSTALL_BDS
	IRET

DO_DOS_REQ:
; SET UP POINTER TO REQUEST PACKET
	cmp	al, 3			;AN002; Get BDS vector?
	je	DO_Get_BDS_Vector	;AN002;
	MOV	WORD PTR CS:[PTRSAV],BX ;othrwise DOS function.
	MOV	WORD PTR CS:[PTRSAV+2],ES
	JMP	DSK$IN

DO_Get_BDS_Vector:			;AN002; AL=3
	push	cs			;AN002;
	pop	ds			;AN002;
	mov	di, Start_BDS		;AN002;
	IRET				;AN002;

INT2F_DISK ENDP

;
; INSTALL_BDS INSTALLS A BDS A LOCATION DS:DI INTO THE CURRENT LINKED LIST OF
; BDS MAINTAINED BY THIS DEVICE DRIVER. IT PLACES THE BDS AT THE END OF THE
; LIST.
	PUBLIC	INSTALL_BDS
INSTALL_BDS PROC NEAR
	MESSAGE FTESTINIT,<"INSTALL BDS",CR,LF>
; DS:DI POINT TO BDS TO BE INSTALLED
	LES	SI,DWORD PTR CS:[START_BDS] ; START AT BEGINNING OF LIST
	PUSH	ES			; SAVE POINTER TO CURRENT BDS
	PUSH	SI
; ES:SI NOW POINT TO BDS IN LINKED LIST
LOOP_NEXT_BDS:
	CMP	SI,-1			; GOT TO END OF LINKED LIST?
	JZ	INSTALL_RET
; IF WE HAVE SEVERAL LOGICAL DRIVES USING THE SAME PHYSICAL DRIVE, WE MUST
; SET THE I_AM_MULT FLAG IN EACH OF THE APPROPRIATE BDSS.
	MOV	AL,BYTE PTR DS:[DI].DRIVENUM
	CMP	BYTE PTR ES:[SI].DRIVENUM,AL
	JNZ	NEXT_BDS
	MESSAGE FTESTINIT,<"LOGICAL DRIVES",CR,LF>
	XOR	BX,BX
	MOV	BL,FI_AM_MULT
	OR	WORD PTR DS:[DI].FLAGS,BX ; SET FLAGS IN BOTH BDSS CONCERNED
	OR	WORD PTR ES:[SI].FLAGS,BX
	MOV	BL,FI_OWN_PHYSICAL
	XOR	BX,-1
	AND	WORD PTR DS:[DI].FLAGS,BX ; RESET THAT FLAG FOR 'NEW' BDS
; WE MUST ALSO SET THE FCHANGELINE BIT CORRECTLY.
	MOV	BX,WORD PTR ES:[SI].FLAGS ; DETERMINE IF CHANGELINE AVAILABLE
	AND	BL,FCHANGELINE
	XOR	BH,BH
	OR	WORD PTR DS:[DI].FLAGS,BX

NEXT_BDS:
; BEFORE MOVING TO NEXT BDS, PRESERVE POINTER TO CURRENT ONE. THIS IS NEEDED AT
; THE END WHEN THE NEW BDS IS LINKED INTO THE LIST.
	POP	BX			; DISCARD PREVIOUS POINTER TO BDS
	POP	BX
	PUSH	ES
	PUSH	SI
	MOV	BX,WORD PTR ES:[SI].LINK + 2
	MOV	SI,WORD PTR ES:[SI].LINK
	MOV	ES,BX
	JMP	SHORT LOOP_NEXT_BDS

INSTALL_RET:
	POP	SI			; RETRIEVE POINTER TO LAST BDS
	POP	ES			; IN LINKED LIST.
	MOV	AX,DS
	MOV	WORD PTR ES:[SI].LINK+2,AX ; INSTALL BDS
	MOV	WORD PTR ES:[SI].LINK,DI
	MOV	WORD PTR DS:[DI].LINK,-1 ; SET NEXT POINTER TO NULL
	RET
INSTALL_BDS ENDP

;
; RE_INIT INSTALLS THE INT 2F VECTOR THAT WILL HANDLE COMMUNICATION BETWEEN
; EXTERNAL BLOCK DRIVERS AND THE INTERNAL DRIVER. IT ALSO INSTALLS THE
; RESET_INT_13 INTERFACE.  IT IS CALLED BY SYSYINIT
;
	PUBLIC	RE_INIT
RE_INIT PROC	FAR
	MESSAGE FTESTINIT,<"REINIT",CR,LF>
	PUSH	AX
	PUSH	DS
	PUSH	DI
	XOR	DI,DI
	MOV	DS,DI
	MOV	DI,2FH*4		; POINT IT TO INT 2F VECTOR
	MOV	AX,WORD PTR DS:[DI]
	MOV	WORD PTR CS:[INT_2F_NEXT],AX
	MOV	AX,WORD PTR DS:[DI+2]	; PRESERVE OLD INT 2F VECTOR
	MOV	WORD PTR CS:[INT_2F_NEXT+2],AX

; INSTALL THE RESET_INT_13
; INTERFACE

;
; THE FOLLOWING TWO LINES ARE NOT NEEDED ANYMORE BECAUSE THE LINK HAS BEEN
; HARD-WIRED INTO THE CODE AT NEXT2F_13. - RAJEN.
;------------------------------------------------------------------------------
;	 MOV	 WORD PTR CS:[NEXT2F_13],OFFSET INT2F_DISK ; PRESERVE INT2F_DISK POINTER
;	 MOV	 WORD PTR CS:[NEXT2F_13+2],CS
;------------------------------------------------------------------------------

	CLI
	MOV	WORD PTR DS:[DI],OFFSET INT_2F_13 ; INSTALL NEW VECTORS
	MOV	WORD PTR DS:[DI+2],CS
	STI
	POP	DI
	POP	DS
	POP	AX

	RET

RE_INIT ENDP

;-------------------------------------------------
;
;  ASK TO SWAP THE DISK IN DRIVE A:
;
	PUBLIC	SWPDSK
SWPDSK	PROC	NEAR
	MOV	AL,BYTE PTR DS:[DI].DRIVELET ; GET THE DRIVE LETTER
;USING A DIFFERENT DRIVE IN A ONE DRIVE SYSTEM SO REQUEST THE USER CHANGE DISKS
	ADD	AL,"A"
	MOV	CS:DRVLET,AL
	PUSH	DS			; PRESERVE SEGMENT REGISTER
	PUSH	CS
	POP	DS
	MOV	SI,OFFSET SNGMSG	; DS:SI -> MESSAGE
	PUSH	BX
	CALL	WRMSG			;PRINT DISK CHANGE MESSAGE
	CALL	FLUSH
;SB33003***************************************************************
	xor	AH, AH			; set command to read character;SB
	int	16h			; call rom-bios 	       ;SB
;SB33003***************************************************************
	POP	BX
	POP	DS			; RESTORE SEGMENT REGISTER
WRMRET:
	RET
SWPDSK	ENDP

;----------------------------------------------
;
;	WRITE OUT MESSAGE POINTED TO BY [SI]
;
	PUBLIC	WRMSG
WRMSG	PROC	NEAR
	LODSB				;GET THE NEXT CHARACTER OF THE MESSAGE
	OR	AL,AL			;SEE IF END OF MESSAGE
	JZ	WRMRET
;	INT	CHROUT
	PUSHF
	PUSH	CS
	CALL	OUTCHR
	JMP	SHORT WRMSG
WRMSG	ENDP

;	 INCLUDE BIOMES.INC
         include MSBIO.CL2

;
; END OF SUPPORT FOR MULTIPLE FLOPPIES WITH NO LOGICAL DRIVES
; THIS IS NOT 'SPECIAL' ANY MORE BECAUSE WE NOW HAVE THE CAPABILITY OF
; DEFINING LOGICAL DRIVES IN CONFIG.SYS. WE THEREFORE KEEP THE CODE FOR
; SWAPPING RESIDENT ALL THE TIME.
;

;J.K. 10/1/86 *******************************************************
;Variables for Dynamic Relocatable modules
;These should be stay resident.

	public	INT6C_RET_ADDR
INT6C_RET_ADDR	DD	?		; return address from INT 6C for P12 machine

	PATHSTART 001,CLK
;
;   DATA STRUCTURES FOR REAL-TIME DATE AND TIME
;
	public	BIN_DATE_TIME
	public	MONTH_TABLE
	public	DAYCNT2
	public	FEB29
BIN_DATE_TIME:
	DB	0		; CENTURY (19 OR 20) OR HOURS (0-23)
	DB	0		; YEAR IN CENTURY (0...99) OR MINUTES (0-59)
	DB	0		; MONTH IN YEAR (1...12) OR SECONDS (0-59)
	DB	0		; DAY IN MONTH (1...31)
MONTH_TABLE:			;
	DW	0		;MJB002 JANUARY
	DW	31		;MJB002 FEBRUARY
	DW	59		;MJB002
	DW	90		;MJB002
	DW	120		;MJB002
	DW	151		;MJB002
	DW	181		;MJB002
	DW	212		;MJB002
	DW	243		;MJB002
	DW	273		;MJB002
	DW	304		;MJB002
	DW	334		;MJB002 DECEMBER
DAYCNT2 DW	0000		;MJB002 TEMP FOR COUNT OF DAYS SINCE 1-1-80
FEB29	DB	0		;MJB002 FEBRUARY 29 IN A LEAP YEAR FLAG
	PATHEND 001,CLK

;********************************************************************
;

	PUBLIC	ENDFLOPPY
ENDFLOPPY LABEL BYTE
;
; END OF CODE FOR VIRTUAL FLOPPY DRIVES
;
	PUBLIC	ENDSWAP
ENDSWAP LABEL	BYTE

	PATHSTART 004,BIO

	PUBLIC	HNUM
HNUM	DB	0			;NUMBER OF HARDFILES
	PUBLIC	HARDDRV
HARDDRV DB	80H			;PHYSICAL DRIVE NUMBER OF FIRST HARDFILE
;**********************************************************************
;	"HDRIVE" IS A HARD DISK WITH 512 BYTE SECTORS
;*********************************************************************
	EVENB
	PUBLIC	BDSH
BDSH	DW	-1			;LINK TO NEXT STRUCTURE
	DW	CODE
	DB	80			;INT 13 DRIVE NUMBER
	DB	"C"                     ;LOGICAL DRIVE LETTER
	PUBLIC	HDRIVE
HDRIVE:
	DW	512
	DB	1			;SECTORS/ALLOCATION UNIT
	DW	1			;RESERVED SECTORS FOR DOS
	DB	2			;NO. OF ALLOCATION TABLES
	DW	16			;NUMBER OF DIRECTORY ENTRIES
	DW	0000			;NUMBER OF SECTORS (AT 512 BYTES EACH)
	DB	11111000B		;MEDIA DESCRIPTOR
	DW	1			;NUMBER OF FAT SECTORS
	DW	00			;SECTOR LIMIT
	DW	00			;HEAD LIMIT
	DW	00			;HIDDEN SECTOR COUNT(low)
	dw	00			;AN000;  Hidden Sector (high)
	dw	00			;AN000;  Number of Sectors (low)
	dw	00			;AN000;  Number of Sectors (high)
	DB	0			; TRUE => BIGFAT
OPCNTH	DW	0			;OPEN REF. COUNT
	DB	3			;FORM FACTOR
FLAGSH	DW	0020H			;VARIOUS FLAGS
;	DB	9 DUP (0)		;RESERVED FOR FUTURE USE
	DW	40			; NUMBER OF CYLINDERS
RECBPBH DB	31 DUP (?)		; RECOMMENDED BPB FOR DRIVE
TRACKH	DB	-1			;LAST TRACK ACCESSED ON THIS DRIVE
TIM_LOH DW	-1			;KEEP THESE TWO CONTIGUOUS (?)
TIM_HIH DW	-1
VOLIDH	DB	"NO NAME    ",0         ;AN000; VOLUME ID FOR THIS DISK
VolSerH dd	0	      ;AN000; Current volume serial number from Boot record
SysIDH	db	"FAT12   " ,0 ;AN000; Current file system id from Boot record

;
; END OF SINGLE HARD DISK SECTION
;
	PUBLIC	ENDONEHARD
ENDONEHARD LABEL BYTE
;**********************************************************************
;	"DRIVEX " IS AN EXTRA TYPE OF DRIVE USUALLY RESERVED FOR AN
;	ADDITIONAL HARD FILE
;*********************************************************************
	EVENB
	PUBLIC	BDSX
BDSX	DW	-1			;LINK TO NEXT STRUCTURE
	DW	CODE
	DB	81			;INT 13 DRIVE NUMBER
	DB	"D"                     ;LOGICAL DRIVE LETTER
	PUBLIC	DRIVEX
DRIVEX:
	DW	512
	DB	00			;SECTORS/ALLOCATION UNIT
	DW	1			;RESERVED SECTORS FOR DOS
	DB	2			;NO. OF ALLOCATION TABLES
	DW	0000			;NUMBER OF DIRECTORY ENTRIES
	DW	0000			;NUMBER OF SECTORS (AT 512 BYTES EACH)
	DB	11111000B		;MEDIA DESCRIPTOR
	DW	0000			;NUMBER OF FAT SECTORS
	DW	00			;SECTOR LIMIT
	DW	00			;HEAD LIMIT
	DW	00			;HIDDEN SECTOR COUNT (low)
	dw	00			;AN000;  Hidden Sector (high)
	dw	00			;AN000;  Number of Sectors (low)
	dw	00			;AN000;  Number of Sectors (high)
	DB	0			; TRUE => BIGFAT
OPCNTD	DW	0			;OPEN REF. COUNT
	DB	3			;FORM FACTOR
FLAGSD	DW	0020H			;VARIOUS FLAGS
;	DB	9 DUP (0)		;RESERVED FOR FUTURE USE
	DW	40			; NUMBER OF CYLINDERS
RECBPBD DB	31 DUP (?)		; RECOMMENDED BPB FOR DRIVE
TRACKD	DB	-1			;LAST TRACK ACCESSED ON THIS DRIVE
TIM_LOD DW	-1			;KEEP THESE TWO CONTIGUOUS (?)
TIM_HID DW	-1
VOLIDD	DB	"NO NAME    ",0         ;AN000; VOLUME ID FOR THIS DISK
VolSerD dd	0	      ;AN000; Current volume serial number from Boot record
SysIDD	db	"FAT12   " ,0 ;AN000; Current file system id from Boot record

;
; END OF SECTION FOR TWO HARD DISKS
	PUBLIC	ENDTWOHARD
ENDTWOHARD LABEL BYTE

	PATHEND 004,BIO

	PUBLIC	TWOHARD
TWOHARD LABEL	BYTE
	PAGE
	INCLUDE MS96TPI.INC

;*********************************************************************
;Memory allocation for BDSM table. - J.K. 2/21/86
;*********************************************************************
	PUBLIC BDSMs
BDSMs	BDSM_type Max_mini_dsk_num dup (<>)	;currently max. 23

;** End_of_BDSM defined in IBMINIT.ASM will be used to set the appropriate
;** ending address of BDSM table.

;
;;3.3 BUG FIX -SP ------------------------------
;;Migrated into 4.00 -MRW
;Paragraph buffer between the BDSMs and MSHARD
;
;The relocation code for MSHARD needs this. this cannot be used for 
;anything. nothing can come before this or after this.....IMPORTANT!!!!
;don't get too smart and using this buffer for anything!!!!!!
;
	db	16 dup(0)
;
;end of bug fix buffer
;;
;;3.3 BUG FIX -SP------------------------------

CODE	ENDS
	END
