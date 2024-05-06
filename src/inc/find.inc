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

;	SCCSID = @(#)find.asm	1.1 85/04/10
Break	<find first/next buffer>

find_buf    STRUC
;----+----+----+----+----+----+----+----+----+----+----+----+----+----+----;
;	     C	A  V  E  A  T	  P  R	O  G  R  A  M  M  E  R		   ;
;									   ;
find_buf_drive	    DB	?		; drive of search
find_buf_name	    DB	11 DUP (?)	; formatted name
find_buf_sattr	    DB	?		; attribute of search
find_buf_LastEnt    DW	?		; LastEnt
find_buf_DirStart   DW	?		; DirStart
find_buf_NetID	    DB	4 DUP (?)	; Reserved for NET
;									   ;
;	     C	A  V  E  A  T	  P  R	O  G  R  A  M  M  E  R		   ;
;----+----+----+----+----+----+----+----+----+----+----+----+----+----+----;

find_buf_attr	    DB	?		; attribute found
find_buf_time	    DW	?		; time
find_buf_date	    DW	?		; date
find_buf_size_l     DW	?		; low(size)
find_buf_size_h     DW	?		; high(size)
find_buf_pname	    DB	13 DUP (?)	; packed name
find_buf    ENDS
