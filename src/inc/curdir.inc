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

;	SCCSID = @(#)curdir.asm 1.1 85/04/10
BREAK <Current directory list structure>
;----+----+----+----+----+----+----+----+----+----+----+----+----+----+----;
;	     C	A  V  E  A  T	  P  R	O  G  R  A  M  M  E  R		   ;
;									   ;
; CDS items are used bu the internal routines to store cluster numbers and ;
; network identifiers for each logical name.  The ID field is used dually, ;
; both as net ID and for a cluster number for local devices.  In the case  ;
; of local devices, the cluster number will be -1 if there is a potential  ;
; of the disk being changed or if the path must be recracked.  The END	   ;
; field is the location of the end of the definition.  No .. is allowed    ;
; past this point							   ;

DIRSTRLEN	EQU	64+3		; Max length in bytes of directory strings
TEMPLEN 	EQU	DIRSTRLEN*2

curdir_list	STRUC
curdir_text	DB	DIRSTRLEN DUP (?)   ; text of assignment and curdir
curdir_flags	DW	?		; various flags
curdir_devptr	DD	?		; local pointer to DPB or net device
curdir_ID	DW	?		; cluster of current dir (net ID)
		DW	?
curdir_user_word DW	?
curdir_end	DW	?		; end of assignment
curdir_type	DB	?		; IFS drive (2=ifs, 4=netuse)
curdir_ifs_hdr	DD	?		; Ptr to File System Header
curdir_fsda	DB	2 DUP (?)	; File System Dependent Data Area
curdir_list	ENDS

curdirLen	EQU	Size curdir_list	; Needed for screwed up
						; ASM87 which doesn't allow
						; Size directive as a macro
						; argument
curdir_netID	EQU	DWORD PTR curdir_ID

;Flag word masks
curdir_isnet	EQU	1000000000000000B
curdir_isifs	EQU	1000000000000000B	; DOS 4.00
curdir_inuse	EQU	0100000000000000B
curdir_splice	EQU	0010000000000000B
curdir_local	EQU	0001000000000000B
;									   ;
;	     C	A  V  E  A  T	  P  R	O  G  R  A  M  M  E  R		   ;
;----+----+----+----+----+----+----+----+----+----+----+----+----+----+----;
