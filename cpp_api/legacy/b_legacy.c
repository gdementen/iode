#pragma once

/* ********************************************** *
 * To be removed when b_(...).c source files will *
 * be integrated in current C API                 *
 * ********************************************** */

#include "../../api/iode.h"

 // =================== b_ws.c =================== //

B_WsLoad(arg, type)
char* arg;
int     type;
{
    KDB* kdb = NULL;
    int     pos = K_PWS[type];
    char    buf[K_MAX_FILE + 1];

    SCR_strlcpy(buf, arg, K_MAX_FILE);
    K_strip(buf);   /* JMP 19-04-98 */
    if (buf[0] == 0) return(0);

    kdb = K_interpret(type, buf);
    if (kdb == NULL) return(-1);

    K_free(K_RWS[type][pos]);
    K_WS[type] = K_RWS[type][pos] = kdb;

    return(0);
}

/* Retourne le type de fichier
  - 0 -> 6 = .cmt, ..., .var (binary format)
  - 10 -> 16 = ac, ... av
  - 26 = csv
  - 22 = rep ???
  - autres formats (rep, a2m, ..., csv)
  - -1 sinon
*/
X_findtype(filename)
char* filename;
{
    int         i, lg = strlen(filename);
    extern char k_ext[][4];
    char        buf[5];

    // Check std extensions .cmt => .var
    if (lg > 4) {
        for (i = 0; i < 7; i++) {
            if (filename[lg - 4] == '.' &&
                SCR_cstrcmp(k_ext[i], filename + lg - 3) == 0) return(i);
        }
    }

    // Check ascii extensions .ac => .av
    if (lg > 3) {
        strcpy(buf, ".ac");
        for (i = 0; i < 7; i++) {
            buf[2] = k_ext[i][0];
            if (SCR_cstrcmp(filename + lg - 3, buf) == 0) return(10 + i);
        }
    }

    // Other extensions
    // 
    //if(lg > 4 && SCR_cstrcmp(filename + lg - 4, ".csv") == 0) return(21); // Correction JMP 16/1/2019 
    //if(lg > 4 && SCR_cstrcmp(filename + lg - 4, ".rep") == 0) return(22); // Correction JMP 16/1/2019 
    if (lg > 4 && SCR_cstrcmp(filename + lg - 4, ".csv") == 0) return(K_CSV); // Correction JMP 25/3/2019 
    if (lg > 4 && SCR_cstrcmp(filename + lg - 4, ".rep") == 0) return(22); // ??? pas tr�s coh�rent...

    // Sais plus a quoi ca peut servir... => a supprimer
    for (i = 16; strcmp(k_ext[i], "xxx") != 0; i++) {
        if (lg > 4 && SCR_cstrcmp(filename + lg - 4, k_ext[i]) == 0) return(i); // Correction JMP 16/1/2019 : lg - 4 au lieu de -3 
    }

    return(-1);
}

int B_WsDump(kdb, filename)
KDB* kdb;
char* filename;
{
    int     rc = -1, ftype, type = KTYPE(kdb);

    kmsg("Saving %s", filename);
    ftype = X_findtype(filename);

    if (ftype >= 10 && ftype <= 17)
        rc = (*K_save_asc[type])(kdb, filename);
    //else if(ftype >= 0 && ftype <= 6)
    else if (ftype <= 6)
        rc = K_save(kdb, filename);
    else if (ftype == K_CSV)
        rc = (*K_save_csv[type])(kdb, filename, NULL, NULL);

    return(rc);
}

B_WsSave(arg, type)
char* arg;
int     type;
{
    char    buf[K_MAX_FILE + 1];

    SCR_strip(arg);
    if (strlen(arg) >= sizeof(FNAME)) {
        B_seterror(B_msg(256));   /* File name too long */
        return(-1);
    }
    SCR_strlcpy(buf, arg, K_MAX_FILE); /* JMP 18-04-98 */
    SCR_strip(buf);
    if (buf[0] == 0) return(0);
    return(B_WsDump(K_WS[type], buf));
}

B_WsDescr(arg, type)
char* arg;
int     type;
{
    SCR_strlcpy(KDESC(K_WS[type]), arg, 50);
    return(0);
}

