himem.sys: himem.exe
    exe2bin himem.exe himem.sys

himem.exe: himem.obj
    link himem;

himem.obj: himem.asm xm286.asm xm386.asm
    masm -I. himem;

