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

	%OUT BPB.INC...
;	SCCSID = @(#)BPB.ASM	1.1 85/04/29
;----+----+----+----+----+----+----+----+----+----+----+----+----+----+----;
;	     C	A  V  E  A  T	  P  R	O  G  R  A  M  M  E  R		   ;
;									   ;

; BIOS PARAMETER BLOCK DEFINITION
; THIS STRUCTURE IS USED TO BUILD A FULL DPB

BPBLOCK STRUC
BPSECSZ DW	?			; SIZE IN BYTES OF PHYSICAL SECTOR
BPCLUS	DB	?			; SECTORS/ALLOC UNIT
BPRES	DW	?			; NUMBER OF RESERVED SECTORS
BPFTCNT DB	?			; NUMBER OF FATS
BPDRCNT DW	?			; NUMBER OF DIRECTORY ENTRIES
BPSCCNT DW	?			; TOTAL NUMBER OF SECTORS
BPMEDIA DB	?			; MEDIA DESCRIPTOR BYTE
BPFTSEC DW	?			; NUMBER OF SECTORS TAKEN UP BY ONE FAT
BPBLOCK ENDS

A_BPB			STRUC
BPB_BYTESPERSECTOR	DW	?
BPB_SECTORSPERCLUSTER	DB	?
BPB_RESERVEDSECTORS	DW	?
BPB_NUMBEROFFATS	DB	?
BPB_ROOTENTRIES 	DW	?
BPB_TOTALSECTORS	DW	?
BPB_MEDIADESCRIPTOR	DB	?
BPB_SECTORSPERFAT	DW	?
BPB_SECTORSPERTRACK	DW	?
BPB_HEADS		DW	?
BPB_HIDDENSECTORS	DW	?
			DW	?
BPB_BIGTOTALSECTORS	DW	?
			DW	?
			DB	6 DUP(?)
A_BPB			ENDS
;									   ;
;	     C	A  V  E  A  T	  P  R	O  G  R  A  M  M  E  R		   ;
;----+----+----+----+----+----+----+----+----+----+----+----+----+----+----;
