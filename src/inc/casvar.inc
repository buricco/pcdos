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

;
; Revised:  02-15-88
;
CASRM	       EQU  0			     ;Set to zero (0) to create an
					     ; object module to put in the
					     ; CAS Library.  Set to one (1)
					     ; to create the CAS Routine
					     ; Manager version of the routine.
;
CASFAR	       EQU  1			     ;Set to zero (0) to create an
					     ; object module that is called
					     ; as a near procedure.  Set to
					     ; one (1) to create an object
					     ; module that is called as a far
					     ; procedure.
;
COPYRIGHT      EQU  0			     ;Set to zero (0) to include
					     ; Copyright 1988 Microsoft
					     ; (1) to exclude Copyright 1988 Microsoft
					     ; notice.
;
SMODE	       EQU  2			     ;Set to one (1) for Interpertive
					     ; BASIC. Set to two (2) for
					     ; Compiled BASIC.
;
CASINT	       EQU  7FH 		     ;CAS Routine Manager interupt
;
CASFILEID      EQU  01234H		     ;This CAS file identification
					     ; is found at the beginning of all
					     ; CAS files in the first word
PANELOBJID     EQU  0FFH		     ;This is the panel object
					     ; identification number that is
					     ; found inside a valid CAS file's
					     ; object list when panels have
					     ; been saved inside a file
HELPOBJID      EQU  0FEH		     ;This is the help/error object
					     ; identification number that is
					     ; found inside a valid CAS file's
					     ; object list when helps have
					     ; been saved inside a file
COLOROBJID     EQU  0FDH		     ;This is the color object
					     ; identification number that is
					     ; found inside a valid CAS file's
					     ; object list when colors have
					     ; been saved inside a file
INPUTOBJID     EQU  0FCH		     ;This is the input object
					     ; identification number that is
					     ; found inside a valid CAS file's
					     ; object list when input fields
					     ; have been saved inside a file
DIALOGOBJID    EQU  0FBH		     ;This is the dialog object
					     ; identification number that is
					     ; found inside a valid CAS file's
					     ; object list when dialogs have
					     ; been saved inside a file
SCROLLOBJID    EQU  0FAH		     ;This is the scroll field object
					     ; identification number that is
					     ; found inside a valid CAS file's
					     ; object list when scroll fields
					     ; have been saved inside a file
TRANSOBJID     EQU  0F9H		     ;This is the translation object
					     ; identification number that is
					     ; found inside a valid CAS file's
					     ; object list when a translation
					     ; table has been saved inside a
					     ; file
GRAPHOBJID     EQU  0F8H		     ;This is the graphic field object
					     ; identification number that is
					     ; found inside a valid CAS file's
					     ; object list when a graphic
					     ; fields has been saved inside a
					     ; file
MENUOBJID      EQU  0F7H		     ;This is the maintain menu object
					     ; identification number that is
					     ; found inside a valid CAS file's
					     ; object list when a menu table
					     ; has been saved inside a file
MAXNUMOBJS     EQU  20			     ;Maximum possible number of
					     ; objects types reserved in CAS
					     ; data files.  (i.e. panel, help,
					     ; error, color, input objects,,,)
;
LIBVER	       MACRO
	       DB   "Version 4.0"            ;CAS library version number
ENDM
;
INCLUDE        CASRN.INC		     ;Include the CAS routine numbers
