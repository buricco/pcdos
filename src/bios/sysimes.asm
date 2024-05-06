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

	;SCCSID = @(#)sysimes.asm	 1.2 85/07/25
%OUT ...SYSIMES

;==============================================================================
;REVISION HISTORY:
;AN000 - New for DOS Version 4.00 - J.K.
;AC000 - Changed for DOS Version 4.00 - J.K.
;AN00x - PTM number for DOS Version 4.00 - J.K.
;==============================================================================
;AN001 D246, P976 Show "Bad command or parameters - ..." msg        9/22/87 J.K.
;AN002 P1820 New Message SKL file				   10/20/87 J.K.
;AN003 D486 Share installation for large media			   02/24/88 J.K.
;==============================================================================

iTEST = 0
include MSequ.INC
include MSmacro.INC

SYSINITSEG	SEGMENT PUBLIC BYTE 'SYSTEM_INIT'

	PUBLIC	BADOPM,CRLFM,BADSIZ_PRE,BADLD_PRE,BADCOM,SYSSIZE,BADCOUNTRY
;	 PUBLIC  BADLD_POST,BADSIZ_POST,BADMEM,BADBLOCK,BADSTACK
	PUBLIC	BADMEM,BADBLOCK,BADSTACK
	PUBLIC	INSUFMEMORY,BADCOUNTRYCOM
	public	BadOrder,Errorcmd		;AN000;
	public	BadParm 			;AN001;
	public	SHAREWARNMSG			;AN003;


;include sysimes.inc
include MSbio.cl3				;AN002;

SYSSIZE LABEL	BYTE

PATHEND 	001,SYSMES

SYSINITSEG	ENDS
	END
