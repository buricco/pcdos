/*
 * Copyright 2022, 2024 S. V. Nickolas.
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
 * THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

/*
 * Do not build this in a FAR model without compensating for pointer casts to
 * unsigned short (use int86x and FP_SEG/FP_OFF instead ... uh, does MSC5 do
 * those?).
 */

#include <dos.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*
 * The parser converts the command line into a path to operate on (arg; may
 * contain wildcards), a flag stating whether to recurse into subdirectories
 * (mode&MODE_S), and two flags stating what modes we want to set or unset
 * (maskon, maskoff).
 * 
 * If maskon=0x00 and maskoff=0xFF, then instead of setting attributes, we
 * want to display them.
 */

unsigned char arg[80];
unsigned char maskon, maskoff;
unsigned char gotarg;

#define MODE_S 0x01
unsigned char mode;

union REGS regs;

/*
 * MS-DOS file attributes.
 * We don't use them all, but define them anyway.
 */
#define ATTR_READONLY  0x01
#define ATTR_SYSTEM    0x02
#define ATTR_HIDDEN    0x04
#define ATTR_LABEL     0x08
#define ATTR_DIRECTORY 0x10
#define ATTR_ARCHIVE   0x20

/* Error code returned from MS-DOS. */
int dos_errno;

unsigned char flags;

#include "messages.h"

/*
 * Struct used by FINDFIRST and FINDNEXT.
 * The definition of reserved[] is irrelevant and varies from version to
 * version according to RBIL so never mind, we're only using fnam anyway.
 */
struct dos_ffblk
{
 unsigned char reserved[21];
 unsigned char attr;
 unsigned long mtime;
 unsigned long size;
 unsigned char fnam[13];
};

/* Dependency of dos_puts */
int dos_write (int handle, const void *buf, int len)
{
 int r;
 
 regs.h.ah=0x40;
 regs.x.bx=handle;
 regs.x.cx=len;
 regs.x.dx=(unsigned short) buf;
 int86(0x21, &regs, &regs);
 if (regs.x.cflag)
 {
  dos_errno=regs.x.ax;
  return 0;
 }
 dos_errno=0;
 r=regs.x.ax;
 return r;
}

/*
 * The official ATTRIB (this is white code) checks for and temporarily kills
 * APPEND while running.  (I personally think APPEND is daft and has no place
 * in DOS at all, but we have to take this precaution, esp. with APPEND /X.)
 */
static unsigned short gotappend, isappend;

void unappend (void)
{
 regs.x.ax=0xB700;
 int86(0x21, &regs, &regs);
 isappend=regs.h.al;
 
 if (isappend)
 {
  regs.x.ax=0xB706;
  int86(0x21, &regs, &regs);
  gotappend=regs.x.bx;
  regs.x.ax=0xB707;
  regs.x.bx &= 0x7FFF;        /* official way to temporarily kill APPEND */
  int86(0x21, &regs, &regs);
 }
}

void reappend (void)
{
 if (isappend)
 {
  regs.x.ax=0xB707;
  regs.x.bx=gotappend;
  int86(0x21, &regs, &regs);
 }
}

int dos_getattr (const char *filename)
{
 int r;
 
 regs.x.ax=0x4300;
 regs.x.dx=(unsigned short) filename;
 int86(0x21, &regs, &regs);
 if (regs.x.cflag)
 {
  dos_errno=regs.x.ax;
  return 0;
 }
 dos_errno=0;
 r=regs.x.cx;
 return r;
}

int dos_setattr (const char *filename, int attr)
{
 regs.x.ax=0x4301;
 regs.x.cx=attr;
 regs.x.dx=(unsigned short) filename;
 int86(0x21, &regs, &regs);
 if (regs.x.cflag)
 {
  dos_errno=regs.x.ax;
  return -1;
 }
 dos_errno=0;
 return 0;
}

int dos_findfirst (const char *mask, int attr, struct dos_ffblk *f)
{
 regs.h.ah=0x1A; /* SETDTA */
 regs.x.dx=(unsigned short) f;
 int86(0x21, &regs, &regs);
 regs.h.ah=0x4E;
 regs.x.cx=attr;
 regs.x.dx=(unsigned short) mask;
 int86(0x21, &regs, &regs);
 if (regs.x.cflag)
 {
  dos_errno=regs.x.ax;
  return 0;
 }
 dos_errno=0;
 return 1;
}

int dos_findnext (struct dos_ffblk *f)
{
 regs.h.ah=0x1A; /* SETDTA */
 regs.x.dx=(unsigned short) f;
 int86(0x21, &regs, &regs);
 regs.h.ah=0x4F;
 int86(0x21, &regs, &regs);
 if (regs.x.cflag)
 {
  dos_errno=regs.x.ax;
  return 0;
 }
 dos_errno=0;
 return 1;
}

