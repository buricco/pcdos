	PAGE	90,132			;A2
	TITLE	GRTABNO - NORDIC CHARACTER SET FOR GRAFTABL COMMAND
;This module is to be linked with the OBJ of GRTAB.SAL.  Refer to the
;Prolog of that module for more complete description.

;This module contains the binary description of the pixels that are used
;in graphics mode to define the Nordic character set when loaded to
;interrupt 1FH by the GRAFTABL command in DOS 3.3.
	IF1
	    %OUT    GRTABNO.ASM...
	ELSE
;    %OUT GRTABNO.ASM...
	ENDIF
CSEG	SEGMENT PARA PUBLIC
TABLENO EQU	THIS BYTE
	PUBLIC	TABLENO

;(note: the display of the character to the right of the decimal number
;value of this location is not necessarily the graphic that these pixels
;will produce.	The displayed character is from the USA character set, and
;does not represent the language character set generated by this table.)

;These fonts are as defined in the Nordic Code Page = 865.

	DB	00111100B		;128 �
	DB	01100110B
	DB	01100000B
	DB	01100110B
	DB	00111100B
	DB	00001100B
	DB	00000110B
	DB	00111100B
;
	DB	00000000B		;129 �
	DB	01100110B
	DB	00000000B
	DB	01100110B
	DB	01100110B
	DB	01100110B
	DB	00111111B
	DB	00000000B
.XLIST
;
	DB	00001110B		;130 �
	DB	00000000B
	DB	00111100B
	DB	01100110B
	DB	01111110B
	DB	01100000B
	DB	00111100B
	DB	00000000B
;
	DB	01111110B		;131 �
	DB	11000011B
	DB	00111100B
	DB	00000110B
	DB	00111110B
	DB	01100110B
	DB	00111111B
	DB	00000000B
;
	DB	01100110B		;132 �
	DB	00000000B
	DB	00111100B
	DB	00000110B
	DB	00111110B
	DB	01100110B
	DB	00111111B
	DB	00000000B
;
	DB	01110000B		;133 �
	DB	00000000B
	DB	00111100B
	DB	00000110B
	DB	00111110B
	DB	01100110B
	DB	00111111B
	DB	00000000B
;
	DB	00011000B		;134 �
	DB	00011000B
	DB	00111100B
	DB	00000110B
	DB	00111110B
	DB	01100110B
	DB	00111111B
	DB	00000000B
;
	DB	00000000B		;135 �
	DB	00000000B
	DB	00111100B
	DB	01100000B
	DB	01100000B
	DB	00111100B
	DB	00000110B
	DB	00011100B
;
	DB	01111110B		;136 �
	DB	11000011B
	DB	00111100B
	DB	01100110B
	DB	01111110B
	DB	01100000B
	DB	00111100B
	DB	00000000B
;
	DB	01100110B		;137 �
	DB	00000000B
	DB	00111100B
	DB	01100110B
	DB	01111110B
	DB	01100000B
	DB	00111100B
	DB	00000000B
;
	DB	01110000B		;138 �
	DB	00000000B
	DB	00111100B
	DB	01100110B
	DB	01111110B
	DB	01100000B
	DB	00111100B
	DB	00000000B
;
	DB	01100110B		;139 �
	DB	00000000B
	DB	00111000B
	DB	00011000B
	DB	00011000B
	DB	00011000B
	DB	00111100B
	DB	00000000B
;
	DB	01111100B		;140 �
	DB	11000110B
	DB	00111000B
	DB	00011000B
	DB	00011000B
	DB	00011000B
	DB	00111100B
	DB	00000000B
;
	DB	01110000B		;141 �
	DB	00000000B
	DB	00111000B
	DB	00011000B
	DB	00011000B
	DB	00011000B
	DB	00111100B
	DB	00000000B
;
	DB	01100011B		;142 �
	DB	00011100B
	DB	00110110B
	DB	01100011B
	DB	01111111B
	DB	01100011B
	DB	01100011B
	DB	00000000B
;
	DB	00011000B		;143 �
	DB	00011000B
	DB	00000000B
	DB	00111100B
	DB	01100110B
	DB	01111110B
	DB	01100110B
	DB	00000000B
;
	DB	00001110B		;144 �
	DB	00000000B
	DB	01111110B
	DB	00110000B
	DB	00111100B
	DB	00110000B
	DB	01111110B
	DB	00000000B
;
	DB	00000000B		;145 �
	DB	00000000B
	DB	01111111B
	DB	00001100B
	DB	01111111B
	DB	11001100B
	DB	01111111B
	DB	00000000B
