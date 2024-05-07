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

;	SCCSID = @(#)fordata.asm	1.1 85/05/14
; Data structure definitions included by tfor.asm

for_info        STRUC
    for_args        DB          (SIZE arg_unit) DUP (?) ; argv[] structure
    FOR_COM_START   DB          (?)                     ; beginning of <command>
    FOR_EXPAND      DW          (?)                     ; * or ? item in <list>?
    FOR_MINARG      DW          (?)                     ; beginning of <list>
    FOR_MAXARG      DW          (?)                     ; end of <list>
    forbuf          DW          64 DUP (?)              ; temporary buffer
    fordma          DW          64 DUP (?)              ; FindFirst/Next buffer
    FOR_VAR         DB          (?)                     ; loop control variable
for_info        ENDS

; empty segment done for bogus addressing
for_segment     segment
f       LABEL   BYTE
for_segment     ends
