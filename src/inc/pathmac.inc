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

;;***********************************************************************
;; NAME: pathlabl
;; DESC: creates a public label at the spot it is placed, using the name
;;       given.
;; INPUT: either module name or procedure name
;; OUTPUT: public label
;; LOGIC: LBL-parameter-name will have four values -
;;            - one for each pass (2)
;;            - one for start and one for stop
;;        if LBL is not defined, it is first pass, at beginning label
;;              - set it to 1 and create the start label
;;        if LBL = 1, it is first pass, at end label
;;              - set it to 2 and create stop label
;;        if LBL = 2, it is second pass, at beginning label
;;              - set it to 3 and create the start label
;;        if LBL = 3, it is second pass, at end label
;;              - set it to 4 and create stop label
;;        if LBL = 4, it is second pass,
;;              - this macro has been invoked more than twice with same parm
;;              - issue error message
;;***********************************************************************
IF1
    %OUT COMPONENT=COMMON, MODULE=PATHMAC.INC ...
ENDIF

pathlabl MACRO pnam
IFNDEF LBL_&pnam                        ;;IF THIS IS THE FIRST TIME,
    LBL_&pnam = 0                       ;;DEFINE IT, INITIALLY ZERO
ELSE                                    ;;SINCE IT IS DEFINED
    IF (LBL_&pnam GT 3)                 ;;IF USED TOO MANY TIMES,
        .ERR NON-UNIQUE OPERAND ON PATHLABL
        EXITM                           ;;ABORT THIS GENERATION
    ENDIF
ENDIF

IF (LBL_&pnam EQ 0) OR (LBL_&pnam EQ 2) ;;ready for START?
    $$A_START_&pnam:                    ;;create START label
    PUBLIC $$A_START_&pnam              ;;make it public
ELSE                                    ;;SINCE SWITCH MAY BE 1 OR 3,
    $$A_STOP_&pnam:                     ;;create STOP label
    PUBLIC $$A_STOP_&pnam               ;;make it public
ENDIF
LBL_&pnam = LBL_&pnam + 1               ;;INCREMENT SWITCH
ENDM
