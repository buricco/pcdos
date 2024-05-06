; Copyright 2021, 2022, 2024 S. V. Nickolas.
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
; THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT,TORT OR OTHERWISE, ARISING FROM,
; OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
; THE SOFTWARE.

cseg      segment   para public 'CODE'
          assume    cs:cseg, ds:cseg, es:cseg, ss:cseg
          org       100h

; This program requires DOS 2.0 or later because it uses ERRORLEVEL.
; If some weirdo decides to try running us on MS-DOS 1.25 to see what would
; happen, just say "Incorrect DOS version" and exit via INT20 (because MS-DOS
; 1 does not support AH=4C).

entry:    mov       ah, 30h             ; DOS 2 or later?
          int       21h
          cmp       al, 2               ; Major DOS version (0 on 1.x)
          jnb       okdos
          mov       dx, offset edos1    ; No, print error and die screaming
          mov       ah, 9
          int       21h
          int       20h                 ; DOS 1 EXIT

; Case smash AH.  Should be pretty obvious how this works.

toupper:  cmp       ah, 'a'
          jb        tou_ret             ; Can't touch this
          cmp       ah, 'z'
          ja        tou_ret             ; Can't touch this
                                        ; Stop, hammertime
          and       ah, 5Fh             ; Mask off the lowercase bit
tou_ret:  retn      

; Process command line.

todone:   jmp       done                ; Optimization
okdos:    push      cs                  ; Make data segment == code segment
          pop       ds
          push      cs
          pop       es
          mov       si, 81h             ; Start of command line
top:      cmp       si, 100h            ; Overrun
          jnb       todone
          mov       ah, [si]            ; Get next character
          cmp       ah, 0Dh             ; CR - end of line
          jz        todone
          cmp       ah, ' '             ; Kill whitespace
          jnz       notspc
          inc       si                  ; Skip and continue
          jmp short top
notspc:   cmp       ah, 9               ; A tab is fine too, as is a cat
          jnz       nottab
          inc       si                  ; Skip and continue
          jmp short top
nottab:   cmp       ah, '/'             ; Switch?
          jnz       todone              ; No, stop processing
          inc       si                  ; Next character
          mov       ah, [si]
          call      toupper             ; Smash case
          cmp       ah, 'C'             ; /C: select keys to allow
          jnz       notc
          inc       si                  ; Next character
          cld                           ; Zot option list (write 128 zeroes)
          mov       di, offset opt
          xor       al, al              ; Note: the empty switch case will be
          mov       cx, 80h             ;       caught later and crushed
          rep stosb
          mov       di, offset opt      ; Reset pointer
          mov       ah, [si]            ; If followed immediately by :, skip :
          cmp       ah, ':'
          jnz       ctop
          inc       si                  ; Next character
ctop:     mov       ah, [si]            ; Copy options to list
          cmp       ah, 0Dh             ; CR - end of line
          jz        top
          cmp       ah, '/'             ; New switch - end of argument
          jz        top
          cmp       ah, ' '             ; Space - end of argument
          jz        top
          cmp       ah, 9               ; Tab - end of argument
          jz        top
          mov       [di], ah            ; Add it
          inc       si                  ; Advance pointers
          inc       di
          jmp short ctop                ; Keep going
notc:     cmp       ah, 'N'             ; /N - don't display list of choices
          jnz       notn
          mov       byte ptr quiet, 1   ; Set the flag
          inc       si
totop:    jmp short top                 ; Label is for a size optimization
notn:     cmp       ah, 'T'             ; /T - set default option and timeout
          jnz       nott
          inc       si                  ; Next character
          mov       ah, [si]
          cmp       ah, ':'             ; If followed immediately by :, skip :
          jnz       notcolon
          inc       si                  ; Next character
          mov       ah, [si]
