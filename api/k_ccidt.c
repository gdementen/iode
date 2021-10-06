#include "iode.h"

/* Read ascii file and add to DBIDT */

KDB *KI_load_asc(filename)
char    *filename;
{
    char    *lec = NULL;
    int     cmpt = 0;
    KDB     *kdb = 0;
    YYFILE  *yy;
    ONAME   name;

    /* INIT YY READ */
    YY_CASE_SENSITIVE = 1;
    SCR_strip(filename);
    yy = YY_open(filename, 0L, 0,
                 (!K_ISFILE(filename)) ? YY_STDIN : YY_FILE);
    if(yy == 0) {
        kerror(0, "Cannot open '%s'", filename);
        return(kdb);
    }

    /* READ FILE */
    kdb = K_create(K_IDT, K_UPPER);
    while(1) {
        switch(YY_lex(yy)) {
            case YY_EOF :
                YY_close(yy);
                return(kdb);

            case YY_WORD :
                yy->yy_text[K_MAX_NAME] = 0;
                strcpy(name, yy->yy_text);
                if(YY_lex(yy) != YY_STRING) {
                    kerror(0, "%s : identity not defined", YY_error(yy));
                    break;
                }
                lec = K_wrap(yy->yy_text, 60);
                if(K_add(kdb, name, lec) < 0)
                    kerror(0, "%s (%s : %s).",
                           YY_error(yy), name, L_error());
                SW_nfree(lec);
                kmsg("Reading object %d : %s", ++cmpt, name);
                break;

            default :
                kerror(0, "Incorrect entry : %s", YY_error(yy));
                break;
        }
    }

err:
    K_free(kdb);
    YY_close(yy);
    return((KDB *)0);
}


KI_save_asc(kdb, filename)
KDB   *kdb;
char    *filename;
{
    FILE    *fd;
    int     i;

    if(filename[0] == '-') fd = stdout;
    else {
        fd = fopen(filename, "w+");
        if(fd == 0) {
            kerror(0, "Cannot create '%s'", filename);
            return(-1);
        }
    }

    for(i = 0 ; i < KNB(kdb) ; i++) {
        fprintf(fd, "%s ", KONAME(kdb, i));
        fprintf(fd, "\"%s\"\n", KELEC(kdb, i));
    }

    if(filename[0] != '-') fclose(fd);
    return(0);
}


int KI_save_csv(KDB *kdb, char *filename)
{
    return(-1);
}
