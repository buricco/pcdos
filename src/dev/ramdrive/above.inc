BREAK	<ABOVE BOARD Equates>

;
; Assorted equates for use with Intel Above Board
;

;
; EMM INT 67H Function codes
;
ABOVE_STATUS		EQU	40H
ABOVE_GET_SEG		EQU	41H
ABOVE_GET_FREE		EQU	42H
ABOVE_ALLOC		EQU	43H
ABOVE_MAP		EQU	44H
ABOVE_DEALLOC		EQU	45H
ABOVE_GET_VERSION	EQU	46H
ABOVE_SAVE_MAP_PID	EQU	47H
ABOVE_RESTORE_MAP_PID	EQU	48H

;
; NEW call not implemented in version 1.00 Above Board
;
ABOVE_GETSET_MAP	EQU	4EH
;
; 4EH AX equates for subfunctions
;
ABOVE_GETSET_GET	EQU	4E00H
ABOVE_GETSET_SET	EQU	4E01H
ABOVE_GETSET_GETSET	EQU	4E02H


;
; "Maintenance" calls
;
ABOVE_GET_IOPORT	EQU	49H
ABOVE_GET_MAP_ARRAY	EQU	4AH
ABOVE_GET_PIDS		EQU	4BH
ABOVE_GET_PAGES 	EQU	4CH
ABOVE_GET_ALLOC 	EQU	4DH


;
; EMM INT 67H AH return values
;
ABOVE_SUCCESSFUL	    EQU     0
ABOVE_ERROR_SOFTWARE	    EQU     80H
ABOVE_ERROR_HARDWARE	    EQU     81H
ABOVE_ERROR_BUSY	    EQU     82H
ABOVE_ERROR_BAD_PID	    EQU     83H
ABOVE_ERROR_BAD_FUNC	    EQU     84H
ABOVE_ERROR_OUT_OF_PIDS     EQU     85H
ABOVE_ERROR_MAP_CNTXT	    EQU     86H
ABOVE_ERROR_INSUFF_MEM	    EQU     87H
ABOVE_ERROR_INSUFF_FREE     EQU     88H
ABOVE_ERROR_ALLOC_ZERO	    EQU     89H
ABOVE_ERROR_LOG_INVALID     EQU     8AH
ABOVE_ERROR_PHYS_INVALID    EQU     8BH
ABOVE_ERROR_CNTXT_NO_STACK  EQU     8CH
ABOVE_ERROR_SECOND_SAVE     EQU     8DH
ABOVE_ERROR_NO_CNTXT	    EQU     8EH
ABOVE_ERROR_BAD_PARM	    EQU     8FH