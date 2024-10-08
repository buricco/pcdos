	PAGE	90,132			;AN000;A2
	TITLE	GRTABSM.SAL - GRAFTABL SYSTEM MESSAGES ;AN000;
;****************** START OF SPECIFICATIONS *****************************
; MODULE NAME: GRTABSM.SAL
;
; DESCRIPTIVE NAME: Include the DOS system MESSAGE HANDLER in the SEGMENT
;		    configuration expected by the modules of GRAFTABL.
;
;FUNCTION: The common code of the DOS SYSTEM MESSAGE HANDLER is made a
;	   part of the GRAFTABL module by using INCLUDE to bring in the
;	   common portion, in SYSMSG.INC.  This included code contains
;	   the routines to initialize for message services, to find
;	   where a particular message is, and to display a message.
;
; ENTRY POINT: SYSDISPMSG:near
;	       SYSGETMSG:near
;	       SYSLOADMSG:near
;
; INPUT:
;    AX = MESSAGE NUMBER
;    BX = HANDLE TO DISPLAY TO (-1 means use DOS functions 1-12)
;    SI = OFFSET IN ES: OF SUBLIST, OR 0 IF NONE
;    CX = NUMBER OF %PARMS, 0 IF NONE
;    DX = CLASS IN HIGH BYTE, INPUT FUNCTION IN LOW
;   CALL SYSDISPMSG		;DISPLAY THE MESSAGE

;    If carry set, extended error already called:
;    AX = EXTENDED MESSAGE NUMBER
;    BH = ERROR CLASS
;    BL = SUGGESTED ACTION
;    CH = LOCUS
; _ _ _ _ _ _ _ _ _ _ _ _

;    AX = MESSAGE NUMBER
;    DH = MESSAGE CLASS (1=DOS EXTENDED ERROR, 2=PARSE ERROR, -1=UTILITY MSG)
;   CALL SYSGETMSG		 ;FIND WHERE A MSG IS

;    If carry set, error
;     CX = 0, MESSAGE NOT FOUND
;    If carry NOT set, ok, and resulting regs are:
;     CX = MESSAGE SIZE
;     DS:SI = MESSAGE TEXT
; _ _ _ _ _ _ _ _ _ _ _ _

;   CALL SYSLOADMSG		 ;SET ADDRESSABILITY TO MSGS, CHECK DOS VERSION
;    If carry not set:
;    CX = SIZE OF MSGS LOADED

;    If carry is set, regs preset up for SYSDISPMSG, as:
;    AX = ERROR CODE IF CARRY SET
;	  AX = 1, INCORRECT DOS VERSION
;	  DH =-1, (Utility msg)
;	OR,
;	  AX = 1, Error loading messages
;	  DH = 0, (Message manager error)
;    BX = STDERR
;    CX = NO_REPLACE
;    DL = NO_INPUT
;
; EXIT-NORMAL: CARRY is not set
;
; EXIT-ERROR:  CARRY is set
;	       Call Get Extended Error for reason code, for SYSDISPMSG and
;	       SYSGETMSG.
;
; INTERNAL REFERENCES:
;    ROUTINES: (Generated by the MSG_SERVICES macro)
;	SYSLOADMSG
;	SYSDISPMSG
;	SYSGETMSG
;
;    DATA AREAS:
;	INCLUDE GRTABMS.INC  ;message defining control blocks
;	INCLUDE SYSMSG.INC   ;Permit System Message handler definition
;	INCLUDE COPYRIGH.INC ;Standard copyright notice
;	INCLUDE MSGHAN.INC   ;Defines message control blocks STRUCs
;	INCLUDE VERSIONA.INC ;INCLUDEd by code generated by SYSMSG.INC
;
; EXTERNAL REFERENCES:
;    ROUTINES: none
;
;    DATA AREAS: control blocks pointed to by input registers.
;
; NOTES:
;	 This module should be processed with the SALUT preprocessor
;	 with the re-alignment not requested, as:
;
;		SALUT GRTABSM,NUL,;
;
;	 To assemble these modules, the alphabetical or sequential
;	 ordering of segments may be used.
;
;	 For LINK instructions, refer to the PROLOG of the main module,
;	 GRTAB.SAL.
;
; COPYRIGHT: "Version 4.00 (C)Copyright Microsoft Corp 1981,1988 "
;	     "Licensed Material - Program Property of Microsoft"
;
;****************** END OF SPECIFICATIONS *****************************
	IF1				;AN000;
	    %OUT    COMPONENT=GRAFTABL, MODULE=GRTABSM.SAL... ;AN000;
	ENDIF				;AN000;
	INCLUDE pathmac.inc		;AN006;
;	INCLUDE SYSMSG.INC		;PERMIT SYSTEM MESSAGE HANDLER DEFINITION ;AN000;
.XLIST					;AN000;
	INCLUDE sysmsg.inc		;AN000;PERMIT SYSTEM MESSAGE HANDLER DEFINITION
.LIST					;AN000;
	MSG_UTILNAME <GRAFTABL> 	;AN000;IDENTIFY THE COMPONENT
; =  =	=  =  =  =  =  =  =  =	=  =
;	   $SALUT (4,12,18,36)	   ;AN000;
CSEG	   SEGMENT PARA PUBLIC	   ;AN000;
	   ASSUME CS:CSEG,DS:CSEG,ES:CSEG,SS:CSEG ;AN000;

;THIS MODULE IS EXPECTED TO BE LINKED DIRECTLY FOLLOWING THE LAST
;FONT DEFINITION MODULE, SINCE THE VARIABLE, "COPYRIGHT", IS USED
;TO DETERMINE THE END OF THE ARRAY OF FONT TABLES.

	   PUBLIC COPYRIGHT	   ;AN000;
COPYRIGHT  LABEL BYTE		   ;AN006;
;(deleted ;AN004;) INCLUDE COPYRIGH.INC ;(this is now being done in MSG_SERVICES)

	   INCLUDE msghan.inc	   ;AN000;DEFINE MESSAGE HANDLER CONTROL BLOCKS
	   INCLUDE grtabms.inc	   ;AN000;DEFINE THE MESSAGES, AND CONTROL BLOCKS
	   MSG_SERVICES <GRAFTABL.CLA,GRAFTABL.CL1,GRAFTABL.CL2> ;AN000;
	   MSG_SERVICES <MSGDATA>  ;AN000;
; =  =	=  =  =  =  =  =  =  =	=  =
	   PUBLIC SYSLOADMSG	   ;AN000;
	   PUBLIC SYSDISPMSG	   ;AN000;
	   PUBLIC SYSGETMSG	   ;AN000;
	   PATHLABL GRTABSM	   ;AN006;
				   ;DEFAULT=CHECK DOS VERSION
				   ;DEFAULT=NEARmsg
				   ;DEFAULT=NO INPUTmsg
				   ;DEFAULT=NO NUMmsg
				   ;DEFAULT=NO TIMEmsg
				   ;DEFAULT=NO DATEmsg
;	   MSG_SERVICES <LOADmsg,GETmsg,DISPLAYmsg,CHARmsg>				;AN000;
.XLIST				   ;AN000;
.XCREF				   ;AN000;
	   MSG_SERVICES <LOADmsg,GETmsg,DISPLAYmsg,CHARmsg> ;AN000;
.LIST				   ;AN000;
.CREF				   ;AN000;
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
	   PATHLABL GRTABSM	   ;AN006;


CSEG	   ENDS 		   ;AN000;

include msgdcl.inc

	   END			   ;AN000;

