#include "pch.h"


class KDBVariablesTest : public KDBTest, public ::testing::Test
{
protected:
    EnumIodeVarMode mode = I_VAR_MODE_LEVEL;
    int pos = 0;
    int t = 10;
    int t_nan = 5;

    void SetUp() override
    {
        load_global_kdb(I_VARIABLES, input_test_dir + "fun.var");
    }

    // void TearDown() override {}
};


TEST_F(KDBVariablesTest, Load)
{
    KDBVariables kdb2;
    EXPECT_EQ(kdb2.count(), 394);

    KDBVariables kdb3(input_test_dir + "fun.var");
    EXPECT_EQ(kdb3.count(), 394);
}

TEST_F(KDBVariablesTest, CopyConstructor)
{
    Variable var = Variables.get("ACAF");
    std::string lec = "10 + t";
    Variable new_var;
    new_var.reserve(var.size());
    for (int p = 0; p < var.size(); p++) new_var.push_back(10.0 + p);

    // GLOBAL KDB
    KDBVariables kdb_copy(Variables);
    EXPECT_EQ(kdb_copy.count(), 394);
    EXPECT_TRUE(kdb_copy.is_global_kdb());

    // LOCAL KDB
    KDBVariables local_kdb(KDB_LOCAL, "A*");
    KDBVariables local_kdb_hard_copy(local_kdb);
    EXPECT_EQ(local_kdb.count(), local_kdb_hard_copy.count());
    EXPECT_TRUE(local_kdb_hard_copy.is_local_kdb());
    local_kdb_hard_copy.update("ACAF", lec);
    EXPECT_EQ(local_kdb.get("ACAF"), var);
    EXPECT_EQ(local_kdb_hard_copy.get("ACAF"), new_var);

    // SHALLOW COPY KDB
    KDBVariables shallow_kdb(KDB_SHALLOW_COPY, "A*");
    KDBVariables shallow_kdb_copy(shallow_kdb);
    EXPECT_EQ(shallow_kdb.count(), shallow_kdb_copy.count());
    EXPECT_TRUE(shallow_kdb_copy.is_shallow_copy());
    shallow_kdb_copy.update("ACAF", lec);
    EXPECT_EQ(shallow_kdb.get("ACAF"), new_var);
    EXPECT_EQ(shallow_kdb_copy.get("ACAF"), new_var);
}

TEST_F(KDBVariablesTest, Save)
{
    // save in binary format
    save_global_kdb(I_VARIABLES, output_test_dir + "fun.var");
    Variables.dump(output_test_dir + "fun.var");

    // save in ascii format
    save_global_kdb(I_VARIABLES, output_test_dir + "fun.av");
    Variables.dump(output_test_dir + "fun.av");
}

TEST_F(KDBVariablesTest, GetSetVar)
{
    IODE_REAL value;
    IODE_REAL new_value;
    int nb_periods = Variables.get_nb_periods();
    std::string name = Variables.get_name(pos + 1);
    Period start = Variables.get_sample().start_period();

    // period as int
    value = 1.2130001;
    EXPECT_DOUBLE_EQ(Variables.get_var(pos, t), value);
    new_value = 10.0;
    Variables.set_var(pos, t, new_value);
    EXPECT_DOUBLE_EQ(Variables.get_var(pos, t), new_value);

    value = -11.028999;
    EXPECT_DOUBLE_EQ(Variables.get_var(name, t), value);
    new_value = 20.0;
    Variables.set_var(name, t, new_value);
    EXPECT_DOUBLE_EQ(Variables.get_var(name, t), new_value);

    // period as Period object
    Period period = start.shift(t + 1);

    value = 5.2020001;
    EXPECT_DOUBLE_EQ(Variables.get_var(pos, period), value);
    new_value = 30.0;
    Variables.set_var(pos, period, new_value);
    EXPECT_DOUBLE_EQ(Variables.get_var(pos, period), new_value);

    value = -15.847;
    EXPECT_DOUBLE_EQ(Variables.get_var(name, period), value);
    new_value = 40.0;
    Variables.set_var(name, period, new_value);
    EXPECT_DOUBLE_EQ(Variables.get_var(name, period), new_value);

    // period as string
    std::string s_period = start.shift(t + 2).to_string();

    value = 9.184;
    EXPECT_DOUBLE_EQ(Variables.get_var(pos, s_period), value);
    new_value = 50.0;
    Variables.set_var(pos, s_period, new_value);
    EXPECT_DOUBLE_EQ(Variables.get_var(pos, s_period), new_value);

    value = -19.288002;
    EXPECT_DOUBLE_EQ(Variables.get_var(name, s_period), value);
    new_value = 60.0;
    Variables.set_var(name, s_period, new_value);
    EXPECT_DOUBLE_EQ(Variables.get_var(name, s_period), new_value);
}

