#include "pch.h"


class KDBListsTest : public KDBTest, public ::testing::Test
{
protected:
    KDBLists kdb;

    void SetUp() override
    {
        load_global_kdb(I_LISTS, input_test_dir + "fun.lst");
    }

    // void TearDown() override {}
};


TEST_F(KDBListsTest, Load)
{
    KDBLists kdb2;
    EXPECT_EQ(kdb2.count(), 16);
}

TEST_F(KDBListsTest, Save)
{
    // save in binary format
    save_global_kdb(I_LISTS, output_test_dir + "fun.lst");
    kdb.dump(output_test_dir + "fun.lst");

    // save in ascii format
    save_global_kdb(I_LISTS, output_test_dir + "fun.al");
    kdb.dump(output_test_dir + "fun.al");
}

TEST_F(KDBListsTest, Get)
{
    int pos = 0;
    std::string list;
    std::string expected_list = "$COPY0;$COPY1;";

    // by position
    list = kdb.get(pos);
    EXPECT_EQ(expected_list, list);

    // by name
    std::string name = kdb.get_name(pos);
    list = kdb.get(name);
    EXPECT_EQ(expected_list, list);
}

TEST_F(KDBListsTest, CreateRemove)
{
    std::string name = "A_COMMENTS";
    std::string new_list = "ACAF;ACAG;AOUC;AQC";

    kdb.add(name, new_list);
    ASSERT_EQ(kdb.get(name), new_list);

    kdb.remove(name);
    EXPECT_THROW(kdb.get(name), std::runtime_error);
}

TEST_F(KDBListsTest, Update)
{
    std::string expanded_list = kdb.get("COPY0") + kdb.get("COPY1");

    kdb.update("COPY", expanded_list);
    EXPECT_EQ(kdb.get("COPY"), expanded_list);
}

TEST_F(KDBListsTest, Copy)
{
    std::string name = "COPY";
    std::string list = kdb.get(name);

    std::string list_copy = kdb.copy(name);
    EXPECT_EQ(list_copy, list);
}

TEST_F(KDBListsTest, Filter)
{
    std::string pattern = "C*";
    std::vector<std::string> expected_names;
    KDBLists* local_kdb;
    KDBLists global_kdb;

    std::vector<std::string> all_names;
    for (int p = 0; p < global_kdb.count(); p++) all_names.push_back(global_kdb.get_name(p));
    for (const std::string& name : all_names) if (name.front() == 'C') expected_names.push_back(name);

    int nb_total_comments = global_kdb.count();

    // create local kdb
    local_kdb = new KDBLists(pattern);
    EXPECT_EQ(local_kdb->count(), expected_names.size());

    // modify an element of the local KDB and check if the 
    // corresponding element of the global KDB also changes
    std::string name = "COPY";
    std::string expanded_list = kdb.get("COPY0") + kdb.get("COPY1");
    kdb.update(name, expanded_list);
    EXPECT_EQ(local_kdb->get(name), expanded_list);
    EXPECT_EQ(global_kdb.get(name), expanded_list);

    // add an element to the local KDB and check if it has also 
    // been added to the global KDB
    std::string new_name = "NEW_LIST";
    std::string new_list = "ACAF;ACAG;AOUC;AQC";
    local_kdb->add(new_name, new_list);
    EXPECT_EQ(local_kdb->get(new_name), new_list);
    EXPECT_EQ(global_kdb.get(new_name), new_list);

    // rename an element in the local KDB and check if the 
    // corresponding element has also been renamed in the global KDB
    std::string old_name = new_name;
    new_name = "LIST_NEW";
    local_kdb->rename(old_name, new_name);
    EXPECT_EQ(local_kdb->get(new_name), new_list);
    EXPECT_EQ(global_kdb.get(new_name), new_list);

    // delete an element from the local KDB and check if it has also 
    // been deleted from the global KDB
    local_kdb->remove(new_name);
    EXPECT_FALSE(local_kdb->contains(new_name));
    EXPECT_FALSE(global_kdb.contains(new_name));

    // delete local kdb
    delete local_kdb;
    EXPECT_EQ(global_kdb.count(), nb_total_comments);
    EXPECT_EQ(global_kdb.get(name), expanded_list);
}
