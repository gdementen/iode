#include <nanobind/nanobind.h>
#include <nanobind/stl/string.h>
#include <nanobind/stl/vector.h>

namespace nb = nanobind;

#include "cpp_api/iode_cpp_api.h"
#include "py_ws.h"


NB_MODULE(iode, m) {
    // IODE defines used in python functions
    // -------------------------------------

    // Object and file types
    m.attr("I_CMT") = (int) I_COMMENTS;
    m.attr("I_EQS") = (int) I_EQUATIONS;
    m.attr("I_IDT") = (int) I_IDENTITIES;
    m.attr("I_LST") = (int) I_LISTS;
    m.attr("I_SCL") = (int) I_SCALARS;
    m.attr("I_TBL") = (int) I_TABLES;
    m.attr("I_VAR") = (int) I_VARIABLES;

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

    // Workspace functions

    m.def("ws_content", &ws_content, nb::arg("pattern"), nb::arg("iode_type") = (int) I_VARIABLES, 
          "Return the names of objects of a given IODE data type, satisfying a pattern specification.");
    m.def("ws_content_cmt", [](const std::string& pattern){ return ws_content(pattern, I_COMMENTS); }, nb::arg("pattern"),
          "Return the list of comment names corresponding to the given pattern");
    m.def("ws_content_eqs", [](const std::string& pattern){ return ws_content(pattern, I_EQUATIONS); }, nb::arg("pattern"),
          "Return the list of equation names corresponding to the given pattern");
    m.def("ws_content_idt", [](const std::string& pattern){ return ws_content(pattern, I_IDENTITIES); }, nb::arg("pattern"),
          "Return the list of identity names corresponding to the given pattern");
    m.def("ws_content_lst", [](const std::string& pattern){ return ws_content(pattern, I_LISTS); }, nb::arg("pattern"),
          "Return the list of list names corresponding to the given pattern");
    m.def("ws_content_scl", [](const std::string& pattern){ return ws_content(pattern, I_SCALARS); }, nb::arg("pattern"),
          "Return the list of scalar names corresponding to the given pattern");
    m.def("ws_content_tbl", [](const std::string& pattern){ return ws_content(pattern, I_TABLES); }, nb::arg("pattern"),
          "Return the list of table names corresponding to the given pattern");
    m.def("ws_content_var", [](const std::string& pattern){ return ws_content(pattern, I_VARIABLES); }, nb::arg("pattern"),
          "Return the list of variable names corresponding to the given pattern");

    m.def("ws_clear_all", &ws_clear_all, "Clear all workspaces");
    m.def("ws_clear", &ws_clear, nb::arg("iode_type"), "Clear the workspace for a given IODE data type");
    m.def("ws_clear_cmt", [](){ Comments.clear(); },   "Clear the workspace of comments");
    m.def("ws_clear_eqs", [](){ Equations.clear(); },  "Clear the workspace of equations");
    m.def("ws_clear_idt", [](){ Identities.clear(); }, "Clear the workspace of identities");
    m.def("ws_clear_lst", [](){ Lists.clear(); },      "Clear the workspace of lists");
    m.def("ws_clear_scl", [](){ Scalars.clear(); },    "Clear the workspace of scalars");
    m.def("ws_clear_tbl", [](){ Tables.clear(); },     "Clear the workspace of tables");
    m.def("ws_clear_var", [](){ Variables.clear(); },  "Clear the workspace of variables");

    m.def("ws_load", &ws_load, nb::arg("filename"), nb::arg("iode_type") = -1, 
          "Load an IODE file and return the number of read objects");
    m.def("ws_load_cmt", [](const std::string& filename){ Comments.load(filename);   return Comments.count(); }, nb::arg("filename"), 
          "Load a comment file and return the number of read objects");
    m.def("ws_load_eqs", [](const std::string& filename){ Equations.load(filename);  return Equations.count(); }, nb::arg("filename"), 
          "Load an equation file and return the number of read objects");
    m.def("ws_load_idt", [](const std::string& filename){ Identities.load(filename); return Identities.count(); }, nb::arg("filename"), 
          "Load a identity file and return the number of read objects");
    m.def("ws_load_lst", [](const std::string& filename){ Lists.load(filename);      return Lists.count(); }, nb::arg("filename"), 
          "Load a list file and return the number of read objects");
    m.def("ws_load_scl", [](const std::string& filename){ Scalars.load(filename);    return Scalars.count(); }, nb::arg("filename"), 
          "Load a scalar file and return the number of read objects");
    m.def("ws_load_tbl", [](const std::string& filename){ Tables.load(filename);     return Tables.count(); }, nb::arg("filename"), 
          "Load a table file and return the number of read objects");
    m.def("ws_load_var", [](const std::string& filename){ Variables.load(filename);  return Variables.count(); }, nb::arg("filename"), 
          "Load a variable file and return the number of read objects");

    m.def("ws_save", &ws_save, nb::arg("filename"), nb::arg("iode_type"), 
          "Save the current IODE workspace of a given IODE data type");
    m.def("ws_save_cmt", [](const std::string& filename){ Comments.save(filename); },   nb::arg("filename"), 
          "Save the current comments workspace");
    m.def("ws_save_eqs", [](const std::string& filename){ Equations.save(filename); },  nb::arg("filename"), 
          "Save the current equations workspace");
    m.def("ws_save_idt", [](const std::string& filename){ Identities.save(filename); }, nb::arg("filename"), 
          "Save the current identities workspace");
    m.def("ws_save_lst", [](const std::string& filename){ Lists.save(filename); },      nb::arg("filename"), 
          "Save the current lists workspace");
    m.def("ws_save_scl", [](const std::string& filename){ Scalars.save(filename); },    nb::arg("filename"), 
          "Save the current scalars workspace");
    m.def("ws_save_tbl", [](const std::string& filename){ Tables.save(filename); },     nb::arg("filename"), 
          "Save the current tables workspace");
    m.def("ws_save_var", [](const std::string& filename){ Variables.save(filename); },  nb::arg("filename"), 
          "Save the current variables workspace");

    m.def("ws_htol", nb::overload_cast<const std::string&, const std::string&, const int>(&ws_htol), 
          nb::arg("filename"), nb::arg("varlist"), nb::arg("series_type"));
    m.def("ws_htol_last", [](const std::string& filename, const std::string& varlist) { ws_htol(filename, varlist, (int) EnumIodeHtoL::HTOL_LAST); }, 
          nb::arg("filename"), nb::arg("varlist"));
    m.def("ws_htol_mean", [](const std::string& filename, const std::string& varlist) { ws_htol(filename, varlist, (int) EnumIodeHtoL::HTOL_MEAN); }, 
          nb::arg("filename"), nb::arg("varlist"));
    m.def("ws_htol_sum",  [](const std::string& filename, const std::string& varlist) { ws_htol(filename, varlist, (int) EnumIodeHtoL::HTOL_SUM); }, 
          nb::arg("filename"), nb::arg("varlist"));

    m.def("ws_htol", nb::overload_cast<const std::string&, const std::vector<std::string>&, const int>(&ws_htol), 
          nb::arg("filename"), nb::arg("varlist"), nb::arg("series_type"));
    m.def("ws_htol_last", [](const std::string& filename, const std::vector<std::string>& varlist) { ws_htol(filename, varlist, (int) EnumIodeHtoL::HTOL_LAST); }, 
          nb::arg("filename"), nb::arg("varlist"));
    m.def("ws_htol_mean", [](const std::string& filename, const std::vector<std::string>& varlist) { ws_htol(filename, varlist, (int) EnumIodeHtoL::HTOL_MEAN); }, 
          nb::arg("filename"), nb::arg("varlist"));
    m.def("ws_htol_sum",  [](const std::string& filename, const std::vector<std::string>& varlist) { ws_htol(filename, varlist, (int) EnumIodeHtoL::HTOL_SUM); }, 
          nb::arg("filename"), nb::arg("varlist"));

    m.def("ws_ltoh", nb::overload_cast<const std::string&, const std::string&, const int, const char>(&ws_ltoh), 
          nb::arg("filename"), nb::arg("varlist"), nb::arg("series_type"), nb::arg("method"));
    m.def("ws_ltoh_flow",  [](const std::string& filename, const std::string& varlist, const char method = 'C') 
          { ws_ltoh(filename, varlist, EnumIodeLtoH::LTOH_FLOW, method); }, 
          nb::arg("filename"), nb::arg("varlist"), nb::arg("method") = 'C');
    m.def("ws_ltoh_stock", [](const std::string& filename, const std::string& varlist, const char method = 'C') 
          { ws_ltoh(filename, varlist, EnumIodeLtoH::LTOH_STOCK, method); }, 
          nb::arg("filename"), nb::arg("varlist"), nb::arg("method") = 'C');

    m.def("ws_ltoh", nb::overload_cast<const std::string&, const std::vector<std::string>&, const int, const char>(&ws_ltoh), 
          nb::arg("filename"), nb::arg("varlist"), nb::arg("series_type"), nb::arg("method"));
    m.def("ws_ltoh_flow",  [](const std::string& filename, const std::vector<std::string>& varlist, const char method = 'C') 
          { ws_ltoh(filename, varlist, EnumIodeLtoH::LTOH_FLOW, method); }, 
          nb::arg("filename"), nb::arg("varlist"), nb::arg("method") = 'C');
    m.def("ws_ltoh_stock", [](const std::string& filename, const std::vector<std::string>& varlist, const char method = 'C') 
          { ws_ltoh(filename, varlist, EnumIodeLtoH::LTOH_STOCK, method); }, 
          nb::arg("filename"), nb::arg("varlist"), nb::arg("method") = 'C');

}
