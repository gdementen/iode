#ifndef _IODEAPI_
#define _IODEAPI_

#ifdef SCRCPP
extern "C" {
#endif

extern int IodeInit();
extern int IodeEnd();
extern char *IodeVersion();

extern int IodeLoad(char *name, int type);
extern int IodeSave(char *name, int type);
extern int IodeClearWs(int type);
extern int IodeClearAll();
extern char **IodeContents(char *pattern, int type);

extern int IodeGetSampleLength();
extern int IodeIsSampleSet();
extern char *IodeGetSampleAsString();
extern char **IodeGetSampleAsPeriods();
extern char **IodeCreateSampleAsPeriods(char* aper_from, char* aper_to);
extern double *IodeGetSampleAsDoubles(int *lg);
extern int IodeSetSampleStr(char* str_from, char* str_to);
extern int IodeSetSample(int from, int to);

extern int IodeDeleteObj(char* obj_name, int obj_type);
extern char *IodeGetCmt(char *name);
extern int IodeSetCmt(char *name, char *cmt);
extern int IodeGetEqs(char *name, char**lec, int *method, char*sample_from, char* sample_to, char**blk, char**instr, float *tests);
extern char *IodeGetEqsLec(char *name);
extern int IodeSetEqs(char *name, char *eqlec);
extern char *IodeGetIdt(char *name);
extern int IodeSetIdt(char *name, char *idt);
extern char *IodeGetLst(char *name);
extern int IodeSetLst(char *name, char *lst);
extern int IodeGetScl(char *name, double* value, double *relax, double *std_err);
extern int IodeSetScl(char *name, double value, double relax, double std);
extern char* IodeGetTbl(char *name, char *gsmpl);
extern char* IodeGetTblTitle(char *name);
extern TBL* IodeGetTblDefinition(char *name);
extern int IodeSetTblFile(int ref, char *filename);
extern double IodeGetVarT(char *name, int t, int mode);
extern int IodeSetVarT(char *name, int t, int mode, double value);
extern double *IodeGetVector(char *name, int *lg);
extern int IodeCalcSamplePosition(char *str_la_from, char* str_la_to, int *la_pos, int *ws_pos, int *la_lg);
extern int IodeSetVector(char *la_name, double *la_values, int la_pos, int ws_pos, int la_lg);

extern int IodeEstimate(char* veqs, char* afrom, char* ato);

extern int IodeModelSimulate(char *per_from, char *per_to, char *eqs_list, char *endo_exo_list, double eps, double relax, int maxit, int init_values, int sort_algo, int nb_passes, int debug, double newton_eps, int newton_maxit, int newton_debug);

extern int IodeExecArgs(char *filename, char **args);
extern int IodeExec(char *filename);

extern double IodeExecLecT(char* lec, int t);
extern double *IodeExecLec(char* lec);

extern int IodeGetChart(char *name, char *gsmpl);
extern int IodeFreeChart(int hdl);
extern int IodeChartNl(int hdl);
extern int IodeChartNc(int hdl);
extern char IodeChartType(int hdl, int i);
extern int IodeChartAxis(int hdl, int i);
extern char *IodeChartTitle(int hdl, int i);
extern double *IodeChartData(int hdl, int i);

extern void kmsg_null(char*msg);
extern void IodeSetMsgs(int IsOn);
extern void IodeSuppressMsgs();
extern void IodeResetMsgs();

extern int IodeSetNbDec(int nbdec);
extern int IodeGetNbDec();


// // Init / End / Version
// extern  int IodeInit();
// extern  int IodeEnd();
// extern  char *IodeVersion();
// 
// // File Operations & Objects 
// extern  int  IodeLoad(char *name, int type);
// extern  int  IodeSave(char *name, int type);
// extern  int IodeClearWs(int type);
// extern  int IodeClearAll();
// extern  char **IodeContents(char *pattern, int type);
// 
// // Sample operations 
// extern int      IodeGetSampleLength();
// extern  int     IodeIsSampleSet();
// 
// extern  char    *IodeGetSampleAsString();
// extern  char    **IodeGetSampleAsAxis();
// extern  char    **IodeCreateSampleAsAxis(char* aper_from, char* aper_to);
// extern  double  *IodeGetSampleAsDoubles(int *lg);           
// 
// extern  int     IodeSetSampleStr(char* str_from, char* str_to);
// extern  int     IodeSetSample(int, int);
// 
// extern  char    *IodeContentsStr(char *pattern, int type);
// 
// extern int      IodeDeleteObj(char* name, int type);
// 
// extern  char    *IodeGetCmt(char *name);
// extern  int     IodeSetCmt(char *name, char *cmttxt);
// 
// extern  char    *IodeGetIdt(char *name);
// extern  int     IodeSetIdt(char *name, char *idt);
// 
// extern  char    *IodeGetEqsLec(char *name);
// extern  int     IodeGetEqs(char *name, char**lec, int *method, char *sample_from, char* sample_to, char**blk, char**instr, float *tests);
// extern  int     IodeSetEqs(char *name, char *eqlec);
// 
// extern  char    *IodeGetLst(char *name); 
// extern  int     IodeSetLst(char *name, char *lst);
// 
// extern  int     IodeGetScl(char *name, double* value, double *relax, double *std_err);
// extern  double  *IodeGetScls(char *name);
// extern  int     IodeSetScl(char *name, double value, double relax, double std);
// 
// extern  double  IodeGetVar(char *name, int t, int mode);
// //extern  int     IodeSetVar(char *name, int t, int mode, double value);
// extern  int     IodeSetVector_v1(char *la_name, double *la_values, int la_year_from, int la_year_to);
// extern  int     IodeSetVector_v2(char *la_name, double *la_values, char *str_from, char* str_to);
// extern  int     IodeSetVector(char *la_name, double *la_values, int la_pos, int ws_pos, int la_lg);
// extern  int     IodeCalcSamplePosition(char *str_la_from, char* str_la_to, int *la_pos, int *ws_pos, int *la_lg);
// 
// extern  double  *IodeExecLec(char* lec);
// extern  double  IodeExecLecT(char* lec, int t);
// 
// extern  char    *IodeGetTbl(char *name, char *smpl);
// extern  TBL		*IodeGetTblDefinition(char *name);
// extern  char    *IodeGetTblTitle(char *name);
// extern  int     IodeSetTblFile(int ref, char *filename);
// 
// extern  double  *IodeGetVector(char *name, int *lg);
// 
// extern int      IodeModelSimulate(char *per_from, char *per_to, char *eqs_list, char *endo_exo_list,
//                  double eps, double relax, int maxit, 
//                  int init_values, int sort_algo, int nb_passes, int debug, 
//                  double newton_eps, int newton_maxit, int newton_debug);
// 
// extern  int     IodeGetNbDec();
// extern  int     IodeSetNbDec(int nbdec);
// 
// extern  int     IodeGetSampleLength();
// extern  char    *IodeGetPeriodAsString(int t);
// extern  int     IodeGett(char *period);
// 
// extern  int     IodeGetChart(char *name, char *smpl);
// extern  int     IodeChartNl(int hdl);
// extern  int     IodeChartNc(int hdl);
// extern  char    IodeChartType(int hdl, int i);
// extern  int     IodeChartAxis(int hdl, int i);
// extern  char    *IodeChartTitle(int hdl, int i);
// extern  double  *IodeChartData(int hdl, int i);
// extern  int     IodeFreeChart(int hdl);
// 
// extern  void    IodeSuppressMsgs();
// extern  void    IodeResetMsgs();
// extern  void    ODE_assign_super_PYIODE();

#ifdef SCRCPP
}
#endif
#endif /* _IODEAPI_ */