;
	DB	00011111B		;146 �
	DB	00110110B
	DB	01100110B
	DB	01111111B
	DB	01100110B
	DB	01100110B
	DB	01100111B
	DB	00000000B
;
	DB	00111100B		;147 �
	DB	01100110B
	DB	00000000B
	DB	00111100B
	DB	01100110B
	DB	01100110B
	DB	00111100B
	DB	00000000B
;
	DB	00000000B		;148 �
	DB	01100110B
	DB	00000000B
	DB	00111100B
	DB	01100110B
	DB	01100110B
	DB	00111100B
	DB	00000000B
;
	DB	00000000B		;149 �
	DB	01110000B
	DB	00000000B
	DB	00111100B
	DB	01100110B
	DB	01100110B
	DB	00111100B
	DB	00000000B
;
	DB	00111100B		;150 �
	DB	01100110B
	DB	00000000B
	DB	01100110B
	DB	01100110B
	DB	01100110B
	DB	00111111B
	DB	00000000B
;
	DB	00000000B		;151 �
	DB	01110000B
	DB	00000000B
	DB	01100110B
	DB	01100110B
	DB	01100110B
	DB	00111111B
	DB	00000000B
;
	DB	00000000B		;152 �
	DB	01100110B
	DB	00000000B
	DB	01100110B
	DB	01100110B
	DB	00111110B
	DB	00000110B
	DB	01111100B
;
	DB	11000011B		;153 �
	DB	00011000B
	DB	00111100B
	DB	01100110B
	DB	01100110B
	DB	00111100B
	DB	00011000B
	DB	00000000B
;
	DB	01100110B		;154 �
	DB	00000000B
	DB	01100110B
	DB	01100110B
	DB	01100110B
	DB	01100110B
	DB	00111100B
	DB	00000000B
;
	DB	00000000B		;155 �	  *
	DB	00000000B
	DB	00000000B
	DB	00111100B
	DB	01101110B
	DB	01110110B
	DB	00111100B
	DB	00000000B
;
	DB	00011100B		;156 �
	DB	00110110B
	DB	00110010B
	DB	01111000B
	DB	00110000B
	DB	01110011B
	DB	01111110B
	DB	00000000B
;
	DB	01111100B		;157 �	  *
	DB	11000110B
	DB	11001110B
	DB	11011110B
	DB	11110110B
	DB	11100110B
	DB	01111100B
	DB	00000000B
;
	DB	11111000B		;158   �
	DB	11001100B
	DB	11001100B
	DB	11111010B
	DB	11000110B
	DB	11001111B
	DB	11000110B
	DB	11000111B
;
	DB	00001110B		;159   �
	DB	00011011B
	DB	00011000B
	DB	00111100B
	DB	00011000B
	DB	00011000B
	DB	11011000B
	DB	01110000B
;
	DB	00001110B		;160 �
	DB	00000000B
	DB	00111100B
	DB	00000110B
	DB	00111110B
	DB	01100110B
	DB	00111111B
	DB	00000000B
;
	DB	00011100B		;161 �
	DB	00000000B
	DB	00111000B
	DB	00011000B
	DB	00011000B
	DB	00011000B
	DB	00111100B
	DB	00000000B
;
	DB	00000000B		;162 �
	DB	00001110B
	DB	00000000B
	DB	00111100B
	DB	01100110B
	DB	01100110B
	DB	00111100B
	DB	00000000B
;
	DB	00000000B		;163 �
	DB	00001110B
	DB	00000000B
	DB	01100110B
	DB	01100110B
	DB	01100110B
	DB	00111111B
	DB	00000000B
;
	DB	00000000B		;164 �
	DB	01111100B
	DB	00000000B
	DB	01111100B
	DB	01100110B
	DB	01100110B
	DB	01100110B
	DB	00000000B
;
	DB	01111110B		;165 �
	DB	00000000B
	DB	01100110B
	DB	01110110B
	DB	01111110B
	DB	01101110B
	DB	01100110B
	DB	00000000B
;
	DB	00111100B		;166   �
	DB	01101100B
	DB	01101100B
	DB	00111110B
	DB	00000000B
	DB	01111110B
	DB	00000000B
	DB	00000000B
;
	DB	00111000B		;167   �
	DB	01101100B
	DB	01101100B
	DB	00111000B
	DB	00000000B
	DB	01111100B
	DB	00000000B
	DB	00000000B
