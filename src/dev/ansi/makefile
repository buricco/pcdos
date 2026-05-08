# Copyright 2026 S. V. Nickolas.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the Software), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.

all:	ansi.sys

ansi.sys:	ansi.exe
	exe2bin ansi.exe ansi.sys

ansi.exe:	ansi.obj ioctl.obj ansiinit.obj parser.obj
	link ansi+ioctl+ansiinit+parser;

ansi.obj:	ansi.asm ansi.inc
	masm -t -Mx ansi ;

ioctl.obj:	ioctl.asm ansi.inc
	masm -t -Mx ioctl ;

ansiinit.obj:	ansiinit.asm ansi.inc ansivid.inc
	masm -t -Mx ansiinit ;

parser.obj:	parser.asm
	masm -t -Mx parser ;

