; MODECPEQ.INC - INCLUDED IN MODECP.SAL 
	IF1
	    %OUT    INCLUDE MODECPEQ.INC ;MACROS,DOS EQUATES,STRUCS,OTHER EQUATES
	ENDIF

;	$SALUT	CP(4,9,17,32)
HEADER	MACRO	TEXT,EJECT
;;example:  header <new subtitle goes here>
;;the angle brackets are required
.XLIST
	SUBTTL	TEXT
IFB	<EJECT>
.LIST
ENDIF
	PAGE
	ENDM

; - - - - - - - - - - - - - - - - - - - -
;			   $SALUT      CP(2,28,40,47)

DOSCALL 		   MACRO       FUNC,SUBFUNC
;;IF SUBFUNC IS USED, THEN FUNC MUST BE USED
			   IFNB        <FUNC> ;IS THERE ANY PARMS AT ALL?
			     IFNB	 <SUBFUNC>
			       MOV	   AX,(FUNC SHL 8) + SUBFUNC
			     ELSE	      ;;SINCE THERE IS NO SUBFUNC
			       MOV	   AH,FUNC
			     ENDIF
			   ENDIF
			   INT	       21H
			   ENDM

; - - - - - - - - - - - - - - - - - - - -
;		    $SALUT CP(4,21,26,32)

;		DOS FUNCTION CALLS
PRINTSTR	    EQU  09H   ;PRINT STRING ENDING WITH "$"
			       ;DS:DX = POINTER TO STRING

SET_VECTOR	    EQU  25H   ;SET INTERRUPT VECTOR
			       ;DS:DX = VECTOR TO INT HANDLER
			       ;AL = INTERRUPT NUMBER

DOS_VERSION	    EQU  30H   ;DETERMINE VERSION OF DOS
			       ;OUTPUT: AL=MAJOR, AH=MINOR VERSION NUMBER
			       ;	BX AND CX SET TO ZERO

BREAK_CHECK	    EQU  33H   ;CNTRL-BREAK CHECK
			       ;AL=0 - REQUEST CURRENT STATE
			       ;AL=1 - SET CURRENT STATE
			       ;DL=0 - BREAK OFF
			       ;DL=1 - BREAK ON

GET_VECTOR	    EQU  35H   ;GET INTERRUPT VECTOR
			       ;AL = INTRRUPT NUMBER
			       ;OUTPUT: ES:BX = CONTENTS OF VECTOR

OPEN		    EQU  3DH   ;OPEN FILE FOR INPUT
			       ;DS:DX = POINTER TO ASCIIZ PATH NAME
			       ;AL = OPEN MODE

CLOSE		    EQU  3EH   ;CLOSE A FILE HANDLE
			       ;BX = HANDLE RETURNED BY OPEN OR CREATE

READ		    EQU  3FH   ;READ FROM A FILE OR DEVICE
			       ;BX = FILE HANDLE
			       ;DS:DX = BUFFER ADDRESS
			       ;CX NUMBER OF BYTES TO READ

WRITE		    EQU  40H   ;WRITE TO A FILE OR DEVICE
			       ;BX = FILE HANDLE
			       ;DS:DX = ADDRESS OF DATA TO WRITE
			       ;CX = NUMBER OF BYTES TO WRITE


LSEEK		    EQU  42H   ;MOVE FILE READ/WRITE POINTER
			       ;CX:DX - DISTANCE TO MOVE IN BYTES
			       ;BX = FILE HANDLE
			       ;AL = METHOD OF MOVING:
			       ;   00 - MOVE CX:DX BYTES FROM BEGINNING
			       ;   01 - MOVE TO CURRENT LOCATION + OFFSET
			       ;   02 - MOVE TO END OF FILE
			       ;OUTPUT:DX:AX NEW POINTER LOCATION

IOCTL		    EQU  44H   ;I/O CONTROL FOR DEVICES
			       ;DS:DX = DATA OR BUFFER
			       ;CX = NUMBER OF BYTES TO READ OR WRITE
			       ;BX = FILE HANDLE, OR,
			       ;BL = DRIVE NUMBER (0=DEFAULT,1=A,...)
			       ;AL = FUNCTION VALUE
			       ;OUTPUT: AX=NO. BYTES TRANSFERRED
			       ; OR ERROR CODE IS CY SET

