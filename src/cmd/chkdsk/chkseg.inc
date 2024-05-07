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

PSP	segment public	para 'DUMMY'                                            ;an000;bgb
PSP	ends									;an000;bgb
										;an000;bgb
data	segment public para 'DATA'                                              ;an000;bgb
data	ends									;an000;bgb
										;an000;bgb
CONST	SEGMENT PUBLIC para 'DATA'                                              ;an000;bgb
CONST	ENDS									;an000;bgb
										;an000;bgb
code	segment public para 'CODE'                                              ;an000;bgb
code	ends									;an000;bgb
										;an000;bgb
cstack	 segment para stack 'STACK'                                             ;an000;bgb
cstack	 ends									;an000;bgb
										;an000;bgb
lastseg segment public para 'LAST'                                              ;an000;bgb;AN000;bgb
lastseg ends			 ;this is a pointer to the end of the pgm     ;A;an000;bgbN000;bgb
										;an000;bgb;AN000;bgb
DG	GROUP	data,const,code,CSTACK,lastseg					;an000;bgb
assume	cs:dg,ds:dg,ss:dg,es:dg 						;an000;bgb

