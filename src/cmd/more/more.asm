; Copyright 1983, 1988 Microsoft Corp.
; Copyright 1988 International Business Machines Corp.
; Copyright 2021, 2022, 2026 S. V. Nickolas.
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
; THE SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
; FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
; IN THE SOFTWARE.

cseg      segment   para public 'CODE'
          assume    cs:cseg, ds:cseg, es:cseg, ss:cseg
          org       0100h

entry:    push      cs                  ; Make sure DS points to us
          pop       ds
          mov       ah, 30h             ; Check for DOS 1.x and die screaming
          int       21h
          cmp       al, 02h
          jae       okdos
          mov       dx, offset edos1
          mov       ah, 09h
          int       21h
          int       20h

ansibuf:  dw        0000h               ; IOCTL buffer
          dw        000Eh
          dw        0000h
d_mode:   db        00h
          db        00h
          dw        0000h
          dw        0000h
          dw        0000h
          dw        0000h
scr_rows: dw        0000h

okdos:    mov       ax, 440Ch           ; This call needs DOS 4's ANSI.SYS
          mov       bx, 0002h
          mov       cx, 037Fh
          mov       dx, offset ansibuf
          int       21h
          jc        noansi              ; Didn't work, assume 25 lines
          mov       ah, byte ptr d_mode
          cmp       ah, 1
          jne       noansi              ; Not text mode, assume 25 lines
          mov       ax, word ptr scr_rows
          mov       byte ptr maxrow, al
noansi:   mov       ah, 0Fh             ; Get width from BIOS
          int       10h
          mov       byte ptr maxcol, ah

          mov       dx, offset crlf
          mov       ah, 09h
          int       21h
          xor       bx, bx              ; dup(stdin)
          mov       ah, 45h
          int       21h
          mov       bp, ax
          mov       ah, 3Eh             ; close
          int       21h
          mov       bx, 0002h
          mov       ah, 45h             ; dup(stderr)
          int       21h

aloop:    cld                           ; read up to 4K at a time
          mov       dx, offset buffer
          mov       cx, 1000h
          mov       bx, bp
          mov       ah, 3Fh
          int       21h
          or        ax, ax              ; EOF?
          jnz       setcx               ; no, keep going
done:     mov       ax, 4C00h           ; yes, exit successfully
          int       21h
setcx:    mov       cx, ax
          mov       si, dx
tloop:    lodsb
          cmp       al, 1Ah             ; EOF (^Z)?
          jz        done                ; yes, die
          cmp       al, 0Dh             ; CR?
          jnz       notcr               ; no, skip
          mov       byte ptr curcol, 1  ; act on it
          jmp short iscntrl
notcr:    cmp       al, 0Ah             ; linefeed?
          jnz       notlf               ; no, skip
          inc       byte ptr currow     ; act on it
          jmp short iscntrl
notlf:    cmp       al, 08h             ; backspace?
          jnz       notbs               ; no, skip
          cmp       byte ptr curcol, 1  ; beginning of line?
          jz        iscntrl             ; yes, skip
          dec       byte ptr curcol     ; act on it
          jmp short iscntrl
notbs:    cmp       al, 09h             ; tab?
          jnz       nottb               ; no, skip
          mov       ah, byte ptr curcol ; tab stops of 8 chars.
          add       ah, 07h
          and       ah, 0F8h
          inc       ah
          mov       byte ptr curcol, ah
          jmp short iscntrl
nottb:    cmp       al, 07h             ; bell?
          jz        iscntrl             ; yes, act on it
          inc       byte ptr curcol     ; add to our column position
          mov       ah, byte ptr curcol
          cmp       ah, byte ptr maxcol
          jbe       iscntrl
          inc       byte ptr currow     ; add to our row position
          mov       byte ptr curcol, 1  ; reset column position
iscntrl:  mov       dl, al              ; write the character to stdout
          mov       ah, 02h
          int       21h
          mov       ah, byte ptr currow ; end of screen?
          cmp       ah, byte ptr maxrow
          jb        charloop            ; no, keep processing
askmore:  mov       dx, offset emore    ; "-- More --" prompt
          mov       ah, 09h
          int       21h
          mov       ah, 0Ch             ; flush input, get char
          mov       al, 01h
          int       21h
          mov       dx, offset crlf     ; write newline
          mov       ah, 09h
          int       21h
          mov       byte ptr curcol, 1  ; reset position
          mov       byte ptr currow, 1
charloop: dec       cx
          jz        gobig
          jmp       tloop
gobig:    jmp       aloop

maxrow:   db        18h
maxcol:   db        50h
currow:   db        01h
curcol:   db        01h

edos1:    db        "Incorrect DOS version"
crlf:     db        13, 10, "$"
emore:    db        "-- More --$"

buffer:

cseg      ends
          end       entry
