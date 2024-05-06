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

;J.K. This is a temporary version of EMS function definitions needed for
;IBMBIO SYSINIT.

EMS_INT 	equ	67h	;interrupt vector designated for EMS.

EMS_STATUS	equ	40h	;status of memery manager
EQ_PAGES	equ	42h	;get number of unallocated & total pages
E_GET_HANDLE	equ	43h	;allocate pages
EMAP_L_TO_P	equ	44h	;Map logical to physical page
EMAP_STATE	equ	4Fh	;Mapping status
    GET_MAP_STATE     equ    00h
    GET_MAP_SIZE      equ    02h
    SET_MAP_STATE     equ    01h
EDE_ALLOCATE	equ	45h	;deallocate pages
EMS_VERSION	equ	46h	;Get EMM version number
GET_PAGE_FRAME	equ	58h	;Get page frame address
    GET_PAGEFRAME_TAB equ 00H
    GET_NUM_PAGEFRAME equ 01H
EMS_HANDLE_NAME equ	53h
    SET_HANDLE_NAME equ  01h

IBM_PAGE_ID	equ	255	;Physical page id that will be used by
				;IBMBIO and IBMDOS for buffer manipulation.

;MAX_NUM_PAGEFRAME equ	 12	;maximum number of page frames IBMBIO can
				;handle

MAX_NUM_PAGEFRAME equ	 64	;maximum number of page frames MSBIO can
				;handle

EMSVERSION	equ	40h	;4.0


