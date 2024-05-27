/*
 * Copyright 2024 S. V. Nickolas.
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

/* Note: MSC 5.1 doesn't define __MSDOS__, you'll have to do that yourself */

#ifdef __MSDOS__
# define strcasecmp stricmp
# define strncasecmp strnicmp
# ifndef PATH_MAX
#  define PATH_MAX 80
# endif
#endif

#define LNBUFSIZ 256

FILE *skl, *msg, *out;
char utilnam[PATH_MAX], clasnam[PATH_MAX], linbuf[LNBUFSIZ], tag[6];

char smash (char x)
{
 if ((x<'a')||(x>'z')) return x;
 return (x-'a')+'A';
}

void getstr (char *util, unsigned id, char *label)
{
 int m;
 char clabel[PATH_MAX], cutil[PATH_MAX];
 
 strcpy(clabel, label);
 strcpy(cutil, util);
 
 sprintf (tag, "%04u ", id);
 
 if (!msg) return;
 fseek(msg, 0, SEEK_SET);
 m=0;
 while (1)
 {
  fgets(linbuf, LNBUFSIZ-2, msg);
  if (feof(msg)&&(!m))
  {
   fprintf (stderr, "Warning: Could not find message %s in category %s\n",
            id, cutil);
   return;
  }
  
/* Handle CRLF on not-MS-DOS */
#ifndef __MSDOS__
  {
   int l;
   
   l=strlen(linbuf);
   if (l>1)
   {
    if (!strcmp(&(linbuf[l-2]), "\r\n")) strcpy(&(linbuf[l-2]),"\n");
   }
  }
#endif
  
  switch (m)
  {
   case 0: /* Searching for the utility name. */
    if (strncasecmp(linbuf, cutil, strlen(cutil))) continue;
    if ((linbuf[strlen(cutil)]!=' ')&&(linbuf[strlen(cutil)]!='\t')) continue;
    m=1;
   case 1: /* Searching for first line. */
    if (!strncmp(linbuf, tag, 5))
    {
     m=2;
     fprintf (out, "%s DB %s", clabel, &(linbuf[12]));
    }
    continue;
   case 2:
    if ((*linbuf!=' ')&&(*linbuf!='\t'))
     return;
/* Handle CRLF on not-MS-DOS */
#ifndef __MSDOS__
    {
     int l;
   
     l=strlen(linbuf);
     if (l>1)
     {
      if (!strcmp(&(linbuf[l-2]), "\r\n")) strcpy(&(linbuf[l-2]),"\n");
     }
    }
#endif
    fprintf (out, "%s", linbuf);
  }
 }
}

int main (int argc, char **argv)
{
 char *p;
 int m;
 
 if (argc!=3)
 {
  fprintf (stderr, "usage: nosrvbld filename.skl filename.msg\n");
  return 1;
 }
 
 out=NULL;
 
 /* Default utilname */
#ifdef __MSDOS__
 p=strrchr(argv[1], '\\');
#else
 p=strrchr(argv[1], '/');
#endif
 if (p) p++; else p=argv[1];
 strcpy(utilnam, p);
 p=strchr(utilnam, '.');
 if (p) *p=0;
 for (p=utilnam; *p; p++) *p=smash(*p);
 
 skl=fopen(argv[1], "rt");
 if (!skl)
 {
  perror(argv[1]);
  return 1;
 }
 msg=fopen(argv[2], "rt");
 if (!msg)
 {
  perror(argv[2]);
  return 1;
 }
 while (1)
 {
  fgets (linbuf, LNBUFSIZ-2, skl);
  if (feof(skl)) break;
/* Handle CRLF on not-MS-DOS */
#ifndef __MSDOS__
  {
   int l;
   
   l=strlen(linbuf);
   if (l>1)
   {
    if (!strcmp(&(linbuf[l-2]), "\r\n")) strcpy(&(linbuf[l-2]),"\n");
   }
  }
#endif
  linbuf[strlen(linbuf)-1]=0;
  
  m=0;
  
  for (p=linbuf; *p; p++)
  {
   if (*p=='"') m=!m;
   if ((*p==';')&&(!m))
   {
    *p=0;
    p--;
   }
  }
  if (*linbuf!=':') continue;
  if (!strcasecmp(linbuf, ":end")) break;
  if (!strncasecmp(linbuf, ":util ", 6))
  {
   char *q;
   p=&(linbuf[6]);
   while ((*p==' ')||(*p=='\t')) p++;
   while (0!=(q=strchr(p, ' '))) *q=0;
   while (0!=(q=strchr(p, '\t'))) *q=0;
   strcpy(utilnam, p);
   for (p=utilnam; *p; p++) *p=smash(*p);
   printf ("Utility name is now: %s\n", utilnam);
   continue;
  }
  if (!strncasecmp(linbuf, ":class ", 7))
  {
   printf ("Writing class: %c\n", linbuf[7]);
   sprintf (clasnam, "%s.CL%c", utilnam, linbuf[7]);
   out=fopen(clasnam, "wt");
   if (!out)
   {
    perror(clasnam);
    return 1;
   }
  }
  if (!strncasecmp(linbuf, ":def ", 5))
  {
   char *q;
   unsigned x;
   
   p=&(linbuf[5]);
   while ((*p==' ')||(*p=='\t')) p++;
   x=0;
   while ((*p>='0')&&(*p<='9'))
   {
    x*=10;
    x+=(*p-'0');
    p++;
   }
   while ((*p==' ')||(*p=='\t')) p++;
   q=p;
   while (*q)
   {
    if ((*q!=' ')&&(*q!='\t'))
     q++;
    else
    {
     *(q++)=0;
     break;
    }
   }
   getstr(utilnam, x, p);
  }
  if (!strncasecmp(linbuf, ":use ", 5))
  {
   char *q;
   unsigned x;
   char n[LNBUFSIZ];
   
   p=&(linbuf[5]);
   while ((*p==' ')||(*p=='\t')) p++;
   x=0;
   while ((*p>='0')&&(*p<='9'))
   {
    x*=10;
    x+=(*p-'0');
    p++;
   }
   while ((*p==' ')||(*p=='\t')) p++;
   strcpy(n, p);
   p=strchr(n, ' ');
   if (!p) continue;
   *(p++)=0;
   getstr(n, x, p);
  }
 }
 
 fclose(skl);
 return 0;
}
