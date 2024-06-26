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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;	TABLES.INC
;
;	THIS FILE CONTAINS THE CONFIGURATION INFORMATION FOR THE CPS CON
;	DEVICE DRIVER.	THE INFORMATION IS INDEXED USING THE FULL DEVICE
;	SUB-TYPE ID.
;
;	THE TABLE STRUCTURE IS AS FOLLOWS:
;
;	DB	"........"       device sub-type id
;	DB	00000xxxb	 encoded font resolution byte
;	DW	OFFSET modes	 pointer to list of display modes
;	DW	OFFSET fonts	 pointer to list of font resolutions
;
;    旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
;    � Loading mechanism bit incoding			    �
;    �							    �
;    �	 USER ? 					    �
;    �	   �	  BIOS SUPPORT				    �
;    �	旼컨컴� 旼컨컴� 				    �
;    �							    �
;    �	7 6 5 4 3 2 1 0 				    �
;    �	x x x x 0 0 x x 				    �
;    �	� � � �     � 읕� 1 - INT 10 - AX=1100H 	    �
;    �	� � � �     �					    �
;    �	� � � �     읕컴� 1 = INT 10 - AX=1400H 	    �
;    �	� � � � 					    �
;    �	� � � 읕컴컴컴컴� 1 = INT 1FH			    �
;    �	� � �						    �
;    �	� � 읕컴컴컴컴컴� 1 = INT 43H			    �
;    �	� �						    �
;    �	� 읕컴컴컴컴컴컴� 1 = LCD 1FH handling needed	    �
;    �	�						    �
;    �	읕컴컴컴컴컴컴컴� 1 = LCD 44H handling needed	    �
;    읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
;
;    旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
;    � Memory Requirements				    �
;    �							    �
;    �	7 6 5 4 3 2 1 0 				    �
;    �	0 0 0 0 x x x x 				    �
;    �		� � � 읕� 200 scan lines		    �
;    �		� � 읕컴� 350 scan lines		    �
;    �		� 읕컴컴� 400 scan lines		    �
;    �		읕컴컴컴� 480 scan lines		    �
;    �							    �
;    읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
;
;	THE TABLES ARE FILLED BEYOND THE SUPPORTED MODES.  THIS
;	IS 'GUESSING' AT THE APPROACH FOR ANY FUTURE DISPLAY MODES
;	WHICH MAY BE BEYOND THE CON-CPS V1.0 SUPPORT.  TO DATE,
;	NO ADAPTER SUPPORTS THE EXTRA MODES - NOT EVEN <insert IBM codeword>.
;
;	Numerous <insert IBM code words> WOULD USE THE
;	SUBSET OF THE EGA MODES.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF1
	%OUT .		     췛ABLES  .INC�
ENDIF
						;
DISPLAY_CONFIG	LABEL	BYTE			;
	DB	"EGA     "                      ; EGA SUPPORT
DC_FONT DB	00000111b			;
	DW	OFFSET EGA_MODES		;
	DW	OFFSET EGA_FONT_SIZE		;
DC_ENTRY	EQU ($-DISPLAY_CONFIG)		;
	DB	"EGA 8   "                      ; EGA (5153)
	DB	00000001b			;
	DW	OFFSET EGA_MODES		;
	DW	OFFSET EGA8_FONT_SIZE		;
	DB	"EGA 14  "                      ; EGA (5154)
	DB	00000011b			;
	DW	OFFSET EGA_MODES		;
	DW	OFFSET EGA14_FONT_SIZE		;
	DB	"EGA 14M "                      ; EGA (5151)
	DB	00000011b			; WGR load 8x8 for > 25.       ;AN000;
	DW	OFFSET EGAM_MODES		;
	DW	OFFSET EGA14_FONT_SIZE		;
	DB	"LCD     "                      ; CONVERTIBLE
	DB	00000001b			;
	DW	OFFSET LCD_MODES		;
	DW	OFFSET LCD_FONT_SIZE		;
	DB	"MONO    "                      ; MONOCHROME ADAPTER
	DB	00000000b			;
	DW	OFFSET MONO_MODES		;
	DW	OFFSET MONO_FONT_SIZE		;
	DB	"CGA     "                      ; COLOUR GRAPHICS ADAPTER
	DB	00000000b			;
	DW	OFFSET MONO_MODES		;
	DW	OFFSET MONO_FONT_SIZE		;