notcolon: cmp       ah, 0Dh             ; End of line - arguments incomplete
          jz        synerr
          cmp       ah, ' '             ; End of arg - arguments incomplete
          jz        synerr
          cmp       ah, 9               ; End of arg - arguments incomplete
          jz        synerr
          mov       timeout, ah         ; Save default
          inc       si
          mov       ah, [si]            ; Next char ,?  If not, error
          cmp       ah, ','
          jnz       synerr
          inc       si                  ; Next character
          mov       ah, [si]            ; Digit?  If not, error
          cmp       ah, '0'
          jb        synerr
          cmp       ah, '9'
          ja        synerr
          and       ah, 0Fh             ; Mask it off
          mov       al, ah              ; Hold it
          inc       si                  ; Next character
          mov       ah, [si]            ; Digit?  If not, skip
          cmp       ah, '0'
          jb        onedigit
          cmp       ah, '9'
          ja        onedigit
          and       ah, 0Fh             ; Mask it off
          mov       bl, al              ; The cheap LUT method of *10
          xor       bh, bh
          mov       al, byte ptr ten[bx]
          add       al, ah              ; Combine digits (limit of 99 is
          inc       si                  ; documented by Microsoft)
onedigit: mov       seconds, al         ; Save our timeout and loop back
          jmp short totop               ; (Pointer is already on next char)
nott:     cmp       ah, 'S'             ; /S - case-sensitive
          jnz       badswtch            ; No, invalid switch
          mov       byte ptr nosmash, 1 ; Set the flag
          inc       si                  ; Next character
          jmp short totop               ; Go back, Jack, and do it again
badswtch: mov       fault, ah           ; Alter the message to include the
          mov       dx, offset eswitch  ; letter of the invalid switch
          jmp short scream
synerr:   mov       dx, offset esyn     ; FALL INTO
scream:   mov       ah, 9               ; Die screaming (with error)
          int       21h
          mov       ax, 4CFFh
          int       21h                 ; EXIT (code=255)

; Done with argument processing.  Rest of command line is prompt.
; Now smash the case of options (if needed) and make sure that if a default
; option was set with /T that it is valid.

