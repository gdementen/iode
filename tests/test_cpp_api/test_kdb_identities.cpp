#include "pch.h"


class KDBIdentitiesTest : public KDBTest, public ::testing::Test
{
protected:
    void SetUp() override
    {
        load_global_kdb(I_IDENTITIES, input_test_dir + "fun.idt");
    }

    // void TearDown() override {}
};


TEST_F(KDBIdentitiesTest, Load)
{
    Identities.load(input_test_dir + "fun.idt");
    EXPECT_EQ(Identities.count(), 48);
}

TEST_F(KDBIdentitiesTest, CopyConstructor)
{
    std::string lec = Identities.get_lec("AOUC");
    std::string new_lec = "((WCRH/QL)/(WCRH/QL)[1990Y1])*(VAFF/(VM+VAFF))[-2]+PM*(VM/(VM+VAFF))[-2]";

    // GLOBAL KDB
    KDBIdentities kdb_copy(Identities);
    EXPECT_EQ(kdb_copy.count(), 48);
    EXPECT_TRUE(kdb_copy.is_global_kdb());

    // LOCAL KDB
    KDBIdentities local_kdb(KDB_LOCAL, "A*");
    KDBIdentities local_kdb_hard_copy(local_kdb);
    EXPECT_EQ(local_kdb.count(), local_kdb_hard_copy.count());
    EXPECT_TRUE(local_kdb_hard_copy.is_local_kdb());
    local_kdb_hard_copy.update("AOUC", new_lec);
    EXPECT_EQ(local_kdb.get_lec("AOUC"), lec);
    EXPECT_EQ(local_kdb_hard_copy.get_lec("AOUC"), new_lec);

    // SHALLOW COPY KDB
    KDBIdentities shallow_kdb(KDB_SHALLOW_COPY, "A*");
    KDBIdentities shallow_kdb_copy(shallow_kdb);
    EXPECT_EQ(shallow_kdb.count(), shallow_kdb_copy.count());
    EXPECT_TRUE(shallow_kdb_copy.is_shallow_copy());
    shallow_kdb_copy.update("AOUC", new_lec);
    EXPECT_EQ(shallow_kdb.get_lec("AOUC"), new_lec);
    EXPECT_EQ(shallow_kdb_copy.get_lec("AOUC"), new_lec);
}

TEST_F(KDBIdentitiesTest, Save)
{
    // save in binary format
    save_global_kdb(I_IDENTITIES, output_test_dir + "fun.idt");
    Identities.save(output_test_dir + "fun.idt");

    // save in ascii format
    save_global_kdb(I_IDENTITIES, output_test_dir + "fun.ai");
    Identities.save(output_test_dir + "fun.ai");
}

TEST_F(KDBIdentitiesTest, Rename)
{
    int new_pos;
    std::string old_name;
    std::string new_name;

    // rename
    old_name = Identities.get_name(0);
    EXPECT_EQ(old_name, "AOUC");
    new_pos = Identities.rename(old_name, "NEW_NAME");
    EXPECT_EQ(Identities.get_name(new_pos), "NEW_NAME");

    // set by position
    new_pos = Identities.set_name(1, "NEW_POS");
    EXPECT_EQ(Identities.get_name(new_pos), "NEW_POS");
}

TEST_F(KDBIdentitiesTest, GetLec)
{
    int pos = 0;
    std::string name = Identities.get_name(pos);
    std::string lec;
    std::string expected_lec = "((WCRH/QL)/(WCRH/QL)[1990Y1])*(VAFF/(VM+VAFF))[-1]+PM*(VM/(VM+VAFF))[-1]";

    // by position
    lec = Identities.get_lec(pos);
    EXPECT_EQ(lec, expected_lec);

    // by name
    lec = Identities.get_lec(name);
    EXPECT_EQ(lec, expected_lec);
}