ALLOC_MEM	    EQU  48H   ;ALLOCATE MEMORY
			       ;BX = NUMBER OF PARAGRAPHS REQUESTED
			       ;OUTPUT: IF NO CARRY, AX:0 POINTS TO
			       ; ALLOCATED MEMORY BLOCK
			       ; IF CARRY, BX IS SIZE OF LARGEST BLOCK
			       ; AVAILABLE, IN PARAGRAPHS, AX=ERR CODE

FREE_AL_MEM	    EQU  49H   ;FREE ALLOCATED MEM
			       ;ES=SEG OF BLOCK BEING RETURNED
			       ;OUTPUT: AX=ERROR CODE IF CY SET

EXTERROR	    EQU  59H   ;EXTENDED ERROR
			       ;BX = 30 VERSION NUMBER (FOR 3.30)
			       ;OUTPUT:
			       ;AX=EXTENDED ERROR
			       ;BH=ERROR CLASS
			       ;BL=SUGGESTED ACTION
			       ;CH=LOCUS

;		(THESE VALUES GO TO AX FOR INT 21H)
SET_GLOBAL_CP	    EQU  6602H ;INPUTS:
			       ; BX=CODE PAGE,

GET_GLOBAL_CP	    EQU  6601H ;RESULTS:
			       ; BX=ACTIVE CODE PAGE,
			       ; DX=SYSTEM CODE PAGE

GENERIC_IOCTL	    EQU  440CH ;INPUTS:
			       ; CH AND CL SET AS DEFINED IN NEXT 2 SECTIONS
			       ; IN GENERAL, CH=CATEGORY CODE (MAJOR CODE)
			       ; CL=FUNCTION WITHIN CATEGORY (MINOR CODE)

