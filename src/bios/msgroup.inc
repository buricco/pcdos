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

EVBOUND = 1  ;THIS VALUE BEING 0 DOES NO BOUNDARY ALIGNMENT, VALUE 1	  ;3.30
	     ; ALIGNS TO EVEN						  ;3.30
; : : : : : : : : : : : : : :						  ;3.30
	IF EVBOUND	;;IF EVEN (WORD) ALIGNMENT IS REQUESTED,	  ;3.30
; : : : : : : : : : : : : : :						  ;3.30
EVENB	MACRO								  ;3.30
	  EVEN	;;ADJUST TO EVEN BOUNDARY				  ;3.30
	ENDM								  ;3.30
									  ;3.30
ODD	MACRO								  ;3.30
;;GENERATE BOUNDARY PADDING TO FORCE ODD OFFSET 			  ;3.30
	IF (($-CODE) MOD 2) EQ 0					  ;3.30
	  DB	?							  ;3.30
	ENDIF								  ;3.30
	ENDM								  ;3.30
									  ;3.30
CODE_SEGMENT MACRO							  ;3.30
;;ALIGN THE SEGMENT ON WORD BOUNDARY TO ALLOW FOR EVEN ALIGNMENT OF DATA;3.30
CODE	SEGMENT WORD PUBLIC 'CODE'                                        ;3.30 ;3.30
	ENDM								  ;3.30
									  ;3.30
; : : : : : : : : : : : : : :						  ;3.30
	ELSE	;;SINCE EVEN ALIGNMENT IS NOT DESIRED, JUST USE BYTE ALN;3.30 GNMENT
; : : : : : : : : : : : : : :						  ;3.30
									  ;3.30
EVENB	MACRO								  ;3.30
;;REQUEST FOR WORD ALIGNMENT DOES NOTHING				  ;3.30
	ENDM								  ;3.30
									  ;3.30
ODD	MACRO								  ;3.30
;;REQUEST FOR ODD ALIGNMENT DOES NOTHING				  ;3.30
	ENDM								  ;3.30
									  ;3.30
CODE_SEGMENT MACRO							  ;3.30
;;SEGMENT IS ALIGNED ON BYTE BOUNDARY FOR MINIMUM SIZE OF GENERATION	  ;3.30
CODE	SEGMENT BYTE PUBLIC 'CODE'                                        ;3.30
	ENDM								  ;3.30
									  ;3.30
; : : : : : : : : : : : : : :						  ;3.30
	ENDIF								  ;3.30
; : : : : : : : : : : : : : :						  ;3.30
									  ;3.30
	CODE_SEGMENT							  ;3.30
	ASSUME	CS:CODE 						  ;3.30
									  ;3.30
