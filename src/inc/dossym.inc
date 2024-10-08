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

;	SCCSID = @(#)dossym.asm 1.1 85/04/10
	PAGE 80,132
TRUE	    EQU 0FFFFh
FALSE	    EQU 0

Installed   = TRUE
IFNDEF	DEBUG
    DEBUG	= FALSE
ENDIF

include dbcs.sw
include dosmac.inc

include versiona.inc

IF2
    %OUT    DOSSYM in Pass 2
ENDIF

BREAK <Control character definitions>

c_DEL	    EQU     7Fh 		;    ASCII rubout or delete previous char
c_BS	    EQU     08h 		; ^H ASCII backspace
c_CR	    EQU     0Dh 		; ^M ASCII carriage return
c_LF	    EQU     0Ah 		; ^J ASCII linefeed
c_ETB	    EQU     17h 		; ^W ASCII end of transmission
c_NAK	    EQU     15h 		; ^U ASCII negative acknowledge
c_ETX	    EQU     03h 		; ^C ASCII end of text
c_HT	    EQU     09h 		; ^I ASCII tab

BREAK <Read This and Weep>

;----+----+----+----+----+----+----+----+----+----+----+----+----+----+----;
;									   ;
;	     C	A  V  E  A  T	  P  R	O  G  R  A  M  M  E  R		   ;
;									   ;
; Certain structures, constants and system  calls  below  are  private	to ;
; the DOS  and	are  extremely	version-dependent.  They may change at any ;
; time at  the	implementors'  whim.   As  a  result,  they  must  not  be ;
; documented to  the  general  public.	 If  an  extreme case arises, they ;
; must be documented with this warning. 				   ;
;									   ;
; Those structures and constants that are subject to  the  above  will	be ;
; marked and bracketed with the flag:					   ;
;									   ;
;	     C	A  V  E  A  T	  P  R	O  G  R  A  M  M  E  R		   ;
;									   ;
;----+----+----+----+----+----+----+----+----+----+----+----+----+----+----;

include bpb.inc

include buffer.inc

BREAK <User stack inside of system call and SysVars>
; Location of user registers relative user stack pointer

user_environ	STRUC
user_AX     DW	    ?
user_BX     DW	    ?
user_CX     DW	    ?
user_DX     DW	    ?
user_SI     DW	    ?
user_DI     DW	    ?
user_BP     DW	    ?
user_DS     DW	    ?
user_ES     DW	    ?
user_IP     DW	    ?
user_CS     DW	    ?
user_F	    DW	    ?
user_environ	ENDS

include sysvar.inc

include vector.inc

include mult.inc

BREAK <Disk map>
;  MSDOS partitions the disk into 4 sections:
;
;  phys sector 0:   +-------------------+
;	|	    | boot/reserved	|
;	|	    +-------------------+
;	|	    |  File allocation	|
;	v	    |	   table(s)	|
;		    |  (multiple copies |
;		    |	  are kept)	|
;		    +-------------------+
;		    |	  Directory	|
;		    +-------------------+
;		    |	  File space	|
;		    +-------------------+
;		    |	Unaddressable	|
;		    |  (to end of disk) |
;		    +-------------------+
;
; All partition boundaries are sector boundaries.  The size of the FAT is
; adjusted to maximize the file space addressable.

include dirent.inc

BREAK <File allocation Table information>
;
; The File Allocation Table uses a 12-bit entry for each allocation unit on
; the disk.  These entries are packed, two for every three bytes.  The contents
; of entry number N is found by 1) multiplying N by 1.5; 2) adding the result
; to the base address of the Allocation Table; 3) fetching the 16-bit word
; at this address; 4) If N was odd (so that N*1.5 was not an integer), shift
; the word right four bits; 5) mask to 12 bits (AND with 0FFF hex).  Entry
; number zero is used as an end-of-file trap in the OS and is passed to the
; BIOS to help determine disk format.  Entry 1 is reserved for future use.
; The first available allocation unit is assigned entry number two, and even
; though it is the first, is called cluster 2.	Entries greater than 0FF8H
; (12-bit fats) or 0FFF8H (16-bit fats) are end of file marks; entries of zero
; are unallocated.  Otherwise, the contents of a FAT entry is the number of
; the next cluster in the file.
;
; Clusters with bad sectors are tagged with FF7H.  Any non-zero number would
; do because these clusters show as allocated, but are not part of any
; allocation chain and thus will never be allocated to a file.	A particular
; number is selected so that disk checking programs know what to do (ie.  a
; cluster with entry FF7H which is not in a chain is not an error).

include dpb.inc

include curdir.inc

include cpmfcb.inc

include find.inc

include pdb.inc

include exe.inc

include sf.inc

include arena.inc

include intnat.inc

include mi.inc

fChk	equ 1
fDelim	equ 2
fSpChk	equ 4
fFCB	equ 8

include filemode.inc

include error.inc

include syscall.inc

SUBTTL