;
	DB	00011000B		;168 �
	DB	00000000B
	DB	00011000B
	DB	00110000B
	DB	01100000B
	DB	01100110B
	DB	00111100B
	DB	00000000B
;
	DB	00000000B		;169   �
	DB	00000000B
	DB	00000000B
	DB	11111100B
	DB	11000000B
	DB	11000000B
	DB	00000000B
	DB	00000000B
;
	DB	00000000B		;170   �
	DB	00000000B
	DB	00000000B
	DB	11111100B
	DB	00001100B
	DB	00001100B
	DB	00000000B
	DB	00000000B
;
	DB	11000011B		;171   �
	DB	11000110B
	DB	11001100B
	DB	11011110B
	DB	00110011B
	DB	01100110B
	DB	11001100B
	DB	00001111B
;
	DB	11000011B		;172   �
	DB	11000110B
	DB	11001100B
	DB	11011011B
	DB	00110111B
	DB	01101111B
	DB	11001111B
	DB	00000011B
;
	DB	00011000B		;173 �
	DB	00011000B
	DB	00000000B
	DB	00011000B
	DB	00011000B
	DB	00011000B
	DB	00011000B
	DB	00000000B
;
	DB	00000000B		;174   �
	DB	00110011B
	DB	01100110B
	DB	11001100B
	DB	01100110B
	DB	00110011B
	DB	00000000B
	DB	00000000B
;
	DB	00000000B		;175 �	  *
	DB	11000110B
	DB	01111100B
	DB	11000110B
	DB	11000110B
	DB	01111100B
	DB	11000110B
	DB	00000000B
;
	DB	00100010B		;176 �
	DB	10001000B
	DB	00100010B
	DB	10001000B
	DB	00100010B
	DB	10001000B
	DB	00100010B
	DB	10001000B
;
	DB	01010101B		;177 �
	DB	10101010B
	DB	01010101B
	DB	10101010B
	DB	01010101B
	DB	10101010B
	DB	01010101B
	DB	10101010B
;
	DB	11011011B		;178 �
	DB	01110111B
	DB	11011011B
	DB	11101110B
	DB	11011011B
	DB	01110111B
	DB	11011011B
	DB	11101110B
;
	DB	00011000B		;179 �
	DB	00011000B
	DB	00011000B
	DB	00011000B
	DB	00011000B
	DB	00011000B
	DB	00011000B
	DB	00011000B
;
	DB	00011000B		;180 �
	DB	00011000B
	DB	00011000B
	DB	00011000B
	DB	11111000B
	DB	00011000B
	DB	00011000B
	DB	00011000B
;
	DB	00011000B		;181 �
	DB	00011000B
	DB	11111000B
	DB	00011000B
	DB	11111000B
	DB	00011000B
	DB	00011000B
	DB	00011000B
;
	DB	00110110B		;182 �
	DB	00110110B
	DB	00110110B
	DB	00110110B
	DB	11110110B
	DB	00110110B
	DB	00110110B
	DB	00110110B
;
	DB	00000000B		;183 �
	DB	00000000B
	DB	00000000B
	DB	00000000B
	DB	11111110B
	DB	00110110B
	DB	00110110B
	DB	00110110B
;
	DB	00000000B		;184 �
	DB	00000000B
	DB	11111000B
	DB	00011000B
	DB	11111000B
	DB	00011000B
	DB	00011000B
	DB	00011000B
;
	DB	00110110B		;185 �
	DB	00110110B
	DB	11110110B
	DB	00000110B
	DB	11110110B
	DB	00110110B
	DB	00110110B
	DB	00110110B
;
	DB	00110110B		;186 �
	DB	00110110B
	DB	00110110B
	DB	00110110B
	DB	00110110B
	DB	00110110B
	DB	00110110B
	DB	00110110B
;
	DB	00000000B		;187 �
	DB	00000000B
	DB	11111110B
	DB	00000110B
	DB	11110110B
	DB	00110110B
	DB	00110110B
	DB	00110110B
;
	DB	00110110B		;188 �
	DB	00110110B
	DB	11110110B
	DB	00000110B
	DB	11111110B
	DB	00000000B
	DB	00000000B
	DB	00000000B
;
	DB	00110110B		;189 �
	DB	00110110B
	DB	00110110B
	DB	00110110B
	DB	11111110B
	DB	00000000B
	DB	00000000B
	DB	00000000B
;
	DB	00011000B		;190 �
	DB	00011000B
	DB	11111000B
	DB	00011000B
	DB	11111000B
	DB	00000000B
	DB	00000000B
	DB	00000000B