B_WsName(arg, type)
char* arg;
int     type;
{
    //char	dir[K_MAX_FILE], file[K_MAX_FILE];				// JMP 3/6/2015

    // Save filename only (not path) in KDB
    //SCR_split_name(arg, dir, file)						// JMP 3/6/2015
    //SCR_strlcpy(KNAME(K_WS[type]), file, K_MAX_FILE - 1);	// JMP 3/6/2015

    // Save full name in K_WSNAME
    K_set_kdb_name(K_WS[type], arg);  // JMP 3/6/2015
    return(0);
}

B_WsClear(arg, type)
char* arg;
int     type;
{
    B_WsDescr("", type);
    B_WsName("", type);
    return(K_clear(K_WS[type]));
}

// =================== b_data.c =================== //

B_DataUpdateEqs(name, lec, cmt, method, smpl, instr, blk, tests, date)
char* name, * lec, * cmt, * instr, * blk;
SAMPLE* smpl;
float* tests; /* FLOAT 12-04-98 */
int     method, date;
{
    int     pos, rc;
    EQ* eq;

    pos = K_find(K_WS[K_EQS], name);
    if (pos < 0) eq = SW_nalloc(sizeof(EQ));
    else eq = KEVAL(K_WS[K_EQS], pos);

    if (lec != NULL) {
        SW_nfree(eq->lec);
        eq->lec = SCR_stracpy(lec);
    }
    if (cmt != NULL) {
        SW_nfree(eq->cmt);
        eq->cmt = SCR_stracpy(cmt);
    }
    if (instr != NULL) {
        SW_nfree(eq->instr);
        eq->instr = SCR_stracpy(instr);
    }
    if (blk != NULL) {
        SW_nfree(eq->blk);
        eq->blk = SCR_stracpy(blk);
    }

    if (method >= 0) eq->method = method;
    if (date > 0) eq->date = SCR_current_date();
    else eq->date = 0L;

    if (tests != NULL)  memcpy(&(eq->tests), tests, EQS_NBTESTS * sizeof(float));   /* FLOAT 12-04-98 */
    else memset(&(eq->tests), 0, EQS_NBTESTS * sizeof(float)); /* JMP 12-04-98 */

    if (smpl != NULL) memcpy(&(eq->smpl), smpl, sizeof(SAMPLE));
    /*    else memset(&(eq->smpl), 0, sizeof(SAMPLE)); */

    rc = K_add(K_WS[K_EQS], name, eq, name);
    if (rc < 0) {
        rc = -1;
        B_seterror(L_error());
    }
    else rc = 0;

    /* GB 27/9/96
        E_tests2scl(eq, E_T, E_NCE);
    */
    E_free(eq);
    return(rc);
}

// =================== b_rep.c =================== //

#define RP_STDALLOC     1
#define MEMBLK_BLK      100
#define MEMBLK_MAXLOST  512
#define MEMBLK_ADDSIZE  10


typedef struct _memblk_ {
    int  used, size;
    char* ptr;
} MEMBLK;

MEMBLK* RP_MEMBLKS = 0;
int     RP_NBMEMBLKS = 0;

char* RP_VSEPS = 0;

B_free_repfile(REPFILE* rf)
{
    if (rf) { // CORR JMP 23/5/2019
        SCR_free_tbl(rf->tbl);
        SCR_free(rf->filename);
        SCR_free(rf);
    }
}

RP_free(char* ptr)
{
    int i;

    if (RP_STDALLOC) {
        if (ptr) SCR_free(ptr); // JMP 26/8/2012
        return(0);
    }

    for (i = 0; i < RP_NBMEMBLKS; i++) {
        if (RP_MEMBLKS[i].ptr == ptr) {
            RP_MEMBLKS[i].used = 0;
            return(0);
        }
    }
    return(-1);
}

RP_free_bufs()
{
    extern char* RP_VSEPS;
    int i;

    if (RP_VSEPS) SCR_free(RP_VSEPS);
    RP_VSEPS = 0;

    // MEMBLKS
    for (i = 0; i < RP_NBMEMBLKS; i++) {
        SCR_free(RP_MEMBLKS[i].ptr);
        RP_MEMBLKS[i].ptr = 0;
    }

    SCR_free(RP_MEMBLKS);
    RP_MEMBLKS = 0;
    RP_NBMEMBLKS = 0;
}

