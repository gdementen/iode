#include "pch.h"


class KDBIdentitiesTest : public KDBTest, public ::testing::Test
{
protected:
    KDBIdentities kdb;

    void SetUp() override
    {
        load_global_kdb(I_IDENTITIES, input_test_dir + "fun.idt");
    }

    // void TearDown() override {}
};


TEST_F(KDBIdentitiesTest, Load)
{
    KDBIdentities kdb2;
    EXPECT_EQ(kdb2.count(), 48);
}

TEST_F(KDBIdentitiesTest, Save)
{
    // save in binary format
    save_global_kdb(I_IDENTITIES, output_test_dir + "fun.idt");
    kdb.dump(output_test_dir + "fun.idt");

    // save in ascii format
    save_global_kdb(I_IDENTITIES, output_test_dir + "fun.ai");
    kdb.dump(output_test_dir + "fun.ai");
}

TEST_F(KDBIdentitiesTest, Rename)
{
    int new_pos;
    std::string old_name;
    std::string new_name;

    // rename
    old_name = kdb.get_name(0);
    EXPECT_EQ(old_name, "AOUC");
    new_pos = kdb.rename(old_name, "NEW_NAME");
    EXPECT_EQ(kdb.get_name(new_pos), "NEW_NAME");

    // set by position
    new_pos = kdb.set_name(1, "NEW_POS");
    EXPECT_EQ(kdb.get_name(new_pos), "NEW_POS");
}

TEST_F(KDBIdentitiesTest, GetLec)
{
    int pos = 0;
    std::string name = kdb.get_name(pos);
    std::string lec;
    std::string expected_lec = "((WCRH/QL)/(WCRH/QL)[1990Y1])*(VAFF/(VM+VAFF))[-1]+PM*(VM/(VM+VAFF))[-1]";

    // by position
    lec = kdb.get_lec(pos);
    EXPECT_EQ(lec, expected_lec);

    // by name
    lec = kdb.get_lec(name);
    EXPECT_EQ(lec, expected_lec);
}

TEST_F(KDBIdentitiesTest, Get)
{
    int pos = 0;
    std::string name = kdb.get_name(pos);
    CLEC* expected_clec = KICLEC(K_WS[I_IDENTITIES], pos);
    std::string expected_lec = "((WCRH/QL)/(WCRH/QL)[1990Y1])*(VAFF/(VM+VAFF))[-1]+PM*(VM/(VM+VAFF))[-1]";

    // by position
    Identity identity_pos = kdb.get(pos);
    EXPECT_EQ(identity_pos.lec, expected_lec);
    EXPECT_EQ(identity_pos.clec, expected_clec);

    // by name
    Identity identity_name = kdb.get(name);
    EXPECT_EQ(identity_name.lec, expected_lec);
    EXPECT_EQ(identity_name.clec, expected_clec);
}

TEST_F(KDBIdentitiesTest, CreateRemove)
{
    std::string name = kdb.get_name(0);
    std::string lec = "((WCRH/QL)/(WCRH/QL)[1990Y1])*(VAFF/(VM+VAFF))[-1]+PM*(VM/(VM+VAFF))[-1]";

    kdb.remove(name);
    EXPECT_THROW(kdb.get(name), std::runtime_error);

    kdb.add(name, lec);
    EXPECT_EQ(kdb.get_lec(name), lec);
}

TEST_F(KDBIdentitiesTest, Update)
{
    std::string name = kdb.get_name(0);
    std::string new_lec = "((WCRH/QL)/(WCRH/QL)[1990Y1])*(VAFF/(VM+VAFF))[-2]+PM*(VM/(VM+VAFF))[-2]";

    kdb.update(name, new_lec);
    EXPECT_EQ(kdb.get_lec(name), new_lec);
}

TEST_F(KDBIdentitiesTest, Copy)
{
    std::string name = kdb.get_name(0);

    Identity identity_copy = kdb.copy(name);

    EXPECT_EQ(std::string(identity_copy.lec), kdb.get_lec(name));
}

TEST_F(KDBIdentitiesTest, Filter)
{
    std::string pattern = "A*;*_";
    std::vector<std::string> expected_names;
    KDBIdentities* local_kdb;
    KDBIdentities global_kdb;

    std::vector<std::string> all_names;
    for (int p = 0; p < global_kdb.count(); p++) all_names.push_back(global_kdb.get_name(p));

    int nb_total_comments = global_kdb.count();
    // A*
    for (const std::string& name : all_names) if (name.front() == 'A') expected_names.push_back(name);
    // *_
    for (const std::string& name : all_names) if (name.back() == '_') expected_names.push_back(name);

    // create local kdb
    local_kdb = new KDBIdentities(pattern);
    EXPECT_EQ(local_kdb->count(), expected_names.size());

    // modify an element of the local KDB and check if the 
    // corresponding element of the global KDB also changes
    std::string name = "AOUC";
    std::string modified_lec = "((WCRH/QL)/(WCRH/QL)[1990Y1])*(VAFF/(VM+VAFF))[-2]+PM*(VM/(VM+VAFF))[-2]";
    local_kdb->update(name, modified_lec);
    EXPECT_EQ(local_kdb->get_lec(name), modified_lec);
    EXPECT_EQ(global_kdb.get_lec(name), modified_lec);

    // add an element to the local KDB and check if it has also 
    // been added to the global KDB
    std::string new_name = "NEW_IDENTITY";
    std::string new_lec = "((WCRH/QL)/(WCRH/QL)[1990Y1])*(VAFF/(VM+VAFF))[-1]+PM*(VM/(VM+VAFF))[-1]";
    local_kdb->add(new_name, new_lec);
    EXPECT_EQ(local_kdb->get_lec(new_name), new_lec);
    EXPECT_EQ(global_kdb.get_lec(new_name), new_lec);

    // rename an element in the local KDB and check if the 
    // corresponding element has also been renamed in the global KDB
    std::string old_name = new_name;
    new_name = "IDENTITY_NEW";
    local_kdb->rename(old_name, new_name);
    EXPECT_EQ(local_kdb->get_lec(new_name), new_lec);
    EXPECT_EQ(global_kdb.get_lec(new_name), new_lec);

    // delete an element from the local KDB and check if it has also 
    // been deleted from the global KDB
    local_kdb->remove(new_name);
    EXPECT_FALSE(local_kdb->contains(new_name));
    EXPECT_FALSE(global_kdb.contains(new_name));

    // delete local kdb
    delete local_kdb;
    EXPECT_EQ(global_kdb.count(), nb_total_comments);
    EXPECT_EQ(global_kdb.get_lec(name), modified_lec);
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
    kdb.execute_identities(std::to_string(y_from)+"Y1", std::to_string(y_to)+"Y1", identities_list);

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