/*
 * Functions for console I/O, so we do not need to bring in big ugly printf().
 * (It makes the code a little uglier, but makes the binary significantly
 *  lighter, which may make the difference on a resource-constrained MS-DOS 
 *  machine.)
 */
void dos_putc (char c)
{
 regs.h.ah=0x02;
 regs.h.dl=c;
 int86(0x21, &regs, &regs);
}

void dos_puts (const char *s)
{
 dos_write(1, s, strlen(s));
}

/* Case smash input. */
char smash (char x)
{
 if ((x<'a')||(x>'z')) return x;
 return x&0x5F;
}

/* Generic error printer. (Call as soon as possible after the error.) */
void wrerr (void)
{
 int p;
 
 for (p=0; errtab[p].err; p++)
 {
  if (errtab[p].err==dos_errno) break;
 }
 dos_puts(errtab[p].msg);
 dos_puts(m_crlf);
}

int getswitch (char a)
{
 switch (a)
 {
  case 'S':
   mode|=MODE_S;
   return 0;
  default:
   dos_puts(m_switch);
   dos_putc(a);
   dos_puts(m_crlf);
   return -1;
 }
}

int getmode (char *x)
{
 int plusminus;
 
 plusminus=-1;
 
 while (*x)
 {
  unsigned char mask;
  
  switch (smash(*x))
  {
   case '+':
    plusminus=1;
    break;
   case '-':
    plusminus=0;
    break;
   case 'R':
    if (plusminus==-1)
    {
     dos_puts(m_synerr);
     return -1;
    }
    if (plusminus) maskon|=ATTR_READONLY; else maskoff&=~ATTR_READONLY;
    break;
   case 'A':
    if (plusminus==-1)
    {
     dos_puts(m_synerr);
     return -1;
    }
    if (plusminus) maskon|=ATTR_ARCHIVE; else maskoff&=~ATTR_ARCHIVE;
    break;
   case 'S':
    if (plusminus==-1)
    {
     dos_puts(m_synerr);
     return -1;
    }
    if (plusminus) maskon|=ATTR_SYSTEM; else maskoff&=~ATTR_SYSTEM;
    break;
   case 'H':
    if (plusminus==-1)
    {
     dos_puts(m_synerr);
     return -1;
    }
    if (plusminus) maskon|=ATTR_HIDDEN; else maskoff&=~ATTR_HIDDEN;
    break;
   default:
    dos_puts(m_synerr);
    return -1;
  }
  x++;
 }
 
 return 0;
}

void process (char *filename, int a)
{
 int e;
 
 /*
  * If no attributes were specified, show them.
  * Otherwise, turn them on and off as requested.
  * 
  * The MS-DOS version will refuse to set certain attribute combinations
  * without setting others; I believe this is a braindead choice, and prefer
  * to assume the user knows what he's doing.
  */
 if ((!maskon)&&(maskoff==0xFF))
 {
  dos_puts(m_space);
  dos_putc((a&ATTR_ARCHIVE)?'A':' ');
  dos_puts(m_space);
  dos_putc((a&ATTR_SYSTEM)?'S':' ');
  dos_putc((a&ATTR_HIDDEN)?'H':' ');
  dos_putc((a&ATTR_READONLY)?'R':' ');
  dos_puts("     ");
  dos_puts(filename);
  dos_puts(m_crlf);
 }
 else
 {
  a|=maskon;
  a&=maskoff;
  if (dos_setattr(filename,a))
  {
   e=dos_errno;
   dos_puts(filename);
   dos_puts(" - ");
   dos_errno=e;
   wrerr();
  }
 }
}

/*
 * The gories.
 * 
 * Since we recurse, we need to be able to pass a filename, but the other
 * arguments are set at parse time and will not change during execution.
 */
