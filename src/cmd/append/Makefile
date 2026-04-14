SRCPATH = ../..

append.exe:	append.obj messages.obj
	link append+messages,append;

append.obj:	append.asm sysmac.inc
	masm -t -I$(SRCPATH)/inc -I$(SRCPATH)/dos append;

messages.obj:	messages.asm
	masm -t -I$(SRCPATH)/inc -I$(SRCPATH)/dos messages;
