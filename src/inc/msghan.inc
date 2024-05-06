	       IF1			;AN000;
		     %OUT INCLUDING MSGHAN.INC...;AN000;
	       ENDIF			;AN000;
;THIS IS A COMMONLY INCLUDED FILE, USED BY (AT LEAST) THE FOLLOWING COMPONENTS:
;TREE, GRAFTABL, DISKCOMP, DISKCOPY, COMP - WRITTEN OR Revised BY E.K.

;		VALUES FOR THE MSG_DESC CONTROL BLOCK
ONE_SUBS       EQU   1		   ;AN000;ONE VARIABLE FIELD IN MESSAGE
TWO_SUBS       EQU   2		   ;AN000;TWO VARIABLE FIELDS IN MESSAGE
THREE_SUBS     EQU   3		   ;AN000;THREE VARIABLE FIELDS IN MESSAGE
CLASS_1        EQU   EXT_ERR_CLASS ;AN000;CLASS 1 (DOS EXTENDED ERRORS)
CLASS_2        EQU   PARSE_ERR_CLASS ;AN000;CLASS 2 (PARSE ERRORS)
CLASS_A        EQU   UTILITY_MSG_CLASS ;AN000;CLASS A TYPE MESSAGE

;THIS MESSAGE DESCRIPTOR CONTROL BLOCK IS GENERATED, ONE PER MESSAGE,
;TO DEFINE THE SEVERAL PARAMETERS THAT ARE EXPECTED TO BE PASSED IN
;CERTAIN REGISTERS WHEN THE SYSDISPMSG FUNCTION IS TO BE INVOKED.

MSG_DESC	  STRUC 	   ;AN000;
MSG_NUM 	  DW	0	   ;AN000;MESSAGE NUMBER (TO AX)
MSG_HANDLE	  DW	STDOUT	   ;AN000;HANDLE OF OUTPUT DEVICE (TO BX)
MSG_SUBLIST	  DW	0	   ;AN000;POINTER TO SUBLIST (TO SI)
MSG_COUNT	  DW	0	   ;AN000;SUBSTITUTION COUNT (TO CX)
MSG_CLASS	  DW	CLASS_A SHL 8 ;AN000;MESSAGE CLASS (IN HIGH BYTE, TO DH)
				   ; LOW BYTE HAS 0 (FUNCTION "NO INPUT", TO DL)
MSG_DESC	  ENDS		   ;AN000;

;		VALUES FOR THE SUBLIST CONTROL BLOCK
PC_ID_0        EQU   0		   ;AN000;ID OF " - " TRAILER TO MESSAGE
PC_ID_1        EQU   1		   ;AN000;ID OF PERCENT VARIABLE FIELD
PC_ID_2        EQU   2		   ;AN000;ID OF PERCENT VARIABLE FIELD
PC_ID_3        EQU   3		   ;AN000;ID OF PERCENT VARIABLE FIELD
MAX_0	       EQU   0		   ;AN000;MAXIMUM WIDTH OF STRING FIELD (0=NO LIMIT)
MIN_1	       EQU   1		   ;AN000;MINIMUM WIDTH OF STRING FIELD
PAD_BLK        EQU   " "           ;AN000;CHAR FOR PAD FIELD
FILL_OFF       EQU   0		   ;AN000;TO BE REPLACED WITH ACTUAL OFFSET
FILL_SEG       EQU   0		   ;AN000;TO BE REPLACED WITH ACTUAL SEG ID

;THIS SUBLIST CONTROL BLOCK, POINTED TO BY SI WHEN SYSDISPMSG IS CALLED
;FURTHER DESCRIBES THE MESSAGE AND THE VARIABLE FIELDS THE MSG MAY CONTAIN.
;THERE IS ONE OF THESE CONTROL BLOCKS PER VARIABLE FIELD.  ADDITIONAL
;VARIABLE FIELDS ARE DEFINED IN ADDITIONAL "SUBLIST" CONTROL BLOCKS,
;CONSECUTIVE AND CONTIGUOUS WITH THIS ONE.  THE NUMBER OF THESE CONTROL
;BLOCKS IS THE SUBSTITUTION COUNT, PASSED IN CS TO SYSDISPMSG, AS DEFINED
;IN THE ABOVE "MSC_DESC" CONTROL BLOCK.

SUBLIST 	  STRUC 	;AN000;
SUB_SIZE	  DB	11	;AN000;SUBLIST SIZE (POINTER TO NEXT SUBLIST)
SUB_RES 	  DB	0	;AN000;RESERVED
				;NEXT FIELD IS TO BE USED AS A DOUBLE WORD
SUB_VALUE	  DW	0	;AN000;TIME, DATE, OR PTR TO DATA ITEM
SUB_VALUE_SEG	  DW	0	;AN000;SEG ID OF PTR
				;(ABOVE FIELD MUST BE FILLED AT EXECUTION TIME
				; IF THIS IS A .COM FILE)
SUB_ID		  DB	0	;AN000;N OF %N
SUB_FLAGS	  DB	0	;AN000;DATA TYPE FLAGS
SUB_MAX_WIDTH	  DB	MAX_0	;AN000;MAXIMUM FIELD WIDTH (0=UNLIMITED)
SUB_MIN_WIDTH	  DB	0	;AN000;MINIMUM FIELD WIDTH
SUB_PAD_CHAR	  DB	PAD_BLK ;AN000;CHARACTER FOR PAD FIELD
				; CAN BE " ", "0" OR ",".
				; "," CAUSES INSERTION OF THE ACTIVE
				; THOUSANDS SEPARATOR BETWEEN EVERY 3 DIGITS.
SUBLIST 	  ENDS		;AN000;

