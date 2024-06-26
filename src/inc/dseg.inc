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

;---Revised 8-17-84 FOR KBX	(ADDED ADDITIONAL KEYBOARD FLAG - KB_FLAG_3)
;----------------------------------------
;	 0286 INTERRUPT LOCATIONS (READ):
;----------------------------------------
ABS0	SEGMENT AT 0
STG_LOC0		LABEL	BYTE
	ORG 2*4
NMI_PTR 		LABEL	WORD
	ORG 5*4
INT5_PTR		LABEL	WORD
	ORG 8*4
INT_ADDR		LABEL	WORD
INT_PTR 		LABEL	DWORD
	ORG 10H*4
VIDEO_INT		LABEL	WORD
	ORG 13H*4			; NEW FDISK
ORG_VECTOR		LABEL	DWORD
	ORG 18H*4
BASIC_PTR		LABEL	WORD
	ORG 19H*4
BOOT_VEC		LABEL	DWORD
BOOT_VECTOR		LABEL	DWORD
	ORG 1DH*4
PARM_PTR		LABEL	DWORD	; POINTER TO VIDEO PARMS
	ORG 1EH*4
DISK_POINTER		LABEL	DWORD
	ORG 01FH*4
EXT_PTR 		LABEL	DWORD
	ORG 40H*4			; DISKETTE POINTER
DISK_VECTOR		LABEL	DWORD
       ORG 41H*4
HF_TBL_VEC		LABEL	DWORD
	ORG 46H*4
HF1_TBL_VEC		LABEL	DWORD
	ORG 70H*4
SLAVE_INT_PTR		LABEL	DWORD
RTC_INT_VEC		LABEL	DWORD	; REAL TIME CLOCK INT
	ORG 76H*4			; FIXED DISK INTERRUPT VECTOR
HDISK_INT		LABEL	DWORD
	ORG	400H
DATA_AREA		 LABEL BYTE	;ABSOLUTE LOCATION OF DATA SEGMENT
DATA_WORD		 LABEL WORD
	ORG	0500H
MFG_TEST_RTN		 LABEL	FAR
	ORG	7C00H
BOOT_LOCN		 LABEL	FAR
ABS0	ENDS
PAGE
;------------------------------------------------
; STACK -- USED DURING INITIALIZATION ONLY	:
;------------------------------------------------
STACK	SEGMENT AT 30H
	DW	128 DUP(?)
TOS	LABEL	WORD
STACK	ENDS
;----------------------------------------
;	ROM BIOS DATA AREAS		:
;----------------------------------------
DATA	SEGMENT AT 40H
;DATA_BASE	 LABEL	 BYTE
RS232_BASE	DW	4 DUP(?)	; ADDRESSES OF RS232 ADAPTERS
PRINTER_BASE	DW	4 DUP(?)	; ADDRESSES OF PRINTERS
EQUIP_FLAG	DW	1 DUP(?)	; INSTALLED HARDWARE
MFG_TST 	DB	1 DUP(?)	; INITIALIZATION FLAG
MEMORY_SIZE	DW	1 DUP(?)	; MEMORY SIZE IN K BYTES
MFG_ERR_FLAG	DB	1 DUP(?)	; SCRATCHPAD FOR MANUFACTURING
		DB	1 DUP(?)	; ERROR CODES
PAGE
;----------------------------------------
;	KEYBOARD DATA AREAS		:
;----------------------------------------
KB_FLAG 	DB	1 DUP(?)
KB_FLAG_1	DB	1 DUP(?)	; SECOND BYTE OF KEYBOARD STATUS
ALT_INPUT	DB	1 DUP(?)	; STORAGE FOR ALTERNATE KEYPAD ENTRY
BUFFER_HEAD	DW	1 DUP(?)	; POINTER TO HEAD OF KEYBOARD BUFFER
BUFFER_TAIL	DW	1 DUP(?)	; POINTER TO TAIL OF KEYBOARD BUFFER
KB_BUFFER	DW	16 DUP(?)	; ROOM FOR 15 ENTRIES
KB_BUFFER_END	LABEL	WORD

;------ HEAD = TAIL INDICATES THAT THE BUFFER IS EMPTY

;----------------------------------------
;	DISKETTE DATA AREAS		:
;----------------------------------------
SEEK_STATUS	DB	1 DUP(?)	; DRIVE RECALIBRATION STATUS
					; BIT 3-0 = DRIVE 3-0 NEEDS RECAL
					; BEFORE NEXT SEEK IF BIT IS = 0
MOTOR_STATUS	DB	1 DUP(?)	; MOTOR STATUS
					; BIT 3-0 = DRIVE 3-0 IS CURRENTLY
					;   RUNNING
					; BIT 7 = CURRENT OPERATION IS A WRITE,
					;   REQUIRES DELAY