TEST_F(KDBIdentitiesTest, Get)
{
    int pos = 0;
    std::string name = Identities.get_name(pos);
    CLEC* expected_clec = KICLEC(K_WS[I_IDENTITIES], pos);
    std::string expected_lec = "((WCRH/QL)/(WCRH/QL)[1990Y1])*(VAFF/(VM+VAFF))[-1]+PM*(VM/(VM+VAFF))[-1]";

    // by position
    Identity identity_pos = Identities.get(pos);
    EXPECT_EQ(identity_pos.get_lec(), expected_lec);
    EXPECT_TRUE(memcmp(identity_pos.get_clec(), expected_clec, expected_clec->tot_lg) == 0);

    // by name
    Identity identity_name = Identities.get(name);
    EXPECT_EQ(identity_name.get_lec(), expected_lec);
    EXPECT_TRUE(memcmp(identity_name.get_clec(), expected_clec, expected_clec->tot_lg) == 0);
}

TEST_F(KDBIdentitiesTest, GetNames)
{
    std::vector<std::string> expected_names;
    for (int i=0; i < Identities.count(); i++) expected_names.push_back(Identities.get_name(i));
    std::vector<std::string> names = Identities.get_names();
    EXPECT_EQ(names, expected_names);
}

TEST_F(KDBIdentitiesTest, CreateRemove)
{
    std::string name = Identities.get_name(0);
    std::string lec = "((WCRH/QL)/(WCRH/QL)[1990Y1])*(VAFF/(VM+VAFF))[-1]+PM*(VM/(VM+VAFF))[-1]";

    Identities.remove(name);
    EXPECT_THROW(Identities.get(name), IodeExceptionFunction);

    Identities.add(name, lec);
    EXPECT_EQ(Identities.get_lec(name), lec);
}

TEST_F(KDBIdentitiesTest, Update)
{
    std::string name = Identities.get_name(0);
    std::string new_lec = "((WCRH/QL)/(WCRH/QL)[1990Y1])*(VAFF/(VM+VAFF))[-2]+PM*(VM/(VM+VAFF))[-2]";

    Identities.update(name, new_lec);
    EXPECT_EQ(Identities.get_lec(name), new_lec);
}

TEST_F(KDBIdentitiesTest, Copy)
{
    int pos = 0;
    std::string name = Identities.get_name(pos);

    Identity identity_copy = Identities.copy(name);

    EXPECT_EQ(identity_copy.get_lec(), Identities.get_lec(name));

    // add copy
    Identities.add("DUP_" + name, identity_copy);
}

TEST_F(KDBIdentitiesTest, Filter)
{
    std::string pattern = "A*;*_";
    std::vector<std::string> expected_names;
    KDBIdentities* local_kdb;

    std::vector<std::string> all_names;
    for (int p = 0; p < Identities.count(); p++) all_names.push_back(Identities.get_name(p));

    int nb_total_comments = Identities.count();
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
    local_kdb = new KDBIdentities(KDB_SHALLOW_COPY, pattern);
    EXPECT_EQ(local_kdb->count(), expected_names.size());

    // modify an element of the local KDB and check if the 
    // corresponding element of the global KDB also changes
    std::string name = "AOUC";
    std::string modified_lec = "((WCRH/QL)/(WCRH/QL)[1990Y1])*(VAFF/(VM+VAFF))[-2]+PM*(VM/(VM+VAFF))[-2]";
    local_kdb->update(name, modified_lec);
    EXPECT_EQ(local_kdb->get_lec(name), modified_lec);
    EXPECT_EQ(Identities.get_lec(name), modified_lec);

    // add an element to the local KDB and check if it has also 
    // been added to the global KDB
    std::string new_name = "NEW_IDENTITY";
    std::string new_lec = "((WCRH/QL)/(WCRH/QL)[1990Y1])*(VAFF/(VM+VAFF))[-1]+PM*(VM/(VM+VAFF))[-1]";
    local_kdb->add(new_name, new_lec);
    EXPECT_EQ(local_kdb->get_lec(new_name), new_lec);
    EXPECT_EQ(Identities.get_lec(new_name), new_lec);

    // rename an element in the local KDB and check if the 
    // corresponding element has also been renamed in the global KDB
    std::string old_name = new_name;
    new_name = "IDENTITY_NEW";
    local_kdb->rename(old_name, new_name);
    EXPECT_EQ(local_kdb->get_lec(new_name), new_lec);
    EXPECT_EQ(Identities.get_lec(new_name), new_lec);

    // delete an element from the local KDB and check if it has also 
    // been deleted from the global KDB
    local_kdb->remove(new_name);
    EXPECT_FALSE(local_kdb->contains(new_name));
    EXPECT_FALSE(Identities.contains(new_name));

    // delete local kdb
    delete local_kdb;
    EXPECT_EQ(Identities.count(), nb_total_comments);
    EXPECT_EQ(Identities.get_lec(name), modified_lec);
}

