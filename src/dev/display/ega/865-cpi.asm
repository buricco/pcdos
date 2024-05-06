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

CODE    SEGMENT BYTE PUBLIC 'CODE'
        ASSUME CS:CODE,DS:CODE

IF1
        %OUT    EGA.CPI creation file
        %OUT    .
        %OUT    CP SRC files:
        %OUT    .
        %OUT    .       CODE PAGE:  865
ENDIF

EGA865: DW     LEN_865                  ; SIZE OF ENTRY HEADER
        DW     POST_EGA865,0            ; POINTER TO NEXT HEADER
        DW     1                        ; DEVICE TYPE
        DB     "EGA     "               ; DEVICE SUBTYPE ID
        DW     865                      ; CODE PAGE ID
        DW     3 DUP(0)                 ; RESERVED
        DW     OFFSET DATA865,0         ; POINTER TO FONTS
LEN_865 EQU    ($-EGA865)               ;
                                        ;
DATA865:DW     1                        ; CART/NON-CART
        DW     3                        ; # OF FONTS
        DW     LEN_D865                 ; LENGTH OF DATA
D865:                                   ;
        DB     16,8                     ; CHARACTER BOX SIZE
        DB     0,0                      ; ASPECT RATIO (UNUSED)
        DW     256                      ; NUMBER OF CHARACTERS
                                        ;
        INCLUDE 865-8X16.ASM            ;
                                        ;
        DB     14,8                     ; CHARACTER BOX SIZE
        DB     0,0                      ; ASPECT RATIO (UNUSED)
        DW     256                      ; NUMBER OF CHARACTERS
                                        ;
        INCLUDE 865-8X14.ASM            ;
                                        ;
        DB     8,8                      ; CHARACTER BOX SIZE
        DB     0,0                      ; ASPECT RATIO (UNUSED)
        DW     256                      ; NUMBER OF CHARACTERS
                                        ;
        INCLUDE 865-8X8.ASM             ;
                                        ;
LEN_D865        EQU ($-D865)            ;
                                        ;
POST_EGA865     EQU     $               ;
                                        ;
CODE    ENDS                            ;
        END                             ;

