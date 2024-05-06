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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; *** MACROS **** MACROS **** MACROS ****
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF1                                     ;
        %OUT .               ®MACROS  .INC¯
ENDIF                                   ;
                                        ;
JUMP    MACRO   LBL                     ;
        LOCAL   A                       ;
.XCREF                                  ;
      IFNDEF LBL&_J                     ; IS THIS FIRST INVOKATION
A:       JMP     LBL                    ;
      ELSE                              ;
         IF (LBL&_J GE $) OR ($-LBL&_J GT 126)
A:          JMP     LBL                 ; IS THE JUMP TOO FAR AWAY?
         ELSE                           ;
A:          JMP     LBL&_J              ; PERFORM SHORT JUMP
         ENDIF                          ;
      ENDIF                             ;
LBL&_J=A                                ;
.CREF                                   ;
        ENDM                            ;
.XCREF JUMP                             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; *** MACROS **** MACROS **** MACROS ****
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