TEST_F(KDBVariablesTest, GetSample)
{
    Sample sample = Variables.get_sample();
    Sample expected_sample("1960Y1", "2015Y1");
    EXPECT_EQ(sample.to_string(), expected_sample.to_string());
}

TEST_F(KDBVariablesTest, GetNbPeriods)
{
    int expected_nb_periods = 56;
    EXPECT_EQ(Variables.get_nb_periods(), expected_nb_periods);
}

TEST_F(KDBVariablesTest, GetPeriod)
{
    Period expected_period(1970, 'Y', 1);
    EXPECT_EQ(Variables.get_period(t), expected_period);
}

TEST_F(KDBVariablesTest, Get)
{
    int nb_periods = Variables.get_nb_periods();
    std::string name = Variables.get_name(pos);
    Variable var;
    Variable expected_var;
    
    expected_var.reserve(nb_periods);
    for (int p = 0; p < nb_periods; p++)
        expected_var.push_back(Variables.get_var(name, p, mode));

    // by position
    var = Variables.get(pos);
    EXPECT_EQ(var, expected_var);

    // by name
    var = Variables.get(name);
    EXPECT_EQ(var, expected_var);
}

TEST_F(KDBVariablesTest, GetNames)
{
    std::vector<std::string> expected_names;
    for (int i=0; i < Variables.count(); i++) expected_names.push_back(Variables.get_name(i));
    std::vector<std::string> names = Variables.get_names();
    EXPECT_EQ(names, expected_names);
}

TEST_F(KDBVariablesTest, CreateRemove)
{
    std::string new_name = "NEW_VAR";
    int nb_periods = Variables.get_nb_periods();

    // pass a vector with values
    Variable new_var;
    new_var.reserve(nb_periods);
    for (int p = 0; p < nb_periods; p++) new_var.push_back(10. + p);

    Variables.add(new_name, new_var);
    EXPECT_EQ(Variables.get(new_name), new_var);

    // --- already existing name
    std::fill(new_var.begin(), new_var.end(), 1);
    EXPECT_THROW(Variables.add(new_name, new_var), IodeExceptionInitialization);

    Variables.remove(new_name);
    EXPECT_THROW(Variables.get(new_name), IodeExceptionFunction);

    // pass a LEC expression
    for (int p = 0; p < nb_periods; p++) new_var[p] = 10. + p;
    Variables.add(new_name, "10 + t");
    EXPECT_EQ(Variables.get(new_name), new_var);
    Variables.remove(new_name);
    
    new_var[0] = L_NAN;
    for (int p = 1; p < nb_periods; p++) new_var[p] = 1. / p;
    Variables.add(new_name, "1 / t");
    EXPECT_EQ(Variables.get(new_name), new_var);
    Variables.remove(new_name);

    std::fill(new_var.begin(), new_var.end(), L_NAN);
    Variables.add(new_name, "");
    EXPECT_EQ(Variables.get(new_name), new_var);
    Variables.remove(new_name);

    // --- using function that does not exist
    EXPECT_THROW(Variables.add("FAILS", "func(t)"), IodeExceptionFunction);
    // --- using variable taht does not exist
    EXPECT_THROW(Variables.add("FAILS", "ln Z"), IodeExceptionFunction);
}

