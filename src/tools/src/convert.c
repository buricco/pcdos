/*
 * Copyright 2022, 2024 S. V. Nickolas.
 * Portions copyright 1984 Microsoft Corp.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the Software), to
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

#include <stdio.h>
#include <string.h>

/*
 * Method:
 * 
 * 1. Patch the word at head[1] and head[2] to the filesize plus 21.
 * 2. Concatenate head, the meat of the file, and tail.
 * 
 * Obviously this will require that the source EXE will be no larger than
 * 65141 / 0xFE75 (I believe) bytes.
 */

unsigned char head[16]={
 0xE9, 0x00, 0x00, 0x43, 0x6F, 0x6E, 0x76, 0x65,
 0x72, 0x74, 0x65, 0x64, 0x00, 0x00, 0x00, 0x00
};

unsigned char tail[123]={
 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xE8, 0x00, 0x00, 0x5B, 0x50, 
 0x8C, 0xC0, 0x05, 0x10, 0x00, 0x8B, 0x0E, 0x1E, 0x01, 0x03, 0xC8, 0x89, 0x4F, 
 0xFB, 0x8B, 0x0E, 0x26, 0x01, 0x03, 0xC8, 0x89, 0x4F, 0xF7, 0x8B, 0x0E, 0x20, 
 0x01, 0x89, 0x4F, 0xF9, 0x8B, 0x0E, 0x24, 0x01, 0x89, 0x4F, 0xF5, 0x8B, 0x3E, 
 0x28, 0x01, 0x8B, 0x16, 0x18, 0x01, 0xB1, 0x04, 0xD3, 0xE2, 0x8B, 0x0E, 0x16, 
 0x01, 0xE3, 0x1A, 0x26, 0xC5, 0xB5, 0x10, 0x01, 0x83, 0xC7, 0x04, 0x8C, 0xDD, 
 0x26, 0x03, 0x2E, 0x18, 0x01, 0x83, 0xC5, 0x01, 0x03, 0xE8, 0x8E, 0xDD, 0x01, 
 0x04, 0xE2, 0xE6, 0x0E, 0x1F, 0xBF, 0x00, 0x01, 0x8B, 0xF2, 0x81, 0xC6, 0x10, 
 0x01, 0x8B, 0xCB, 0x2B, 0xCE, 0xF3, 0xA4, 0x58, 0xFA, 0x8E, 0x57, 0xFB, 0x8B, 
 0x67, 0xF9, 0xFB, 0xFF, 0x6F, 0xF5
};

int main (int argc, char **argv)
{
 FILE *in, *out;
 
 char *p;
 char fnout[128];
 unsigned char b1, b2;
 
 unsigned long l, b, e;
 int c;
 
 if ((argc<2)||(argc>3))
 {
  fprintf (stderr, "usage: convert filename.exe\n");
  return 1;
 }
 
 if (argc==2)
 {
  strcpy(fnout, argv[1]);
  p=strrchr(fnout, '.');
  if (p) strcpy(p, ".com"); else strcat(fnout, ".com");
 }
 else
  strcpy(fnout, argv[2]);

 in=fopen(argv[1],"rb");
 if (!in)
 {
  perror(argv[1]);
  return 2;
 }
 
 fseek(in,0,SEEK_END);
 l=ftell(in);
 fseek(in,0,SEEK_SET);
 if (l>65141)
 {
  fclose(in);
  fprintf (stderr, "File %s is too large to convert\n", argv[1]);
  return 3;
 }

 out=fopen(fnout,"wb");
 if (!out)
 {
  perror(fnout);
  return 4;
 }
 
 b1=(l+21)&0xFF;
 b2=((l+21)>>8)&0xFF;
 head[1]=b1;
 head[2]=b2;
 e=fwrite(head,1,16,out);
 if (e<16)
 {
  fclose(in);
  fclose(out);
  fprintf (stderr, "Short write when writing header\n");
  perror(fnout);
  return 5;
 }
 
 for (b=0; b<l; b++)
 {
  c=fgetc(in);
  if (c<0)
  {
   fclose(in);
   fclose(out);
   fprintf (stderr, "Short read when copying program\n");
   perror(fnout);
   return 6;
  }
  if (fputc(c, out)<0)
  {
   fclose(in);
   fclose(out);
   fprintf (stderr, "Short write when copying program\n");
   perror(fnout);
   return 6;
  }
 }
 fclose(in);
 
 e=fwrite(tail,1,123,out);
 fclose(out);
 if (e<123)
 {
  fprintf (stderr, "Short write when writing footer\n");
  perror(fnout);
  return 7;
 }
 return 0;
}