TEST_F(KDBIdentitiesTest, HardCopy)
{
    std::string pattern = "A*;*_";
    std::vector<std::string> expected_names;
    KDBIdentities* local_kdb;

    std::vector<std::string> all_names;
    for (int p = 0; p < Identities.count(); p++) all_names.push_back(Identities.get_name(p));

    int nb_total_comments = Identities.count();
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
    local_kdb = new KDBIdentities(KDB_LOCAL, pattern);
    EXPECT_EQ(local_kdb->count(), expected_names.size());

    // modify an element of the local KDB and check if the 
    // corresponding element of the global KDB didn't changed
    std::string name = "AOUC";
    std::string lec = Identities.get_lec(name);
    std::string modified_lec = "((WCRH/QL)/(WCRH/QL)[1990Y1])*(VAFF/(VM+VAFF))[-2]+PM*(VM/(VM+VAFF))[-2]";
    local_kdb->update(name, modified_lec);
    EXPECT_EQ(local_kdb->get_lec(name), modified_lec);
    EXPECT_EQ(Identities.get_lec(name), lec);

    // add an element to the local KDB and check if it has not 
    // been added to the global KDB
    std::string new_name = "NEW_IDENTITY";
    std::string new_lec = "((WCRH/QL)/(WCRH/QL)[1990Y1])*(VAFF/(VM+VAFF))[-1]+PM*(VM/(VM+VAFF))[-1]";
    local_kdb->add(new_name, new_lec);
    EXPECT_TRUE(local_kdb->contains(new_name));
    EXPECT_EQ(local_kdb->get_lec(new_name), new_lec);
    EXPECT_FALSE(Identities.contains(new_name));

    // rename an element in the local KDB and check if the 
    // corresponding element has not been renamed in the global KDB
    std::string old_name = "AOUC_";
    new_name = "IDENTITY_NEW";
    local_kdb->rename(old_name, new_name);
    EXPECT_TRUE(local_kdb->contains(new_name));
    EXPECT_FALSE(Identities.contains(new_name));

    // delete an element from the local KDB and check if it has not 
    // been deleted from the global KDB
    name = "GAP_";
    local_kdb->remove(name);
    EXPECT_FALSE(local_kdb->contains(name));
    EXPECT_TRUE(Identities.contains(name));

    // delete local kdb
    delete local_kdb;
    EXPECT_EQ(Identities.count(), nb_total_comments);
}