;		  BITS DEFINED FOR SUB_FLAGS ABOVE
;			FORMAT = A0SSTTTT
;				 �� � ���� FIELD TYPE
;				 �� ���� DATA VARIABLE SIZE
;				 ����� RESERVED, MUST BE ZERO
;				 ���� ALIGNMENT INDICATOR
SF_BITS     RECORD F_ALIGN:1,F_RES:1=0,F_SIZE:2,F_TYPE:4;AN000;

;		F_ALIGN FIELD, ALIGNMENT INDICATOR
SF_LEFT 	  EQU	0	   ;AN000;LEFT ALIGN
SF_RIGHT	  EQU	1	   ;AN000;RIGHT ALIGN

;		F_RES FIELD, RESERVED, SHOULD BE ZERO

;		F_TYPE FIELD, FIELD TYPE
SF_CHAR 	  EQU	0000B	   ;AN000;TYPE IS CHARACTER
;		F_SIZE FIELD,
SF_CH		  EQU	00B	   ;AN000;SINGLE CHARACTER
SF_ASCIIZ	  EQU	01B	   ;AN000;ASCIIZ STRING

;		F_TYPE FIELD, FIELD TYPE
SF_UN_BD	  EQU	0001B	   ;AN000;UNSIGNED BINARY TO DECIMAL CHARACTER
;		F_SIZE FIELD,
SF_BYTE 	  EQU	01B	   ;AN000;DATA IS BYTE SIZED
SF_WORD 	  EQU	10B	   ;AN000;DATA IS WORD SIZED
SF_DWORD	  EQU	11B	   ;AN000;DATA IS DOUBLE WORD SIZED

;		F_TYPE FIELD, FIELD TYPE
SF_SIN_BD	  EQU	0010B	   ;AN000;SIGNED BINARY TO DECIMAL CHARACTER
;		F_SIZE FIELD,
;SF_BYTE	  EQU	01B	   ;DATA IS BYTE SIZED
;SF_WORD	  EQU	10B	   ;DATA IS WORD SIZED
;SF_DWORD	  EQU	11B	   ;DATA IS DOUBLE WORD SIZED

;		F_TYPE FIELD, FIELD TYPE
SF_UN_BH	  EQU	0011B	   ;AN000;UNSIGNED BINARY TO HEXADECIMAL CHARACTER
;		F_SIZE FIELD,
;SF_BYTE	  EQU	01B	   ;DATA IS BYTE SIZED
;SF_WORD	  EQU	10B	   ;DATA IS WORD SIZED
;SF_DWORD	  EQU	11B	   ;DATA IS DOUBLE WORD SIZED

;		F_TYPE FIELD, FIELD TYPE
SF_DATE 	  EQU	0100B	   ;AN000;DATE TO CHARACTER,
				   ; USING CURRENT COUNTRY FORMAT
				   ;SUB_VALUE HIGH=YEAR
				   ;SUB_VALUE LOW=MMDD
;		F_SIZE FIELD,
SF_MD		  EQU	01B	   ;AN000;MONTH AND DAY ONLY
SF_MDY2 	  EQU	10B	   ;AN000;MONTH,DAY AND YEAR (2 DIGITS)
SF_MDY4 	  EQU	11B	   ;AN000;MONTH,DAY AND YEAR (4 DIGITS)

;		F_TYPE FIELD, FIELD TYPE
SF_TIME_12	  EQU	0101B	   ;AN000;TIME TO CHARACTER, 12 HOUR FORMAT
				   ; USING CURRENT COUNTRY FORMAT
				   ;SUB_VALUE HIGH=HHMM
				   ;SUB_VALUE LOW=SSHH
;		F_SIZE FIELD,
SF_HHMM 	  EQU	00B	   ;AN000;HH:MM (ACTIVE TIME FORMAT)
SF_HHMMSS	  EQU	01B	   ;AN000;HH:MM:SS (ACTIVE TIME FORMAT)
SF_HHMMSSHH	  EQU	10B	   ;AN000;HH:MM:SS:HH

;		F_TYPE FIELD, FIELD TYPE
SF_TIME_24	  EQU	0110B	   ;AN000;TIME TO CHARACTER, 24 HOUR FORMAT
				   ; USING CURRENT COUNTRY FORMAT
				   ;SUB_VALUE HIGH=HHMM
				   ;SUB_VALUE LOW=SSHH
;		F_SIZE FIELD,
;SF_HHMM	  EQU	00B	   ;HH:MM (ACTIVE TIME FORMAT)
;SF_HHMMSS	  EQU	01B	   ;HH:MM:SS (ACTIVE TIME FORMAT)
;SF_HHMMSSHH	  EQU	10B	   ;HH:MM:SS:HH

;		THE NEXT GROUP ARE ALL CLASS "1" MESSAGES

	       PUBLIC MSGNUM_EXTERR;AN000;
MSGNUM_EXTERR  MSG_DESC <,STDERR,,,CLASS_1 SHL 8> ;AN000;ALL EXTENDED DOS ERRORS
				   ;ERROR NUMBER WILL NEED TO BE FILLED IN

;		THE NEXT GROUP ARE ALL CLASS "2" MESSAGES

	       PUBLIC MSGNUM_PARSE ;AN000;SO PARSE DRIVER CAN FIND IT
MSGNUM_PARSE   MSG_DESC <,STDERR,,,CLASS_2 SHL 8> ;AN000;ALL PARSING ERRORS
				   ;ERROR NUMBER WILL NEED TO BE FILLED IN

;		THE NEXT GROUP ARE ALL CLASS "A" MESSAGES
;		THESE ARE THE "CANNED" MESSAGES ALWAYS PRESENT

	       PUBLIC MSGNUM_VER   ;AN000;
MSGNUM_VER     MSG_DESC <1,STDERR> ;AN000;"Incorrect DOS Version"
;end of MSGHAN.INC