#include "py_constants.h"


void init_constants(nb::module_ &m)
{
      // IODE CONSTANTS
      // --------------

      // NAN value
      m.attr("nan") = L_NAN;

      // Object and file types
      m.attr("I_CMT") = (int) I_COMMENTS;
      m.attr("I_EQS") = (int) I_EQUATIONS;
      m.attr("I_IDT") = (int) I_IDENTITIES;
      m.attr("I_LST") = (int) I_LISTS;
      m.attr("I_SCL") = (int) I_SCALARS;
      m.attr("I_TBL") = (int) I_TABLES;
      m.attr("I_VAR") = (int) I_VARIABLES;

      // Methods to estimation equations
      m.attr("E_LSQ")            = (int) IE_LSQ;
      m.attr("E_ZELLNER")        = (int) IE_ZELLNER;
      m.attr("E_INSTRUMENTAL")   = (int) IE_INSTRUMENTAL;
      m.attr("E_GLS")            = (int) IE_GLS;
      m.attr("E_MAX_LIKELIHOOD") = (int) IE_MAX_LIKELIHOOD;

      // test values
      m.attr("IE_CORR")    = (int) IE_CORR;
      m.attr("IE_STDEV")   = (int) IE_STDEV;
      m.attr("IE_MEANY")   = (int) IE_MEANY; 
      m.attr("IE_SSRES")   = (int) IE_SSRES; 
      m.attr("IE_STDERR")  = (int) IE_STDERR;
      m.attr("IE_STDERRP") = (int) IE_STDERRP;
      m.attr("IE_FSTAT")   = (int) IE_FSTAT; 
      m.attr("IE_R2")      = (int) IE_R2;
      m.attr("IE_R2ADJ")   = (int) IE_R2ADJ; 
      m.attr("IE_DW")      = (int) IE_DW;
      m.attr("IE_LOGLIK")  = (int) IE_LOGLIK;

      // Simulation parameters
      m.attr("SORT_CONNEX") = (int) SORT_CONNEX;
      m.attr("SORT_BOTH")   = (int) SORT_BOTH;
      m.attr("SORT_NONE")   = (int) SORT_NONE;

      m.attr("IV_INIT_TM1")      = (int) IV_INIT_TM1;
      m.attr("IV_INIT_TM1_A")    = (int) IV_INIT_TM1_A;
      m.attr("IV_INIT_EXTRA")    = (int) IV_INIT_EXTRA;
      m.attr("IV_INIT_EXTRA_A")  = (int) IV_INIT_EXTRA_A;
      m.attr("IV_INIT_ASIS")     = (int) IV_INIT_ASIS;
      m.attr("IV_INIT_TM1_NA")   = (int) IV_INIT_TM1_NA;
      m.attr("IV_INIT_EXTRA_NA") = (int) IV_INIT_EXTRA_NA;

      // Print outputs
      m.attr("W_GDI")   = (int) W_GDI; 
      m.attr("W_A2M")   = (int) W_A2M;
      m.attr("W_MIF")   = (int) W_MIF;
      m.attr("W_HTML")  = (int) W_HTML;
      m.attr("W_RTF")   = (int) W_RTF;
      m.attr("W_CSV")   = (int) W_CSV;
      m.attr("W_DUMMY") = (int) W_DUMMY;

      // HTOL methods
      m.attr("HTOL_LAST") = (int) HTOL_LAST;
      m.attr("HTOL_MEAN") = (int) HTOL_MEAN;
      m.attr("HTOL_SUM")  = (int) HTOL_SUM;

      // LTOH defines 
      m.attr("LTOH_STOCK")  = (int) LTOH_STOCK;
      m.attr("LTOH_FLOW")   = (int) LTOH_FLOW;
      m.attr("LTOH_LIN")    = WS_LTOH_LIN; 
      m.attr("LTOH_CS")     = WS_LTOH_CS;
      m.attr("LTOH_STEP")   = WS_LTOH_STEP;
}
