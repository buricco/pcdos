; Copyright 1985-1988 Microsoft Corp.
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

	TITLE	MESSAGE MODULE FOR RAMDRIVE.ASM
;
;   WRITTEN BY S. P. 3/3/87
;
PAGE	58,132

BREAK	MACRO	subtitle
	SUBTTL	subtitle
	PAGE
ENDM

BREAK <messages and common data>

RAMCODE	SEGMENT
ASSUME	CS:RAMCODE,DS:RAMCODE,ES:NOTHING,SS:NOTHING

;**	Message texts and common data
;
;	Init data. This data is disposed of after initialization.
;	it is mostly texts of all of the messages
;
;	COMMON to TYPE 1,2,3 and 4 drivers
;
; THIS IS THE START OF DATA SUBJECT TO TRANSLATION

	PUBLIC	NO_ABOVE,BAD_ABOVE,BAD_AT,NO_MEM,ERRMSG1,ERRMSG2
	PUBLIC	ERRMSG2,INIT_IO_ERR,BADVERMES
	PUBLIC	HEADERMES,PATCH2X,DOS_DRV
	PUBLIC	STATMES1,STATMES2,STATMES3,STATMES4,STATMES4,STATMES5

NO_ABOVE db	"RAMDrive: Gestor de Memoria Expandida no se encuentra",13,10,"$"
BAD_ABOVE db	"RAMDrive: Estado de Memoria Expandida muestra error",13,10,"$"
BAD_AT	db	"RAMDrive: Ordenador debe ser PC-AT, o compatible con PC-AT",13,10,"$"
NO_MEM	db	"RAMDrive: No hay memoria extendida disponible",13,10,"$"
ERRMSG1 db	"RAMDrive: Par metro no v lido",13,10,"$"
ERRMSG2 db	"RAMDrive: Memoria insuficiente",13,10,"$"
INIT_IO_ERR db	"RAMDrive: Error de E/S al acceder memoria de la unidad",13,10,"$"
BADVERMES db	13,10,"RAMDrive: Versi¢n incorrecta de DOS",13,10,"$"

;
; This is the Ramdrive header message. THE MESSAGE IS DYNAMICALLY
;   PATCHED AT RUNTIME. The DOS drive letter of the RAMDRIVE
;   is patched in at DOS_DRV for DOS versions >= 3.00. For
;   DOS versions < 3.00 the three bytes  13,10,"$" are placed
;   at the label PATCH2X eliminating the drive specifier since
;   this information cannot be determined on 2.X DOS.
;   NO PART OF THIS MESSAGE WHICH MUST BE PRINTED ON ALL VERSIONS
;   OF DOS CAN BE PLACED AFTER THE LABEL PATCH2X. This may cause
;   translation problems for some languages, if this is so
;   the only solution is to eliminate the drive letter part of
;   the message totally for ALL DOS versions:
;
;	HEADERMES db	13,10,"Microsoft RAMDrive version 1.17 "
;	PATCH2X   db	13,10,"$"
;	DOS_DRV   db	"A"
;
;
HEADERMES db	13,10,"RAMDrive de Microsoft versi¢n 2.12 "
PATCH2X   db	"disco virtual "
DOS_DRV   db	"A"
	  db	":",13,10,"$"

;
; This is the status message used to display RAMDRIVE configuration
;  it is:
;
;    STATMES1<size in K>STATMES2<Sector size in bytes>STATMES3
;    <sectors per alloc unit>STATMES4<Number of root dir entries>
;    STATMES5
;
; It is up to translator to move the message text around the numbers
; so that the message is printed correctly when translated
;
STATMES1  db	"    Tama¤o disco: $"
STATMES2  db	"kb",13,10,"   Tama¤o sector: $"
STATMES3  db	" bytes",13,10,"    Unidad asignada: $"
STATMES4  db	" sectores",13,10,"  Entradas/directorio: $"
STATMES5  db	13,10,"$"


RAMCODE ENDS
	END
