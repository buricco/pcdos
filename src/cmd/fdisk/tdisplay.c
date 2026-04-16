/*
 * Copyright 1983-1988 International Business Machines Corp.
 * Copyright 1986-1988 Microsoft Corp.
 * Copyright 2026 S. V. Nickolas.
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

#include <memory.h>
#include <stdio.h>
#include <string.h>
#include "dos.h"
#include "fdisk.h"
#include "fdiskmsg.h"
#include "subtype.h"
#include "extern.h"

char table_display (void)
{
 unsigned int   i, x, io;
 char          *ThisPartitionType;
 char           ThisPartitionLetter[3];
 FLAG           partition_found;
 char           partition_num;
 
 /* Initialize all the inserts to blanks. */
 memset (insert, ' ', 4*21);
 io = 0;
 
 /* Sort the partitions. */
 sort_part_table(4);
 
 /* Loop through the partitions; only print stuff if it is there */
 partition_found=FALSE;
 partition_num=0;
 for (i=0; i<4; i++)
 {
  char ltr;
  if (part_table[cur_disk][sort[i]].sys_id)
  {
   partition_found=TRUE;
   strcpy (ThisPartitionLetter, "  ");
   switch (part_table[cur_disk][sort[i]].sys_id)
   {
    case DOSNEW:
    case DOS16:
    case DOS12:
     ThisPartitionType=DOS_part;
     part_table[cur_disk][sort[i]].drive_letter=ltr=table_drive_letter();
     sprintf (ThisPartitionLetter, "%c%c", ltr, (ltr==' ')?' ':':');
     break;
    case EXTENDED:
     ThisPartitionType=EXTENDED_part;
     break;
    case BAD_BLOCK:
     ThisPartitionType=BAD_BLOCK_part;
     break;
    case XENIX1:
    case XENIX2:
     ThisPartitionType=XENIX_part;
     break;
    case PCIX:
     ThisPartitionType=PCIX_part;
     break;
    default:
     ThisPartitionType=NON_DOS_part;
     break;
   }
   io+=sprintf(&(insert[io]), "%-2.2s%c%c%-7.7s%4.0d%3.0d%%",
               ThisPartitionLetter, partition_num+'1',
               (part_table[cur_disk][sort[i]].boot_ind == 0x80)?'A':' ',
               ThisPartitionType,
               part_table[cur_disk][sort[i]].mbytes_used,
               part_table[cur_disk][sort[i]].percent_used);
  }
 }
 
 /* Do a clear screen to erase previous data. */
 clear_screen(8, 0, 12, 79);
 
 display (partition_found?menu_14:status_8);
 
 /* Return true if partitions exist, false otherwise. */
 return (partition_found?TRUE:FALSE);
}

char table_drive_letter (void)
{
 char drive_letter;
 
 /* Put in drive letter in display. */
 if (!cur_disk) /* There is primary partition on 0x80, so drive C: */
  drive_letter='C';
 else
 {
  /* We are on drive 0x81, so assume D: */
  drive_letter='D';
  /* See if primary exists on drive 0x80 */
  cur_disk=0;
  if (!((find_partition_type(DOS12))||(find_partition_type(DOS16))
      ||(find_partition_type(DOSNEW))))
   drive_letter='C';
  
  /* Restore cur_disk to normal */
  cur_disk=1;
 }
 
 return drive_letter;
}