MOTOR_COUNT	DB	1 DUP(?)	; TIME OUT COUNTER FOR DRIVE TURN OFF
DISKETTE_STATUS DB	1 DUP(?)	; RETURN CODE STATUS BYTE
CMD_BLOCK	LABEL	BYTE
HD_ERROR	LABEL	BYTE
NEC_STATUS	DB	7 DUP(?)	; STATUS BYTES FROM NEC
PAGE
;----------------------------------------
;	VIDEO DISPLAY DATA AREA 	:
;----------------------------------------
CRT_MODE	DB	1 DUP(?)	; CURRENT CRT MODE
CRT_COLS	DW	1 DUP(?)	; NUMBER OF COLUMNS ON SCREEN
CRT_LEN 	DW	1 DUP(?)	; LENGTH OF REGEN IN BYTES
CRT_START	DW	1 DUP(?)	; STARTING ADDRESS IN REGEN BUFFER
CURSOR_POSN	DW	8 DUP(?)	; CURSOR FOR EACH OF UP TO 8 PAGES
CURSOR_MODE	DW	1 DUP(?)	; CURRENT CURSOR MODE SETTING
ACTIVE_PAGE	DB	1 DUP(?)	; CURRENT PAGE BEING DISPLAYED
ADDR_6845	DW	1 DUP(?)	; BASE ADDRESS FOR ACTIVE DISPLAY CARD
CRT_MODE_SET	DB	1 DUP(?)	; CURRENT SETTING OF THE 3X8 REGISTER
CRT_PALLETTE	DB	1 DUP(?)	; CURRENT PALLETTE SETTING COLOR CARD
PAGE
;----------------------------------------
;	POST DATA AREA			:
;----------------------------------------
IO_ROM_INIT	DW	1 DUP(?)	; PNTR TO OPTIONAL I/O ROM INIT ROUTINE
IO_ROM_SEG	DW	1 DUP(?)	; POINTER TO IO ROM SEGMENT
INTR_FLAG	DB	1 DUP(?)	; FLAG TO INDICATE AN INTERRUPT HAPPEND
;----------------------------------------
;	TIMER DATA AREA 		:
;----------------------------------------
TIMER_LOW	DW	1 DUP(?)	; LOW WORD OF TIMER COUNT
TIMER_HIGH	DW	1 DUP(?)	; HIGH WORD OF TIMER COUNT
TIMER_OFL	DB	1 DUP(?)	; TIMER HAS ROLLED OVER SINCE LAST READ
;----------------------------------------
;	SYSTEM DATA AREA		:
;----------------------------------------
BIOS_BREAK	DB	1 DUP(?)	; BIT 7=1 IF BREAK KEY HAS BEEN HIT
RESET_FLAG	DW	1 DUP(?)	; WORD=1234H IF KEYBOARD RESET UNDERWAY
PAGE
;----------------------------------------
;	HARD FILE DATA AREAS		:
;----------------------------------------
DISK_STATUS1	DB	1 DUP(?)
HF_NUM		DB	1 DUP(?)
CONTROL_BYTE	DB	1 DUP(?)
PORT_OFF	DB	1 DUP(?)
;------------------------------------------------------
;	PRINTER AND RS232 TIME-OUT VARIABLES	      :
;------------------------------------------------------
PRINT_TIM_OUT	DB	4 DUP(?)
RS232_TIM_OUT	DB	4 DUP(?)
;----------------------------------------
;	ADDITIONAL KEYBOARD DATA AREA	:
;----------------------------------------
BUFFER_START	DW	1 DUP(?)
BUFFER_END	DW	1 DUP(?)
;---------------------------------------
;	ADDITIONAL FLOPPY DATA	       ;
;---------------------------------------
	ORG	8BH
LASTRATE	DB	1 DUP(?)	; LAST DATA RATE SELECTED
PAGE
;---------------------------------------
;	ADDITIONAL HARD FILE DATA      :
;---------------------------------------
	ORG	8CH
HF_STATUS	DB	1 DUP(?)	; STATUS REGISTER
HF_ERROR	DB	1 DUP(?)	; ERROR REGISTER
HF_INT_FLAG	DB	1 DUP(?)	; HARD FILE INTERRUPT FLAG
HF_CNTRL	DB	1 DUP(?)	; COMBO HARD FILE/FLOPPY CARD BIT 0=1
;----------------------------------------
;	ADDITIONAL DISKETTE AREA       :
;----------------------------------------
	ORG	90H
DSK_STATE	LABEL	BYTE
		DB	1 DUP(?)	; DRIVE 0 MEDIA STATE
		DB	1 DUP(?)	; DRIVE 1 MEDIA STATE
		DB	1 DUP(?)	; DRIVE 0 OPERATION START STATE
		DB	1 DUP(?)	; DRIVE 1 OPERATION START STATE
DSK_TRK 	DB	1 DUP(?)	; DRIVE 0 PRESENT CYLINDER
		DB	1 DUP(?)	; DRIVE 1 PRESENT CYLINDER
		DB	1 DUP(?)	; RESERVED
;----------------------------------------				AEV
;	ADDITIONAL KEYBOARD FLAG FOR KBX:				AEV
;----------------------------------------				AEV
	ORG	96H			;				AEV
KB_FLAG_3	DB	1 DUP(?)	;				AEV
;----------------------------------------
;	ADDITIONAL KEYBOARD LED FLAG	:
;----------------------------------------
	ORG	97H
KB_FLAG_2	DB	1 DUP(?)
PAGE
;----------------------------------------
;	REAL TIME CLOCK DATA AREA	:
;----------------------------------------
	ORG	98H
USER_FLAG	DW	1 DUP(?)	; OFFSET ADDR OF USERS WAIT FLAG
USER_FLAG_SEG	DW	1 DUP(?)	; SEG ADDR OF USER WAIT FLAG
RTC_LOW 	DW	1 DUP(?)	; LOW WORD OF USER WAIT FLAG
RTC_HIGH	DW	1 DUP(?)	; HIGH WORD OF USER WAIT FLAG
RTC_WAIT_FLAG	DB	1 DUP(?)	; WAIT ACTIVE FLAG
DATA	ENDS
;----------------------------------------
;	EXTRA DATA AREA 		:
;----------------------------------------
XXDATA	SEGMENT AT 50H
STATUS_BYTE	DB	1 DUP(?)
XXDATA	ENDS
;----------------------------------------
;	VIDEO DISPLAY BUFFER		:
;----------------------------------------
VIDEO_RAM	SEGMENT AT 0B800H
REGEN	LABEL	BYTE
REGENW	LABEL	WORD
	DB	16384 DUP(?)
VIDEO_RAM	ENDS
