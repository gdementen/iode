/**
 * @header4iode
 *
 * Functions acting on workspaces of variables.
 *
 *    int KV_sample(KDB *kdb, SAMPLE *nsmpl)                                  Changes the SAMPLE of a KDB of variables.
 *    int KV_merge(KDB *kdb1, KDB* kdb2, int replace)                         Merges two KDB of variables: kdb1 <- kdb1 + kdb2.            
 *    void KV_merge_del(KDB *kdb1, KDB *kdb2, int replace)                    Merges 2 KDB of variables, then deletes the second one.
 *    double KV_get(KDB *kdb, int pos, int t, int mode)                       Gets VAR[t]  where VAR is the series in position pos in kdb. 
 *    void KV_set(KDB *kdb, int pos, int t, int mode, IODE_REAL new)          Sets VAR[t], where VAR is the series in position pos in kdb. 
 *    int KV_extrapolate(KDB *dbv, int method, SAMPLE *smpl, char **vars)     Extrapolates variables on a selected SAMPLE according to one of the available methods.
 *    KDB *KV_aggregate(KDB *dbv, int method, char *pattern, char *filename)  Creates a new KDB with variables created by aggregation based on variable names.
 *   
 */

#include "iode.h"

/**
 * Changes the SAMPLE of a KDB of variables. Truncates the vars and/or add NaN values to fill the variables on the new sample.
 * 
 * @param [in, out] kdb     KDB*        pointer to a KDB
 * @param [in]      nsmpl   SAMPLE*     new sample 
 * @return                  int         -1 if the kdb's sample and nsmpl don't overlap
 *                                      0 otherwise
 */
 
int KV_sample(KDB *kdb, SAMPLE *nsmpl)
{
    int     i, start1 = 0, start2 = 0, new_val;
    char    *pack, *ptr;
    SAMPLE  *ksmpl, smpl;

    ksmpl = (SAMPLE *) KDATA(kdb);
    if(ksmpl->s_nb != 0) {
        if(PER_common_smpl(ksmpl, nsmpl, &smpl) < 0) return(-1);
        if(smpl.s_nb > 0) {
            start1 = PER_diff_per(&(smpl.s_p1), &(ksmpl->s_p1));
            start2 = PER_diff_per(&(smpl.s_p1), &(nsmpl->s_p1));
        }
    }

    memcpy(ksmpl, nsmpl, sizeof(SAMPLE));
    for(i = 0 ; i < KNB(kdb); i++) {
        new_val = KV_alloc_var(ksmpl->s_nb);
        ptr = SW_getptr(new_val);
        if(KSOVAL(kdb, i) != 0) {
            if(smpl.s_nb > 0)
                memcpy((IODE_REAL *)(P_get_ptr(ptr, 0)) + start2,
                       KVVAL(kdb, i, start1),
                       sizeof(IODE_REAL) * smpl.s_nb);
            SW_free(KSOVAL(kdb, i));
        }
        KSOVAL(kdb, i) = new_val;
    }
    return(0);
}