;
	DB	00000000B		;191 �
	DB	00000000B
	DB	00000000B
	DB	00000000B
	DB	11111000B
	DB	00011000B
	DB	00011000B
	DB	00011000B
;
	DB	00011000B		;192 �
	DB	00011000B
	DB	00011000B
	DB	00011000B
	DB	00011111B
	DB	00000000B
	DB	00000000B
	DB	00000000B
;
	DB	00011000B		;193 �
	DB	00011000B
	DB	00011000B
	DB	00011000B
	DB	11111111B
	DB	00000000B
	DB	00000000B
	DB	00000000B
;
	DB	00000000B		;194 �
	DB	00000000B
	DB	00000000B
	DB	00000000B
	DB	11111111B
	DB	00011000B
	DB	00011000B
	DB	00011000B
;
	DB	00011000B		;195 �
	DB	00011000B
	DB	00011000B
	DB	00011000B
	DB	00011111B
	DB	00011000B
	DB	00011000B
	DB	00011000B
;
	DB	00000000B		;196 �
	DB	00000000B
	DB	00000000B
	DB	00000000B
	DB	11111111B
	DB	00000000B
	DB	00000000B
	DB	00000000B
;
	DB	00011000B		;197 �
	DB	00011000B
	DB	00011000B
	DB	00011000B
	DB	11111111B
	DB	00011000B
	DB	00011000B
	DB	00011000B
;
	DB	00011000B		;198 �
	DB	00011000B
	DB	00011111B
	DB	00011000B
	DB	00011111B
	DB	00011000B
	DB	00011000B
	DB	00011000B
;
	DB	00110110B		;199 �
	DB	00110110B
	DB	00110110B
	DB	00110110B
	DB	00110111B
	DB	00110110B
	DB	00110110B
	DB	00110110B
;
	DB	00110110B		;200 �
	DB	00110110B
	DB	00110111B
	DB	00110000B
	DB	00111111B
	DB	00000000B
	DB	00000000B
	DB	00000000B
;
	DB	00000000B		;201 �
	DB	00000000B
	DB	00111111B
	DB	00110000B
	DB	00110111B
	DB	00110110B
	DB	00110110B
	DB	00110110B
;
	DB	00110110B		;202 �
	DB	00110110B
	DB	11110111B
	DB	00000000B
	DB	11111111B
	DB	00000000B
	DB	00000000B
	DB	00000000B
;
	DB	00000000B		;203 �
	DB	00000000B
	DB	11111111B
	DB	00000000B
	DB	11110111B
	DB	00110110B
	DB	00110110B
	DB	00110110B
;
	DB	00110110B		;204 �
	DB	00110110B
	DB	00110111B
	DB	00110000B
	DB	00110111B
	DB	00110110B
	DB	00110110B
	DB	00110110B
;
	DB	00000000B		;205 �
	DB	00000000B
	DB	11111111B
	DB	00000000B
	DB	11111111B
	DB	00000000B
	DB	00000000B
	DB	00000000B
;
	DB	00110110B		;206 �
	DB	00110110B
	DB	11110111B
	DB	00000000B
	DB	11110111B
	DB	00110110B
	DB	00110110B
	DB	00110110B
;
	DB	00011000B		;207 �
	DB	00011000B
	DB	11111111B
	DB	00000000B
	DB	11111111B
	DB	00000000B
	DB	00000000B
	DB	00000000B
;
	DB	00110110B		;208 �
	DB	00110110B
	DB	00110110B
	DB	00110110B
	DB	11111111B
	DB	00000000B
	DB	00000000B
	DB	00000000B
;
	DB	00000000B		;209 �
	DB	00000000B
	DB	11111111B
	DB	00000000B
	DB	11111111B
	DB	00011000B
	DB	00011000B
	DB	00011000B
;
	DB	00000000B		;210 �
	DB	00000000B
	DB	00000000B
	DB	00000000B
	DB	11111111B
	DB	00110110B
	DB	00110110B
	DB	00110110B
;
	DB	00110110B		;211 �
	DB	00110110B
	DB	00110110B
	DB	00110110B
	DB	00111111B
	DB	00000000B
	DB	00000000B
	DB	00000000B
;
	DB	00011000B		;212 �
	DB	00011000B
	DB	00011111B
	DB	00011000B
	DB	00011111B
	DB	00000000B
	DB	00000000B
	DB	00000000B
