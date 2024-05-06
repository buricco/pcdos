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

						  ;;Rev 3.30 Modification
;
; given a label <lbl> either 2 byte jump to another label <lbl>_J
; if it is near enough or 3 byte jump to <lbl>
;

jump	macro lbl
	local a
.xcref

	ifndef lbl&_j			;; is this the first invocation
a:
				JMP lbl
	ELSE
	    IF (lbl&_J GE $) OR ($-lbl&_J GT 126)
a:
				JMP lbl ;; is the jump too far away?
	    ELSE
a:
			       JMP lbl&_J  ;; do the short one...
	    ENDIF
	ENDIF
lbl&_j = a
.cref
	endm
.xcref	jump
;REDEFINE THE ABOVE MACRO TO ALWAYS TRY A 3 BYTE NEAR JUMP		 
JUMP MACRO LBL								 
					JMP LBL 			 
	ENDM					;;End of Modification

