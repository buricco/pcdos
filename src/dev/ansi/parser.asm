; Copyright 1983-1988 International Business Machines Corp.
; Copyright 1985-1988 Microsoft Corp.
; Copyright 2026 S. V. Nickolas.
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
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
; FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
; DEALINGS IN THE SOFTWARE.

code            segment public byte
                assume  cs:code

extrn           switch_x:byte
extrn           switch_l:byte
extrn           switch_k:byte
public          parse_parm

; Original document says that we enter this function with DS:SI pointing to
; our command line.  Skip until we hit a space or a slash - that's the end of
; our name and the beginning of the actual command tail - then start parsing.
;
; To ease on the complexity, ignore non-switch arguments.

parse_parm      proc    near

nextchr:        mov     ah, [si]
		or	ah, ah
		jz	outtie
                cmp     ah, '/'
                jz      switch
                cmp     ah, 13
                jnz     spc
outtie:         clc
		ret
badparm:        push    cs
                pop     ds
                mov     dx, offset earg
ercommon:       mov     ah, 9
                int     21h
                stc
                ret

spc:            inc     si
                jmp     short nextchr

switch:         inc     si
                mov     ah, [si]
                inc     si
                cmp     ah, 'a'
                jb      nosmash
                cmp     ah, 'z'
                ja      nosmash
                and     ah, 5Fh
nosmash:        cmp     ah, 'X'
                jz      gotx
                cmp     ah, 'L'
                jz      gotl
                cmp     ah, 'K'
                jnz     badparm
                mov     switch_k, 1
                jmp     short nextchr

gotx:           mov     switch_x, 1
                jmp     short nextchr
gotl:           mov     switch_l, 1
                jmp     short nextchr
parse_parm      endp

earg            db      'ANSI.SYS: Invalid parameter', 0Dh, 0Ah, '$'

code            ends
                end
