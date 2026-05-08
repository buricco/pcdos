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
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT,TORT OR OTHERWISE, ARISING FROM,
; OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
; THE SOFTWARE.

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;
;       ADDRESSES FOR I/O
;
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;------------------------------------------------------------------------------
;AN000; New functionality in DOS 4.00
;AN001; GHG fix scrolling flashes on Mod 25/30's
;AN002; P1767 VIDEO_MODE_TABLE not initialized correctly           10/16/87 J.K.
;AN003; D375 /X needs to be supported by ANSI sequence also        12/14/87 J.K.
;AN004; D397 /L option for Enforcing number of lines               12/17/87 J.K.
;AN005; D479  An option to disable the extended keyboard functions 02/12/88 J.K.
;AN006; P4241 AN001 fix be Revised to fix this problem            04/20/88 J.K.
;AN007; P4532 Scrolling has a snow for CGA adapter                 04/27/88 J.K.
;AN008; P4533 In mode Dh, Eh, Fh, 10h and 13h, Scrolling not working 04/27/88 J.K.
;AN009; P4766 In mode 11h, and 12h erase display leaves bottom 5   05/24/88 F.G.
;------------------------------------------------------------------------------
TRUE     EQU 0FFFFh
FALSE    EQU 0

BREAK   MACRO   subtitle
        SUBTTL  subtitle
        PAGE    ,132
ENDM

AsmVars Macro   varlist
IRP     var,<varlist>
AsmVar  var
ENDM
ENDM

AsmVar  Macro   var
IFNDEF  var
var = FALSE
ENDIF
ENDM

INCLUDE ansi.inc                ; equates and structures
.list
        CR=13                   ;CARRIAGE RETURN
        BACKSP=8                ;BACKSPACE
        ESC_CHAR=1BH
        BRKADR=6CH              ;006C  BREAK VECTOR ADDRESS
        ASNMAX=400              ;WGR  (increased) SIZE OF KEY ASSIGNMENT BUFFER
PUBLIC  SWITCH_X                ;/X option for extended keyboard redefinition support;AN000;
PUBLIC  SCAN_LINES              ;
PUBLIC  VIDEO_MODE_TABLE        ;
PUBLIC  VIDEO_TABLE_MAX         ;
public  MAX_VIDEO_TAB_NUM       ;P1767
PUBLIC  PTRSAV                  ;
PUBLIC  ERR1                    ;
PUBLIC  ERR2                    ;
PUBLIC  EXT_16                  ;
PUBLIC  BRKADR                  ;
PUBLIC  BRKKY                   ;
PUBLIC  COUT                    ;
PUBLIC  BASE                    ;
PUBLIC  MODE                    ;
PUBLIC  MAXCOL                  ;
PUBLIC  TRANS                   ;
PUBLIC  STATUS                  ;
PUBLIC  EXIT                    ;
PUBLIC  NO_OPERATION            ;
PUBLIC  HDWR_FLAG               ;
public  Switch_L                ;AN004;
public  Switch_K                ;AN005;

CODE    SEGMENT PUBLIC BYTE
   ASSUME CS:CODE,DS:NOTHING,ES:NOTHING
;-----------------------------------------------
;
;       C O N - CONSOLE DEVICE DRIVER
;
EXTRN   CON$INIT:NEAR           ; ANSI initialization code
EXTRN   GENERIC_IOCTL:NEAR      ; Generic IOCTL code
EXTRN   REQ_TXT_LENGTH:WORD     ; current text length
EXTRN   GRAPHICS_FLAG:BYTE      ; graphics flag
CONDEV:                                 ;HEADER FOR DEVICE "CON"
        DW      -1,-1
        DW      1100000001010011B       ;WGR changed to match CON
        DW      STRATEGY
        DW      ENTRY
        DB      'CON     '

;--------------------------------------------------------------
;
;       COMMAND JUMP TABLES
CONTBL:
        DW      CON$INIT
        DW      NO_OPERATION         ;
        DW      NO_OPERATION         ;
        DW      NO_OPERATION         ;
        DW      CON$READ
        DW      CON$RDND
        DW      NO_OPERATION         ;
        DW      CON$FLSH
        DW      CON$WRIT
        DW      CON$WRIT
        DW      NO_OPERATION         ;
        DW      NO_OPERATION         ;
        DW      NO_OPERATION         ;
        DW      NO_OPERATION         ;
        DW      NO_OPERATION         ;
        DW      NO_OPERATION         ;
        DW      NO_OPERATION         ;
        DW      NO_OPERATION         ;
        DW      NO_OPERATION         ;
        DW      GENERIC_IOCTL        ; generic IOCTL routine offset
