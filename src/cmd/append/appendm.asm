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

page	60,120
;      @@04 07/30/86 Fix second APPEND hang		 PTM P0000053
;      @@05 08/13/86 Fix bad parm message		PTM P0000125
;      @@10 08/28/86 Change message for @@05		PTM P0000291
;      @@11 09/10/86 Support message profile and make
;		     msg length variable.	R.G. PTM P0000479
cseg	segment public para 'CODE'
	assume	cs:cseg

	public	bad_append_msg			;@@11
	public	path_error_msg			;@@11
	public	parm_error_msg			;@@11
	public	path_parm_error_msg		;@@11
	public	no_append_msg			;@@11
	public	append_assign_msg		;@@11
	public	append_tv_msg			;@@11
	public	bad_DOS_msg			;@@11
	public	second_append_msg		;@@11

	public	len_bad_append_msg		;@@11
	public	len_path_error_msg		;@@11
	public	len_parm_error_msg		;@@11
	public	len_path_parm_error_msg 	;@@11
	public	len_no_append_msg		;@@11
	public	len_append_assign_msg		;@@11
	public	len_append_tv_msg		;@@11
	public	len_bad_DOS_msg 		;@@11
	public	len_second_append_msg		;@@11

cr	equ	13
lf	equ	10

include appendm.inc

cseg		ends
		end
