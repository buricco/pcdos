;*--------------------------------------------------------------------------*
;*	DRIVER MESSAGES							    *
;*--------------------------------------------------------------------------*		 

SignOnMsg   db	13,10,'HIMEM: DOS XMS Driver, Version 2.04 - 8/17/88'
	    db	13,10,'Copyright 1988, Microsoft Corp.'
	    db	13,10,'$'

BadDOSMsg   db	13,10,'ERROR: HIMEM.SYS requires DOS 3.00 or higher.$'
NowInMsg    db	13,10,'ERROR: An Extended Memory Manager is already installed.$'
On8086Msg   db	13,10,'ERROR: HIMEM.SYS requires an 80x86-based machine.$'
NoExtMemMsg db	13,10,'ERROR: No available extended memory was found.$'
BadA20Msg   db	13,10,'ERROR: Unrecognized A20 hardware.$'
FlushMsg    db	13,10,'	      XMS Driver not installed.',13,10,13,10,'$'

StartMsg    db	13,10,'$'
HandlesMsg  db	' extended memory handles available.$'
HMAMINMsg   db	13,10,'Minimum HMA size set to $'
KMsg	    db	'K.$'

NoHMAMsg    db	13,10,'WARNING: The High Memory Area is unavailable.',13,10,'$'
A20OnMsg    db	13,10,'WARNING: The A20 Line was already enabled.',13,10,'$'

HMAOKMsg    db	13,10,'64K High Memory Area is available.',13,10,13,10,'$'

	    db	'This program is the property of Microsoft Corporation.'
	    
	    db	64 dup(0)			; For internationalization

