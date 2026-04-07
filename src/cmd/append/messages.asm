; Copyright 1986-88 Microsoft Corp. & International Business Machines Corp.
; Copyright 2026 S. V. Nickolas.
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

cseg      segment public para 'CODE'

          public    bad_append_msg, path_error_msg, parm_error_msg
          public    path_parm_error_msg, no_append_msg, append_assign_msg
          public    append_TV_msg, bad_DOS_msg, second_APPEND_msg

          public    len_bad_append_msg, len_path_error_msg, len_parm_error_msg
          public    len_path_parm_error_msg, len_no_append_msg
          public    len_append_assign_msg, len_append_TV_msg, len_bad_DOS_msg
          public    len_second_APPEND_msg

SECOND_APPEND_MSG             db        "APPEND already installed", 13, 10
LEN_SECOND_APPEND_MSG         dw        $-SECOND_APPEND_MSG

BAD_APPEND_MSG                db        "Incompatible APPEND version", 13, 10
LEN_BAD_APPEND_MSG            dw        $-BAD_APPEND_MSG

BAD_DOS_MSG                   db        "Incorrect DOS version", 13, 10
LEN_BAD_DOS_MSG               dw        $-BAD_DOS_MSG

APPEND_ASSIGN_MSG             db        "APPEND/ASSIGN conflict", 13, 10
LEN_APPEND_ASSIGN_MSG         dw        $-APPEND_ASSIGN_MSG

APPEND_TV_MSG                 db        "APPEND/TopView conflict", 13, 10
LEN_APPEND_TV_MSG             dw        $-APPEND_TV_MSG

PATH_ERROR_MSG                db        "Invalid path", 13, 10
LEN_PATH_ERROR_MSG            dw        $-PATH_ERROR_MSG

PATH_PARM_ERROR_MSG           db        "Invalid parameter", 13, 10
LEN_PATH_PARM_ERROR_MSG       dw        $-PATH_PARM_ERROR_MSG

PARM_ERROR_MSG                db        "Invalid combination of parameters", 13, 10
LEN_PARM_ERROR_MSG            dw        $-PARM_ERROR_MSG

NO_APPEND_MSG                 db        "No Append", 13, 10
LEN_NO_APPEND_MSG             dw        $-NO_APPEND_MSG

cseg	     ends
          end