// QUESTION FOR JMP: How to test with variables file, scalars file and trace ?
TEST_F(KDBIdentitiesTest, ExecuteIdentities)
{
    int y_from = 1991;
    int y_to = 2000;
    // GAP2 "100*(QAFF_/(Q_F+Q_I))"
    // GAP_ "100*((QAF_/Q_F)-1)"
    std::string identities_list = "GAP2;GAP_";

    load_global_kdb(I_VARIABLES, input_test_dir + "fun.var");
    KDBVariables kdb_var;

    std::string period;
    Variable expected_gap2;
    Variable expected_gap_;
    expected_gap2.reserve(10);
    expected_gap_.reserve(10);
    IODE_REAL qaff_;
    IODE_REAL qaf_;
    IODE_REAL q_f;
    IODE_REAL q_i;
    for (int y=y_from; y <= y_to; y++)
    {
        period = std::to_string(y) + "Y1";
        // reset GAP2 and GAP_
        kdb_var.set_var("GAP2", period, 0.0);
        kdb_var.set_var("GAP_", period, 0.0);
        // compute values of GAP2 and GAP_
        qaff_ = kdb_var.get_var("QAFF_", period);
        qaf_ = kdb_var.get_var("QAF_", period);
        q_f = kdb_var.get_var("Q_F", period);
        q_i = kdb_var.get_var("Q_I", period);
        expected_gap2.push_back(100.0 * (qaff_ / (q_f + q_i)));
        expected_gap_.push_back(100.0 * ((qaf_ / q_f) - 1.0));
    }

    // compute GAP2 and GAP_
    Identities.execute_identities(std::to_string(y_from)+"Y1", std::to_string(y_to)+"Y1", identities_list);

    Variable computed_gap2;
    Variable computed_gap_;
    computed_gap2.reserve(10);
    computed_gap_.reserve(10);
    for (int y=y_from; y <= y_to; y++)
    {
        period = std::to_string(y) + "Y1";
        computed_gap2.push_back(kdb_var.get_var("GAP2", period));
        computed_gap_.push_back(kdb_var.get_var("GAP_", period));
    }

    EXPECT_DOUBLE_EQ(computed_gap2[0], expected_gap2[0]);
    EXPECT_DOUBLE_EQ(computed_gap_[0], expected_gap_[0]);

    EXPECT_DOUBLE_EQ(computed_gap2[4], expected_gap2[4]);
    EXPECT_DOUBLE_EQ(computed_gap_[4], expected_gap_[4]);

    EXPECT_DOUBLE_EQ(computed_gap2[9], expected_gap2[9]);
    EXPECT_DOUBLE_EQ(computed_gap_[9], expected_gap_[9]);
}

TEST_F(KDBIdentitiesTest, Merge)
{
    std::string pattern = "A*";

    // create hard copies kdb
    KDBIdentities kdb0(KDB_LOCAL, pattern);
    KDBIdentities kdb1(KDB_LOCAL, pattern);
    KDBIdentities kdb_to_merge(KDB_LOCAL, pattern);

    // add an element to the KDB to be merged
    std::string new_name = "NEW_IDENTITY";
    std::string new_lec = "((WCRH/QL)/(WCRH/QL)[1990Y1])*(VAFF/(VM+VAFF))[-1]+PM*(VM/(VM+VAFF))[-1]";
    kdb_to_merge.add(new_name, new_lec);

    // modify an existing element of the KDB to be merge
    std::string name = "AOUC";
    std::string unmodified_lec = kdb_to_merge.get_lec(name);
    std::string modified_lec = "((WCRH/QL)/(WCRH/QL)[1990Y1])*(VAFF/(VM+VAFF))[-2]+PM*(VM/(VM+VAFF))[-2]";
    kdb_to_merge.update(name, modified_lec);

    // merge (overwrite)
    kdb0.merge(kdb_to_merge, true);
    // a) check kdb0 contains new item of KDB to be merged
    EXPECT_TRUE(kdb0.contains(new_name));
    EXPECT_EQ(kdb0.get_lec(new_name), new_lec);
    // b) check already existing item has been overwritten
    EXPECT_EQ(kdb0.get_lec(name), modified_lec); 

    // merge (NOT overwrite)
    kdb1.merge(kdb_to_merge, false);
    // b) check already existing item has NOT been overwritten
    EXPECT_EQ(kdb1.get_lec(name), unmodified_lec);
}

