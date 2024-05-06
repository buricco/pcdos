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

;	SCCSID = @(#)bugtyp.asm	1.1 85/04/09
;
; debugging types and levels for MSDOS
;

TypAccess   EQU     0001h
    LevSFN	EQU	0000h
    LevBUSY	EQU	0001h

TypShare    EQU     0002h
    LevShEntry	EQU	0000h
    LevMFTSrch	EQU	0001h

TypSect     EQU     0004h
    LevEnter	EQU	0000h
    LevLeave	EQU	0001h
    LevReq	EQU	0002h

TypSMB	    EQU     0008h
    LevSMBin	EQU	0000h
    LevSMBout	EQU	0001h
    LevParm	EQU	0002h
    LevASCIZ	EQU	0003h
    LevSDB	EQU	0004h
    LevVarlen	EQU	0005h

TypNCB	    EQU     0010h
    LevNCBin	EQU	0000h
    LevNCBout	EQU	0001h

TypSeg	    EQU     0020h
    LevAll	EQU	0000h

TypSyscall  EQU     0040h
    LevLog	EQU	0000h
    LevArgs	EQU	0001h

TypInt24    EQU     0080h
    LevLog	EQU	0000h

TypProlog   EQU     0100h
    LevLog	EQU	0000h

TypInt	    EQU     0200h
    LevLog	equ	0000h

typFCB	    equ     0400h
    LevLog	equ	0000h
    LevCheck	equ	0001h
