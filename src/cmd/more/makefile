all:	more.com

more.obj:	more.asm
    masm -t -Mx more.asm;

more.com:	more.obj
    link more.obj,more.exe;
    exe2bin more.exe more.com
    del more.exe
