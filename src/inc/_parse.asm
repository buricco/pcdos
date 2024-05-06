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

page           60,132
name           _parse
title          C to PARSER interface
;-------------------------------------------------------------------
;
;       MODULE:         _parse
;
;       PURPOSE:        Supplies an interface between C programs and
;                       the DOS 3.30 parser
;
;       CALLING FORMAT:
;                       parse(&inregs,&outregs);
;
;       DATE:           5-21-87
;
;-------------------------------------------------------------------

;       extrn   sysparse:far

        public  _parse

;-------------------------------------------------------------------

; SET FOR SUBST
; -------------

FarSW   equ     0       ; make sysparse be a NEAR proc
TimeSW  equ     0       ; Check time format
FileSW  equ     1       ; Check file specification
CAPSW   equ     1       ; Perform CAPS if specified
CmpxSW  equ     0       ; Check complex list
NumSW   equ     0       ; Check numeric value
KeySW   equ     0       ; Support keywords
SwSW    equ     1       ; Support switches
Val1SW  equ     0       ; Support value definition 1
Val2SW  equ     0       ; Support value definition 2
Val3SW  equ     0       ; Support value definition 3
DrvSW   equ     1       ; Support drive only format
QusSW   equ     0       ; Support quoted string format
;-------------------------------------------------------------------

_DATA   segment byte public 'DATA'
_DATA   ends

_TEXT   segment byte public 'CODE'

        ASSUME  CS: _TEXT
        ASSUME  DS: _DATA

;-------------------------------------------------------------------
include parse.asm               ; include the parser
;-------------------------------------------------------------------

_parse  proc    near

        push    bp              ; save user's base pointer
        mov     bp,sp           ; set bp to current sp
        push    di              ; save some registers
        push    si

;       copy C inregs into proper registers

        mov     di,[bp+4]       ; fix di (arg 0)

;-------------------------------------------------------------------

        mov     ax,[di+0ah]     ; load di
        push    ax              ; the di value from inregs is now on stack

        mov     ax,[di+00]      ; get inregs.x.ax
        mov     bx,[di+02]      ; get inregs.x.bx
        mov     cx,[di+04]      ; get inregs.x.cx
        mov     dx,[di+06]      ; get inregs.x.dx
        mov     si,[di+08]      ; get inregs.x.si
        pop     di              ; get inregs.x.di from stack

        push    bp              ; save base pointer

;        int     3               ; debugger

;-------------------------------------------------------------------
        call    sysparse        ; call the parser
;-------------------------------------------------------------------

;        int     3               ; debugger

        pop     bp              ; restore base pointer
        push    di              ; the di value from call is now on stack
        mov     di,[bp+6]       ; fix di (arg 1)

        mov     [di+00],ax      ; load outregs.x.ax
        mov     [di+02],bx      ; load outregs.x.bx
        mov     [di+04],cx      ; load outregs.x.cx
        mov     [di+06],dx      ; load outregs.x.dx
        mov     [di+08],si      ; load outregs.x.si

        xor     ax,ax           ; clear ax
        lahf                    ; get flags into ax
        mov     [di+0ch],ax     ; load outregs.x.cflag

        pop     ax              ; get di from stack
        mov     [di+0ah],ax     ; load outregs.x.di

;-------------------------------------------------------------------

        pop     si              ; restore registers
        pop     di
        mov     sp,bp           ; restore sp
        pop     bp              ; restore user's bp
        ret

_parse  endp

_TEXT   ends                    ; end code segment
        end