/**
 * Merges two KDB of variables: kdb1 <- kdb1 + kdb2.
 * 
 * The resulting sample if the sample of kdb1.
 * If homonyms exist, vars from kbd2 replace their homonyms in kdb1 
 * if and only if replace is not 0.
 * 
 * @param [in, out]     kdb1         KDB *   KDB that will contain both kdb1 and kdb2.
 * @param [in]          kdb2         KDB *   source KDB.
 * @param [in]          replace      int     if not null, kdb2 vars replace kdb1 homonyms.
 * @return                           int -1 if there is no intersection between the 2 samples, 0 if ok.
*/
int KV_merge(KDB *kdb1, KDB* kdb2, int replace)
{
    int     i, start1, start2, pos, nb1;
    int     *p_pos;
    SAMPLE  *k1smpl, *k2smpl, smpl;

    k1smpl = (SAMPLE *) KDATA(kdb1);
    k2smpl = (SAMPLE *) KDATA(kdb2);

    if(k1smpl->s_nb == 0) memcpy(k1smpl, k2smpl, sizeof(SAMPLE));

    if(PER_common_smpl(k1smpl, k2smpl, &smpl) < 0) return(-1);
    if(smpl.s_nb > 0) {
        start1 = PER_diff_per(&(smpl.s_p1), &(k1smpl->s_p1)); /* always >= 0 */
        start2 = PER_diff_per(&(smpl.s_p1), &(k2smpl->s_p1)); /* always >= 0 */
    }

    nb1 = k1smpl->s_nb;
    for(i = 0; i < KNB(kdb2); i++) {
        pos = K_find(kdb1, KONAME(kdb2, i));
        if(pos < 0) pos = K_add(kdb1, KONAME(kdb2, i), NULL, &nb1);
        else if(!replace) continue;

        if(pos >= 0 && KSOVAL(kdb2, i) != 0)
            memcpy((IODE_REAL *) KVVAL(kdb1, pos, start1),
                   (IODE_REAL *) KVVAL(kdb2, i, start2),
                   sizeof(IODE_REAL) * smpl.s_nb);
    }

    return(0);
}


/**
 * Merges 2 KDB of variables, then deletes the second one.
 * 
 * The resulting sample is kdb1 sample if it is defined. 
 * If not, the sample of kdb2 is used.
 * 
 * @param [in, out] kdb1       KDB*   ws that will contain the result of the merge.
 * @param [in, out] kdb2       KDB*   ws to copy into kdb1
 * @param [in]      replace    int    indicates if kdb2 homonyms must replace kdb1
*/

void KV_merge_del(KDB *kdb1, KDB *kdb2, int replace)
{
    SAMPLE  *k1smpl, *k2smpl;

    k1smpl = (SAMPLE *) KDATA(kdb1);
    k2smpl = (SAMPLE *) KDATA(kdb2);

    if(KNB(kdb2) == 0) return;
    if(KNB(kdb1) == 0) {
        if(k1smpl->s_nb != 0)
            KV_sample(kdb2, k1smpl);
        else
            memcpy(k1smpl, k2smpl, sizeof(SAMPLE));
        KNB(kdb1)   = KNB(kdb2);
        KOBJS(kdb1) = KOBJS(kdb2);
        KNB(kdb2)   = 0;
        KOBJS(kdb2) = 0;
        K_free(kdb2);
        return;
    }

    KV_merge(kdb1, kdb2, replace);
    K_free(kdb2);
}


/**
 * Gets VAR[t] where VAR is the series in position pos in kdb. The value can be modified depending on mode.
 *
 * @param [in] kdb       KDB*    KDB of variables
 * @param [in] pos       int     position of the variable in the kdb
 * @param [in] t         int     index in the variable (0 = first position in the series...)
 * @param [in] mode      int     transformation of the value, see below. 
 *
 * @return               double  depends on the param mode (can be L_NAN if the operation is impossible):
 *                                    K_LEVEL : no modification    x[t]
 *                                    K_DIFF  : diff on one period (x[t]-x[t-1])
 *                                    K_DIFFY : diff on one year   (x[t]-x[t-{nb sub periods}])
 *                                    K_GRT   : grt on one period  (x[t]/x[t-1] - 1)*100
 *                                    K_GRTY  : grt on one year    (x[t]/x[t-{nb sub periods}] - 1) * 100
 *                                      
 */
 
double KV_get(KDB *kdb, int pos, int t, int mode)
{
    int     pernb;
    double  var;
    IODE_REAL    *vt;
    SAMPLE  *smpl;

    smpl = (SAMPLE *) KDATA(kdb);
    pernb = PER_nb((smpl->s_p1).p_p);

    switch(mode) {
        case K_LEVEL :
            var = *KVVAL(kdb, pos, t);
            break;
        case K_DIFF :
            pernb = 1;
        /* NO BREAK */
        case K_DIFFY : 
            if(t < pernb) {
                var = L_NAN;
                break;
            }
            vt = KVVAL(kdb, pos, 0);
            if(L_ISAN(vt[t]) && L_ISAN(vt[t - pernb]))
                var = vt[t] - vt[t - pernb];
            else var = L_NAN;
            break;

        case K_GRT :
            pernb = 1;
        /* NO BREAK */
        case K_GRTY :
            if(t < pernb) {
                var = L_NAN;
                break;
            }
            vt = KVVAL(kdb, pos, 0);
            if(L_ISAN(vt[t]) && L_ISAN(vt[t - pernb]) && !L_IS0(vt[t - pernb]))
                var = (vt[t]/vt[t - pernb] - 1) * 100.0;
            else var = L_NAN;
            break;
    }

    return(var);
}

