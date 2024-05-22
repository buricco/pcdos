;*--------------------------------------------------------------------------*
;*	DRIVER MESSAGES							    *
;*--------------------------------------------------------------------------*		 

SignOnMsg   db	13,10,'HIMEM: Controlador XMS para DOS, Versi¢n 2.04 - 8/17/88'
	    db	13,10,'Copyright 1988, Microsoft Corp.'
	    db	13,10,'$'

BadDOSMsg   db	13,10,'ERROR: HIMEM.SYS requiere DOS 3.00 o mayor.$'
NowInMsg    db	13,10,'ERROR: Un administrador de memoria ampliada ya est  instalado.$'
On8086Msg   db	13,10,'ERROR: HIMEM.SYS requiere un ordenador basado en un 80x86.$'
NoExtMemMsg db	13,10,'ERROR: No se encontr¢ memoria ampliada disponible.$'
BadA20Msg   db	13,10,'ERROR: No se reconoce el hardware A20.$'
FlushMsg    db	13,10,'	      El controlador XMS no est  instalado.',13,10,13,10,'$'

StartMsg    db	13,10,'$'
HandlesMsg  db	' manejos de memoria ampliada est n disponibles.$'
HMAMINMsg   db	13,10,'El tama¤o m¡nimo del HMA est  asignado a $'
KMsg	    db	'K.$'

NoHMAMsg    db	13,10,'AVISO: El  rea de memoria alta no est  disponible.',13,10,'$'
A20OnMsg    db	13,10,'AVISO: La l¡nea A20 ya est  activada.',13,10,'$'

HMAOKMsg    db	13,10,'Area de memoria alta de 64K est  disponible.',13,10,13,10,'$'

	    db	'This program is the property of Microsoft Corporation.'
	    
	    db	64 dup(0)			; For internationalization