NUM_DISPLAY_CONFIG EQU ($-DISPLAY_CONFIG)/DC_ENTRY
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EGA_MODES:			;
	DB	00000001b	;0
	DB	00000001b	;1
	DB	00000001b	;2
	DB	00000001b	;3
	DB	00110000b	;4
	DB	00110000b	;5
	DB	00110000b	;6
	DB	00000001b	;7
	DB	11111111b     ;D;8 컴컴컴�
	DB	11111111b     ;D;9	 �
	DB	11111111b     ;D;A    RESERVED
	DB	11111111b     ;D;B	 �
	DB	11111111b     ;D;C 컴컴컴�
	DB	00110000b	;D
	DB	00110000b	;E
	DB	00100000b	;F
	DB	00100000b	;10
	DB	00100000b	;11
	DB	00100000b	;12
	DB	00110000b	;13
	DB	00110000b	;14
	DB	00110000b	;15
	DB	00110000b	;16
	DB	00110000b	;17
	DB	00110000b	;18
	DB	00110000b	;19
	DB	00110000b	;1A
	DB	00110000b	;1B
	DB	00110000b	;1C
	DB	00110000b	;1D
	DB	00110000b	;1E
	DB	00110000b	;1F
NUM_MODES    EQU ($-EGA_MODES)	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EGAM_MODES:			;
	DB	11111111b	;0
	DB	11111111b	;1
	DB	11111111b	;2
	DB	11111111b	;3
	DB	11111111b	;4
	DB	11111111b	;5
	DB	11111111b	;6
	DB	00010001b	;7
	DB	11111111b     ;D;8 컴컴컴�
	DB	11111111b     ;D;9	 �
	DB	11111111b     ;D;A    RESERVED
	DB	11111111b     ;D;B	 �
	DB	11111111b     ;D;C 컴컴컴�
	DB	11111111b	;D
	DB	11111111b	;E
	DB	00100000b	;F
	DB	11111111b	;10
	DB	11111111b	;11
	DB	11111111b	;12
	DB	11111111b	;13
	DB	11111111b	;14
	DB	11111111b	;15
	DB	11111111b	;16
	DB	11111111b	;17
	DB	11111111b	;18
	DB	11111111b	;19
	DB	11111111b	;1A
	DB	11111111b	;1B
	DB	11111111b	;1C
	DB	11111111b	;1D
	DB	11111111b	;1E
	DB	11111111b	;1F
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LCD_MODES:			;
	DB	00000010b	;0
	DB	00000010b	;1
	DB	00000010b	;2
	DB	00000010b	;3
	DB	11010000b	;4
	DB	11010000b	;5
	DB	11010000b	;6
	DB	00000010b	;7
	DB	11111111b     ;D;8 컴컴컴�
	DB	11111111b     ;D;9	 �
	DB	11111111b     ;D;A    RESERVED
	DB	11111111b     ;D;B	 �
	DB	11111111b     ;D;C 컴컴컴�
	DB	11010000b	;D
	DB	11010000b	;E
	DB	11010000b	;F
	DB	11010000b	;10
	DB	11010000b	;11
	DB	11010000b	;12
	DB	11010000b	;13
	DB	11010000b	;14
	DB	11010000b	;15
	DB	11010000b	;16
	DB	11010000b	;17
	DB	11010000b	;18
	DB	11010000b	;19
	DB	11010000b	;1A
	DB	11010000b	;1B
	DB	11010000b	;1C
	DB	11010000b	;1D
	DB	11010000b	;1E
	DB	11010000b	;1F
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MONO_MODES:			;
MONO_FONT_SIZE: 		;
	DB	11111111b	;0
	DB	11111111b	;1
	DB	11111111b	;2
	DB	11111111b	;3
	DB	11111111b	;4
	DB	11111111b	;5
	DB	11111111b	;6
	DB	11111111b	;7
	DB	11111111b     ;D;8 컴컴컴�
	DB	11111111b     ;D;9	 �
	DB	11111111b     ;D;A    RESERVED
	DB	11111111b     ;D;B	 �
	DB	11111111b     ;D;C 컴컴컴�
	DB	11111111b	;D
	DB	11111111b	;E
	DB	11111111b	;F
	DB	11111111b	;10
	DB	11111111b	;11
	DB	11111111b	;12
	DB	11111111b	;13
	DB	11111111b	;14
	DB	11111111b	;15
	DB	11111111b	;16
	DB	11111111b	;17
	DB	11111111b	;18
	DB	11111111b	;19
	DB	11111111b	;1A
	DB	11111111b	;1B
	DB	11111111b	;1C
	DB	11111111b	;1D
	DB	11111111b	;1E
	DB	11111111b	;1F
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EGA_FONT_SIZE:			;		this needs to be adjusted
	DB	0		;0		*************************
	DB	0		;1		*************************
	DB	0		;2
	DB	0		;3
	DB	8		;4
	DB	8		;5
	DB	8		;6
	DB	0		;7
	DB	0FFH	      ;D;8 컴컴컴�
	DB	0FFH	      ;D;9	 �
	DB	0FFH	      ;D;A    RESERVED
	DB	0FFH	      ;D;B	 �
	DB	0FFH	      ;D;C 컴컴컴�
	DB	0		;D
	DB	0		;E
	DB	0		;F
	DB	0		;10
	DB	0		;11
	DB	0		;12
	DB	0		;13
	DB	0		;14
	DB	0		;15
	DB	0		;16
	DB	0		;17
	DB	0		;18
	DB	0		;19
	DB	0		;1A
	DB	0		;1B
	DB	0		;1C
	DB	0		;1D
	DB	0		;1E
	DB	0		;1F
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EGA8_FONT_SIZE: 		;
	DB	8		;0
	DB	8		;1
	DB	8		;2
	DB	8		;3
	DB	8		;4
	DB	8		;5
	DB	8		;6
	DB	0FFH		;7
	DB	0FFH	      ;D;8 컴컴컴�
	DB	0FFH	      ;D;9	 �
	DB	0FFH	      ;D;A    RESERVED
	DB	0FFH	      ;D;B	 �
	DB	0FFH	      ;D;C 컴컴컴�
	DB	8		;D
	DB	8		;E
	DB	8		;F
	DB	0FFH		;10
	DB	0FFH		;11
	DB	0FFH		;12
	DB	0FFH		;13
	DB	0FFH		;14
	DB	0FFH		;15
	DB	0FFH		;16
	DB	0FFH		;17
	DB	0FFH		;18
	DB	0FFH		;19
	DB	0FFH		;1A
	DB	0FFH		;1B
	DB	0FFH		;1C
	DB	0FFH		;1D
	DB	0FFH		;1E
	DB	0FFH		;1F
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EGA14_FONT_SIZE:		;
	DB	14		;0
	DB	14		;1
	DB	14		;2
	DB	14		;3
	DB	 8		;4
	DB	 8		;5
	DB	 8		;6
	DB	14		;7
	DB	0FFH	      ;D;8 컴컴컴�
	DB	0FFH	      ;D;9	 �
	DB	0FFH	      ;D;A    RESERVED
	DB	0FFH	      ;D;B	 �
	DB	0FFH	      ;D;C 컴컴컴�
	DB	 8		;D
	DB	 8		;E
	DB	14		;F
	DB	14		;10
	DB	0FFH		;11
	DB	0FFH		;12
	DB	0FFH		;13
	DB	0FFH		;14
	DB	0FFH		;15
	DB	0FFH		;16
	DB	0FFH		;17
	DB	0FFH		;18
	DB	0FFH		;19
	DB	0FFH		;1A
	DB	0FFH		;1B
	DB	0FFH		;1C
	DB	0FFH		;1D
	DB	0FFH		;1E
	DB	0FFH		;1F
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LCD_FONT_SIZE:			;
	DB	8		;0
	DB	8		;1
	DB	8		;2
	DB	8		;3
	DB	8		;4
	DB	8		;5
	DB	8		;6
	DB	8		;7
	DB	0FFH	      ;D;8 컴컴컴�
	DB	0FFH	      ;D;9	 �
	DB	0FFH	      ;D;A    RESERVED
	DB	0FFH	      ;D;B	 �
	DB	0FFH	      ;D;C 컴컴컴�
	DB	8		;D
	DB	8		;E
	DB	8		;F
	DB	8		;10
	DB	8		;11
	DB	8		;12
	DB	8		;13
	DB	8		;14
	DB	8		;15
	DB	8		;16
	DB	8		;17
	DB	8		;18
	DB	8		;19
	DB	8		;1A
	DB	8		;1B
	DB	8		;1C
	DB	8		;1D
	DB	8		;1E
	DB	8		;1F
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