;
	DB	00000000B		;213 �
	DB	00000000B
	DB	00011111B
	DB	00011000B
	DB	00011111B
	DB	00011000B
	DB	00011000B
	DB	00011000B
;
	DB	00000000B		;214 �
	DB	00000000B
	DB	00000000B
	DB	00000000B
	DB	00111111B
	DB	00110110B
	DB	00110110B
	DB	00110110B
;
	DB	00110110B		;215 �
	DB	00110110B
	DB	00110110B
	DB	00110110B
	DB	11111111B
	DB	00110110B
	DB	00110110B
	DB	00110110B
;
	DB	00011000B		;216 �
	DB	00011000B
	DB	11111111B
	DB	00011000B
	DB	11111111B
	DB	00011000B
	DB	00011000B
	DB	00011000B
;
	DB	00011000B		;217 �
	DB	00011000B
	DB	00011000B
	DB	00011000B
	DB	11111000B
	DB	00000000B
	DB	00000000B
	DB	00000000B
;
	DB	00000000B		;218 �
	DB	00000000B
	DB	00000000B
	DB	00000000B
	DB	00011111B
	DB	00011000B
	DB	00011000B
	DB	00011000B
;
	DB	11111111B		;219 �
	DB	11111111B
	DB	11111111B
	DB	11111111B
	DB	11111111B
	DB	11111111B
	DB	11111111B
	DB	11111111B
;
	DB	00000000B		;220 �
	DB	00000000B
	DB	00000000B
	DB	00000000B
	DB	11111111B
	DB	11111111B
	DB	11111111B
	DB	11111111B
;
	DB	11110000B		;221 �
	DB	11110000B
	DB	11110000B
	DB	11110000B
	DB	11110000B
	DB	11110000B
	DB	11110000B
	DB	11110000B
;
	DB	00001111B		;222 �
	DB	00001111B
	DB	00001111B
	DB	00001111B
	DB	00001111B
	DB	00001111B
	DB	00001111B
	DB	00001111B
;
	DB	11111111B		;223 �
	DB	11111111B
	DB	11111111B
	DB	11111111B
	DB	00000000B
	DB	00000000B
	DB	00000000B
	DB	00000000B
;
	DB	00000000B		;224 �
	DB	00000000B
	DB	00111011B
	DB	01101110B
	DB	01100100B
	DB	01101110B
	DB	00111011B
	DB	00000000B
;
	DB	00000000B		;225 �
	DB	00111100B
	DB	01100110B
	DB	01111100B
	DB	01100110B
	DB	01111100B
	DB	01100000B
	DB	01100000B
;
	DB	00000000B		;226 �
	DB	01111110B
	DB	01100110B
	DB	01100000B
	DB	01100000B
	DB	01100000B
	DB	01100000B
	DB	00000000B
;
	DB	00000000B		;227 �
	DB	01111111B
	DB	00110110B
	DB	00110110B
	DB	00110110B
	DB	00110110B
	DB	00110110B
	DB	00000000B
;
	DB	01111110B		;228 �
	DB	01100110B
	DB	00110000B
	DB	00011000B
	DB	00110000B
	DB	01100110B
	DB	01111110B
	DB	00000000B
;
	DB	00000000B		;229 �
	DB	00000000B
	DB	00111111B
	DB	01101100B
	DB	01101100B
	DB	01101100B
	DB	00111000B
	DB	00000000B
;
	DB	00000000B		;230 �
	DB	00110011B
	DB	00110011B
	DB	00110011B
	DB	00110011B
	DB	00111110B
	DB	00110000B
	DB	01100000B
;
	DB	00000000B		;231 �
	DB	00111011B
	DB	01101110B
	DB	00001100B
	DB	00001100B
	DB	00001100B
	DB	00001100B
	DB	00000000B
;
	DB	01111110B		;232 �
	DB	00011000B
	DB	00111100B
	DB	01100110B
	DB	01100110B
	DB	00111100B
	DB	00011000B
	DB	01111110B
;
	DB	00011100B		;233 �
	DB	00110110B
	DB	01100011B
	DB	01111111B
	DB	01100011B
	DB	00110110B
	DB	00011100B
	DB	00000000B
;
	DB	00011100B		;234 �
	DB	00110110B
	DB	01100011B
	DB	01100011B
	DB	00110110B
	DB	00110110B
	DB	01110111B
	DB	00000000B
;
	DB	00001110B		;235 �
	DB	00011000B
	DB	00001100B
	DB	00111110B
	DB	01100110B
	DB	01100110B
	DB	00111100B
	DB	00000000B
