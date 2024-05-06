Starting point
==============

  This codebase was synched with neozeed's tree, which has been fully updated
  to 4.01 and contains some patches relative to that version.
  
Local modifications
===================

  The embedded copyright messages were removed to save space and because they
  would need a bit of reworking.  
  
  VDISK, XMAEM and XMA2EMS, which were redundant, and SELECT, which is next to
  useless in its current form, have been removed.  EMM386 is moved into the
  DEV folder with other device drivers.
  
Building
========

  Mount the source tree to D:\ or edit src/setenv.bat accordingly.
  Then from D:\SRC, run the following:

    setenv
    nmake

Note on boot disks
==================

  I have made this PC DOS, because "PC DOS" is not trademarked.  This of
  course means that the boot files are IBMBIO.COM and IBMDOS.COM, not IO.SYS
  and MSDOS.SYS.  The relevant tools are mutatis-mutandis.

Where do we go from here?
=========================

  That may partially depend on whether Microsoft and/or IBM releases anything
  further.  The goal here is to bring in as much of the MS-DOS 6.22 and PC DOS
  7.0 functionality as reasonable (possibly minus stuff that just introduces
  bloat, or that has lost its utility).
  
  Some enhancements over both are also on the wishlist/to-do list.
  
  A major reworking of FDISK is on the to-do list.
