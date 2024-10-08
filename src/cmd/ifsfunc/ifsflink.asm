	PAGE	,132				; 
;	SCCSID = @(#)ifsflink.asm 1.0 87/05/11
TITLE	IFSFUNC LINK FIX ROUTINES - Routines to resolve ifsfunc externals
NAME	IFSFLINK

.xlist
.xcref
INCLUDE dossym.inc
INCLUDE devsym.inc
.cref
.list

CODE	SEGMENT BYTE PUBLIC 'CODE'
code	ENDS

include dosseg.asm

code	SEGMENT BYTE PUBLIC 'code'
	ASSUME	CS:dosgroup

	procedure OUTT,FAR
	entry	$DUP
	entry	MSG_RETRIEVAL
	entry	$ECS_CALL
	entry	$EXTENDED_OPEN
	entry	FASTINIT
	entry	$IFS_IOCTL
	entry	IFS_DOSCALL
	entry	$QUERY_DOS_VALUE
	entry	$STD_AUX_INPUT,FAR
	entry	LCRITDEVICE,FAR
	entry	$ABORT,FAR
	entry	$SET_TIME,FAR
	entry	$ALLOC,FAR
	entry	SETMEM,FAR
	entry	SKIPONE,FAR
	entry	$SET_DMA,FAR
	entry	$PARSE_FILE_DESCRIPTOR,FAR
	entry	$CREATETEMPFILE,FAR
	entry	$SLEAZEFUNCDL,FAR
	entry	$CHDIR,FAR
	entry	TWOESC,FAR
	entry	$GET_INTERRUPT_VECTOR,FAR
	entry	$FCB_SEQ_WRITE,FAR
	entry	DEVNAME,FAR
	entry	$GET_DEFAULT_DRIVE,FAR
	entry	$STD_CON_STRING_INPUT,FAR
	entry	$CLOSE,FAR
	entry	$RAW_CON_IO,FAR
	entry	$INTERNATIONAL,FAR
	entry	IDLE,FAR
	entry	$STD_CON_INPUT_NO_ECHO,FAR
	entry	$ASSIGNOPER,FAR
	entry	$LOCKOPER,FAR
	entry	$FCB_CLOSE,FAR
	entry	$STD_CON_STRING_OUTPUT,FAR
	entry	$DUP_PDB,FAR
	entry	GETCH,FAR
	entry	STRLEN,FAR
	entry	INITCDS,FAR
	entry	COPYONE,FAR
	entry	PJFNFROMHANDLE,FAR
	entry	$GET_VERIFY_ON_WRITE,FAR
	entry	$KEEP_PROCESS,FAR
	entry	STRCMP,FAR
	entry	$SET_INTERRUPT_VECTOR,FAR
	entry	$FCB_DELETE,FAR
	entry	$RAW_CON_INPUT,FAR
	entry	$RENAME,FAR
	entry	$FIND_FIRST,FAR
	entry	$FCB_RANDOM_WRITE,FAR
	entry	$SET_DEFAULT_DRIVE,FAR
	entry	$SETDPB,FAR
	entry	$STD_PRINTER_OUTPUT,FAR
	entry	$MKDIR,FAR
	entry	$DUP2,FAR
	entry	SET_SFT_MODE,FAR
	entry	$GET_DATE,FAR
	entry	$FCB_RENAME,FAR
	entry	$CREATE_PROCESS_DATA_BLOCK,FAR
	entry	$CREAT,FAR
	entry	ECRITDISK,FAR
	entry	PLACEBUF,FAR
	entry	$IOCTL,FAR
	entry	$READ,FAR
	entry	PATHCHRCMP,FAR
	entry	$GET_VERSION,FAR
	entry	COPYLIN,FAR
	entry	LCRITDISK,FAR
	entry	$LSEEK,FAR
	entry	STRCPY,FAR
	entry	$FILE_TIMES,FAR
	entry	BACKSP,FAR
	entry	$SET_VERIFY_ON_WRITE,FAR
	entry	SETYEAR,FAR
	entry	FASTRET,FAR
	entry	$RMDIR,FAR
	entry	DIVOV,FAR
	entry	$GET_FCB_POSITION,FAR
	entry	$DISK_RESET,FAR
	entry	$DIR_SEARCH_FIRST,FAR
	entry	$WAIT,FAR
	entry	FASTOPENCOM,FAR
	entry	STAY_RESIDENT,FAR
	entry	$ALLOCOPER,FAR
	entry	$GET_DEFAULT_DPB,FAR
	entry	DSTRLEN,FAR
	entry	CTRLZ,FAR
	entry	$USEROPER,FAR
	entry	$SET_DATE,FAR
	entry	$FCB_RANDOM_WRITE_BLOCK,FAR
	entry	EXITINS,FAR
	entry	$GET_IN_VARS,FAR
	entry	GETDEVLIST,FAR
	entry	DATE16,FAR
	entry	POINTCOMP,FAR
	entry	SFFROMSFN,FAR
	entry	SKIPSTR,FAR
	entry	FREE_SFT,FAR
	entry	SHARE_ERROR,FAR
	entry	NLS_IOCTL,FAR
	entry	$CURRENT_DIR,FAR
	entry	$FCB_CREATE,FAR
	entry	$WRITE,FAR
	entry	$GET_INDOS_FLAG,FAR
	entry	RECSET,FAR
	entry	$CREATENEWFILE,FAR
	entry	$STD_CON_INPUT_STATUS,FAR
	entry	REEDIT,FAR
	entry	GETTHISDRV,FAR
	entry	DSUM,FAR
	entry	$GETEXTENDEDERROR,FAR
	entry	$EXTHANDLE,FAR
	entry	$NAMETRANS,FAR
	entry	NLS_LSEEK,FAR
	entry	SCANPLACE,FAR
	entry	GETCDSFROMDRV,FAR
	entry	DSLIDE,FAR
	entry	UCASE,FAR
	entry	$STD_CON_OUTPUT,FAR
	entry	$FCB_RANDOM_READ_BLOCK,FAR
	entry	CHECKFLUSH,FAR
	entry	COPYSTR,FAR
	entry	$GETSETCDPG,FAR
	entry	$DIR_SEARCH_NEXT,FAR
	entry	$OPEN,FAR
	entry	SKIPVISIT,FAR
	entry	$EXEC,FAR
	entry	$DEALLOC,FAR
	entry	DOS_CLOSE,FAR
	entry	$STD_CON_INPUT,FAR
	entry	NLS_GETEXT,FAR
	entry	BUFWRITE,FAR
	entry	$GET_TIME,FAR
	entry	$SLEAZEFUNC,FAR
	entry	$CHAR_OPER,FAR
	entry	NET_I24_ENTRY,FAR
	entry	$COMMIT,FAR
	entry	$SETBLOCK,FAR
	entry	$FCB_OPEN,FAR
	entry	NLS_OPEN,FAR
	entry	$GET_DMA,FAR
	entry	$UNLINK,FAR
	entry	$FCB_SEQ_READ,FAR
	entry	$STD_CON_INPUT_FLUSH,FAR
	entry	$GET_DRIVE_FREESPACE,FAR
	entry	DRIVEFROMTEXT,FAR
	entry	$GETEXTCNTRY,FAR
	entry	SETVISIT,FAR
	entry	$EXIT,FAR
	entry	$STD_AUX_OUTPUT,FAR
	entry	KILNEW,FAR
	entry	$CHMOD,FAR
	entry	$FCB_RANDOM_READ,FAR
	entry	SHARE_VIOLATION,FAR
	entry	ECRITDEVICE,FAR
	entry	$GET_DPB,FAR
	entry	$FIND_NEXT,FAR
	entry	$GET_FCB_FILE_LENGTH,FAR
	entry	ENTERINS,FAR
	entry	DEVIOCALL2,FAR
	entry	$SERVERCALL,FAR
	entry	$GSETMEDIAID,FAR
	entry	FETCHI_CHECK,FAR
	entry	TABLEDISPATCH,FAR
	entry	DSKSTATCHK,FAR
	entry	SET_RQ_SC_PARMS,FAR
	entry	SAVE_MAP,FAR
	entry	RESTORE_MAP,FAR
	entry	DSKREAD,FAR
	entry	FAST_DISPATCH,FAR
	entry	DSKWRITE,FAR
	entry	INTCNE0,FAR
	entry	SHARE_INSTALL,FAR							 ;P3568
	entry	FAKE_VERSION,FAR							 ;D503
	NOP
EndProc OUTT

	code	ENDS
    END


