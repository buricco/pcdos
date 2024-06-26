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

;Get/Set Extended Attrbute Equates

;The following equates are for EA types

EAISUNDEF	      equ  00H	     ; undefined
EAISLOGICAL	      equ  01H	     ; logical (0 or 1), 1 byte
EAISBINARY	      equ  02H	     ; binary integer 1, 2, or 4 bytes
EAISASCII	      equ  03H	     ; ASCII , 0 to 128 bytes
EAISDATE	      equ  04H	     ; DOS file date format, 2 bytes
EAISTIME	      equ  05H	     ; DOS file time format, 2 bytes

;The following equates are for EA flags

EASYSTEM	      equ  8000H     ; system defined, bultin
EAREADONLY	      equ  4000H     ; read-only , cannot be changed
EAHIDDEN	      equ  2000H     ; hidden from ATTRIB
EACREATEONLY	      equ  1000H     ; settable only at create time

;The following equates are for EA failure reason code (set by DOS)

EARCSUCCESS	      equ  00H	     ; success
EARCNOTFOUND	      equ  01H	     ; name not found
EARCNOSPACE	      equ  02H	     ; no space to hold name or value
EARCNOTNOW	      equ  03H	     ; name can't be set on this function
EARCNOTEVER	      equ  04H	     ; name can't be set
EARCUNDEF	      equ  05H	     ; name known to IFS but not supported
EARCDEFBAD	      equ  06H	     ; EA definition bad (type,length, etc)
EARCACCESS	      equ  07H	     ; EA access denied
EARCBADVAL	      equ  08H	     ; bad value
EARCDEVERROR	      equ  09H	     ; device error
EARCUNKNOWN	      equ  0FFFFH    ; unknown cause


;The following equates are for EA file type

EAEXISTING	     equ  00H	    ; existing file
EARTL		     equ  02H	    ; right to left
EAEXECUTABLE	     equ  03H	    ; executable program
EAINSTALLABLE	     equ  04H	    ; installable executable program
EAOVERLAY	     equ  05H	    ; program overlay
EADEV_DRIVER	     equ  06H	    ; device driver
EAIFS_DRIVER	     equ  07H	    ; ifs deriver




By_Create	      equ  0000010B	     ; set by Extended Open (create)
BY_XA		      equ  0000100B	     ; set by Get/Set XA by Handle

;Extended Attribute Structure

EA	    STRUC			      ; extended attribute list
EA_TYPE     DB	      ? 		      ; type
EA_FLAGS    DW	      ? 		      ; flags
EA_RC	    DB	      ? 		      ; reason code
EA_NAMELEN  DB	      ? 		      ; name length
EA_VALLEN   DW	      ? 		      ; value length
EA_NAME     DB	      ? 		      ; name
EA	    ENDS


;Query Extended Attribute list

QEA	     STRUC			       ; extended attribute list
QEA_TYPE     DB        ?		       ; type
QEA_FLAGS    DW        ?		       ; flags
QEA_NAMELEN  DB        ?		       ; name length
QEA_NAME     DB        ?		       ; name
QEA	     ENDS