TEST_F(KDBVariablesTest, Update)
{
    std::string name = Variables.get_name(pos);
    int nb_periods = Variables.get_nb_periods();
    std::string lec;
    Variable updated_var;
    updated_var.reserve(nb_periods);

    // by position
    // pass a vector with values
    for (int p = 0; p < nb_periods; p++) updated_var.push_back(10.0 + p);
    Variables.update(pos, updated_var);
    EXPECT_EQ(Variables.get(name), updated_var);
    // pass a LEC expression
    lec = "10 + t";
    Variables.update(pos, lec);
    EXPECT_EQ(Variables.get(name), updated_var);

    // by name
    // pass a vector with values
    for (int p = 0; p < nb_periods; p++) updated_var[p] = 20.0 + p;
    Variables.update(name, updated_var);
    EXPECT_EQ(Variables.get(name), updated_var);
    // pass a LEC expression
    lec = "20 + t";
    Variables.update(name, lec);
    EXPECT_EQ(Variables.get(name), updated_var);
}

TEST_F(KDBVariablesTest, Copy)
{
    std::string name = Variables.get_name(pos);
    Variable var;
    Variable copy_var;

    // by position
    var = Variables.get(pos);
    copy_var = Variables.copy(pos);
    EXPECT_EQ(copy_var, var);

    // by name
    var = Variables.get(name);
    copy_var = Variables.copy(name);
    EXPECT_EQ(copy_var, var);

    // add copy
    Variables.add("DUP_" + name, copy_var);
}

TEST_F(KDBVariablesTest, Filter)
{
    std::string pattern = "A*;*_";
    std::vector<std::string> expected_names;
    KDBVariables* local_kdb;

    std::vector<std::string> all_names;
    for (int p = 0; p < Variables.count(); p++) all_names.push_back(Variables.get_name(p));

    int nb_total_comments = Variables.count();
    // A*
    for (const std::string& name : all_names) if (name.front() == 'A') expected_names.push_back(name);
    // *_
    for (const std::string& name : all_names) if (name.back() == '_') expected_names.push_back(name);

    // remove duplicate entries
    // NOTE: std::unique only removes consecutive duplicated elements, 
    //       so the vector needst to be sorted first
    std::sort(expected_names.begin(), expected_names.end());
    std::vector<std::string>::iterator it = std::unique(expected_names.begin(), expected_names.end());  
    expected_names.resize(std::distance(expected_names.begin(), it));

    // create local kdb
    local_kdb = new KDBVariables(KDB_SHALLOW_COPY, pattern);
    EXPECT_EQ(local_kdb->count(), expected_names.size());

    // modify an element of the local KDB and check if the 
    // corresponding element of the global KDB also changes
    std::string name = "ACAF";
    int nb_periods = Variables.get_nb_periods();
    std::string lec = "10 + t";
    Variable updated_var;
    updated_var.reserve(nb_periods);
    for (int p = 0; p < nb_periods; p++) updated_var.push_back(10. + p);
    local_kdb->update(name, lec);
    EXPECT_EQ(local_kdb->get(name), updated_var);
    EXPECT_EQ(Variables.get(name), updated_var);

    // add an element to the local KDB and check if it has also 
    // been added to the global KDB
    std::string new_name = "NEW_VARIABLE";
    Variable new_var;
    new_var.reserve(nb_periods);
    for (int p = 0; p < nb_periods; p++) new_var.push_back(10. + p);
    local_kdb->add(new_name, new_var);
    EXPECT_EQ(local_kdb->get(new_name), new_var);
    EXPECT_EQ(Variables.get(new_name), new_var);

    // rename an element in the local KDB and check if the 
    // corresponding element has also been renamed in the global KDB
    std::string old_name = new_name;
    new_name = "VARIABLE_NEW";
    local_kdb->rename(old_name, new_name);
    EXPECT_EQ(local_kdb->get(new_name), new_var);
    EXPECT_EQ(Variables.get(new_name), new_var);

    // delete an element from the local KDB and check if it has also 
    // been deleted from the global KDB
    local_kdb->remove(new_name);
    EXPECT_FALSE(local_kdb->contains(new_name));
    EXPECT_FALSE(Variables.contains(new_name));

    // delete local kdb
    delete local_kdb;
    EXPECT_EQ(Variables.count(), nb_total_comments);
    EXPECT_EQ(Variables.get(name), updated_var);
}