done:     mov       ah, byte ptr opt    ; Make sure we have any options set
          or        ah, ah              ; (someone didn't use /C by itself)
          jz        synerr
          mov       ah, nosmash         ; Skip rest of block if /S specified
          or        ah, ah
          jnz       smashed
          mov       di, offset opt      ; Upcase the entire option list
optloop:  mov       ah, [di]            ; Get next potential option
          or        ah, ah              ; Zero = end
          jz        smashed
          call      toupper             ; Upcase option, then keep going
          mov       [di], ah
          inc       di
          cmp       di, offset optend   ; End of our memory block?
          jb        optloop             ; No, keep going
smashed:  mov       ah, timeout         ; Skip rest of block
          or        ah, ah              ;   unless /T specified
          jz        toutok
          mov       ah, nosmash         ; If we're smashing case, smash the
          or        ah, ah              ; case of the default option too.
          jnz       smashed2
          mov       ah, timeout         ; Smash case and then put it back.
          call      toupper
          mov       timeout, ah
smashed2: mov       di, offset opt      ; Set initial pointer
toutloop: mov       ah, [di]            ; Get next option
          or        ah, ah              ; Is it zero (end of list)?
          jz        nerpski             ; Yes, eat screaming death
          cmp       ah, timeout         ; Is it our char?
          jz        toutok              ; Yes, so move on
          inc       di                  ; Next, please
          cmp       di, offset optend   ; End of list?
          jb        toutloop            ; No, keep going
nerpski:  mov       dx, offset edefault ; OK, it's broken, so die screaming
          jmp short scream

; Display prompt.

toutok:   cmp       si, 100h            ; End of memory?
          jnb       pmptdone            ; Yes, quit reading
          mov       ah, [si]            ; Get our character
          cmp       ah, 0Dh             ; EOL?
          jz        pmptdone            ; Yes, quit reading
          mov       dl, ah              ; Tell DOS to write it
          mov       ah, 2
          int       21h
          inc       si                  ; NEXT!
          jmp short toutok
pmptdone: mov       ah, quiet           ; Skip rest of block if /N specified
          or        ah, ah
          jnz       shutup
          mov       si, offset opt
          mov       dl, '['             ; Open prompt
          jmp short sepchar             ; "[" the first time, "," thereafter
pmptloop: mov       dl, ','
sepchar:  mov       ah, 2
          int       21h
          mov       dl, [si]            ; Get character (DOS wants it in DL)
          or        dl, dl              ; Zero (end of list)?
          jz        pmptq               ; Done
          mov       ah, 2               ; Print it by DOS
          int       21h
          inc       si                  ; Next character
          mov       ah, [si]
          or        ah, ah              ; Zero (end of list)?
          jz        pmptq               ; Yes, so end parsing
          cmp       si, offset optend
          jb        pmptloop
pmptq:    mov       dx, offset closetag ; "]?" to close prompt
          mov       ah, 9
          int       21h
shutup:   mov       ah, timeout         ; If not using a timeout, use a simple
          or        ah, ah              ; keyboard read function.
          jz        rdsimple
          mov       ah, 2Ch             ; Get the initial system time
          int       21h                 ; (only seconds needed)
          mov       tank, dh
tick:     mov       ah, 0Bh             ; Poll the keyboard via DOS
          int       21h
          or        al, al              ; Is a key waiting?
          jnz       rdsimple            ; Stop waiting and do normal read.
          mov       ah, 2Ch             ; No; get the new time.
          int       21h
          cmp       dh, tank            ; Tick?
          jz        tick                ; Not yet; loop
          mov       tank, dh            ; Update
          mov       ah, seconds         ; Countdown
          dec       ah
          mov       seconds, ah         ; Update
          or        ah, ah
          jnz       tick                ; Not done yet
          mov       ah, timeout         ; Time's up; get default
          jmp short ckkey
rdsimple: mov       ah, 8               ; Request blocking input from STDIN
          int       21h
          mov       ah, al              ; Move key to work register
          mov       al, nosmash         ; Are we smashing case?
          or        al, al
          jnz       ckkey               ; No; skip
          call      toupper             ; Yes; do it, maggot
ckkey:    mov       si, offset opt      ; Is the pressed key valid?
          mov       al, 1               ; This will be our ERRORLEVEL
ckkl:     cmp       ah, [si]            ; Check against next key in list
          jz        gotit               ; We gotcha!
          inc       al                  ; Increment ERRORLEVEL
          inc       si                  ; Increment offset
          mov       bl, [si]            ; Zero?
          or        bl, bl
          jz        ckfail              ; Yes; stop looking
          cmp       si, offset optend   ; End of the line
          jb        ckkl                ; Nope; keep looking (otherwise error)
ckfail:   mov       ah, 2
          mov       dl, 7               ; Beep
          int       21h
          jmp short rdsimple            ; Even if we have a timeout, a key w
                                        ; pressed, so ignore the timeout.
gotit:    mov       tank, al            ; Hold this
          mov       dl, ah              ; Echo the key
          mov       ah, 2
          int       21h
          mov       dx, offset crlf     ; Write newline
          mov       ah, 9
          int       21h
          mov       al, tank            ; Get our ERRORLEVEL back
          mov       ah, 4Ch             ; and send it back to DOS as we
          int       21h                 ; EXIT

ten       db        0, 10, 20, 30, 40, 50, 60, 70, 80, 90

tank      db        0

quiet     db        0
nosmash   db        0
timeout   db        0
seconds   db        0

edos1     db        "Incorrect DOS version",0Dh,0Ah,"$"
esyn      db        "Syntax error",0Dh,0Ah,"$"
eswitch   db        "Invalid switch - /"
fault     db        0
crlf      db        0Dh,0Ah,"$"
edefault  db        "Default option not valid",0Dh,0Ah,"$"
closetag  db        "]?$"

opt       db        "YN",0

optend    equ       opt+80h

cseg      ends
          end       entry
