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

; Some modules really want TRUE to be 0FFH.  Best to let them have their way.
ifndef TRUE
	TRUE	   EQU	   0FFFFh
endif
ifndef TRUEBYTE
	TRUEBYTE   EQU     0FFh
endif
ifndef FALSE
	FALSE	   EQU	   0
endif

;
; Use the following switches to control cmacros.inc
;
?PLM       =       0
?WIN       =       0

memS       EQU     1			; Small model
;
; Use the switches below to produce the standard Microsoft version or the IBM
; version of the operating system
;
; The below chart will indicate how to set the switches to build the various
; versions
;
;                     IBMVER          IBMCOPYRIGHT
; --------------------------------------------------------
;  IBM Version   |     TRUE              TRUE
; --------------------------------------------------------
;  MS Version    |     FALSE             FALSE
; --------------------------------------------------------
;  Clone Version |     TRUE              FALSE
;
IBMVER     EQU     TRUE
IBMCOPYRIGHT EQU   FALSE

BUFFERFLAG	EQU	NOT IBMCOPYRIGHT

ifndef	MSVER	
MSVER      EQU     NOT IBMVER
endif
IBM	   EQU	   IBMVER
;
;
  IF1
	IF IBMVER
	    IF IBMCOPYRIGHT
              %OUT ... IBM version build switch on ...
	    ELSE
	      %OUT ... CLONE version build switch on ...
	    ENDIF
	ELSE
	    IF NOT IBMCOPYRIGHT
	      %OUT ... MS version build switch on ...
	    ELSE
	      %OUT !!!!!!!!!  VERSION SWITCHES SET INCORECTLY  !!!!!!!!!
	      %OUT !!!!!!!!! CHECK SETTINGS IN INC\VERSION.INC !!!!!!!!!
	    ENDIF
	ENDIF   
  ENDIF
;
;
;***************************************************************************
;*          The following switches are for DBCS or SBCS support            *
;*                                                                         *
;*                     Set INTERNAT EQU TRUE FOR DBCS                      *
;*                     Set INTERNAT EQU FALSE FOR SBCS                     *
;*                                                                         *
;***************************************************************************
;
IBMJAPVER  EQU	   FALSE		;If TRUE set KANJI true also

;
; Switch INTERNAT for DBCS support
;
INTERNAT   EQU	   FALSE
;
	IF INTERNAT
KANJI	   EQU	   TRUE
IBMJAPAN   EQU	   TRUE
	ELSE
KANJI	   EQU	   FALSE
IBMJAPAN   EQU	   FALSE
	ENDIF

ifndef altvect				; avoid jerking off vector.inc
ALTVECT    EQU	   FALSE		;Switch to build ALTVECT version
endif

;
; Country code switches
; The default contry code is assumed as USA.
;
	IF INTERNAT
 KOREA	   EQU	   TRUE
 JAPAN	   EQU	   FALSE
	ELSE
 KOREA	   EQU	   FALSE
 JAPAN	   EQU	   FALSE
	ENDIF
;
	IF1
		IF INTERNAT
%OUT	Internat(ECS) version build switch on
		ENDIF
	ENDIF
