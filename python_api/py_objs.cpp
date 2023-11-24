#include "py_objs.h"


void init_iode_objs(nb::module_ &m)
{
    // IODE object classes

    // Read https://nanobind.readthedocs.io/en/latest/classes.html#classes 
    // to see how to export C++ classes to Python

    // NOTE: attributes 'solved', 'date' and 'tests' have been set as read-only in Python
    nb::class_<Equation>(m, "Equation")
    .def_prop_rw("lec", &Equation::get_lec, &Equation::set_lec)
    .def_prop_ro("solved", &Equation::get_solved)
    .def_prop_rw("method", &Equation::get_method, nb::overload_cast<const int>(&Equation::set_method))
    .def_prop_rw("block", &Equation::get_block, &Equation::set_block)
    .def_prop_rw("sample", &Equation::get_sample, &Equation::set_sample)
    .def_prop_rw("comment", &Equation::get_comment, &Equation::set_comment)
    .def_prop_rw("instruments", &Equation::get_instruments, &Equation::set_instruments)
    .def_prop_ro("date", &Equation::get_date_as_string)
    .def("update_date", &Equation::update_date)
    .def_prop_ro("tests", &Equation::get_tests)
    .def_prop_ro("e_stdev",  &Equation::get_test_stdev)
    .def_prop_ro("e_meany",  &Equation::get_test_meany)
    .def_prop_ro("e_ssres",  &Equation::get_test_ssres)
    .def_prop_ro("e_stderr", &Equation::get_test_stderr)
    .def_prop_ro("e_fstat",  &Equation::get_test_fstat)
    .def_prop_ro("e_r2",     &Equation::get_test_r2)
    .def_prop_ro("e_r2adj",  &Equation::get_test_r2adj)
    .def_prop_ro("e_dw",     &Equation::get_test_dw)
    .def_prop_ro("e_loglik", &Equation::get_test_loglik)
    .def(nb::init<const std::string&>())
    .def(nb::init<const std::string&, const std::string&, const int, const std::string&, const std::string&, 
                    const std::string&, const std::string&, const std::string&, const bool>())
    .def(nb::init<const std::string&, const std::string&, const std::string&, const std::string&, const std::string&, 
                    const std::string&, const std::string&, const std::string&, const bool>())
    .def("get_coefficients_list", &Equation::get_coefficients_list, nb::arg("create_if_not_exit") = true)
    .def("get_variables_list", &Equation::get_variables_list, nb::arg("create_if_not_exit") = true)
    .def("split_equation", &Equation::split_equation)
    .def(nb::self == nb::self)
    .def("__str__", &Equation::to_string)
    .def("__repr__", &Equation::to_string);

    nb::class_<Scalar>(m, "Scalar")
        .def_rw("value", &Scalar::val)
        .def_rw("relax", &Scalar::relax)
        .def_ro("std", &Scalar::std)
        .def(nb::init<const std::string&>())
        .def(nb::init<const IODE_REAL, const IODE_REAL, const IODE_REAL>())
        .def(nb::self == nb::self)
        .def("__str__", &Scalar::to_string)
        .def("__repr__", &Scalar::to_string);

    // IODE objects getters

    m.def("get_cmt", [](const std::string& name) { return Comments.get(name); }, nb::arg("name"), "Get an IODE comment");
    m.def("get_eqs", [](const std::string& name) { return Equations.get(name); }, nb::arg("name"), "Get an IODE equation");
    m.def("get_idt", [](const std::string& name) { return Identities.get_lec(name); }, nb::arg("name"),"Get an IODE identity");
    m.def("get_lst", [](const std::string& name) { return Lists.get(name); }, nb::arg("name"), "Get an IODE list");
    m.def("get_scl", [](const std::string& name) { return Scalars.get(name); }, nb::arg("name"), "Get an IODE scalar");
    // m.def("get_tbl", [](const std::string& name) { return Tables.get(name); }, nb::arg("name"),   "Get an IODE table");
    m.def("get_var", [](const std::string& name) { return Variables.get(name); }, nb::arg("name"), "Get an IODE variable");
    
    // IODE objects setters

    m.def("set_cmt", [](const std::string& name, const Comment& cmt) { 
                if(!Comments.contains(name)) Comments.add(name, cmt); 
                else Comments.update(name, cmt); 
        }, nb::arg("name"), nb::arg("cmt"), "Add or create an IODE comment");
    m.def("set_eqs", [](const std::string& name, const std::string& lec) { 
               if(!Equations.contains(name)) Equations.add(name, lec); 
               else Equations.update(name, lec); 
         }, nb::arg("name"), nb::arg("lec"), "Add or create an IODE equation");
    m.def("set_eqs", [](const std::string& name, const Equation& eq) { 
               if(!Equations.contains(name)) Equations.add(name, eq); 
               else Equations.update(name, eq); 
         }, nb::arg("name"), nb::arg("eq"), "Add or create an IODE equation");
    m.def("set_idt", [](const std::string& name, const std::string& idt) { 
                if(!Identities.contains(name)) Identities.add(name, idt); 
                else Identities.update(name, idt); 
        }, nb::arg("name"), nb::arg("idt"), "Add or create an IODE identity");
    m.def("set_lst", [](const std::string& name, const List& lst) { 
                if(!Lists.contains(name)) Lists.add(name, lst); 
                else Lists.update(name, lst); 
        }, nb::arg("name"), nb::arg("lst"), "Add or create an IODE list");
    m.def("set_scl", [](const std::string& name, const Scalar& scl) { 
                if(!Scalars.contains(name)) Scalars.add(name, scl); 
                else Scalars.update(name, scl.val, scl.relax, scl.std); 
        }, nb::arg("name"), nb::arg("scl"), "Add or create an IODE scalar");
    // m.def("set_tbl", [](const std::string& name, const Table& tbl) { 
    //            if(!Tables.contains(name)) Tables.add(name, tbl); 
    //            else Tables.update(name, tbl); 
    //         }, nb::arg("name"), nb::arg("tbl"), "Add or create an IODE table");
    m.def("set_var", [](const std::string& name, const Variable& var) { 
                if(!Variables.contains(name)) Variables.add(name, var); 
                else Variables.update(name, var);  
        }, nb::arg("name"), nb::arg("var"), "Add or create an IODE variable");

    // Equations

    m.def("get_eqs_lec", [](const std::string& name) { return Equations.get_lec(name); }, nb::arg("name"),  "Get LEC of an equation");
    m.def("set_eqs_lec", [](const std::string& name) { return Equations.get_lec(name); }, nb::arg("name"),  "Update LEC of an equation");

    // Variables

    m.def("get_var_as_ndarray", &get_var_as_ndarray, nb::rv_policy::reference, nb::arg("name"),     "Get an IODE variable in a numpy ndarray");
    m.def("get_var_as_ndarray_copy", &get_var_as_ndarray, nb::rv_policy::copy, nb::arg("name"),     "Get a copy of an IODE variable in a numpy ndarray");
    
    m.def("__set_var_from_ndarray", &__set_var_from_ndarray, nb::arg("name"), nb::arg("first_period"), 
          nb::arg("last_period"), nb::arg("array"));
    m.def("__set_var_from_ndarray_contiguous", &__set_var_from_ndarray_contiguous, nb::arg("name"), 
          nb::arg("first_period"), nb::arg("last_period"), nb::arg("array"));

    m.def("__set_vars_from_ndarray", &__set_vars_from_ndarray, nb::arg("names"), nb::arg("first_period"), 
          nb::arg("last_period"), nb::arg("array"));
    m.def("__set_vars_from_ndarray_contiguous", &__set_vars_from_ndarray_contiguous, nb::arg("names"), 
          nb::arg("first_period"), nb::arg("last_period"), nb::arg("array"));

    // IODE objects delete

    m.def("delete_cmt", [](const std::string& name) { Comments.remove(name); },   nb::arg("name"), "delete the comment named `name`");
    m.def("delete_eqs", [](const std::string& name) { Equations.remove(name); },  nb::arg("name"), "delete the equation named `name`");
    m.def("delete_idt", [](const std::string& name) { Identities.remove(name); }, nb::arg("name"), "delete the identity named `name`");
    m.def("delete_lst", [](const std::string& name) { Lists.remove(name); },      nb::arg("name"), "delete the list named `name`");
    m.def("delete_scl", [](const std::string& name) { Scalars.remove(name); },    nb::arg("name"), "delete the scalar named `name`");
    m.def("delete_tbl", [](const std::string& name) { Tables.remove(name); },     nb::arg("name"), "delete the table named `name`");
    m.def("delete_var", [](const std::string& name) { Variables.remove(name); },  nb::arg("name"), "delete the variable named `name`");

}