MAX_CMD  EQU  ($ - CONTBL)/2         ; size of CONTBL
CMDTABL DB      'A'
        DW      CUU             ;cursor up
        DB      'B'
        DW      CUD             ;cursor down
        DB      'C'
        DW      CUF             ;cursor forward
        DB      'D'
        DW      CUB             ;cursor back
        DB      'H'
        DW      CUP             ;cursor position
        DB      'J'
        DW      ED              ;erase display
        DB      'K'
        DW      EL              ;erase line
        DB      'R'
        DW      CPR             ;cursor postion report
        DB      'f'
        DW      CUP             ;cursor position
        DB      'h'
        DW      SM              ;set mode
        DB      'l'
        DW      RM              ;reset mode
        DB      'm'
        DW      SGR             ;select graphics rendition
        DB      'n'
        DW      DSR             ;device status report
        DB      'p'
        DW      KEYASN          ;key assignment
        db      'q'             ; dynamic support of /X option through ansi sequence
        dw      ExtKey          ; esc[0q = reset it. esc[1q = set it
        DB      's'
        DW      PSCP            ;save cursor postion
        DB      'u'
        DW      PRCP            ;restore cursor position
        DB      00
GRMODE  DB      00,00000000B,00000111B
        DB      01,11111111B,00001000B
        DB      04,11111000B,00000001B
        DB      05,11111111B,10000000B
        DB      07,11111000B,01110000B
        DB      08,10001000B,00000000B
        DB      30,11111000B,00000000B
        DB      31,11111000B,00000100B
        DB      32,11111000B,00000010B
        DB      33,11111000B,00000110B
        DB      34,11111000B,00000001B
        DB      35,11111000B,00000101B
        DB      36,11111000B,00000011B
        DB      37,11111000B,00000111B
        DB      40,10001111B,00000000B
        DB      41,10001111B,01000000B
        DB      42,10001111B,00100000B
        DB      43,10001111B,01100000B
        DB      44,10001111B,00010000B
        DB      45,10001111B,01010000B
        DB      46,10001111B,00110000B
        DB      47,10001111B,01110000B
        DB      0FFH
;---------------------------------------------------
;
;       Device entry point
;
CMDLEN  =       0       ;LENGTH OF THIS COMMAND
UNIT    =       1       ;SUB UNIT SPECIFIER
CMD     =       2       ;COMMAND CODE
STATUS  =       3       ;STATUS
MEDIA   =       13      ;MEDIA DESCRIPTOR
TRANS   =       14      ;TRANSFER ADDRESS
COUNT   =       18      ;COUNT OF BLOCKS OR CHARACTERS
START   =       20      ;FIRST BLOCK TO TRANSFER
PTRSAV  DD      0
BUF1:      BUF_DATA <>                  ; Next CON Buffer area

STRATP  PROC    FAR
STRATEGY:
        MOV     WORD PTR CS:[PTRSAV],BX
        MOV     WORD PTR CS:[PTRSAV+2],ES
        RET
STRATP  ENDP
ENTRY:
        PUSH    SI
        PUSH    AX
        PUSH    CX
        PUSH    DX
        PUSH    DI
        PUSH    BP
        PUSH    DS
        PUSH    ES
        PUSH    BX
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                         WGR
; Check if header link has to be set      WGR (Code ported from
;                                         WGR  DISPLAY.SYS)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        LEA     BX, BUF1                ;
        MOV     DI,OFFSET CONDEV        ; CON Device header
                                        ;
        MOV     CONPTR.DEV_HDRO,DI      ;
        MOV     CONPTR.DEV_HDRS,CS      ;
        CLD                             ; all moves forward
                                        ;
        CMP     CONPTR.CON_STRAO, -1    ;
        JNE     L4                      ; has been linked to DOS CON
        CMP     CONPTR.CON_STRAS, -1    ;
        JNE     L4                      ; has been linked to DOS CON
                                        ;  next device header :  ES:[DI]
        LDS     SI,DWORD PTR CONPTR.DEV_HDRO;WGR
        LES     DI,DWORD PTR HP.DH_NEXTO;
                                        ;
;$SEARCH WHILE                          ;  pointer to next device header is NOT
L1:                                     ;
        PUSH    ES                      ;  -1
        POP     AX                      ;
        CMP     AX,-1                   ;
;$LEAVE  E,      AND                    ; leave if both offset and segment are
        JNE     NOT0FFFF                ;
                                        ;
        CMP     DI,-1                   ;  0FFFFH
;$LEAVE  E                              ;
        JE      L4                      ;
NOT0FFFF:                               ;
        PUSH    DI                      ;
        PUSH    SI                      ;
        MOV     CX,NAME_LEN             ;
        LEA     DI,NHD.DH_NAME          ;
        LEA     SI,HP.DH_NAME           ;
        REPE    CMPSB                   ;
        POP     SI                      ;
        POP     DI                      ;
        AND     CX,CX                   ;
;$EXITIF Z                              ; Exit if name is found in linked hd.
        JNZ     L3                      ; Name is not found
                                        ; Name is found in the linked header
        MOV     AX,NHD.DH_STRAO         ; Get the STRATEGY address
        MOV     CONPTR.CON_STRAO,AX     ;
        MOV     AX,ES                   ;
X1:     MOV     CONPTR.CON_STRAS,AX     ;
                                        ;
        MOV     AX,NHD.DH_INTRO         ; Get the INTERRUPT address
        MOV     CONPTR.CON_INTRO,AX     ;
        MOV     AX,ES                   ;
X2:     MOV     CONPTR.CON_INTRS,AX     ;
                                        ;
;$ORELSE                                ; FInd next header to have the same
        JMP     L4                      ; Device Name
L3:                                     ;
        LES     DI,DWORD PTR NHD.DH_NEXTO;WGR
;$ENDLOOP                               ;
        JMP     L1                      ;
L4:                                     ;
        LDS     BX,CS:[PTRSAV]     ;GET PONTER TO I/O PACKET
        MOV     CX,WORD PTR DS:[BX].COUNT    ;CX = COUNT
        MOV     AL,BYTE PTR DS:[BX].CMD
        CBW
        MOV     SI,OFFSET CONTBL
        ADD     SI,AX
        ADD     SI,AX
        CMP     AL,MAX_CMD              ; not a call for ANSI...chain to lower device;AC000;
        JA      NO_OPERATION
        LES     DI,DWORD PTR DS:[BX].TRANS
        PUSH    CS
        POP     DS
        ASSUME  DS:CODE
        JMP     WORD PTR [SI]              ;GO DO COMMAND
;=====================================================
;=
;=      SUBROUTINES SHARED BY MULTIPLE DEVICES
;=
;=====================================================
;----------------------------------------------------------
;
;       EXIT - ALL ROUTINES RETURN THROUGH THIS PATH
;
BUS$EXIT:                               ;DEVICE BUSY EXIT
        MOV     AH,00000011B
        JMP     SHORT ERR1
NO_OPERATION:                           ;
        CALL    PASS_CONTROL            ; Pass control to lower CON
        JMP     SHORT ERR2              ;
ERR$EXIT:
        MOV     AH,10000001B            ;MARK ERROR RETURN
        JMP     SHORT ERR1
EXITP   PROC    FAR
EXIT:   MOV     AH,00000001B
ERR1:   LDS     BX,CS:[PTRSAV]
        MOV     WORD PTR [BX].STATUS,AX      ;MARK OPERATION COMPLETE
ERR2:
        POP     BX                      ;
        POP     ES
        POP     DS
        POP     BP
        POP     DI
        POP     DX
        POP     CX
        POP     AX
        POP     SI
        RET                             ;RESTORE REGS AND RETURN
EXITP   ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                         WGR
;       PASS CONTROL                      WGR
;                                         WGR
;       This calls the attached device to perform any further
;       action on the call!               WGR
;                                         WGR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PASS_CONTROL    PROC                    ;
        LEA     SI,BUF1                 ;
        LES     BX,CS:[PTRSAV]          ; pass the request header to the
        CALL    DWORD PTR CS:[SI].CON_STRAO ; CON strategy routine.
        CALL    DWORD PTR CS:[SI].CON_INTRO ; interrupt the CON
        RET                             ;
PASS_CONTROL    ENDP                    ;
;-----------------------------------------------
;
;       BREAK KEY HANDLING
;
BRKKY:
        MOV     CS:ALTAH,3              ;INDICATE BREAK KEY SET

INTRET: IRET
;
;       WARNING - Variables are very order dependent, be careful
;                 when adding new ones!  - c.p.
;
WRAP    DB      0               ; 0 = WRAP, 1 = NO WRAP
ASNPTR  DW      4
STATE   DW      S1
MODE    DB      3               ;*
MAXCOL  DB      79              ;*
COL     DB      0
ROW     DB      0
SAVCR   DW      0
INQ     DB      0
PRMCNT  LABEL   BYTE
PRMCNTW DW      0
KEYCNT  DB      0
KEYPTR  DW      BUF
REPORT  DB      ESC_CHAR,'[00;00R',CR        ;CURSOR POSTION REPORT BUFFER

ALTAH   DB      0                       ;Special key handling
EXT_16       DB      0                  ; Extended INT 16h flag
Switch_X     DB      OFF                ; /X flag
Switch_L     db      OFF                ;DCR397; 1= /L flag entered.
Switch_K     db      OFF                ;AN005; To control EXT_16
SCAN_LINES   DB      ?                  ; flag for available scan lines (VGA)
HDWR_FLAG    DW      0                  ; byte of flags indicating video support
VIDEO_MODE_TABLE   LABEL   BYTE         ; table containing applicable
MODE_TABLE   <>                         ; video modes and corresponding
MODE_TABLE   <>                         ; data.
MODE_TABLE   <>                         ; this table is initialized at
MODE_TABLE   <>                         ; INIT time
MODE_TABLE   <>                         ;
MODE_TABLE   <>                         ;
MODE_TABLE   <>                         ;
MODE_TABLE   <>                         ;
MODE_TABLE   <>                         ;
MODE_TABLE   <>                         ;
MODE_TABLE   <>                         ;
MODE_TABLE   <>                         ;
MODE_TABLE   <>                         ;
MODE_TABLE   <>                         ;
MODE_TABLE   <>                         ;

VIDEO_TABLE_MAX     EQU  $              ; maximum address for video table
MAX_VIDEO_TAB_NUM   EQU  ($-VIDEO_MODE_TABLE)/13 ; TYPE MODE_TABLE ;P1767 Max number of table

;-------------------------------------------------------------
;
;       CHROUT - WRITE OUT CHAR IN AL USING CURRENT ATTRIBUTE
;
ATTRW   LABEL   WORD
ATTR    DB      00000111B       ;CHARACTER ATTRIBUTE
BPAGE   DB      0               ;BASE PAGE
base       dw   0b800h
screen_seg dw   00000h
chrout: cmp     al,13
        jnz     trylf
        mov     [col],0
        jmp     short setit
trylf:  cmp     al,10
        jz      lf
        cmp     al,7
        jnz     tryback
torom:
        mov     bx,[attrw]
        and     bl,7
        mov     ah,14
        int     10h
ret5:   ret
tryback:
        cmp     al,8
        jnz     outchr
        cmp     [col],0
        jz      ret5
        dec     [col]
        jmp     short setit
outchr:
        mov     bx,[attrw]
        mov     cx,1
        mov     ah,9
        int     10h
        inc     [col]
        mov     al,[col]
        cmp     al,[maxcol]
        jbe     setit
        cmp     [wrap],0
        jz      outchr1
        dec     [col]
        ret
outchr1:
        mov     [col],0
lf:     inc     [row]
        MOV     AH,30                   ; GHG  Fix for ROUNDUP/PALACE
        MOV     AL,MODE                 ; GHG  Fix for ROUNDUP/PALACE
        CMP     AL,11H                  ; GHG  Fix for ROUNDUP/PALACE
        JE      LF2                     ; GHG  Fix for ROUNDUP/PALACE
        CMP     AL,12H                  ; GHG  Fix for ROUNDUP/PALACE
        JE      LF2                     ; GHG  Fix for ROUNDUP/PALACE
					cmp GRAPHICS_FLAG,GRAPHICS_MODE 
					jne $l2 
          MOV     AH,DEFAULT_LENGTH     ;
					jmp short $l1 
$l2: 
          MOV     AH,BYTE PTR [REQ_TXT_LENGTH] ; GHG  Fix for ROUNDUP/PALACE
$l1: 
LF2:                                    ; GHG  Fix for ROUNDUP/PALACE
        cmp     [row],AH                ; GHG  Fix for ROUNDUP/PALACE
        jb      setit
        DEC     AH                      ; GHG  Fix for ROUNDUP/PALACE
        mov     [row],AH                ; GHG  Fix for ROUNDUP/PALACE
        call    scroll
setit:  mov     dh,row
        mov     dl,col
        mov     bh,[bpage]
        mov     ah,2
        int     10h
        ret
;AN006;Writing a LF char through Teletype function to scroll the screen
;has a side effect of changing the color of the cursor when the PROMPT
;setting in PTM P4241 is used. AN001 uses this method to fix the strobing
;problem of the palace machine.  The old method of scrolling used to directly
;write into video buffer.  The old method has been used by AN001 for
;CGA adater of mode 2 or 3 only.
;To solve P4241, but to maintain the fix of the strobing problem of palace
;machine, we return back to the old logic but the old logic has to be
;Revised for the displays above CGA level.  For the adapters above
;CGA display, we don't need to turn off/on the video - this will causes
;a strobing, if you use do this,  for Palace machine.
;This logic will be only applied to mode 2 and 3 only.
scroll:
;AN006;AN008; Myscroll is only for Mode 2 and 3 of all display unit.
;        .IF <BIT HDWR_FLAG eq CGA_ACTIVE>     ; GHG is this the CGA?
					cmp MODE,2 
					je $l7 
					cmp MODE,3 
					jne $l5 
$l7: 
              jmp     myscroll
$l5: 
;        .ENDIF
;AN006;AN008; Other modes (=APA mode) use TeleType function of
; writing LF to scroll the screen!.
        mov     al,10                           ; GHG
        jmp     torom                           ; GHG
myscroll:
        mov     bh,[attr]
        mov     bl,' '
        MOV     AL,[MAXCOL]                     ;
        CBW                                     ;
        INC     AX                              ;
        MOV     BP,AX                           ;
        MOV     SI,BP                           ;
        ADD     SI,BP                           ;
					cmp GRAPHICS_FLAG,GRAPHICS_MODE 
					jne $l9 
          MOV     AX,DEFAULT_LENGTH             ;
					jmp short $l8 
$l9: 
          MOV     AX,[REQ_TXT_LENGTH]           ;
$l8: 
        DEC     AX                              ;
        MUL     BP                              ;
        MOV     CX,AX                           ;
        mov     ax,[base]
        add     ax,[screen_seg]
        mov     es,ax
        mov     ds,ax
        xor     di,di
        cld
        cmp     cs:[base],0b800h
        jz      colorcard
        rep     movsw
        mov     ax,bx
        mov     cx,bp
        rep     stosw
sret:   push    cs
        pop     ds
        ret
colorcard:
; We must protect this with a critical section
;
;   INT 29H calls to device drivers do not enter CritDevice
;   The user MIGHT hit Ctrl-NumLock in the middle of this
;       which will leave the screen blanked.
        mov     ax,8002H                  ; Enter Device critical section
        int     2Ah
        cmp     cs:[Hdwr_Flag], MCGA_ACTIVE ;AN006;AN007;above CGA level?
        jae     Skip_Video_Off            ;AN006;AN007;
        mov     dx,3dah
wait2:  in      al,dx
        test    al,8
        jz      wait2
        mov     al,25h
        mov     dx,3d8h
        out     dx,al                     ;turn off video
Skip_Video_Off:                           ;AN006;
        rep     movsw
        mov     ax,bx
        mov     cx,bp
        rep     stosw
        cmp     cs:[Hdwr_Flag], MCGA_ACTIVE ;AN006;AN007;
        jae     Skip_Video_On             ;AN006;AN007;
        mov     al,29h
        mov     dx,3d8h
        out     dx,al                     ;turn on video
Skip_Video_On:                            ;AN006;
        mov     ax,8102H                  ; Leave Device critical section
        int     2Ah
       jmp     sret
;------------------------------------------------------
;
;       CONSOLE READ ROUTINE
;
CON$READ:
        JCXZ    CON$EXIT
CON$LOOP:
        PUSH    CX              ;SAVE COUNT
        CALL    CHRIN           ;GET CHAR IN AL
        POP     CX
        STOSB                   ;STORE CHAR AT ES:DI
        LOOP    CON$LOOP
CON$EXIT:
        JMP     EXIT
;---------------------------------------------------------
;
;       INPUT SINGLE CHAR INTO AL
;
CHRIN:  XOR     AX,AX
        XCHG    AL,ALTAH     ;GET CHARACTER & ZERO ALTAH
        OR      AL,AL
        JNZ     KEYRET
INAGN:  CMP     KEYCNT,0
        JNZ     KEY5A
        XOR     AH,AH
					cmp EXT_16,ON 
					jne $l13 
           MOV    AH,10h             ; yes..perform extended call
           INT    16H                ;
					cmp SWITCH_X,OFF 
					jne $l15 
              CALL   CHECK_FOR_REMAP ; no....map to normal call
$l15: 
           CALL    SCAN              ; check for redefinition
					jz $l12 
					cmp SWITCH_X,ON 
					jne $l12 
              CALL   CHECK_FOR_REMAP ; then remap..
              OR     BX,BX           ; reset zero flag for jump test in old code
					jmp short $l12 
$l13: 
           INT   16H                 ;
           CALL    SCAN              ; check for redefinition
$l12: 
        JNZ     ALT10           ;IF NO MATCH JUST RETURN IT
        DEC     CX
        DEC     CX
        INC     BX
        INC     BX
					cmp AL,0 
					je $l24 
					cmp AL,0E0H 
					jne $l22 
					cmp SWITCH_X,1 
					jne $l22 
$l24: 
           DEC     CX                  ; adjust pointers
           INC     BX                  ; appropiately
$l22: 
        MOV     KEYCNT,CL
        MOV     KEYPTR,BX
KEY5A:                          ; Jmp here to get rest of translation
        CALL    KEY5            ;GET FIRST KEY FROM TRANSLATION
ALT10:
        OR      AX,AX           ;Check for non-key after BREAK
        JZ      INAGN
        OR      AL,AL           ;SPECIAL CASE?
        JNZ     KEYRET
        MOV     ALTAH,AH        ;STORE SPECIAL KEY
KEYRET: RET
KEY5:   MOV     BX,KEYPTR       ;GET A KEY FROM TRANSLATION TABLE
        MOV     AX,WORD PTR [BX]
        DEC     KEYCNT
        INC     BX
        OR      AL,AL
        JNZ     KEY6
        INC     BX
        DEC     KEYCNT
KEY6:   MOV     KEYPTR,BX
        RET
SCAN:   MOV     BX,OFFSET BUF
KEYLP:  MOV     CL,BYTE PTR [BX]
        XOR     CH,CH
        OR      CX,CX
        JZ      NOTFND
					cmp AL,0 
					je $l27 
					cmp AL,0E0H 
					jne $l26 
					cmp SWITCH_X,ON 
					jne $l26 
$l27: 
           CMP     AX,WORD PTR [BX+1]  ; yes...compare the word
					jmp short $l25 
$l26: 
           CMP     AL,BYTE PTR [BX+1]  ; no...compare the byte
$l25: 
        JZ      MATCH
        ADD     BX,CX
        JMP     KEYLP
NOTFND: OR      BX,BX
MATCH:  RET
;--------------------------------------------------------------
;
;       KEYBOARD NON DESTRUCTIVE READ, NO WAIT
;
CON$RDND:
        MOV     AL,[ALTAH]
        OR      AL,AL
        JNZ     RDEXIT
        CMP     [KEYCNT],0
        JZ      RD1
        MOV     BX,[KEYPTR]
        MOV     AL,BYTE PTR [BX]
        JMP     SHORT RDEXIT
RD1:    MOV     AH,1
					cmp EXT_16,ON 
					jne $l29 
           ADD     AH,10H     ; yes....adjust to extended call
$l29: 
        INT     16H
        JZ      CONBUS
        OR      AX,AX
        JNZ     RD2
        MOV     AH,0
					cmp EXT_16,ON 
					jne $l33 
           MOV    AH,10h             ; yes..perform extended call
           INT    16H                ;
					cmp SWITCH_X,OFF 
					jne $l32 
              CALL   CHECK_FOR_REMAP ; no....map to normal call
					jmp short $l32 
$l33: 
           INT    16H                ;
$l32: 
        JMP     CON$RDND
RD2:    CALL    SCAN
					jz $l39 
					cmp EXT_16,ON 
					jne $l39 
					cmp SWITCH_X,ON 
					jne $l39 
           CALL   CHECK_FOR_REMAP    ; remap to standard call
           OR     BX,BX              ; reset zero flag for jump test in old code
$l39: 
        JNZ     RDEXIT
        MOV     AL,BYTE PTR [BX+2]
        CMP     BYTE PTR [BX+1],0
        JNZ     RDEXIT
        MOV     AL,BYTE PTR [BX+3]
RDEXIT: LDS     BX,[PTRSAV]
        MOV     [BX].MEDIA,AL
EXVEC:  JMP     EXIT
CONBUS: JMP     BUS$EXIT
;--------------------------------------------------------------
;
;       KEYBOARD FLUSH ROUTINE
;
CON$FLSH:
        MOV     [ALTAH],0                 ;Clear out holding buffer
        MOV     [KEYCNT],0
;       PUSH    DS
;       XOR     BP,BP
;       MOV     DS,BP                   ;Select segment 0
;       MOV     DS:BYTE PTR 41AH,1EH    ; Reset KB queue head pointer
;       MOV     DS:BYTE PTR 41CH,1EH    ;Reset tail pointer
;       POP     DS
Flush:  mov     ah,1
					cmp EXT_16,ON 
					jne $l42 
           ADD    AH,10H        ; yes....adjust for extended
$l42: 
        int     16h
        jz      FlushDone
        mov     ah,0
					cmp EXT_16,ON 
					jne $l45 
           ADD    AH,10H        ; yes....adjust for extended
$l45: 
        int     16h
        jmp     Flush
FlushDone:
        JMP     EXVEC
;----------------------------------------------------------
;
;       CONSOLE WRITE ROUTINE
;
CON$WRIT:
        JCXZ    EXVEC
CON$LP: MOV     AL,ES:[DI]      ;GET CHAR
        INC     DI
        CALL    OUTC            ;OUTPUT CHAR
        LOOP    CON$LP          ;REPEAT UNTIL ALL THROUGH
        JMP     EXVEC
COUT:   STI
        PUSH    DS
        PUSH    CS
        POP     DS
        CALL    OUTC
        POP     DS
        IRET
OUTC:   PUSH    AX
        PUSH    BX
        PUSH    CX
        PUSH    DX
        PUSH    SI
        PUSH    DI
        PUSH    ES
        PUSH    BP
        MOV     [BASE],0B800H
        XCHG    AX,SI                   ; SAVE CHARACTER TO STUFF
        MOV     AX,40H                  ; POINT TO ROS BIOS
        MOV     DS,AX
        MOV     AX,DS:[49H]             ; AL=MODE, AH=MAX COL
        DEC     AH                      ; ANSI NEEDS 0-79 OR 0-39
        MOV     WORD PTR CS:[MODE],AX   ; SAVE MODE AND MAX COL
        CMP     AL,7
        JNZ     NOT_BW
        MOV     WORD PTR CS:[BASE],0B000H
NOT_BW: MOV     AL,DS:[62H]             ; GET ACTIVE PAGE
        MOV     CS:[BPAGE],AL
        CBW
        ADD     AX,AX
        MOV     BX,AX
        MOV     AX,DS:[BX+50H]          ; AL=COL, AH=ROW
        MOV     WORD PTR CS:[COL],AX    ; SAVE ROW AND COLUMN
        MOV     AX,DS:[4EH]             ; GET START OF SCREEN SEG
        MOV     CL,4
        SHR     AX,CL                   ; CONVERT TO A SEGMENT
        PUSH    CS
        POP     DS
        MOV     [SCREEN_SEG],AX
        XCHG    AX,SI                   ; GET BACK CHARACTER IN AL
        CALL    VIDEO
        POP     BP
        POP     ES
        POP     DI
        POP     SI
        POP     DX
        POP     CX
        POP     BX
        POP     AX
        RET
;----------------------------------------------------------
;
;       OUTPUT SINGLE CHAR IN AL TO VIDEO DEVICE
;
VIDEO:  MOV     SI,OFFSET STATE
        JMP     [SI]
S2:     CMP     AL,'['
        JZ      S22
        JMP     S1
S22:    MOV     WORD PTR [SI],OFFSET S3
        XOR     BX,BX
        MOV     WORD PTR INQ,BX
        JMP     SHORT S3B
S3:     CMP     AL,';'
        JNZ     S3C
S3A:    INC     PRMCNT
S3B:    CALL    GETPTR
        XOR     AX,AX
        MOV     WORD PTR [BX],AX    ;DEFAULT VALUE IS ZERO
        RET
S3C:    CMP     AL,'0'
        JB      S3D
        CMP     AL,'9'
        JA      S3D
        CALL    GETPTR
        SUB     AL,'0'
        XCHG    AL,BYTE PTR [BX]
        MOV     AH,10
        MUL     AH                      ;*10
        ADD     BYTE PTR [BX],AL        ;MOVE IN DIGIT
        RET
S3D:    CMP     AL,'='
        JZ      S3RET
        CMP     AL,'?'
        JZ      S3RET
        CMP     AL,'"'                  ;BEGIN QUOTED STRING
        JZ      S3E
        CMP     AL,"'"
        JNZ     S7
S3E:    MOV     WORD PTR [SI],OFFSET S4
        MOV     [INQ],AL
S3RET:  RET
;
;   ENTER QUOTED STRINGS
;
S4:     CMP     AL,[INQ]                ;CHECK FOR STRING TERMINATOR
        JNZ     S4A
        DEC     PRMCNT                  ;TERMINATE STRING
        MOV     WORD PTR [SI],OFFSET S3
        RET
S4A:    CALL    GETPTR
        MOV     BYTE PTR [BX],AL
        MOV     WORD PTR [SI],OFFSET S4
        JMP     S3A
;
;  LOOK FOR ANSI COMMAND SPECIFIED IN AL
;
S7:     MOV     BX,OFFSET CMDTABL-3
;
S7A:    ADD     BX,3
        CMP     BYTE PTR [BX],0
        JZ      S1B
        CMP     BYTE PTR [BX],AL
        JNZ     S7A
;
S7B:    MOV     AX,WORD PTR [BX+1]     ;AX = JUMP ADDRESS
        MOV     BX,OFFSET BUF
        INC     BX
        ADD     BX,ASNPTR              ;BX = PTR TO PARM LIST
        MOV     DL,BYTE PTR [BX]
        XOR     DH,DH                  ;DX = FIRST PARAMETER
        MOV     CX,DX
        OR      CX,CX
        JNZ     S7C
        INC     CX                     ;CX = DX, CX=1 IF DX=0
S7C:    JMP     AX                     ;AL = COMMAND
S1:     CMP     AL,ESC_CHAR            ;ESCAPE SEQUENCE?
        JNZ     S1B
        MOV     WORD PTR [SI],OFFSET S2
        RET
S1B:    CALL    CHROUT
S1A:    MOV     WORD PTR [STATE],OFFSET S1
        RET
MOVCUR: CMP     BYTE PTR [BX],AH
        JZ      SETCUR
        ADD     BYTE PTR [BX],AL
        LOOP    MOVCUR
SETCUR: MOV     DX,WORD PTR COL
        XOR     BX,BX
        MOV     AH,2
        INT     16
        JMP     S1A
CUP:
					cmp GRAPHICS_FLAG,GRAPHICS_MODE 
					jne $l49 
          CMP     CL,DEFAULT_LENGTH            ;
					jmp short $l48 
$l49: 
          CMP     CL,BYTE PTR [REQ_TXT_LENGTH] ;
$l48: 
        JA      SETCUR
        MOV     AL,MAXCOL
        MOV     CH,BYTE PTR [BX+1]
        OR      CH,CH
        JZ      CUP1
        DEC     CH
CUP1:   CMP     AL,CH
        JA      CUP2
        MOV     CH,AL
CUP2:   XCHG    CL,CH
        DEC     CH
        MOV     WORD PTR COL,CX
        JMP     SETCUR
CUF:    MOV     AH,MAXCOL
        MOV     AL,1
CUF1:   MOV     BX,OFFSET COL
        JMP     MOVCUR
CUB:    MOV     AX,00FFH
        JMP     CUF1
CUU:    MOV     AX,00FFH
CUU1:   MOV     BX,OFFSET ROW
        JMP     MOVCUR
CUD:
					cmp GRAPHICS_FLAG,GRAPHICS_MODE 
					jne $l53 
          MOV     AH,DEFAULT_LENGTH            ;
					jmp short $l52 
$l53: 
          MOV     AH,BYTE PTR [REQ_TXT_LENGTH] ;
$l52: 
        MOV     AL,1                           ;
        JMP     CUU1
ExtKey:
        cmp     dl, 0 ; DL = previous parameter
        jne     ExtKey_1
        mov     Switch_X, OFF ; reset it if 0.
        jmp     S1A
ExtKey_1:
        cmp     dl, 1
        je      SetExtKey
        jmp     S1A
SetExtKey:
        mov     Switch_X, ON ; set it if 1.
        jmp     S1A
PSCP:   MOV     AX,WORD PTR COL
        MOV     SAVCR,AX
        JMP     SETCUR
PRCP:   MOV     AX,SAVCR
        MOV     WORD PTR COL,AX
        JMP     SETCUR
SGR:    XOR     CX,CX
        XCHG    CL,PRMCNT
        CALL    GETPTR
        INC     CX
SGR1:   MOV     AL,BYTE PTR [BX]
        PUSH    BX
        MOV     BX,OFFSET GRMODE
SGR2:   MOV     AH,BYTE PTR [BX]
        ADD     BX,3
        CMP     AH,0FFH
        JZ      SGR3
        CMP     AH,AL
        JNZ     SGR2
        MOV     AX,WORD PTR [BX-2]
        AND     ATTR,AL
        OR      ATTR,AH
SGR3:   POP     BX
        INC     BX
        LOOP    SGR1
        JMP     SETCUR
ED:     XOR     CX,CX
        MOV     WORD PTR COL,CX
        MOV     DH,30                   ;
        MOV     AL,MODE                 ;
        CMP     AL,11H                  ;
        JE      ERASE                   ;
        CMP     AL,12H                  ;
        JE      ERASE                   ;
					cmp GRAPHICS_FLAG,GRAPHICS_MODE 
					jne $l57 
          MOV     DH,DEFAULT_LENGTH               ;
					jmp short $l56 
$l57: 
          MOV     DH,BYTE PTR [REQ_TXT_LENGTH]    ;
$l56: 
ERASE:  MOV     DL,MAXCOL
					cmp GRAPHICS_FLAG,GRAPHICS_MODE 
					jne $l61 
          XOR    BH,BH                            ; then use 0 as attribute...
					jmp short $l60 
$l61: 
          MOV     BH,ATTR                         ; ...use active attribute
$l60: 
        MOV     AX,0600H
        INT     16
ED3:    JMP     SETCUR
EL:     MOV     CX,WORD PTR COL
        MOV     DH,CH
        JMP     ERASE
BIN2ASC:MOV     DL,10
        INC     AL
        XOR     AH,AH
        DIV     DL
        ADD     AX,'00'
        RET
DSR:    MOV     AH,REQ_CRSR_POS         ;
        PUSH    BX                      ;
        XOR     BH,BH                   ;
        INT     10H                     ;
        POP     BX                      ;
        PUSH    DX                      ;
        MOV     AL,DH                   ;REPORT CURRENT CURSOR POSITION
        CALL    BIN2ASC
        MOV     WORD PTR REPORT+2,AX
        POP     DX                      ;
        MOV     AL,DL                   ;
        CALL    BIN2ASC
        MOV     WORD PTR REPORT+5,AX
        MOV     [KEYCNT],9
        MOV     [KEYPTR],OFFSET REPORT
CPR:    JMP     S1A
RM:     MOV     CL,1
        JMP     SHORT SM1
SM:     XOR     CX,CX
SM1:    MOV     AL,DL
					cmp AL,MODE7 
					jl $l66 
					cmp AL,MODE13 
					jnGE $l65 
					cmp AL,MODE19 
					jnLE $l65 
$l66: 
					test HDWR_FLAG,LCD_ACTIVE 
					jz $l67 
            PUSH   DS                 ;; yes...
            PUSH   AX                 ;; save mode
            MOV    AX,ROM_BIOS        ;;
            MOV    DS,AX              ;; get equipment status flag..
            MOV    AX,DS:[EQUIP_FLAG] ;;
            AND    AX,INIT_VID_MASK   ;; clear initial video bits..
            OR     AX,LCD_COLOR_MODE  ;; .....set bits as color
            MOV    DS:[EQUIP_FLAG],AX ;; replace updated flag.
            POP    AX                 ;; restore mode.
            POP    DS                 ;;
$l67: 
          MOV     AH,SET_MODE       ;; yes....set mode..
          INT     10H               ;;
					jmp short $l64 
$l65: 
					cmp AL,7 
					jne $l64 
            MOV    [WRAP],CL        ;; yes....wrap...
$l64: 
        JMP     CPR
KEYASN: XOR     DX,DX
        XCHG    DL,PRMCNT               ;GET CHARACTER COUNT
        INC     DX
        INC     DX
        CALL    GETPTR
        MOV     AX,WORD PTR [BX]        ;GET CHARACTER TO BE ASSIGNED
        CALL    SCAN                    ;LOOK IT UP
        JNZ     KEYAS1
        MOV     DI,BX                   ;DELETE OLD DEFINITION
        SUB     ASNPTR,CX
        MOV     KEYCNT,0        ; This delete code shuffles the
                                ;   key definition table all around.
                                ;   This will cause all sorts of trouble
                                ;   if we are in the middle of expanding
                                ;   one of the definitions being shuffled.
                                ;   So shut off the expansion.
        MOV     SI,DI
        ADD     SI,CX
        MOV     CX,OFFSET BUF+ASNMAX
        SUB     CX,SI
        CLD
        PUSH    ES              ;SAVE USER'S ES
        PUSH    CS
        POP     ES              ;SET UP ES ADDRESSABILITY
        REP     MOVSB
        POP     ES              ;RESTORE ES
KEYAS1: CALL    GETPTR
        CMP     DL,3
        JB      KEYAS3
        MOV     BYTE PTR [BX-1],DL      ;SET LENGTH
        ADD     ASNPTR,DX               ;REMEMBER END OF LIST
        ADD     BX,DX
        CMP     ASNPTR,ASNMAX           ; Too much???
        JB      KEYAS3                  ; No
        SUB     BX,DX                   ; Next three instructions undo the above
        SUB     ASNPTR,DX
KEYAS3: MOV     BYTE PTR [BX-1],00
        MOV     STATE,OFFSET S1         ;RETURN
        RET
GETPTR: MOV     BX,ASNPTR
        INC     BX
        ADD     BX,PRMCNTW
        CMP     BX,ASNMAX + 8
        JB      GET1
        DEC     PRMCNT
        JMP     GETPTR
GET1:   ADD     BX,OFFSET BUF
        RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; CHECK_FOR_REMAP:
;
;   This function esnures that the keypacket
;   passed to it in AX is mapped to a standard INT16h call
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CHECK_FOR_REMAP PROC NEAR
					cmp AL,0E0h 
					jne $l74 
           OR   AH,AH         ; probably...but check for alpha character
					jz $l74 
              XOR   AL,AL     ; map extended to standard
$l74: 
        RET
CHECK_FOR_REMAP ENDP
BUF     DB      4,00,72H,16,0
        DB      ASNMAX+8-5 DUP (?)

CODE    ENDS
        END