TEST_F(KDBIdentitiesTest, AssociatedObjs)
{
    std::string name = "RENT";
    std::vector<std::string> objs_list;

    load_global_kdb(I_COMMENTS, input_test_dir + "fun.cmt");
    load_global_kdb(I_EQUATIONS, input_test_dir + "fun.eqs");
    load_global_kdb(I_LISTS, input_test_dir + "fun.lst");
    load_global_kdb(I_SCALARS, input_test_dir + "fun.scl");
    load_global_kdb(I_TABLES, input_test_dir + "fun.tbl");
    load_global_kdb(I_VARIABLES, input_test_dir + "fun.var");

    objs_list = Identities.get_associated_objects_list(name, I_COMMENTS);
    EXPECT_EQ(objs_list.size(), 0);

    std::vector<std::string> expected_eqs = { name };
    objs_list = Identities.get_associated_objects_list(name, I_EQUATIONS);
    EXPECT_EQ(objs_list, expected_eqs);

    std::vector<std::string> expected_idt = { name };
    objs_list = Identities.get_associated_objects_list(name, I_IDENTITIES);
    EXPECT_EQ(objs_list, expected_idt);

    std::vector<std::string> expected_lts = { "ENDO0", "IDT", "TOTAL0" };
    objs_list = Identities.get_associated_objects_list(name, I_LISTS);
    EXPECT_EQ(objs_list, expected_lts);

    objs_list = Identities.get_associated_objects_list(name, I_SCALARS);
    EXPECT_EQ(objs_list.size(), 0);

    std::vector<std::string> expected_tbl = { "ANAKNFF", "C8_4", "MULT2FR", "MULT2RESU", "T2" };
    objs_list = Identities.get_associated_objects_list(name, I_TABLES);
    EXPECT_EQ(objs_list, expected_tbl);

    std::vector<std::string> expected_vars = { name };
    objs_list = Identities.get_associated_objects_list(name, I_VARIABLES);
    EXPECT_EQ(objs_list, expected_vars);
}

TEST_F(KDBIdentitiesTest, Hash)
{
    boost::hash<KDBIdentities> kdb_hasher;
    std::size_t hash_val = kdb_hasher(Identities);

    // change a name
    Identities.rename("AOUC", "NEW_NAME");
    std::size_t hash_val_modified = kdb_hasher(Identities);
    EXPECT_NE(hash_val, hash_val_modified);
    std::cout << "(rename identity) orignal vs modified hash: " << std::to_string(hash_val) << " vs " << std::to_string(hash_val_modified) << std::endl;

    // modify an entry
    hash_val = hash_val_modified;
    std::string new_lec = "((WCRH/QL)/(WCRH/QL)[1990Y1])*(VAFF/(VM+VAFF))[-2]+PM*(VM/(VM+VAFF))[-2]";
    Identities.update("NEW_NAME", new_lec);
    hash_val_modified = kdb_hasher(Identities);
    EXPECT_NE(hash_val, hash_val_modified);
    std::cout << "(modify identity) orignal vs modified hash: " << std::to_string(hash_val) << " vs " << std::to_string(hash_val_modified) << std::endl;

    // remove an entry
    hash_val = hash_val_modified;
    Identities.remove("NEW_NAME");
    hash_val_modified = kdb_hasher(Identities);
    EXPECT_NE(hash_val, hash_val_modified);
    std::cout << "(delete identity) orignal vs modified hash: " << std::to_string(hash_val) << " vs " << std::to_string(hash_val_modified) << std::endl;

    // add an entry
    hash_val = hash_val_modified;
    std::string lec = "((WCRH/QL)/(WCRH/QL)[1990Y1])*(VAFF/(VM+VAFF))[-1]+PM*(VM/(VM+VAFF))[-1]";
    Identities.add("NEW_ENTRY", lec);
    hash_val_modified = kdb_hasher(Identities);
    EXPECT_NE(hash_val, hash_val_modified);   
    std::cout << "(new    identity) orignal vs modified hash: " << std::to_string(hash_val) << " vs " << std::to_string(hash_val_modified) << std::endl; 
}