;			MAJOR CODES:
;		(THESE VALUES GO TO CH REG DURING GENERIC IOCTL:
UNK_DEV_TYPE	    EQU  00H   ;USED IF TYPE NOT KNOWN
COM_DEV_TYPE	    EQU  01H   ;COMx DEVICE TYPE
CON_DEV_TYPE	    EQU  03H   ;CONSOLE DEVICE TYPE
LPT_DEV_TYPE	    EQU  05H   ;LPTx DEVICE TYPE
GLOBAL_CP	    EQU  -1    ;GLOBAL CODEPAGE, INDICATED BY DEVICE="*",
			       ; NOT USED WITH GENERIC IOCTL

;			MINOR CODES:
;		SUBFUNCTIONS OF GENERIC_IOCTL:
;		(THESE VALUES GO TO CL REG)
PREPARE_STRT	    EQU  4CH   ;INPUTS:
			       ;BX=HANDLE, AX="GENERIC_IOCTL"
			       ;CX=xxx_DEV_TYPE * 256 + "PREPARE_STRT"
			       ;DS:DX=DATA BUFFER "DES_STRT_PACKET"

PREPARE_END	    EQU  4DH   ;INPUTS:
			       ;BX=HANDLE, AX="GENERIC_IOCTL"
			       ; DS:DX=DATA BUFFER "PACKET"

SELECT_CP	    EQU  4AH   ;INPUTS:
			       ;BX=HANDLE, AX="GENERIC_IOCTL"
			       ; DS:DX=DATA BUFFER "PACKET"

QUERY_SELECTED	    EQU  6AH   ;INPUTS:
			       ;BX=HANDLE, AX="GENERIC_IOCTL"
			       ; DS:DX=DATA BUFFER "PACKET"

QUERY_DES_LST	    EQU  6BH   ;INPUTS:
			       ;BX=HANDLE, AX="GENERIC_IOCTL"
			       ; DS:DX=DATA BUFFER

;		      OTHER EQUATES
IOCTL_WRITE	    EQU  3     ;VAL FOR AL, WHEN WRITING TO DEVICE VIA IOCTL
FILE_OPEN_MODE	    EQU  0     ;BIT FIELDS ARE ISSSRAAA WHERE:
			       ; I=0 FILE IS INHERITED BY CHILD PROCESS
			       ;   (OF WHICH THERE ISN'T ANY)
			       ; SSS=SHARING MODE IS "COMPATABILITY MODE"
			       ; R=0 (RESERVED)
			       ; AAA=0 (READ ACCESS)
DEV_OPEN_MODE	    EQU  2     ;SAME BITS AS ABOVE, EXCEPT AAA=010, READ/WRITE ACCESS

FALSE		    EQU  0     ;INDICATES AN ERROR TO ERRORLEVEL
TRUE		    EQU  0FFH

refresh_request     EQU  0     ;scaler to indicate that the current request is refresh for 'des_end'

STDERR		    EQU  2     ;PRE-OPENED HANDLE FOR STANDARD ERROR
STDOUT		    EQU  1     ;PRE-OPENED HANDLE FOR STANDARD OUTPUT

INT24		    EQU  24H   ;CRITICAL ERROR HANDLER VECTOR
EMPTY		    EQU  -1    ;EMPTY SLOT IN LIST OF CODEPAGES

IOCTL_FUN_GET_INFO  EQU  0     ;GET DEVICE INFORMATION (RETURNED IN DX) FROM IOCTL
IOCTL_FUN_SET_INFO  EQU  1     ;SET DEVICE INFORMATION (PASSED IN DX) TO IOCTL
ISDEVICE	    EQU  0080H ;FLAG IN DEVICE INFO WORD, RETURNED IN DX
BINARY_DEV	    EQU  0020H ;BINARY FLAG IN DEVICE INFO WORD

MAPERR		    EQU  19    ;ERRORS FROM DEVICES MAPPED TO COMMON ERRORS,
			       ; AS DEVICE ERR=0 IS REPORTED AS COM ERROR=19
FAIL24		    EQU  83    ;RET CODE, INT 24 HANDLER REQUESTED "FAIL"

;PREPARE START ERROR CODES:
DS_ERR0 	    EQU  0     ;PREVIOUS PREPARE DELETED
DS_ERR1 	    EQU  1     ;INVALID FUNCTION NUMBER
DS_ERR8 	    EQU  8     ;CODE PAGE CONFLICT (USED FOR KEYB XX MISMATCH)
DS_ERRA 	    EQU  0AH   ;DEVICE ERROR
DS_ERR16	    EQU  016H  ;UNKNOWN COMMAND (22 DECIMAL)

;PREPARE WRITE ERROR CODES:
DW_ERR8 	    EQU  8     ;DEVICE NOT FOUND IN FILE ,OR
			       ;CODE PAGE NOT FOUND IN FILE
DW_ERRA 	    EQU  0AH   ;DEVICE ERROR
DW_ERRC 	    EQU  0CH   ; FILE CONTENTS NOT A FONT FILE,
			       ; OR FILE CONTENTS STRUCTURE DAMAGED

;PREPARE END ERROR CODES:
DE_ERRC 	    EQU  0CH   ;NO PREPARE START

;SELECT ERROR CODES:
IN_ERR7 	    EQU  07H   ;CODE PAGE NOT PREPARED
IN_ERR8 	    EQU  08H   ;CURRENT KEYB DOES NOT SUPPORT THIS CP
IN_ERRA 	    EQU  0AH   ;DEVICE ERROR

;QUERY SELECTED ERROR CODES:
QS_ERR7 	    EQU  07H   ;NO CODE PAGE HAS BEEN SELECTED
QS_ERRA 	    EQU  0AH   ;DEVICE ERROR

;QUERY PREPARED LIST ERROR CODES:
QL_ERR7 	    EQU  07H   ; NO CODE PAGES HAVE BEEN SELECTED
QL_ERRA 	    EQU  0AH   ;DEVICE ERROR

;REFRESH ERROR CODES RETURNED FROM PREPARE START FOR A REFRESH REQUEST:

RS_ERR8 	    EQU  8     ;KEYBOARD/CODE PAGE CONFLICT
RS_ERRA 	    EQU  0AH   ;DEVICE ERROR
RS_ERRC 	    EQU  0CH   ;DEVICE DRIVER DOES NOT HAVE COPY OF CODE PAGE
			       ; TO DOWNLOAD TO DEVICE

;ERROR CODES PRESENTED IN THE LOWER HALF OF DI TO THE INT 24H HANDLER:
;CRERR0 	     EQU  0	;ATTEMPT TO WRITE ON WRITE_PROTECTED DISKETTE
;CRERR1 	     EQU  1	;UNKNOWN UNIT
;CRERR2 	     EQU  2	;DRIVE NOT READY
;CRERR3 	     EQU  3	;UNKNOWN COMMAND
;CRERR4 	     EQU  4	;DATA ERROR (crc)
;CRERR5 	     EQU  5	;BAD REQUEST STRUCTURE LENGTH
;CRERR6 	     EQU  6	;SEEK ERROR
;CRERR7 	     EQU  7	;UNKNOWN MEDIA TYPE
;CRERR8 	     EQU  8	;SECTOR NOT FOUND
;CRERR9 	     EQU  9	;PRINTER OUT OF PAPER
;CRERRA 	     EQU  0AH	;WRITE FAULT
;CRERRB 	     EQU  0BH	;READ FAULT
;CRERRC 	     EQU  0CH	;GENERAL FAILURE

;EXIT CODES, IN AL, WHEN IRET FROM INT 24H ERROR HANDLER.
CRERR_IGNORE	    EQU  0     ;IGNORE THE ERROR
CRERR_RETRY	    EQU  1     ;RETRY THE OPERATION
CRERR_TERM	    EQU  2     ;TERMINATE PROGRAM VIA INT 23H
CRERR_FAIL	    EQU  3     ;FAIL THE SYSTEM CALL IN PROGRESS

;		EQUATES FOR THE BREAK CHECK FUNCTION:

;IN AL:
REQUEST_BREAK_STATE EQU  0
SET_BREAK_STATE     EQU  1

;IN DL:
BREAK_OFF	    EQU  0
BREAK_ON	    EQU  1

DBCS_header	    EQU  ES:[DI]    ;used to address DBCS_head
DBCS_table	    EQU  DS:[SI]    ;used to address the DBCS vector table

; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
;	       DEFINITIONS OF CONTROL BLOCKS

FON		    STRUC      ;CODEPAGE FONT FILE CONTENTS
FONTAG		    DB	 0FFH,"FONT   " ;FILE TAG
		    DB	 8 DUP(?) ;RESERVED
FONPTCT 	    DW	 ?     ;COUNT OF POINTERS IN HEADER
FONPT		    DB	 ?     ;START OF ARRAY OF POINTERS
FON		    ENDS

;		THIS STRUC MAPS AN AREA POINTED TO BY "CP_CB", AN EXTRN
;AC001;CODEPAGE_PARMS	   STRUC
;AC001;DEVICE		   DW	?     ;POINTER TO ASCIIZ STRING OF DEVICE NAME
;AC001;DES_PACK_PTR	   DW	?     ;OFFSET TO "DES_STRT_PACKET"
;AC001;FONT_FILESPEC	   DW	?     ;PATH AND FILESPEC OF FONT FILE
;AC001;REQUEST_TYPE	   DW	?     ;TYPE OF FUNCTION TO BE PERFORMED
;AC001;CODEPAGE_PARMS	   ENDS
;		DEFINITIONS OF VALUES FOUND IN "REQUEST_TYPE" ABOVE:
		    EXTRN SELECT:ABS
		    EXTRN PREPARE:ABS
		    EXTRN REFRESH:ABS

;		"PACKET" POINTED TO BY DS:DX
PACKET		    STRUC      ;USED BY MINOR CODES: 6AH,4AH,4DH (SELECT, QUERY SELECTED, PREPARE END)
PACKLEN 	    DW	 2     ;LENGTH OF PACKET IN BYTES, FOR DBCS COUNTRIES, LENGTH OF DBCS TABLE (IF NON-ZERO) WILL be added
PACKCPID	    DW	 0     ;CODE PAGE ID
PACKVECTOR1	    DB	 0     ;start of vector list if included							    ;AN000;
		    DB	 0												    ;AN000;
		    DB	 0												    ;AN000;
		    DB	 0												    ;AN000;
		    DB	 0												    ;AN000;
		    DB	 0												    ;AN000;
		    DB	 0												    ;AN000;
		    DB	 0												    ;AN000;
		    DB	 0												    ;AN000;
		    DB	 0												    ;AN000;
		    DB	 0												    ;AN000;
		    DB	 0												    ;AN000;
		    DB	 0												    ;AN000;
		    DB	 0												    ;AN000;
		    DB	 0												    ;AN000;
		    DB	 0												    ;AN000;
		    DB	 0												    ;AN000;
		    DB	 0     ; holders for maximum possible number of 						    ;AN000;
		    DB	 0     ; DBCS vector pairs									    ;AN000;
		    DB	 0     ;											    ;AN000;
		    DB	 0     ;											    ;AN000;
		    DB	 0     ;											    ;AN000;
PACKVECTOR12	    DB	 0     ;											    ;AN000;
		    DB	 0     ;											    ;AN000;
PACKET		    ENDS												    ;AN000;
															    ;AN000;
DBCS_head	    STRUC      ;return from function 6507, pointed to by ES:DI, addressed via "DBCS_header"                 ;AN000;
info_id 	    DB	 7												    ;AN000;
table_ptr	    DD	 0     ;used to address DBCS_tabl								    ;AN000;
DBCS_head	    ENDS
															    ;AN000;
DBCS_tabl	    STRUC      ;map of DBCS table, addressed via DBCS_table						    ;AN000;
table_len	    DW	 6     ;length in bytes of the list of vectors							    ;AN000;
vector1 	    DB	 0     ;start of vector list									    ;AN000;
		    DB	 0												    ;AN000;
		    DB	 0												    ;AN000;
		    DB	 0												    ;AN000;
		    DB	 0												    ;AN000;
		    DB	 0												    ;AN000;
		    DB	 0												    ;AN000;
		    DB	 0												    ;AN000;
		    DB	 0												    ;AN000;
		    DB	 0												    ;AN000;
		    DB	 0     ;each vector is two bytes, a start value and an						    ;AN000;
		    DB	 0     ;end value										    ;AN000;
		    DB	 0												    ;AN000;
		    DB	 0												    ;AN000;
		    DB	 0												    ;AN000;
		    DB	 0												    ;AN000;
		    DB	 0												    ;AN000;
		    DB	 0												    ;AN000;
		    DB	 0												    ;AN000;
		    DB	 0												    ;AN000;
		    DB	 0												    ;AN000;
		    DB	 0												    ;AN000;
		    DB	 0												    ;AN000;
		    DB	 0												    ;AN000;
DBCS_tabl	    ENDS


;		"DES_STRT_PACKET" POINTED TO BY DS:DX
DES_STRT_PACKET     STRUC
DES_STRT_PKFL	    DW	 ?     ;FLAGS (DEFINED BELOW STRUC DEFINITION)
DES_STRT_PKLEN	    DW	 ?     ;BYTE LENGTH OF REST OF THE PACKET,
			       ; NOT INCLUDING THIS LENGTH FIELD
DES_STRT_PKNUM	    DW	 ?     ;NUMBER OF CODEPAGES IN FOLLOWING LIST
DES_STRT_PKCP1	    DW	 ?     ;CODE PAGE ONE
DES_STRT_PKCP2	    DW	 ?     ;CODE PAGE TWO
;   :		    :	 :	  :
DES_STRT_PKCPN	    DW	 ?     ;CODE PAGE n
;NOTE: THESE n CODEPAGES MAY HAVE A -1 VALUE, WHICH IS TREATED AS A PLACEHOLDER
; TO ALLOW POSITION CONTROL FOR EACH CODEPAGE VALUE IN THE LIST.
DES_STRT_PACKET     ENDS

;			DEFINITIONS OF CONTENTS OF "DES_STRT_PKFL"
DES_STRT_FL_SINGLE  EQU  8000H ; 8000H=SINGLE CP FIFO PREPARE
;   (NOT SUPPORTED, ONLY LIST FORM IN DOS 3.30 RELEASE)
DES_STRT_FL_CART    EQU  0001H ; 0001H=CARTRIDGE PREPARE

; ED OF MODECPEQ.INC FILE