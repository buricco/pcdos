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

;***********************************************************************
; NAME: pathlabl
; DESC: creates a public label at the spot it is placed, using the name
;       given.
; INPUT: either module name or procedure name
; OUTPUT: public label
; LOGIC: if masm is in pass1 (pass2 will gen dup labels)
;           if this label has not been gen before
;              then create the label
;                   - $$A to place at begin of map
;                   - start means first occurence
;                   - use module/proc name last
;                   define this label for creation of 'stop' label
;              else create stop label
;                   - same as start except name
;***********************************************************************
.LALL
pathlabl MACRO pnam
IF1                                     ;if pass 1
    IFNDEF LBL_&pnam                    ;switch not defined if first creation
        $$A_START_&pnam:                ;create label
        PUBLIC $$A_START_&pnam          ;make it public
        LBL_&pnam = 1                   ;set switch
    ELSE                                ;start label already created
        $$A_STOP_&pnam:                 ;create stop label
        PUBLIC $$A_STOP_&pnam           ;make it public
    ENDIF
ENDIF
ENDM