int attrib (char *of)
{
 int e, t;
 char *p;
 char *dirname, *filename, *recurse;
 int searchmask;
 struct dos_ffblk *ffblk;
 
 /*
  * If some sort of mask is being used, and it does not involve hidden or
  * system files, do not look for them.
  * 
  * But if we are displaying attributes, look for them, and show all the files
  * we find.
  */
 searchmask=ATTR_HIDDEN|ATTR_SYSTEM;
 if ((!(maskon&searchmask))&&((maskoff&searchmask)==searchmask)) searchmask=0;
 if ((!maskon)&&(maskoff==0xFF))
  searchmask=ATTR_HIDDEN|ATTR_SYSTEM;

 /*
  * Allocate enough memory to hold variables specific to this instance, that
  * might otherwise get trashed if we did not watch out for reentrancy.
  */
 ffblk=malloc(sizeof(struct dos_ffblk));
 if (!ffblk)
 {
  dos_puts(m_ram);
  return 1;
 }
 
 dirname=malloc(80);
 if (!dirname)
 {
  free(ffblk);
  dos_puts(m_ram);
  return 1;
 }
 
 filename=malloc(80);
 if (!filename)
 {
  free(dirname);
  free(ffblk);
  dos_puts(m_ram);
  return 1;
 }
 
 recurse=malloc(80);
 if (!recurse)
 {
  free(filename);
  free(dirname);
  free(ffblk);
  dos_puts(m_ram);
  return 1;
 }
 
 /*
  * Get the dirname, and tack a \ on the end if need be.
  * If it's just a drive letter, we don't want the trailing \ unless it was
  * specifically asked for (A: and A:\ are two different things in MS-DOS).
  */
 p=strrchr(of, '\\');
 if (p)
 {
  strcpy(dirname, of);
  (strrchr(dirname, '\\'))[1]=0;
  p++;
 }
 else
 {
  if (of[1]==':')
  {
   dirname[0]=of[0];
   dirname[1]=':';
   dirname[2]=0;
   p=of+2;
  }
  else
  {
   dirname[0]='.';
   dirname[1]='\\';
   dirname[2]=0;
   p=of;
  }
 }

 /*
  * Handle the easier case first.
  * (No wildcards)
  */
 if (!(strchr(of, '?')||strchr(of, '*')))
 {
  int a;
  
  a=dos_getattr(of);
  if (!dos_errno)
   process(of, a);
 }
 else
 {
  /*
   * Find all files on which we might want to operate.
   * (See above for how we figure this out.)
   */
  t=dos_findfirst(of,searchmask,ffblk);
  if (!t)
  {
   e=dos_errno;
   dos_puts(of);
   dos_puts(" - ");
   if (e==0x12)
    dos_puts(m_nofiles);
   else
   {
    dos_errno=e;
    wrerr();
   }
  }
 
  /* Iterate over all matching files. */
  while (t)
  {
   unsigned a;
  
   strcpy(filename, dirname);
   strcat(filename, ffblk->fnam);
   a=ffblk->attr;

   process (filename, a);
  
   t=dos_findnext(ffblk);
  }
 }

 /*
  * AFTERWARD, if the user wants us to recurse into folders, do that.
  * Keep in mind that FINDFIRST/FINDNEXT will also find the "." and ".."
  * folders, and we do NOT want to recurse into those!
  */
 if (mode&MODE_S)
 {
  strcpy(recurse, dirname);
  strcat(recurse, "*.*");
  t=dos_findfirst(recurse,ATTR_DIRECTORY,ffblk);
  while (t)
  {
   if (*(ffblk->fnam)!='.')
   {
    if (ffblk->attr&ATTR_DIRECTORY)
    {
     int e;
     
     strcpy(recurse, dirname);
     strcat(recurse, ffblk->fnam);
     strcat(recurse, "\\");
     strcat(recurse, p);
     attrib(recurse);
    }
   }
   t=dos_findnext(ffblk);
  }
 }
 
 /*
  * Free our dynamic allocations and beat a retreat.
  */
 free(recurse);
 free(filename);
 free(dirname);
 free(ffblk);
 
 return 0;
}

int main (int argc, char **argv)
{
 int t;

 maskon=0x00;
 maskoff=0xFF;
 memset(arg,0,80);
 gotarg=0;
 
 strcpy(arg, "*.*");
 
 for (t=1; t<argc; t++)
 {
  char *ptr;
  
  ptr=strchr(argv[t], '/');
  if (ptr)
  {
   *ptr=0;
   ptr++;
   if (getswitch(smash(*ptr))) return 1;
   ptr++;
   if (!*ptr) continue;
   while (*ptr)
   {
    if (*ptr!='/')
    {
     dos_puts(m_synerr);
     return 1;
    }
    ptr++;
    if (getswitch(smash(*ptr))) return 1;
    ptr++;
   }
  }
  
  /* If the beginning of the argument was /, it is now a NUL terminator. */
  if (!*argv[t]) continue;
  
  if ((*argv[t]=='+')||(*argv[t]=='-'))
  {
   if (getmode(argv[t])) return 1;
   continue;
  }
  
  /* Already got an argument. Die screaming. */
  if (gotarg)
  {
   dos_puts(m_args);
   return 1;
  }
  
  /* Mark argument "got" and save it. */
  gotarg=1;
  strcpy(arg, argv[t]);
 }
 
 unappend();
 t=attrib(arg);
 reappend();
 return t;
}