/**
 * Set VAR[t], where VAR is the series in position pos in kdb. The new value of VAR[t] depends on 
 * the parameter mode and the value new.
 * 
 * @param [in, out]  kdb       KDB*        KDB of variables
 * @param [in]       pos       int         position of the variable in the kdb
 * @param [in]       t         int         index in the variable (0 = first position in the series...)
 * @param [in]       mode      int         transformation of the value, see below. 
 * @param [in]       new       IODE_REAL   new value of VAR[t] before transformation according to mode, see below. 
 *                                              K_LEVEL : no modification    x[t] = new
 *                                              K_DIFF  : diff on one period x[t] = x[t-1] + new
 *                                              K_DIFFY : diff on one year   x[t] = x[t-{nb sub periods}] + new
 *                                              K_GRT   : grt on one period  x[t] = (1 + 0.01*new) * x[t-1]
 *                                              K_GRTY  : grt on one year    x[t] = (1 + 0.01*new) * x[t-{nb sub periods}] 
 *                              
 */
 
void KV_set(KDB *kdb, int pos, int t, int mode, IODE_REAL new)
{
    int     pernb;
    IODE_REAL    *var;
    SAMPLE  *smpl;

    smpl = (SAMPLE *) KDATA(kdb);
    pernb = PER_nb((smpl->s_p1).p_p);

    var = KVVAL(kdb, pos, 0);
    switch(mode) {
        case K_LEVEL :
            var[t] = new;
            break;

        case K_DIFF :
            pernb = 1;
        /* NO BREAK */
        case K_DIFFY :
            if(t < pernb)  break;

            if(L_ISAN(new) && L_ISAN(var[t - pernb])) var[t] = var[t - pernb] + new;
            else var[t] = L_NAN;
            break;

        case K_GRT :
            pernb = 1;
        /* NO BREAK */
        case K_GRTY :
            if(t < pernb) break;

            if(L_ISAN(new) && L_ISAN(var[t - pernb]))
                var[t] = (new/100.0 + 1.0) * var[t - pernb];
            else var[t] = L_NAN;
            break;
    }
}


/**
 *  Extrapolates variables on a selected SAMPLE according to one of the available methods. These extrapolation methods are
 *  described in the function K_init_values() (see k_sim.c). 
 *  
 *  @param [in, out]    dbv    KDB*     KDB of variables on with the operation will be applied
 *  @param [in]         method int      identification of the extrapolation method (see K_init_values())
 *  @param [in]         smpl   SAMPLE*  SAMPLE on which the operation is to be carried out
 *  @param [in]         vars   char**   if not NULL, restricted list of variables to extrapolate
 *                                      if NULL, all variables in KDB will be modified
 *  @return                             0 on success,
 *                                      -1 if the SAMPLE is invalid or the KDB is empty or dbv does not contain any variable 
 *                                          from the list vars
 *  @details 
 */
 