// =================== b_proc.c =================== //

// Objet REP_PROC : contient le texte d'une proc�dure
typedef struct _rp_proc_ {
    char    proc_name[80];      // Nom de la proc�dure
    char** proc_parms;       // Nom des param�tres
    int     proc_nb_parms;      // Nombre de param�tres

    //char    *proc_filename;     // Fichier source
    //int     proc_line1;         // Ligne de d�part de la d�finition dans le fichier

    REPFILE* proc_rf;           // Nombre de lignes de la proc�dure (avec $procdef et $procend)
} REP_PROC;

REP_PROC** REP_PROCS;
int        REP_NB_PROCS = 0;

RP_proc_delete(int proc_nb)
{
    REP_PROC* proc;

    if (proc_nb < 0) return;
    proc = REP_PROCS[proc_nb];
    if (proc == 0) return;
    SCR_free_tbl(proc->proc_parms);
    B_free_repfile(proc->proc_rf);
    //SCR_free(proc->proc_filename);
    SCR_free(proc);
    REP_PROCS[proc_nb] = 0;
}

// Free all the defined procedures 
RP_proc_free_all()
{
    int         i;

    for (i = 0; i < REP_NB_PROCS; i++)
        RP_proc_delete(i);
    SCR_free(REP_PROCS);
}

// =================== b_print.c =================== //

unsigned char* T_get_title(tbl)     /* JMP 13-11-93 */
TBL* tbl;
{
    int     k;
    for (k = 0; k < T_NL(tbl); k++)
        if (tbl->t_line[k].tl_type == KT_TITLE) break;
    if (k == T_NL(tbl) ||
        ((TCELL*)tbl->t_line[k].tl_val)->tc_val == 0)
        strcpy(STATIC_BUF, "No title");
    else
        SCR_strlcpy(STATIC_BUF, (char*)((TCELL*)tbl->t_line[k].tl_val)->tc_val, STATIC_BUF_LG);
    return(STATIC_BUF);
}

// =================== b_base.c =================== //

char    B_SEPS[] = " ,\n\t";
int     B_NBDEC = 2;
int     B_LANG = 0;             /* JMP38 26-09-92 */
int     B_MULTIBAR = 0;         /* GB 30/10/2007 MULTIBAR function*/
int	    B_GRAPHDEFAULT = 0;     /* GB 10/03/2011 T_auto function*/

char** B_ERROR_MSG = NULL;
int     B_ERROR_NB = 0;

void B_reset_error()
{
    int i;

    if (B_ERROR_NB == 0) return;
    SCR_add_ptr(&B_ERROR_MSG, &B_ERROR_NB, NULL);
    SCR_free_tbl(B_ERROR_MSG);
    B_ERROR_MSG = 0;
    B_ERROR_NB = 0;
}

// =================== b_api.c =================== //

#include "../../api/iodeapi.h"

char    STATIC_BUF[512];        /* JMP 10-01-11 */
int     STATIC_BUF_LG = 511;    /* JMP 10-01-11 */

IodeInit()
{
    SW_MIN_MEM = 120 * 1024L;
    SW_MIN_SEGS = 2;
    SW_init(1);
    K_init_ws(0);


    B_LANG = 0;
    B_NBDEC = -1;
    A_SEPS = " ,;\n\t\r";
    A_NO_EXPANDSTAR_DFT = 1; // JMP 12-11-2012 -> suppress default filemane wildcard behavior

    return(0);
}

IodeEnd()
{
    SW_end();
    W_close();
    K_end_ws(0);        /* JMP 23-08-2012 */
    L_free_anames();    /* JMP 14-11-2012 */
    BUF_free();         /* JMP 14-11-2012 */
    RP_proc_free_all(); /* JMP 14-02-2013 */
    RP_free_bufs();     /* JMP 12-12-2012 */
    B_reset_error();    /* JMP 14-02-2013 */

    return(0);
}