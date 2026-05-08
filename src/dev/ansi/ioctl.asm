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

;****************** START OF SPECIFICATIONS **************************
;
;  MODULE NAME: IOCTL.ASM
;
;  DESCRIPTIVE NAME: PERFORM THE GENERIC IOCTL CALL IN ANSI.SYS
;
;  FUNCTION: THE GENERIC DEVICE IOCTL IS USED TO SET AND GET THE
;            MODE OF THE DISPLAY DEVICE ACCORDING TO PARAMETERS PASSED
;            IN A BUFFER. ADDITIONALLY, THE CALL CAN TOGGLE THE
;            USE OF THE INTENSITY BIT, AND CAN LOAD THE 8X8 CHARACTER
;            SET, EFFECTIVELY GIVING MORE LINES PER SCREEN. THE
;            AVAILABILITY OF THIS FUNCTION VARIES STRONGLY WITH HARDWARE
;            ATTACHED.
;
;  ENTRY POINT: GENERIC_IOCTL
;
;  INPUT: LOCATION OF REQUEST PACKET STORED DURING STRATEGY CALL.
;
;  AT EXIT:
;     NORMAL: CARRY CLEAR - DEVICE CHARACTERISTICS SET
;
;     ERROR: CARRY SET - ERROR CODE IN AX.
;            AX = 1  - INVALID FUNCTION. EXTENDED ERROR = 20
;            AX = 10 - UNSUPPORTED FUNCTION ON CURRENT HARDWARE.
;                      EXTENDED ERROR = 29
;            AX = 12 - DISPLAY.SYS DOES NOT HAVE 8X8 RAM CHARACTER SET.
;                      EXTENDED ERROR = 31
;
;  INTERNAL REFERENCES:
;
;     ROUTINES: GET_IOCTL - PERFORMS THE GET DEVICE CHARACTERISTICS
;               SET_IOCTL - PERFORMS THE SET DEVICE CHARACTERISTICS
;               TEST_LENGTH - TESTS FOR VALIDITY OF A SCREEN SIZE VALUE
;               CTL_FLAG - READS THE CURRENT USE FOR THE INT/BLINK BIT
;               SET_CTL_FLAG - SETS THE USE FOR THE INT/BLINK BIT
;               GET_SEARCH - SEARCHES THE INTERNAL VIDEO TABLE FOR THE
;                            CURRENT MODE MATCH
;               SET_SEARCH - SEARCHES THE INTERNAL VIDEO TABEL FOR THE
;                            CURRENT MODE MATCH
;               SET_CURSOR_EMUL - SETS THE BIT THAT CONTROLS CURSOR EMULATION
;               INT10_COM - INTERRUPT 10H HANDLER TO KEEP CURRENT SCREEN SIZE
;               INT2F_COM - INTERRUPT 2FH INTERFACE TO GENERIC IOCTL
;               MAP_DOWN - PERFORMS CURSOR TYPE MAPPING FOR EGA WITH MONOCHROME
;               SET_VIDEO_MODE - SETS THE VIDEO MODE
;               ROM_LOAD_8X8 - LOADS THE 8X8 CHARACTER SET.
;               PROCESS_NORMAL - DOES THE SET PROCESS FOR ADAPTERS OTHER THAN
;                                THE VGA
;               PROCESS_VGA - DOES THE SET PROCESS FOR THE VGA ADAPTER
;               CHECK_FOR_DISPLAY - CHECKS FOR DISPLAY.SYS SUPPORT
;
;     DATA AREAS: SCAN_LINE_TABLE - HOLDS SCAN LINE INFORMATION FOR PS/2
;                 FUNC_INFO - BUFFER FOR PS/2 FUNCTIONALITY CALL.
;
;
;  EXTERNAL REFERENCES:
;
;     ROUTINES: INT 10H SERVICES
;
;     DATA AREAS: VIDEO_MODE_TABLE - INTERNAL TABLE FOR CHARACTERISTICS TO MODE
;                                    MATCH-UPS
;
;  NOTES:
;
;  REVISION HISTORY:
;
;      Label: "DOS ANSI.SYS Device Driver"
;             "Version 4.00 (C) Copyright 1988 Microsoft"
;             "Licensed Material - Program Property of Microsoft"
;
;****************** END OF SPECIFICATIONS ****************************
;Modification history *********************************************************
;AN001; P1350 Codepage switching not working on EGA                10/10/87 J.K.
;AN002; P1626 ANSI does not allow lines=43 with PS2,Monochrome     10/15/87 J.K.
;AN003; p1774 Lines=43 after selecting cp 850 does not work        10/20/87 J.K.
;AN004; p1740 MODE CON LINES command causes problem with PE2 w PS/210/24/87 J.K.
;AN005; p2167 Does'nt say EGA in medium resol. cannot do 43 lines  10/30/87 J.K.
;AN006; p2236 After esc [=0h, issuing INT10h,AH=fh returns mode=1. 11/3/87  J.K.
;AN007; p2305 With ANSI loaded, loading RDTE hangs the system      11/06/87 J.K.
;AN008; P2617 Order dependecy problem with Display.sys             11/23/87 J.K.
;AN009; p2716 HOT key of VITTORIA does not work properly           12/03/87 J.K.
;AN010; d398  /L option for Enforcing the number of lines          12/17/87 J.K.
;AN011; D425 For OS2 compatibiltiy box, /L option status query     01/14/88 J.K.
;******************************************************************************
INCLUDE     ansi.inc                                                                               ;AN000;
.LIST                                                                                              ;AN000;
                                                                                                   ;AN000;
PUBLIC      GENERIC_IOCTL                                                                          ;AN000;
PUBLIC      FUNC_INFO                                                                              ;AN000;
PUBLIC      MAX_SCANS                                                                              ;AN000;
PUBLIC      INT10_COM                                                                              ;AN000;
PUBLIC      ROM_INT10                                                                              ;AN000;
PUBLIC      INT2F_COM                                                                              ;AN000;
PUBLIC      ROM_INT2F                                                                              ;AN000;
PUBLIC      ABORT                                                                                  ;AN000;
PUBLIC      REQ_TXT_LENGTH                                                                         ;AN000;
PUBLIC      GRAPHICS_FLAG                                                                          ;AN000;
public      Display_Loaded_Before_Me            ;AN008;
                                                                                                   ;AN000;
CODE        SEGMENT  PUBLIC  BYTE                                                                  ;AN000;
            ASSUME CS:CODE,DS:CODE                                                                 ;AN000;
                                                                                                   ;AN000;
EXTRN       PTRSAV:DWORD                                                                           ;AN000;
EXTRN       NO_OPERATION:NEAR                                                                      ;AN000;
EXTRN       ERR1:NEAR                                                                              ;AN000;
EXTRN       VIDEO_MODE_TABLE:BYTE                                                                  ;AN000;
extrn       MAX_VIDEO_TAB_NUM:ABS
EXTRN       HDWR_FLAG:WORD                                                                         ;AN000;
EXTRN       SCAN_LINES:BYTE                                                                        ;AN000;
extrn       Switch_L:Byte                       ;AN010;Defined in ANSI.ASM
                                                                                                   ;AN000;
                                                                                                   ;AN000;
SCAN_LINE_TABLE  LABEL    BYTE                                                                     ;AN000;
   SCAN_LINE_STR <200,000000001B,0>            ; 200 scan lines                                    ;
   SCAN_LINE_STR <344,000000010B,1>            ; 350 scan lines                                    ;AN000;
   SCAN_LINE_STR <400,000000100B,2>            ; 400 scan lines                                    ;AN000;
SCANS_AVAILABLE  EQU  ($ - SCAN_LINE_TABLE)/4; TYPE SCAN_LINE_STR                                     ;AN000;
                                                                                                  ;AN000;
;This is used when ANSI calls Get_IOCTL, Set_IOCTL by itself.
In_Generic_IOCTL_flag   db      0                               ;AN004;
I_AM_IN_NOW          EQU     00000001b                          ;AN004;
SET_MODE_BY_DISPLAY  EQU     00000010b                          ;AN004;Display.sys calls Set mode INT 10h.
CALLED_BY_INT10COM   EQU     00000100b                          ;AN009;To prevent from calling set mode int 10h again.
INT10_V_Mode    db      0ffh                                    ;AN006;Used by INT10_COM
My_IOCTL_Req_Packet REQ_PCKT <0,0,0Eh,0,?,0,?,?,?,?,?>          ;AN004;
                                                                                                   ;AN000;
FUNC_INFO        INFO_BLOCK <>                 ; data block for functionality call                 ;AN000;
ROM_INT10        DW    ?                       ; segment and offset of original..                  ;AN000;
                 DW    ?                       ; interrupt 10h vector.                             ;AN000;
ROM_INT2F        DW    ?                       ; segment and offset of original..                  ;AN000;
                 DW    ?                       ; interrupt 2Fh vector.                             ;AN000;
INTENSITY_FLAG   DW    OFF                     ; intensity flag initially off                      ;AN000;
REQ_TXT_LENGTH   DW    DEFAULT_LENGTH          ; requested text screen length                      ;AN000;
SCAN_DESIRED     DB    0                       ; scan lines desired                                ;AN000;
MAX_SCANS        DB    0                       ; maximum scan line setting                         ;AN000;
GRAPHICS_FLAG    DB    TEXT_MODE               ; flag for graphics mode                            ;AN000;
ERROR_FLAG       DB    OFF                     ; flag for error conditions                         ;AN000;
Display_Loaded_Before_Me db     0              ;AN008;flag
ANSI_SetMode_Call_Flag   db     0              ;AN008;Ansi is issuing INT10,AH=0.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PROCEDURE_NAME: GENERIC_IOCTL
;
; FUNCTION:
; TO GET OR SET DEVICE CHARACTERISTICS ACCORDING TO THE BUFFER PASSED
; IN THE REQUEST PACKET.
;
; AT ENTRY:
;
; AT EXIT:
;    NORMAL: CARRY CLEAR - DEVICE CHARACTERISTICS SET
;
;    ERROR: CARRY SET - ERROR CODE IN AL. (SEE MODULE DESCRIPTION ABOVE).
;
; NOTE: THIS PROC IS PERFORMED AS A JMP AS WITH THE OLD ANSI CALLS.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GENERIC_IOCTL:                                 ;                                                   ;AN000;
        LES     BX,[PTRSAV]                    ; establish addressability to request header        ;AN000;
					cmp ES:[BX].MIN_FUNC,GET_FUNC 
					jne $l2 
            LES     DI,ES:[BX].REQ_PCKT_PTR    ; point to request packet                           ;AN000;
            CALL    GET_IOCTL                  ; yes...execute routine                             ;AN000;
					jmp short $l1 
					nop 
$l2: 
					cmp ES:[BX].MIN_FUNC,SET_FUNC 
					jne $l4 
            LES     DI,ES:[BX].REQ_PCKT_PTR    ; point to request packet                           ;AN000;
            CALL    SET_IOCTL                  ; yes....execute routine                            ;AN000;
					jmp short $l1 
$l4: 
            JMP     NO_OPERATION               ; call lower CON device                             ;AN000;
$l1: 
					jnC $l7 
          OR     AX,CMD_ERROR                  ; yes...set error bit in status                     ;AN000;
$l7: 
        OR     AX,DONE                         ; add done bit to status                            ;AN000;
        JMP    ERR1                            ; return with status in AX                          ;AN000;
                                                                                                   ;AN000;
                                                                                                   ;AN000;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PROCEDURE_NAME: GET_IOCTL
;
; FUNCTION:
; THIS PROCEDURE RETURNS DEVICE CHARACTERISTICS.
;
; AT ENTRY: ES:DI POINTS TO REQUEST BUFFER
;
; AT EXIT:
;    NORMAL: CARRY CLEAR - REQUEST BUFFER CONTAINS DEVICE CHARACTERISTICS
;
;    ERROR: CARRY SET - ERROR CONDITION IN AX
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GET_IOCTL PROC    NEAR                                                                             ;AN000;
					cmp ES:[DI].INFO_LEVEL,0 
					jNE $l12 
					cmp ES:[DI].DATA_LENGTH,14; TYPE MODE_TABLE+1 
					jnl $l11 
$l12: 
       MOV    AX,INVALID_FUNC                    ; not valid...unsupported                         ;AN000;
       STC                                       ; function..set error flag and                    ;AN000;
					jmp short $l10 
$l11: 
       MOV     ES:[DI].INFO_LEVEL+1,0            ; set reserved byte to 0.                         ;AN000;
       MOV     AH,REQ_VID_MODE                   ; request current video mode                      ;AN000;
       INT     10H                               ;                                                 ;AN000;
       AND     AL,VIDEO_MASK                     ;                                                 ;AN000;
       LEA     SI,VIDEO_MODE_TABLE               ; point to resident video table                   ;AN000;
       CALL    GET_SEARCH                        ; perform search                                  ;AN000;
					jnC $l15 
         MOV     AX,NOT_SUPPORTED                ; no....load unsupported function                 ;AN000;
					jmp short $l10 
$l15: 
         push    di                              ;AN001;AN003;Save Request Buffer pointer
         MOV     WORD PTR ES:[DI].DATA_LENGTH,14; (TYPE MODE_TABLE)+1 ;length of data is struc size    ;AN000;
         INC     SI                              ; skip mode value                                 ;AN000;
         ADD     DI,RP_FLAGS                     ; point to flag word                              ;AN000;
					cmp HDWR_FLAG,MCGA_ACTIVE 
					jnGE $l19 
           CALL    CTL_FLAG                      ; then ..process control flag                     ;AN000;
					jmp short $l18 
$l19: 
           MOV     WORD PTR ES:[DI],OFF          ; we always have blink.                           ;AN000;
$l18: 
         INC     DI                              ; point to next field..                           ;AN000;
         INC     DI                              ; ..(display mode)                                ;AN000;
         MOV     CX,12; (TYPE MODE_TABLE)-1          ; load count                                      ;AN000;
         REP     MOVSB                           ; transfer data from video table to request packet;AN000;
         SUB     SI,13; TYPE MODE_TABLE              ; point back to start of mode data                ;AN000;
					cmp [SI].D_MODE,TEXT_MODE 
					jne $l22 
					cmp [SI].SCR_ROWS,DEFAULT_LENGTH 
					je $l22 
           DEC    DI                             ; point back to length entry in req packet        ;AN000;
           DEC    DI                             ;                                                 ;AN000;
           PUSH   DS                             ;                                                 ;AN000;
           MOV    AX,ROM_BIOS                    ; load ROM BIOS data area segment                 ;AN000;
           MOV    DS,AX                          ;                                                 ;AN000;
           MOV    AL,BYTE PTR DS:[NUM_ROWS]      ; load current number of rows                     ;AN000;
           CBW                                   ;                                                 ;AN000;
           INC    AX                             ; add 1 to row count                              ;AN000;
           MOV    WORD PTR ES:[DI],AX            ; and copy to request packet                      ;AN000;
           POP    DS                             ;                                                 ;AN000;
$l22: 
         XOR    AX,AX                            ; no errors                                       ;AN000;
         CLC                                     ; clear error flag                                ;AN000;
         pop    di                               ;AN001; AN003;Restore Request Buffer pointer
$l10: 
     RET                                         ; return to calling module                        ;AN000;
GET_IOCTL ENDP                                                                                     ;AN000;
                                                                                                   ;AN000;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PROCEDURE_NAME: SET_IOCTL
;
; FUNCTION:
; THIS PROCEDURE SETS THE VIDEO MODE AND CHARACTER SET ACCORDING
; TO THE CHARACTERSTICS PROVIDED.
;
; AT ENTRY:
;    ES:[DI] POINTS TO REQUEST BUFFER
;
; AT EXIT:
;    NORMAL: CLEAR CARRY - VIDEO MODE SET
;
;    ERROR: CARRY SET - ERROR CONDITION IN AX
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_IOCTL PROC  NEAR                                                                               ;AN000;
     or cs:In_Generic_IOCTL_Flag, I_AM_IN_NOW  ;AN004; Signal GENERIC_IOCTL request being processed
     MOV    ERROR_FLAG,OFF                     ; clear any errors                                  ;AN000;
					cmp ES:[DI].INFO_LEVEL,0 
					jNE $l27 
					cmp ES:[DI].DATA_LENGTH,14; TYPE MODE_TABLE+1 
					jNE $l27 
     MOV    AX,ES:[DI].RP_FLAGS                ; test for invalid flags.                           ;AN000;
					test AX,INVALID_FLAGS 
					jnz $l27 
					test ES:[DI].RP_FLAGS,ON 
					jz $l26 
					cmp HDWR_FLAG,MCGA_ACTIVE 
					jnl $l26 
$l27: 
        MOV    AX,INVALID_FUNC                 ; not valid...unsupported..                         ;AN000;
        MOV    ERROR_FLAG,ON                   ; function..set error and..                         ;AN000;
					jmp short $l25 
$l26: 
        CALL    SET_SEARCH                     ; search table for match                            ;AN000;
					jnC $l30 
          MOV    AX,NOT_SUPPORTED              ; not supported....                                 ;AN000;
          MOV    ERROR_FLAG,ON                 ;                                                   ;AN000;
					jmp short $l25 
$l30: 
					cmp [SI].D_MODE,TEXT_MODE 
					jne $l34 
            PUSH   REQ_TXT_LENGTH              ; save old value in case of error                   ;AN000;
            MOV    AX,ES:[DI].RP_ROWS          ; save new requested value.                         ;AN000;
            MOV    REQ_TXT_LENGTH,AX           ;                                                   ;AN000;
;           .IF <[SI].SCR_ROWS NE UNOCCUPIED>   ; yes...check for VGA support..                     ;AN000;
;             CALL   PROCESS_NORMAL             ; no..process other adapters..                      ;AN000;
;           .ELSE                               ; VGA support available..                           ;AN000;
;             CALL   PROCESS_VGA                ; process the VGA support code.                     ;AN000;
;           .ENDIF                              ;                                                   ;AN000;
					cmp [SI].SCR_ROWS,UNOCCUPIED 
					jE $l38 
					test Hdwr_Flag,VGA_ACTIVE 
					jz $l37 
$l38: 
               call  process_VGA               ;AN002;
					jmp short $l36 
$l37: 
               call  process_Normal            ;AN002;
$l36: 
					cmp ERROR_FLAG,OFF 
					jne $l41 
              POP    AX                        ; discard saved text length                         ;AN000;
              call   DO_ROWS                   ;AN004;
					cmp HDWR_FLAG,E5151_ACTIVE 
					jnGE $l33 
                CALL   SET_CURSOR_EMUL         ; yes..ensure cursor emulation is..                 ;AN000;
					jmp short $l33 
$l41: 
              POP    REQ_TXT_LENGTH            ; error...so restore old value.                     ;AN000;
					jmp short $l33 
$l34: 
            CALL   SET_VIDEO_MODE              ; so set video mode.                                ;AN000;
$l33: 
					cmp ERROR_FLAG,OFF 
					jne $l25 
					cmp HDWR_FLAG,MCGA_ACTIVE 
					jnGE $l25 
					cmp [SI].V_MODE,TEXT_MODE 
					jne $l25 
             CALL   SET_CTL_FLAG               ; set intensity bit to control value                ;AN000;
$l25: 
     and cs:In_Generic_IOCTL_Flag, NOT I_AM_IN_NOW  ;AN004; Turn the flag off
					cmp ERROR_FLAG,OFF 
					jne $l52 
       XOR    AX,AX                            ; clear error register                              ;AN000;
       CLC                                     ; clear error flag                                  ;AN000;
					jmp short $l51 
$l52: 
       STC                                     ;                                                   ;AN000;
$l51: 
     RET                                       ;                                                   ;AN000;
SET_IOCTL ENDP                                                                                     ;AN000;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PROCEDURE_NAME: PROCESS_NORMAL
;
; FUNCTION:
; THIS PROCEDURE PROCESSES THE SET IOCTL FOR ADAPTERS OTHER THAN
; THE VGA.
;
; AT ENTRY: AX - SCREEN LENGTH DESIRED
;           DS:SI - POINTS TO MODE RECORD IN VIDEO TABLE.
;
; AT EXIT:
;    NORMAL: MODE SET
;
;    ERROR: ERROR_FLAG IS ON. ERROR CODE IN AX.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PROCESS_NORMAL PROC   NEAR                                                                         ;
					cmp AX,DEFAULT_LENGTH 
					je $l56 
					cmp AX,[SI].SCR_ROWS 
					je $l56 
               MOV    AX,NOT_SUPPORTED         ; not valid....so                                   ;AN000;
               MOV    ERROR_FLAG,ON            ; set error flag and..                              ;AN000;
					jmp short $l55 
$l56: 
               CALL   CHECK_FOR_DISPLAY        ; see if we need and have DISPLAY.SYS..             ;AN000;
					jc $l60 
					cmp HDWR_FLAG,E5151_ACTIVE 
					jnGE $l62 
                   CALL    SET_CURSOR_EMUL     ;                                                   ;AN000;
$l62: 
                 CALL    SET_VIDEO_MODE        ; ..and set the mode.                               ;AN000;
					jmp short $l55 
$l60: 
                 MOV     AX,NOT_AVAILABLE      ; font not available..                              ;AN000;
                 MOV     ERROR_FLAG,ON         ;                                                   ;AN000;
$l55: 
             RET
PROCESS_NORMAL ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PROCEDURE_NAME: PROCESS_VGA
;
; FUNCTION:
; THIS PROCEDURE PROCESSES THE SET IOCTL FOR THE VGA ADAPTER
;
; AT ENTRY: AX - SCREEN LENGTH DESIRED
;           DS:SI - POINTS TO MODE RECORD IN VIDEO TABLE.
;
; AT EXIT:
;    NORMAL: MODE SET
;
;    ERROR: ERROR_FLAG IS ON. ERROR CODE IN AX.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PROCESS_VGA  PROC    NEAR                                                                          ;AN000;
             CALL    TEST_LENGTH               ; check to see if screen length                     ;AN000;
					jnC $l67 
               MOV    AX,NOT_SUPPORTED         ; no..so set error condition                        ;AN000;
               MOV    ERROR_FLAG,ON            ;                                                   ;AN000;
					jmp short $l66 
$l67: 
               CALL   CHECK_FOR_DISPLAY        ; see if we need and have DISPLAY.SYS..             ;AN000;
					jc $l71 
					cmp REQ_TXT_LENGTH,DEFAULT_LENGTH 
					jne $l73 
                   MOV    AL,MAX_SCANS         ; desired scan setting should be..                  ;AN000;
                   MOV    SCAN_DESIRED,AL      ; the maximum.                                      ;AN000;
$l73: 
                 MOV    AH,ALT_SELECT          ; set the appropriate number..                      ;AN000;
                 MOV    BL,SELECT_SCAN         ; of scan lines..                                   ;AN000;
                 MOV    AL,SCAN_DESIRED        ;                                                   ;AN000;
                 INT    10H                    ;                                                   ;AN000;
                 CALL   SET_VIDEO_MODE         ; and set the mode.                                 ;AN000;
					jmp short $l66 
$l71: 
                 MOV    AX,NOT_AVAILABLE       ; so...load error code..                            ;AN000;
                 MOV    ERROR_FLAG,ON          ;                                                   ;AN000;
$l66: 
             RET                                                                                   ;AN000;
PROCESS_VGA  ENDP                                                                                  ;AN000;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Procedure name: DO_ROWS
; Function:
;  Only called for TEXT_MODE.
;  If (REQ_TXT_LENGTH <> DEFAULT_LENGTH) &
;     (DISPLAY.SYS not loaded or CODEPAGE not active)
;  then
;     LOAD ROM 8X8 charater.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DO_ROWS         proc    near                            ;AN004;
					cmp REQ_TXT_LENGTH,DEFAULT_LENGTH 
					je $l77 
           push ds                                      ;AN004;
           push es                                      ;AN004;
           push di                                      ;AN004;
           push si                                      ;AN004;
           mov  ax, DISPLAY_CHECK                       ;AN004;
           int  2fh                                     ;AN004;
					cmp al,INSTALLED 
					jNE $l82 
           mov  ax, CHECK_ACTIVE                        ;AN004;
           int  2fh                                     ;AN004;
					jnC $l80 
$l82: 
               call     ROM_LOAD_8X8                    ;AN004;
$l80: 
           pop  si                                      ;AN004;
           pop  di                                      ;AN004;
           pop  es                                      ;AN004;
           pop  ds                                      ;AN004;
$l77: 
        ret                                             ;AN004;
DO_ROWS         endp                                    ;AN004;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PROCEDURE_NAME: TEST_LENGTH
;
; FUNCTION:
; THIS PROCEDURE ENSURES THAT THE SCREEN LENGTH REQUESTED CAN BE
; OBTAINED USING THE AVAILABLE SCAN LINE SETTINGS.  (VGA ONLY!)
;
; AT ENTRY:
;
;
; AT EXIT:
;    NORMAL: CARRY CLEAR - SCAN_DESIRED CONTAINS SETTING REQUIRED
;
;    ERROR: CARRY SET
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TEST_LENGTH PROC   NEAR                                                                            ;AN000;
            push   bp                        ;AN007;
            MOV    AX,REQ_TXT_LENGTH         ; load AX with length requested                       ;AN000;
            MOV    BP,EIGHT                  ;                                                     ;AN000;
            MUL    BP                        ; mulitply by 8 to get scan lines                     ;AN000;
            LEA    BX,SCAN_LINE_TABLE        ; load BX with scan line table start                  ;AN000;
            MOV    CX,SCANS_AVAILABLE        ; total number of scan lines settings                 ;AN000;
            MOV    BP,NOT_FOUND              ; set flag                                            ;AN000;
$l83: 
					cmp BP,NOT_FOUND 
					jne $l84 
					cmp CX,0 
					je $l84 
					cmp AX,[BX].NUM_LINES 
					jne $l87 
                MOV    DL,[BX].REP_1BH       ;                                                     ;AN000;
					test SCAN_LINES,DL 
					jz $l90 
                  MOV    BP,FOUND            ; yes....found!!                                      ;AN000;
					jmp short $l83 
$l90: 
                  XOR    CX,CX               ; no...set CX to exit loop.                           ;AN000;
					jmp short $l83 
$l87: 
                ADD    BX,4; TYPE SCAN_LINE_STR ; not this setting..point to next                     ;AN000;
                DEC    CX                    ; record and decrement count                          ;AN000;
					jmp $l83 
$l84: 
					cmp BP,NOT_FOUND 
					jne $l95 
              STC                            ; no....set error flag                                ;AN000;
					jmp short $l94 
$l95: 
              MOV    CL,[BX].REP_12H         ; store value to set it.                              ;AN000;
              MOV    SCAN_DESIRED,CL         ;                                                     ;AN000;
              CLC                            ; clear error flag                                    ;AN000;
$l94: 
            pop  bp                          ;AN007;
            RET                              ; return to calling module                            ;AN000;
TEST_LENGTH ENDP                                                                                   ;AN000;
                                                                                                   ;AN000;
                                                                                                   ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PROCEDURE_NAME: CTL_FLAG
;
; FUNCTION:
; THIS PROCEDURE RETURNS THE CURRENT USE FOR THE INTENSITY/BLINKING
; BIT.
;
; AT ENTRY:
;
; AT EXIT:
;    NORMAL:
;      VGA,MCGA: VALUE RETURNED FROM FUNCTIONALITY CALL
;      EGA: VALUE LAST SET THROUGH IOCTL. DEFAULT IS BLINKING.
;      CGA,MONO: BLINKING
;
;    ERROR: N/A
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                                                                                   ;AN000;
CTL_FLAG  PROC    NEAR                                                                             ;AN000;
					test HDWR_FLAG,VGA_ACTIVE 
					jz $l98 
            PUSH    ES                            ; yes...prepare for                              ;AN000;
            PUSH    DI                            ; functionality call                             ;AN000;
            PUSH    DS                            ;                                                ;AN000;
            POP     ES                            ;                                                ;AN000;
            LEA     DI,FUNC_INFO                  ; point to data block                            ;AN000;
            MOV     AH,FUNC_CALL                  ; load function number                           ;AN000;
            XOR     BX,BX                         ; implementation type 0                          ;AN000;
            INT     10H                           ;                                                ;AN000;
            MOV     AL,ES:[DI].MISC_INFO          ; load misc info byte                            ;AN000;
					test AL,INT_BIT 
					jz $l102 
              AND    INTENSITY_FLAG,NOT ON        ; yes....turn off intensity flag                 ;AN000;
					jmp short $l101 
$l102: 
              OR     INTENSITY_FLAG,ON            ; ensure that intensity is set                   ;AN000;
$l101: 
            POP     DI                            ; restore registers                              ;AN000;
            POP     ES                            ;                                                ;AN000;
$l98: 
          MOV     AX,INTENSITY_FLAG               ; write the control flag..                       ;AN000;
          MOV     ES:[DI],AX                      ; to the request packet                          ;AN000;
          RET                                     ;                                                ;AN000;
CTL_FLAG  ENDP                                                                                     ;AN000;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PROCEDURE_NAME: SET_CTL_FLAG
;
; FUNCTION:
; THIS PROCEDURE SET THE TOGGLE/INTENSITY BIT AS SPECIFIED IN THE
; CONTROL FLAG IOCTL SET SUBFUNCTION. THIS ROUTINE IS ONLY CALLED FOR
; AN EGA, MCGA, OR VGA.
;
; AT ENTRY: ES:DI POINTS TO REQUEST BUFFER
;
; AT EXIT:
;    NORMAL: INTENSITY_FLAG SET APPROPRIATELY AND SYSTEM BIT SET
;
;    ERROR: N/A
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_CTL_FLAG PROC   NEAR                                                                           ;AN000;
					test ES:[DI].RP_FLAGS,ON 
					jz $l106 
               OR     INTENSITY_FLAG,ON                                                            ;AN000;
               MOV    BL,SET_INTENSIFY                                                             ;AN000;
					jmp short $l105 
$l106: 
               AND    INTENSITY_FLAG,NOT ON                                                        ;AN000;
               MOV    BL,SET_BLINK                                                                 ;AN000;
$l105: 
             MOV    AX,BLINK_TOGGLE                                                                ;AN000;
             INT    10H                                                                            ;AN000;
             RET                                                                                   ;AN000;
SET_CTL_FLAG ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PROCEDURE_NAME: SET_SEARCH
;
; FUNCTION:
; THIS PROCEDURE SEARCHES THE RESIDENT VIDEO TABLE IN ATTEMPT TO
; FIND A MODE THAT MATHCES THE CHARACTERISTICS REQUESTED.
;
; AT ENTRY:
;
; AT EXIT:
;    NORMAL: CARRY CLEAR - SI POINTS TO APPLICABLE RECORD
;
;    ERROR: CARRY SET
;
;AN006; When INT10_V_Mode <> 0FFH, then assumes that the user
;       issuing INT10h, Set mode function call.  Unlike Generic IOCTL
;       set mode call, the user already has taken care of the video mode.
;       So, we also find the matching V_MODE.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                                                                                   ;AN000;
SET_SEARCH PROC   NEAR                                                                             ;AN000;
            push   bp                               ;AN007;
            LEA    SI,VIDEO_MODE_TABLE              ; point to video table                         ;AN000;
            MOV    BP,NOT_FOUND                     ; set flag indicating not found                ;AN000;
            MOV    CX,MAX_VIDEO_TAB_NUM             ; load counter, # of tables                    ;AN000;
$l109: 
					cmp BP,NOT_FOUND 
					jne $l110 
					cmp [SI].V_MODE,UNOCCUPIED 
					je $l110 
					cmp CX,0 
					je $l110 
             mov al, cs:INT10_V_Mode                ;AN006;
					cmp AL,0FFh 
					je $l113 
					cmp [SI].V_MODE,AL 
					je $l113 
               add si, 13; type MODE_TABLE              ;AN006; then, this is not the correct entry.
               dec cx                               ;AN006;Let's find the next entry.
					jmp short $l109 
$l113: 
               MOV    AL,ES:[DI].RP_MODE             ; load register for compare.                   ;AN000;
					cmp [SI].D_MODE,AL 
					jne $l116 
                 MOV    AX,ES:[DI].RP_COLORS         ; yes...prepare next field                     ;AN000;
					cmp [SI].COLORS,AX 
					jne $l116 
					cmp ES:[DI].RESERVED2,0 
					jne $l116 
					cmp ES:[DI].RP_MODE,GRAPHICS_MODE 
					jne $l126 
                       MOV    AX,ES:[DI].RP_WIDTH    ; screen width.                                ;AN000;
					cmp [SI].SCR_WIDTH,AX 
					jne $l116 
                         MOV    AX,ES:[DI].RP_LENGTH ; screen length                                ;AN000;
					cmp [SI].SCR_LENGTH,AX 
					jne $l116 
                           MOV    BP,FOUND           ; found...set flag                             ;AN000;
					jmp short $l116 
$l126: 
                       MOV    AX,ES:[DI].RP_COLS     ; the rows are matched in the main routine.    ;AN000;
					cmp [SI].SCR_COLS,AX 
					jne $l116 
                         MOV    BP,FOUND             ; found...set flag                             ;AN000;
$l116: 
               ADD    SI,13; TYPE MODE_TABLE             ; point to next record and..                   ;AN000;
               DEC    CX                             ; decrement count                              ;AN000;
					jmp $l109 
$l110: 
					cmp BP,NOT_FOUND 
					jne $l139 
              STC                                    ; set error flag and..                         ;AN000;
					jmp short $l138 
$l139: 
              SUB    SI,13; TYPE MODE_TABLE              ; position us at the appropriate record        ;AN000;
              CLC                                    ; clear error flag                             ;AN000;
$l138: 
            mov cs:INT10_V_Mode, 0FFh                ;AN006; Done. Reset the value
            pop bp                                   ;AN007;
            RET                                      ; return to calling module                     ;AN000;
SET_SEARCH  ENDP                                                                                    ;AN000;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PROCEDURE_NAME: GET_SEARCH
;
; FUNCTION:
; THIS PROCEDURE SEARCHES THE VIDEO TABLE LOOKING FOR A MATCHING
; VIDEO MODE.
;
; AT ENTRY: DS:SI POINTS TO VIDEO TABLE
;           AL CONTAINS THE MODE REQUESTED
;
; AT EXIT:
;    NORMAL: CARRY CLEAR, DS:SI POINTS TO MATCHING RECORD
;
;    ERROR: CARRY SET
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GET_SEARCH  PROC   NEAR                                                                            ;AN000;
            MOV     CX,MAX_VIDEO_TAB_NUM            ; # of total tables                               ;AN000;
$l142: 
					cmp [SI].V_MODE,AL 
					je $l143 
					cmp [SI].V_MODE,UNOCCUPIED 
					je $l143 
					cmp CX,0 
					je $l143 
              ADD     SI,13; TYPE MODE_TABLE            ; point to the next mode                       ;AN000;
              DEC     CX                            ; decrement counter                            ;AN000;
					jmp $l142 
$l143: 
					cmp CX,0 
					je $l147 
					cmp [SI].V_MODE,UNOCCUPIED 
					jne $l146 
$l147: 
              STC                                   ; no ...so set error flag                      ;AN000;
					jmp short $l145 
$l146: 
              CLC                                   ; yes...clear error flag                       ;AN000;
$l145: 
            RET                                     ;                                              ;AN000;
GET_SEARCH  ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PROCEDURE_NAME: SET_CURSOR_EMUL
;
; FUNCTION:
; THIS PROCEDURE SETS THE CURSOR EMULATION BIT OFF IN ROM BIOS. THIS
; IS TO PROVIDE A CURSOR ON THE EGA WITH THE 5154 LOADED WITH AN 8X8
; CHARACTER SET.
;
; AT ENTRY:
;
; AT EXIT:
;    NORMAL: CURSOR EMULATION BIT SET FOR APPLICABLE HARDWARE
;
;    ERROR: N/A
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_CURSOR_EMUL PROC   NEAR                                                                        ;AN000;
					test HDWR_FLAG,E5154_ACTIVE 
					jz $l149 
                  PUSH   SI                          ;                                             ;AN000;
                  PUSH   DS                          ; yes..so..                                   ;AN000;
                  MOV    AX,ROM_BIOS                 ; check cursor emulation..                    ;AN000;
                  MOV    DS,AX                       ;                                             ;AN000;
                  MOV    SI,CURSOR_FLAG              ;                                             ;
                  MOV    AL,BYTE PTR [SI]            ;                                             ;AN000;
					cmp CS:REQ_TXT_LENGTH,DEFAULT_LENGTH 
					jne $l153 
                    AND    AL,TURN_OFF               ; no....set it OFF                            ;AN000;
					jmp short $l152 
$l153: 
                    OR     AL,TURN_ON                ; yes...set it ON                             ;AN000;
$l152: 
                  MOV    BYTE PTR [SI],AL            ;                                             ;AN000;
                  POP    DS                          ;                                             ;AN000;
                  POP    SI                          ;                                             ;AN000;
$l149: 
                RET                                  ; return to calling module                    ;AN000;
SET_CURSOR_EMUL ENDP                                                                               ;AN000;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PROCEDURE_NAME: INT10_COM
;
; FUNCTION:
; THIS IS THE INTERRUPT 10H HANDLER TO CAPTURE THE FOLLOWING FUNCTIONS:
;
;   AH=1H (SET CURSOR TYPE). CURSOR EMULATION IS PERFORMED IF WE HAVE
;         AND EGA WITH A 5151 MONITOR, AND 43 LINES IS REQUESTED.
;
;   AH=0H (SET MODE) SCREEN LENGTH IS MAINTAINED WHEN POSSIBLE. (IE. IN
;          TEXT MODES ONLY.)
;   AN004; Capturing Set Mode call and enforcing the # of Rows based on the
;          previous Set_IOCTL request lines was a design mistake.  ANSI cannot
;          covers the all the application program out there which use INT 10h
;          directly to make a full screen interface by their own way.
;          This part of logic has been taken out by the management decision.
;          Instead, for each set mdoe INT 10h function call, if it were not
;          issued by SET_IOCTL procedures itself, or by DISPLAY.SYS program,
;          then we assume that it was issued by an APPS, that usually does not
;          know the new ANSI GET_IOCTL/SET_IOCTL interfaces.
;          In this case, ANSI is going to call GET_IOCTL and SET_IOCTL function
;          call - This is not to lose the local data consistency in ANSI.
;
; AT ENTRY:
;
; AT EXIT:
;    NORMAL:
;
;    ERROR:
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
INT10_COM  PROC   NEAR                                                                             ;AN000;
            STI                                      ; restore interrupts                          ;AN000;
					cmp AH,SET_CURSOR_CALL 
					je $l156 
					cmp AH,SET_MODE 
					je $l156 
              JMP    DWORD PTR CS:ROM_INT10          ; no...pass it on.                            ;AN000;
$l156: 
					cmp AH,SET_CURSOR_CALL 
					jne $l160 
              PUSH   AX                              ;                                             ;AN000;
					test CS:HDWR_FLAG,E5151_ACTIVE 
					jz $l162 
					cmp CS:REQ_TXT_LENGTH,DEFAULT_LENGTH 
					je $l162 
					cmp CS:GRAPHICS_FLAG,TEXT_MODE 
					jne $l162 
					cmp CL,8 
					jnGE $l162 
                MOV    AL,CH                         ; check for cursor..                          ;AN000;
;               AND    AL,06H                        ; off emulation.!!!!!Wrong!!! TypeO error     ;
                and    al, 60h                       ; off emulation. J.K.
					cmp AL,020H 
					je $l162 
                  MOV    AL,CH                       ; start position for cursor                   ;AN000;
                  CALL   MAP_DOWN                    ;                                             ;AN000;
                  MOV    CH,AL                       ;                                             ;AN000;
                  MOV    AL,CL                       ; end position for cursor                     ;AN000;
                  CALL   MAP_DOWN                    ;                                             ;AN000;
                  MOV    CL,AL                       ;                                             ;AN000;
$l162: 
              POP    AX                              ;                                             ;AN000;
              JMP    DWORD PTR CS:ROM_INT10          ; continue interrupt processing               ;AN000;
					jmp $l159 
$l160: 
              PUSHF                                  ; prepare for IRET                            ;AN000;
              mov    cs:ANSI_SetMode_Call_Flag, 1    ;AN008; Used by INT2F_COM
              CALL   DWORD PTR CS:ROM_INT10          ; call INT10 routine                          ;AN000;
              mov    cs:ANSI_SetMode_Call_Flag, 0    ;AN008; Reset it
              push   bp                              ;AN007;
              push   es                              ;AN007;
              PUSH   DS                              ;                                             ;AN000;
              PUSH   SI                              ;                                             ;AN000;
              PUSH   DI                              ;                                             ;AN000;
              PUSH   DX                              ;                                             ;AN000;
              PUSH   CX                              ;                                             ;AN000;
              PUSH   BX                              ;                                             ;AN000;
              PUSH   AX                              ;                                             ;AN000;
              PUSH   CS                              ;                                             ;
              POP    DS                              ;                                             ;AN000;
              MOV    AH,REQ_VID_MODE                 ; get current mode..                          ;AN000;
              PUSHF                                  ;                                             ;AN000;
              CALL   DWORD PTR CS:ROM_INT10          ;                                             ;AN000;
              AND    AL,VIDEO_MASK                   ; mask bit 7 (refresh)                        ;AN000;
              test   In_Generic_IOCTL_Flag, (I_AM_IN_NOW + SET_MODE_BY_DISPLAY)  ;AN004; Flag is on?
					jnZ $l169 
					cmp Switch_L,0 
					jne $l169 
                 push   ax                              ;AN004;Save mode
                 push   es                              ;AN004;
                 push   cs                              ;AN004;
                 pop    es                              ;AN004;
                 mov    di, offset My_IOCTL_Req_Packet  ;AN004;
                 mov    INT10_V_Mode, al                ;AN006;Save current mode for SET_SEARCH
                 call   Get_IOCTL                       ;AN004;
					jc $l172 
                    mov    di, offset MY_IOCTL_Req_Packet ;AN004;
                    or     In_Generic_IOCTL_Flag, CALLED_BY_INT10COM ;AN009;Do not set mode INT 10h again. Already done.
                    call   Set_IOCTL                    ;AN004;
                    and    In_Generic_IOCTL_Flag, not CALLED_BY_INT10COM ;AN009;
$l172: 
                 pop    es                              ;AN004;
                 pop    ax                              ;AN004;Restore mode
                 mov    INT10_V_Mode, 0FFh              ;AN006;
$l169: 
              LEA    SI,VIDEO_MODE_TABLE             ;                                             ;AN000;
              CALL   GET_SEARCH                      ; look through table for mode selected.       ;AN000;
					jc $l175 
					cmp [SI].D_MODE,TEXT_MODE 
					je $l179 
                   MOV   GRAPHICS_FLAG,GRAPHICS_MODE ; no...set graphics flag.                    ;AN000;
					jmp short $l175 
$l179: 
                   MOV   GRAPHICS_FLAG,TEXT_MODE     ; yes...set text flag..                       ;AN000;
$l175: 
              test   In_Generic_IOCTL_Flag, I_AM_IN_NOW ;AN010;
					jnz $l182 
					cmp Graphics_Flag,TEXT_MODE 
					jne $l182 
					cmp Switch_L,1 
					jne $l182 
                  call  DO_ROWS                      ;AN010;
$l182: 
;AN004;The following has been taken out!
;AN004;              .IF <REQ_TXT_LENGTH NE DEFAULT_LENGTH> ; 25 lines active?                             ;AN000;
;AN004;                MOV    AX,DISPLAY_CHECK              ; is DISPLAY.SYS there?                        ;AN000;
;AN004;                INT    2FH                           ;                                              ;AN000;
;AN004;                .IF <AL NE INSTALLED> OR             ; if not installed or..                        ;AN000;
;AN004;                MOV    AX,CHECK_ACTIVE               ; if a code page has not..                     ;AN000;
;AN004;                INT    2FH                           ; been selected then..                         ;AN000;
;AN004;                .IF C                                ;                                              ;AN000;
;AN004;                  .IF <GRAPHICS_FLAG EQ TEXT_MODE>   ; is this a text mode?                         ;AN000;
;AN004;                    CALL   ROM_LOAD_8X8              ; yes..load ROM 8x8 character set.             ;AN000;
;AN004;                  .ENDIF                             ;                                              ;AN000;
;AN004;                .ENDIF                               ;                                              ;AN000;
;AN004;              .ENDIF                                 ;                                              ;AN000;
;AN004;Instead, for each SET mode function int 10h function call, if it is not
;AN004;issued by ANSI GET_IOCTL and SET_IOCTL procedure themselves, we assume
;AN004;that the APPS, which usually does not know the ANSI GET_IOCTL/SET_IOCTL
;AN004;interfaces, intend to change the screen mode.  In this case, ANSI is
;AN004;kind enough to call GET_IOCTL and SET_IOCTL function call for themselves.
              POP    AX                              ;                                             ;AN000;
              POP    BX                              ;                                             ;AN000;
              POP    CX                              ;                                             ;AN000;
              POP    DX                              ;                                             ;AN000;
              POP    DI                              ;                                             ;AN000;
              POP    SI                              ;                                             ;AN000;
              POP    DS                              ;                                             ;AN000;
              pop    es                              ;AN007;
              pop    bp                              ;AN007;
$l159: 
            IRET                                     ;                                             ;AN000;
INT10_COM  ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PROCEDURE_NAME: INT2F_COM
;
; FUNCTION:
; THIS IS THE INTERRUPT 2FH HANDLER TO CAPTURE THE FOLLOWING FUNCTIONS:
;
;   AX=1A00H INSTALL REQUEST. ANSI WILL RETURN AL=FFH IF LOADED.
;
;   AH=1A01H THIS IS THE INT2FH INTERFACE TO THE GENERIC IOCTL.
;      NOTE: THE GET CHARACTERISTICS FUNCTION CALL WILL RETURN
;            THE REQ_TXT_LENGTH IN THE BUFFER AS OPPOSED TO
;            THE ACTUAL HARDWARE SCREEN_LENGTH
;   Ax=1A02h This is an information passing from DISPLAY.SYS about
;            the INT 10h, SET MODE call.
;
; AT ENTRY:
;
; AT EXIT:
;    NORMAL:
;
;    ERROR:
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
INT2F_COM  PROC   NEAR                                                                             ;AN000;
           STI                                  ;                                                  ;AN000;
					cmp AH,MULT_ANSI 
					jNE $l187 
;           .IF <AL GT IOCTL_2F>                 ;                                                  ;AN000;
					cmp AL,DA_INFO_2F 
					jng $l185 
$l187: 
             JMP    DWORD PTR CS:ROM_INT2F      ; no....jump to old INT2F                          ;AN000;
$l185: 
					cmp AL,INSTALL_CHECK 
					jne $l189 
				nop 
				nop 
				nop 
               MOV     AL,INSTALLED             ; load value to indicate installed                 ;AN000;
               CLC                              ; clear error flag.                                ;AN000;
;             .WHEN <AL EQ IOCTL_2F>             ; request for IOCTL?                               ;AN000;
					jmp $l188 
$l189: 
					cmp AL,DA_INFO_2F 
					jBE $+5 
					jmp $l188 
               PUSH   BP                        ;                                                  ;AN000;
               PUSH   AX                        ; s                                                ;AN000;
               PUSH   CX                        ;  a                                               ;AN000;
               PUSH   DX                        ;   v                                              ;AN000;
               PUSH   DS                        ;    e  r                                          ;AN000;
               PUSH   ES                        ;        e                                         ;AN000;
               PUSH   DI                        ;         g                                        ;AN000;
               PUSH   SI                        ;          s.                                      ;AN000;
               PUSH   BX                        ;                                                  ;AN000;
               PUSH   DS                        ; load ES with DS (for call)                       ;
               POP    ES                        ;                                                  ;AN000;
               MOV    DI,DX                     ; load DI with DX (for call)                       ;AN000;
               PUSH   CS                        ; setup local addressability                       ;AN000;
               POP    DS                        ;                                                  ;AN000;
					cmp AL,IOCTL_2F 
					jne $l194 
					cmp CL,GET_FUNC 
					jne $l197 
                    CALL   GET_IOCTL            ;                                                  ;AN000;
					jc $l193 
					cmp HDWR_FLAG,E5151_ACTIVE 
					jnGE $l193 
					cmp [SI].D_MODE,TEXT_MODE 
					jne $l193 
					cmp cs:Switch_L,1 
					je $l204 
					cmp cs:ANSI_SetMode_Call_Flag,1 
					jNE $l204 
					cmp cs:Display_Loaded_Before_me,1 
					je $l202 
$l204: 
                         MOV    BX,REQ_TXT_LENGTH    ; then use REQ_TXT_LENGTH instead..           ;AN000;
                         MOV    ES:[DI].RP_ROWS,BX   ;
$l202: 
                      CLC                         ;                                                  ;AN000;
					jmp short $l193 
					nop 
$l197: 
					cmp CL,SET_FUNC 
					jne $l205 
                    CALL   SET_IOCTL              ; set function requested.                          ;AN000;
					jmp short $l193 
$l205: 
                    MOV    AX,INVALID_FUNC        ; load error and...                                ;AN000;
                    STC                           ; set error flag.                                  ;AN000;
					jmp short $l193 
$l194: 
					cmp ES:[DI].DA_INFO_LEVEL,0 
					jne $l210 
					cmp ES:[DI].DA_SETMODE_FLAG,1 
					jne $l213 
                        or cs:In_Generic_IOCTL_Flag, SET_MODE_BY_DISPLAY       ;AN004;Turn the flag on
					jmp short $l209 
$l213: 
                        and cs:In_Generic_IOCTL_Flag, not SET_MODE_BY_DISPLAY  ;AN004;Turn the flag off
					jmp short $l209 
$l210: 
					cmp ES:[DI].DA_INFO_LEVEL,1 
					jne $l209 
                        mov al, cs:[Switch_L]              ;AN011;
                        mov es:[di].DA_OPTION_L_STATE, al  ;AN011;
$l209: 
                  clc                           ;AN004;clear carry. There is no Error in DOS 4.00 for this call.
$l193: 
               POP    BX                        ; restore all..                                    ;AN000;
               POP    SI                        ;                                                  ;AN000;
               POP    DI                        ;   registers except..                             ;AN000;
               POP    ES                        ;                                                  ;
               POP    DS                        ;     BP.                                          ;AN000;
               POP    DX                        ;                                                  ;AN000;
               POP    CX                        ;                                                  ;AN000;
               PUSH   AX                        ; save error condition                             ;AN000;
               MOV    BP,SP                     ; setup frame pointer                              ;AN000;
               MOV    AX,[BP+10]                ; load stack flags                                 ;AN000;
					jc $l221 
                 AND    AX,NOT_CY               ; no.. set carry off.                              ;AN000;
                 MOV    [BP+10],AX              ; put back on stack.                               ;AN000;
                 POP    AX                      ; remove error flag from stack                     ;AN000;
                 POP    AX                      ; no error so bring back function call             ;AN000;
                 XCHG   AH,AL                   ; exchange to show that ANSI present               ;AN000;
					jmp short $l220 
$l221: 
                 OR     AX,CY                   ; yes...set carry on.                              ;AN000;
                 MOV    [BP+10],AX              ; put back on stack.                               ;AN000;
                 POP    AX                      ; restore error flag                               ;AN000;
                 POP    BP                      ; pop off saved value of AX (destroyed)            ;AN000;
$l220: 
               POP    BP                        ; restore final register.                          ;AN000;
$l188: 
ABORT:     IRET                                 ;                                                  ;AN000;
INT2F_COM  ENDP                                                                                    ;AN000;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PROCEDURE_NAME: MAP_DOWN
;
; FUNCTION:
; THIS PROCEDURE MAPS THE CURSOR START (END) POSITION FROM A 14 PEL
; BOX SIZE TO AN 8 PEL BOX SIZE.
;
; AT ENTRY: AL HAS THE CURSOR START (END) TO BE MAPPED.
;
; AT EXIT:
;    NORMAL: AL CONTAINS THE MAPPED POSITION FOR CURSOR START (END)
;
;    ERROR: N/A
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MAP_DOWN   PROC   NEAR                                                                             ;AN000;
           PUSH   BX                   ;                                                           ;AN000;
           XOR    AH,AH                ; clear upper byte of cursor position                       ;AN000;
           MOV    BL,EIGHT             ; multiply by current box size.                             ;AN000;
           PUSH   DX                   ;    al     x                                               ;AN000;
           MUL    BL                   ;   ---- = ---                                              ;AN000;
           POP    DX                   ;    14     8                                               ;AN000;
           MOV    BL,FOURTEEN          ;                                                           ;AN000;
           DIV    BL                   ; divide by box size expected.                              ;AN000;
           POP    BX                   ;                                                           ;AN000;
           RET                         ;                                                           ;AN000;
MAP_DOWN   ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PROCEDURE_NAME: SET_VIDEO_MODE
;
; FUNCTION:
; THIS PROCEDURE SETS THE VIDEO MODE SPECIFIED IN DS:[SI].V_MODE.
;
; AT ENTRY: DS:SI.V_MODE CONTAINS MODE NUMBER
;
; AT EXIT:
;    NORMAL: MODE SET
;
;    ERROR: N/A
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_VIDEO_MODE PROC   NEAR                                                                         ;AN000;
					test cs:In_Generic_IOCTL_Flag,CALLED_BY_INT10COM 
					jnz $l224 
               MOV    AL,[SI].V_MODE             ; ..issue set mode                                ;AN000;
					test HDWR_FLAG,LCD_ACTIVE 
					jnz $l229 
					test HDWR_FLAG,VGA_ACTIVE 
					jz $l227 
$l229: 
                 PUSH   DS                       ; yes...                                          ;AN000;
                 MOV    BL,AL                    ; save mode                                       ;AN000;
                 MOV    AX,ROM_BIOS              ;                                                 ;AN000;
                 MOV    DS,AX                    ; get equipment status flag..                     ;AN000;
                 MOV    AX,DS:[EQUIP_FLAG]       ;                                                 ;AN000;
                 AND    AX,INIT_VID_MASK         ; clear initial video bits..                      ;AN000;
					cmp BL,MODE7 
					je $l232 
					cmp BL,MODE15 
					jne $l231 
$l232: 
                   OR    AX,LCD_MONO_MODE        ; yes...set bits as mono                          ;AN000;
					jmp short $l230 
$l231: 
                   OR    AX,LCD_COLOR_MODE       ; no...set bits as color                          ;AN000;
$l230: 
                 MOV    DS:[EQUIP_FLAG],AX       ; replace updated flag.                           ;AN000;
                 MOV    AL,BL                    ; restore mode.                                   ;AN000;
                 POP    DS                       ;                                                 ;AN000;
$l227: 
               MOV    AH,SET_MODE                ; set mode                                        ;AN000;
               INT    10H                                                                          ;AN000;
$l224: 
               RET                                                                                 ;AN000;
SET_VIDEO_MODE ENDP                                                                                ;AN000;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PROCEDURE_NAME: ROM_LOAD_8X8
;
; FUNCTION:
; THIS PROCEDURE LOADS THE ROM 8X8 CHARACTER SET AND ACTIVATES BLOCK=0
; FONT.
;
; AT ENTRY:
;
; AT EXIT:
;    NORMAL: 8X8 ROM CHARACTER SET LOADED
;
;    ERROR: N/A
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ROM_LOAD_8X8 PROC   NEAR                                                                           ;AN000;
             MOV    AX,LOAD_8X8              ; load 8x8 ROM font                                   ;AN000;
             XOR    BL,BL                    ;                                                     ;AN000;
             PUSHF                                                                                 ;AN000;
             CALL   DWORD PTR CS:ROM_INT10                                                         ;AN000;
             MOV    AX,SET_BLOCK_0           ; activate block = 0                                  ;AN000;
             XOR    BL,BL                                                                          ;AN000;
             PUSHF                                                                                 ;AN000;
             CALL   DWORD PTR CS:ROM_INT10                                                         ;AN000;
             RET                                                                                   ;AN000;
ROM_LOAD_8X8 ENDP                                                                                  ;AN000;
                                                                                                   ;AN000;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PROCEDURE_NAME: CHECK_FOR_DISPLAY
;
; FUNCTION:
; THIS PROCEDURE CHECKS TO SEE IF WE DISPLAY.SYS IS THERE, AND IF
; IT IS..IT HAS THE REQUIRED FONT.
;
; AT ENTRY: AX - DESIRED SCREEN LENGTH
;
; AT EXIT:
;    NORMAL: CARRY CLEAR IF ALL OKAY
;
;    ERROR: CARRY SET IF FONT NOT AVAILABLE.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CHECK_FOR_DISPLAY PROC   NEAR                                                                      ;AN000;
					cmp AX,DEFAULT_LENGTH 
					je $l236 
               MOV    AX,DISPLAY_CHECK         ;                                                   ;AN000;
               INT    2FH                      ;                                                   ;AN000;
					cmp AL,INSTALLED 
					jNE $l236 
               MOV    AX,CHECK_FOR_FONT        ;                                                   ;AN000;
               INT    2FH                      ; or if it is does it have the..                    ;AN000;
					jc $l235 
$l236: 
                 CLC                           ; clear carry                                       ;AN000;
					jmp short $l234 
$l235: 
                 STC                           ; no font...set carry                               ;AN000;
$l234: 
               RET                             ;                                                   ;AN000;
CHECK_FOR_DISPLAY ENDP
CODE        ENDS
            END