int KV_extrapolate(KDB *dbv, int method, SAMPLE *smpl, char **vars)
{
    int         rc = -1, i, v, bt, t;
    IODE_REAL   *val;
    KDB         *edbv = NULL;

    bt = PER_diff_per(&(smpl->s_p1), &(KSMPL(dbv)->s_p1));
    if(bt < 0 || PER_diff_per(&(KSMPL(dbv)->s_p2), &(smpl->s_p2)) < 0) {
        B_seterror(B_msg(131));
        goto done;
    }

    if(vars == NULL || SCR_tbl_size(vars) == 0) edbv = dbv;
    else edbv = K_refer(dbv, SCR_tbl_size(vars), vars);
    // if(edbv == NULL) goto done; /* JMP 12-05-11 */
    if(edbv == NULL || KNB(edbv) == 0) goto done; /* JMP 12-05-11 */

    for(v = 0; v < KNB(edbv); v++) {
        val = KVVAL(edbv, v, 0);
        for(i = 0, t = bt; i < smpl->s_nb; i++, t++)
            K_init_values_1(val, t, method);
    }
    rc = 0;

done:
    if(edbv != dbv) K_free_kdb(edbv);
    return(rc);

}


/**
 *  Creates a new KDB with variables created by aggregation based on variable names.
 *    
 *  @param [in, out]    dbv         KDB*     KDB of variables on with the operation will be applied
 *  @param [in]         method      int      identification of the extrapolation method 
 *  @param [in]         pattern     char*    pattern defining the variables to be aggregated
 *  @param [in]         filename    char*    if not null nor empty, the onput variables will be loaded from that file
 *  @return                         KDB*     new KDB created by aggragation
 *                                           NULL on error (filename given but inexistent, not enough memory...)
 */

KDB *KV_aggregate(KDB *dbv, int method, char *pattern, char *filename)
{
    int     i, t, nb_per, added, *times, nbtimes = 500,
                                         epos, npos;
    ONAME   ename, nname;
    IODE_REAL    *eval = NULL, *nval;
    KDB     *edbv = NULL, *ndbv = NULL;
    SAMPLE  *smpl;

    if(filename == NULL || filename[0] == 0) edbv = dbv;
    else edbv = K_interpret(K_VAR, filename);
    if(edbv == NULL) goto done;

    smpl = KSMPL(edbv);
    nb_per = KSMPL(edbv)->s_nb;
    eval = (IODE_REAL*) SCR_malloc(nb_per * sizeof(IODE_REAL));
    times = (int *) SCR_malloc(nbtimes * sizeof(int));

    ndbv = K_create(K_VAR, K_UPPER);
    if(ndbv == NULL) goto done;
    else memcpy(KDATA(ndbv), KSMPL(edbv), sizeof(SAMPLE));

    for(epos = 0; epos < KNB(edbv); epos++) {
        strcpy(ename, KONAME(edbv, epos));
        if(K_aggr(pattern, ename, nname) < 0) continue;

        added = 1;
        npos = K_find(ndbv, nname);
        if(npos < 0) {
            npos = K_add(ndbv, nname, NULL, &nb_per);
            if(npos > nbtimes - 1) {
                times = (int *) SCR_realloc((char *) times, sizeof(int), nbtimes, nbtimes + 500);
                nbtimes += 500;
            }
            times[npos] = 1;

        }
        else {
            added = 0;
            times[npos] += 1;
        }
        if(npos < 0) goto done;

        memcpy(eval, KVVAL(edbv, epos, 0), nb_per * sizeof(IODE_REAL));
        nval = KVVAL(ndbv, npos, 0);
        for(t = 0; t < smpl->s_nb; t++) {
            if(added) nval[t] = eval[t];
            else {
                if(method == 1) { /* m = 1 PROD */
                    if(L_ISAN(eval[t])) nval[t] *= eval[t];
                    else nval[t] = L_NAN;
                }
                else { /* m != 1 SUM or MEAN */
                    if(L_ISAN(eval[t])) nval[t] += eval[t];
                    else nval[t] = L_NAN;
                }
            }
        }

    }

    if(method == 2) {
        for(npos = 0; npos < KNB(ndbv); npos++) {
            nval = KVVAL(ndbv, npos, 0);
            for(t = 0; t < smpl->s_nb; t++)
                if(L_ISAN(nval[t])) nval[t] /= times[npos];
        }
    }

done:
    if(edbv != dbv) K_free(edbv); /* JMP 12-11-98 */
    SCR_free(eval);
    SCR_free(times);
    return(ndbv);
}