TEST_F(KDBVariablesTest, HardCopy)
{
    std::string pattern = "A*;*_";
    std::vector<std::string> expected_names;
    KDBVariables* local_kdb;

    std::vector<std::string> all_names;
    for (int p = 0; p < Variables.count(); p++) all_names.push_back(Variables.get_name(p));

    int nb_total_comments = Variables.count();
    // A*
    for (const std::string& name : all_names) if (name.front() == 'A') expected_names.push_back(name);
    // *_
    for (const std::string& name : all_names) if (name.back() == '_') expected_names.push_back(name);

    // remove duplicate entries
    // NOTE: std::unique only removes consecutive duplicated elements, 
    //       so the vector needst to be sorted first
    std::sort(expected_names.begin(), expected_names.end());
    std::vector<std::string>::iterator it = std::unique(expected_names.begin(), expected_names.end());  
    expected_names.resize(std::distance(expected_names.begin(), it));

    // create local kdb
    local_kdb = new KDBVariables(KDB_LOCAL, pattern);
    EXPECT_EQ(local_kdb->count(), expected_names.size());

    // modify an element of the local KDB and check if the 
    // corresponding element of the global KDB didn't changed
    std::string name = "ACAF";
    Variable var = Variables.get(name);
    int nb_periods = Variables.get_nb_periods();
    std::string lec = "10 + t";
    Variable updated_var;
    updated_var.reserve(nb_periods);
    for (int p = 0; p < nb_periods; p++) updated_var.push_back(10. + p);
    local_kdb->update(name, lec);
    EXPECT_EQ(local_kdb->get(name), updated_var);
    EXPECT_EQ(Variables.get(name), var);

    // add an element to the local KDB and check if it has not 
    // been added to the global KDB
    std::string new_name = "NEW_VARIABLE";
    Variable new_var;
    new_var.reserve(nb_periods);
    for (int p = 0; p < nb_periods; p++) new_var.push_back(10. + p);
    local_kdb->add(new_name, new_var);
    EXPECT_TRUE(local_kdb->contains(new_name));
    EXPECT_EQ(local_kdb->get(new_name), new_var);
    EXPECT_FALSE(Variables.contains(new_name));

    // rename an element in the local KDB and check if the 
    // corresponding element has not been renamed in the global KDB
    name = "ACAG";
    new_name = "VARIABLE_NEW";
    local_kdb->rename(name, new_name);
    EXPECT_TRUE(local_kdb->contains(new_name));
    EXPECT_FALSE(Variables.contains(new_name));

    // delete an element from the local KDB and check if it has not 
    // been deleted from the global KDB
    name = "AOUC";
    local_kdb->remove(name);
    EXPECT_FALSE(local_kdb->contains(name));
    EXPECT_TRUE(Variables.contains(name));

    // delete local kdb
    delete local_kdb;
    EXPECT_EQ(Variables.count(), nb_total_comments);
}

TEST_F(KDBVariablesTest, Merge)
{
    std::string pattern = "A*";

    // create hard copies kdb
    KDBVariables kdb0(KDB_LOCAL, pattern);
    KDBVariables kdb1(KDB_LOCAL, pattern);
    KDBVariables kdb_to_merge(KDB_LOCAL, pattern);

    int nb_periods = kdb_to_merge.get_nb_periods();

    // add an element to the KDB to be merged
    std::string new_name = "NEW_VARIABLE";
    Variable new_var;
    new_var.reserve(nb_periods);
    for (int p = 0; p < nb_periods; p++) new_var.push_back(10. + p);
    kdb_to_merge.add(new_name, new_var);

    // modify an existing element of the KDB to be merge
    std::string name = "ACAF";
    Variable unmodified_var = kdb_to_merge.get(name);
    std::string lec = "10 + t";
    Variable modified_var;
    modified_var.reserve(nb_periods);
    for (int p = 0; p < nb_periods; p++) modified_var.push_back(10. + p);
    kdb_to_merge.update(name, lec);

    // merge (overwrite)
    kdb0.merge(kdb_to_merge, true);
    // a) check kdb0 contains new item of KDB to be merged
    EXPECT_TRUE(kdb0.contains(new_name));
    EXPECT_EQ(kdb0.get(new_name), new_var);
    // b) check already existing item has been overwritten
    EXPECT_EQ(kdb0.get(name), modified_var); 

    // merge (NOT overwrite)
    kdb1.merge(kdb_to_merge, false);
    // b) check already existing item has NOT been overwritten
    EXPECT_EQ(kdb1.get(name), unmodified_var);
}