;
	DB	00000000B		;236 �
	DB	00000000B
	DB	01111110B
	DB	11011011B
	DB	11011011B
	DB	01111110B
	DB	00000000B
	DB	00000000B
;
	DB	00000110B		;237 �
	DB	00001100B
	DB	01111110B
	DB	11011011B
	DB	11011011B
	DB	01111110B
	DB	01100000B
	DB	11000000B
;
	DB	00011100B		;238 �
	DB	01100000B
	DB	11000000B
	DB	11111100B
	DB	11000000B
	DB	01100000B
	DB	00011100B
	DB	00000000B
;
	DB	00111100B		;239 �
	DB	01100110B
	DB	01100110B
	DB	01100110B
	DB	01100110B
	DB	01100110B
	DB	01100110B
	DB	00000000B
;
	DB	00000000B		;240 �
	DB	01111110B
	DB	00000000B
	DB	01111110B
	DB	00000000B
	DB	01111110B
	DB	00000000B
	DB	00000000B
;
	DB	00011000B		;241 �
	DB	00011000B
	DB	01111110B
	DB	00011000B
	DB	00011000B
	DB	00000000B
	DB	01111110B
	DB	00000000B
;
	DB	00110000B		;242 �
	DB	00011000B
	DB	00001100B
	DB	00011000B
	DB	00110000B
	DB	00000000B
	DB	01111110B
	DB	00000000B
;
	DB	00001100B		;243 �
	DB	00011000B
	DB	00110000B
	DB	00011000B
	DB	00001100B
	DB	00000000B
	DB	01111110B
	DB	00000000B
;
	DB	00001110B		;244 �
	DB	00011011B
	DB	00011011B
	DB	00011000B
	DB	00011000B
	DB	00011000B
	DB	00011000B
	DB	00011000B
;
	DB	00011000B		;245 �
	DB	00011000B
	DB	00011000B
	DB	00011000B
	DB	00011000B
	DB	11011000B
	DB	11011000B
	DB	01110000B
;
	DB	00011000B		;246 �
	DB	00011000B
	DB	00000000B
	DB	01111110B
	DB	00000000B
	DB	00011000B
	DB	00011000B
	DB	00000000B
;
	DB	00000000B		;247 �
	DB	01110110B
	DB	11011100B
	DB	00000000B
	DB	01110110B
	DB	11011100B
	DB	00000000B
	DB	00000000B
;
	DB	00111000B		;248 �
	DB	01101100B
	DB	01101100B
	DB	00111000B
	DB	00000000B
	DB	00000000B
	DB	00000000B
	DB	00000000B
;
	DB	00000000B		;249 �
	DB	00000000B
	DB	00000000B
	DB	00011000B
	DB	00011000B
	DB	00000000B
	DB	00000000B
	DB	00000000B
;
	DB	00000000B		;250 �
	DB	00000000B
	DB	00000000B
	DB	00000000B
	DB	00011000B
	DB	00000000B
	DB	00000000B
	DB	00000000B
;
	DB	00001111B		;251 �
	DB	00001100B
	DB	00001100B
	DB	00001100B
	DB	11101100B
	DB	01101100B
	DB	00111100B
	DB	00011100B
;
	DB	01111000B		;252 �
	DB	01101100B
	DB	01101100B
	DB	01101100B
	DB	01101100B
	DB	00000000B
	DB	00000000B
	DB	00000000B
;
	DB	01110000B		;253 �
	DB	00011000B
	DB	00110000B
	DB	01100000B
	DB	01111000B
	DB	00000000B
	DB	00000000B
	DB	00000000B
.LIST
;
	DB	00000000B		;254 �
	DB	00000000B
	DB	00111100B
	DB	00111100B
	DB	00111100B
	DB	00111100B
	DB	00000000B
	DB	00000000B
;
	DB	00000000B		;255
	DB	00000000B
	DB	00000000B
	DB	00000000B
	DB	00000000B
	DB	00000000B
	DB	00000000B
	DB	00000000B
;
	DW	865			;TABLE ID
;	include graftnom.inc
	DB	"Nordic",0		;LANGUAGE NAME, IN ASCIIZ FORMAT
;(the above "DB" is an example of the ENGLISH version of the above include file)
	IF	($-CSEG) MOD 16 	;IF NOT ALREADY ON 16 BYTE BOUNDARY
	    DB	    (16-(($-CSEG) MOD 16)) DUP(0) ;ADD PADDING TO GET TO 16 BYTE BOUNDARY
	ENDIF
CSEG	ENDS
	END
