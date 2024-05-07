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

BREAK	MACRO	subtitle
	SUBTTL	subtitle
	PAGE
ENDM


;
;******************************************************************************
; Message Macro Definitions
;******************************************************************************
;

      EXTRN Display_Interface:near


;-----------------------------------------------------------------------------

Message macro	Message_Name			;				;AN000;
						;
	mov	dx,offset dg:Message_Name	;				;AN000;
	call	Display_Interface		;				;AN000;
						;
	endm					;				;AN000;

;-----------------------------------------------------------------------------

Parse_Message macro				;				;AN000;

						;
	push	ds
	mov	dx,dg
	mov	ds,dx
	mov	word ptr Parse_Error_Msg,ax	;				;AN000;
	mov	dx,offset dg:Parse_Error_Msg	;				;AN000;
	call	Display_Interface		;				;AN000;
	pop	ds				;
	endm					;				;AN000;

;-----------------------------------------------------------------------------

Extended_Message macro				;				;AN000;
						;

	push	ds
	mov	dx,dg
	mov	ds,dx
	mov	word ptr Extended_Error_Msg,ax	  ;				  ;AN000;
	mov	dx,offset dg:Extended_Error_Msg    ;				   ;AN000;
	call	Display_Interface		;				;AN000;
	pop	ds
	endm					;				;AN000;
;
;*****************************************************************************
; General Macro's
;*****************************************************************************
;

Procedure	macro	Proc_Name,Seg_Name	;				;AN000;
						;
Public	Proc_Name				;				;AN000;
Proc_Name    proc				;				;AN000;

	endm					;				;AN000;
;-----------------------------------------------------------------------------

DOS_Call	macro	Function		;				;AN000;
						;
	mov	ah,Function			;				;AN000;
	int	21h				;				;AN000;
						;
	endm					;				;AN000;

;-----------------------------------------------------------------------------

Popff	macro

Assume	cs:DG

	jmp	$+3
	iret
	push	cs
	call	$-2

Assume	cs:code

	endm

;-----------------------------------------------------------------------------

Set_Data_Segment     macro

	push	ax
	mov	ax,dg				;Point to data segment
	mov	ds,ax				;
	push	ds
	pop	es
	pop	ax

	.LALL
	assume	ds:dg,es:dg
	.XALL
	endm