TEST_F(KDBVariablesTest, AssociatedObjs)
{
    std::string name = "AOUC";
    std::vector<std::string> objs_list;

    load_global_kdb(I_COMMENTS, input_test_dir + "fun.cmt");
    load_global_kdb(I_EQUATIONS, input_test_dir + "fun.eqs");
    load_global_kdb(I_IDENTITIES, input_test_dir + "fun.idt");
    load_global_kdb(I_LISTS, input_test_dir + "fun.lst");
    load_global_kdb(I_SCALARS, input_test_dir + "fun.scl");
    load_global_kdb(I_TABLES, input_test_dir + "fun.tbl");

    std::vector<std::string> expected_cmts = { name };
    objs_list = Variables.get_associated_objects_list(name, I_COMMENTS);
    EXPECT_EQ(objs_list, expected_cmts);

    std::vector<std::string> expected_eqs = { name, "PC", "PIF", "PXS", "QXAB" };
    objs_list = Variables.get_associated_objects_list(name, I_EQUATIONS);
    EXPECT_EQ(objs_list, expected_eqs);

    std::vector<std::string> expected_idt = { name };
    objs_list = Variables.get_associated_objects_list(name, I_IDENTITIES);
    EXPECT_EQ(objs_list, expected_idt);

    std::vector<std::string> expected_lts = { "COPY0", "ENDO0", "TOTAL0" };
    objs_list = Variables.get_associated_objects_list(name, I_LISTS);
    EXPECT_EQ(objs_list, expected_lts);

    objs_list = Variables.get_associated_objects_list(name, I_SCALARS);
    EXPECT_EQ(objs_list.size(), 0);

    std::vector<std::string> expected_tbl = { "ANAPRIX", "MULT1FR", "MULT1RESU", "T1", "T1NIVEAU" };
    objs_list = Variables.get_associated_objects_list(name, I_TABLES);
    EXPECT_EQ(objs_list, expected_tbl);

    std::vector<std::string> expected_vars = { name };
    objs_list = Variables.get_associated_objects_list(name, I_VARIABLES);
    EXPECT_EQ(objs_list, expected_vars);
}

TEST_F(KDBVariablesTest, Hash)
{
    boost::hash<KDBVariables> kdb_hasher;
    std::size_t hash_val = kdb_hasher(Variables);

    // change a name
    Variables.rename("ACAF", "NEW_NAME");
    std::size_t hash_val_modified = kdb_hasher(Variables);
    EXPECT_NE(hash_val, hash_val_modified);
    std::cout << "(rename variable) orignal vs modified hash: " << std::to_string(hash_val) << " vs " << std::to_string(hash_val_modified) << std::endl;

    // modify an entry
    hash_val = hash_val_modified;
    std::string lec = "10 + t";
    Variables.update("NEW_NAME", lec);
    hash_val_modified = kdb_hasher(Variables);
    EXPECT_NE(hash_val, hash_val_modified);
    std::cout << "(modify variable) orignal vs modified hash: " << std::to_string(hash_val) << " vs " << std::to_string(hash_val_modified) << std::endl;

    // remove an entry
    hash_val = hash_val_modified;
    Variables.remove("NEW_NAME");
    hash_val_modified = kdb_hasher(Variables);
    EXPECT_NE(hash_val, hash_val_modified);
    std::cout << "(delete variable) orignal vs modified hash: " << std::to_string(hash_val) << " vs " << std::to_string(hash_val_modified) << std::endl;

    // add an entry
    hash_val = hash_val_modified;
    lec = "20 + t";
    Variables.add("NEW_ENTRY", lec);
    hash_val_modified = kdb_hasher(Variables);
    EXPECT_NE(hash_val, hash_val_modified);   
    std::cout << "(new    variable) orignal vs modified hash: " << std::to_string(hash_val) << " vs " << std::to_string(hash_val_modified) << std::endl; 
}
