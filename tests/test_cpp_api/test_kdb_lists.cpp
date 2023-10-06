#include "pch.h"


class KDBListsTest : public KDBTest, public ::testing::Test
{
protected:
    void SetUp() override
    {
        load_global_kdb(I_LISTS, input_test_dir + "fun.lst");
    }

    // void TearDown() override {}
};


TEST_F(KDBListsTest, Load)
{
    KDBLists kdb2;
    EXPECT_EQ(kdb2.count(), 17);

    KDBLists kdb3(input_test_dir + "fun.lst");
    EXPECT_EQ(kdb3.count(), 17);
}

TEST_F(KDBListsTest, CopyConstructor)
{
    std::string list = Lists.get("COPY");
    std::string new_list = "ACAF;ACAG;AOUC;AQC";

    // GLOBAL KDB
    KDBLists kdb_copy(Lists);
    EXPECT_EQ(kdb_copy.count(), 17);
    EXPECT_TRUE(kdb_copy.is_global_kdb());

    // LOCAL KDB
    KDBLists local_kdb(KDB_LOCAL, "C*");
    KDBLists local_kdb_hard_copy(local_kdb);
    EXPECT_EQ(local_kdb.count(), local_kdb_hard_copy.count());
    EXPECT_TRUE(local_kdb_hard_copy.is_local_kdb());
    local_kdb_hard_copy.update("COPY", new_list);
    EXPECT_EQ(local_kdb.get("COPY"), list);
    EXPECT_EQ(local_kdb_hard_copy.get("COPY"), new_list);

    // SHALLOW COPY KDB
    KDBLists shallow_kdb(KDB_SHALLOW_COPY, "C*");
    KDBLists shallow_kdb_copy(shallow_kdb);
    EXPECT_EQ(shallow_kdb.count(), shallow_kdb_copy.count());
    EXPECT_TRUE(shallow_kdb_copy.is_shallow_copy());
    shallow_kdb_copy.update("COPY", new_list);
    EXPECT_EQ(shallow_kdb.get("COPY"), new_list);
    EXPECT_EQ(shallow_kdb_copy.get("COPY"), new_list);
}

TEST_F(KDBListsTest, Save)
{
    // save in binary format
    save_global_kdb(I_LISTS, output_test_dir + "fun.lst");
    Lists.save(output_test_dir + "fun.lst");

    // save in ascii format
    save_global_kdb(I_LISTS, output_test_dir + "fun.al");
    Lists.save(output_test_dir + "fun.al");
}

TEST_F(KDBListsTest, Get)
{
    int pos = 0;
    std::string list;
    std::string expected_list = "$COPY0;$COPY1;";

    // by position
    list = Lists.get(pos);
    EXPECT_EQ(expected_list, list);

    // by name
    std::string name = Lists.get_name(pos);
    list = Lists.get(name);
    EXPECT_EQ(expected_list, list);
}

TEST_F(KDBListsTest, GetNames)
{
    std::vector<std::string> expected_names;
    for (int i=0; i < Lists.count(); i++) expected_names.push_back(Lists.get_name(i));
    std::vector<std::string> names = Lists.get_names();
    EXPECT_EQ(names, expected_names);
}

TEST_F(KDBListsTest, CreateRemove)
{
    std::string name = "A_COMMENTS";
    std::string new_list = "ACAF;ACAG;AOUC;AQC";

    Lists.add(name, new_list);
    ASSERT_EQ(Lists.get(name), new_list);

    Lists.remove(name);
    EXPECT_THROW(Lists.get(name), IodeExceptionFunction);
}

TEST_F(KDBListsTest, Update)
{
    std::string expanded_list = Lists.get("COPY0") + Lists.get("COPY1");

    Lists.update("COPY", expanded_list);
    EXPECT_EQ(Lists.get("COPY"), expanded_list);
}

TEST_F(KDBListsTest, Copy)
{
    std::string name = "COPY";
    std::string list = Lists.get(name);

    std::string list_copy = Lists.copy(name);
    EXPECT_EQ(list_copy, list);

    // add copy
    Lists.add("DUP_" + name, list_copy);
}

TEST_F(KDBListsTest, Filter)
{
    std::string pattern = "C*";
    std::vector<std::string> expected_names;
    KDBLists* local_kdb;

    std::vector<std::string> all_names;
    for (int p = 0; p < Lists.count(); p++) all_names.push_back(Lists.get_name(p));
    for (const std::string& name : all_names) if (name.front() == 'C') expected_names.push_back(name);

    int nb_total_comments = Lists.count();

    // remove duplicate entries
    // NOTE: std::unique only removes consecutive duplicated elements, 
    //       so the vector needst to be sorted first
    std::sort(expected_names.begin(), expected_names.end());
    std::vector<std::string>::iterator it = std::unique(expected_names.begin(), expected_names.end());  
    expected_names.resize(std::distance(expected_names.begin(), it));

    // create local kdb
    local_kdb = new KDBLists(KDB_SHALLOW_COPY, pattern);
    EXPECT_EQ(local_kdb->count(), expected_names.size());

    // modify an element of the local KDB and check if the 
    // corresponding element of the global KDB also changes
    std::string name = "COPY";
    std::string expanded_list = Lists.get("COPY0") + Lists.get("COPY1");
    local_kdb->update(name, expanded_list);
    EXPECT_EQ(local_kdb->get(name), expanded_list);
    EXPECT_EQ(Lists.get(name), expanded_list);

    // add an element to the local KDB and check if it has also 
    // been added to the global KDB
    std::string new_name = "NEW_LIST";
    std::string new_list = "ACAF;ACAG;AOUC;AQC";
    local_kdb->add(new_name, new_list);
    EXPECT_EQ(local_kdb->get(new_name), new_list);
    EXPECT_EQ(Lists.get(new_name), new_list);

    // rename an element in the local KDB and check if the 
    // corresponding element has also been renamed in the global KDB
    std::string old_name = new_name;
    new_name = "LIST_NEW";
    local_kdb->rename(old_name, new_name);
    EXPECT_EQ(local_kdb->get(new_name), new_list);
    EXPECT_EQ(Lists.get(new_name), new_list);

    // delete an element from the local KDB and check if it has also 
    // been deleted from the global KDB
    local_kdb->remove(new_name);
    EXPECT_FALSE(local_kdb->contains(new_name));
    EXPECT_FALSE(Lists.contains(new_name));

    // delete local kdb
    delete local_kdb;
    EXPECT_EQ(Lists.count(), nb_total_comments);
    EXPECT_EQ(Lists.get(name), expanded_list);
}

TEST_F(KDBListsTest, HardCopy)
{
    std::string pattern = "C*";
    std::vector<std::string> expected_names;
    KDBLists* local_kdb;

    std::vector<std::string> all_names;
    for (int p = 0; p < Lists.count(); p++) all_names.push_back(Lists.get_name(p));
    for (const std::string& name : all_names) if (name.front() == 'C') expected_names.push_back(name);

    // remove duplicate entries
    // NOTE: std::unique only removes consecutive duplicated elements, 
    //       so the vector needst to be sorted first
    std::sort(expected_names.begin(), expected_names.end());
    std::vector<std::string>::iterator it = std::unique(expected_names.begin(), expected_names.end());  
    expected_names.resize(std::distance(expected_names.begin(), it));

    int nb_total_comments = Lists.count();

    // create local kdb
    local_kdb = new KDBLists(KDB_LOCAL, pattern);
    EXPECT_EQ(local_kdb->count(), expected_names.size());

    // modify an element of the local KDB and check if the 
    // corresponding element of the global KDB didn't changed
    std::string name = "COPY";
    std::string list = Lists.get(name);
    std::string expanded_list = Lists.get("COPY0") + Lists.get("COPY1");
    local_kdb->update(name, expanded_list);
    EXPECT_EQ(local_kdb->get(name), expanded_list);
    EXPECT_EQ(Lists.get(name), list);

    // add an element to the local KDB and check if it has not 
    // been added to the global KDB
    std::string new_name = "NEW_LIST";
    std::string new_list = "ACAF;ACAG;AOUC;AQC";
    local_kdb->add(new_name, new_list);
    EXPECT_TRUE(local_kdb->contains(new_name));
    EXPECT_EQ(local_kdb->get(new_name), new_list);
    EXPECT_FALSE(Lists.contains(new_name));

    // rename an element in the local KDB and check if the 
    // corresponding element has not been renamed in the global KDB
    name = "COPY0";
    new_name = "LIST_NEW";
    local_kdb->rename(name, new_name);
    EXPECT_TRUE(local_kdb->contains(new_name));
    EXPECT_FALSE(Lists.contains(new_name));

    // delete an element from the local KDB and check if it has not 
    // been deleted from the global KDB
    name = "COPY1";
    local_kdb->remove(name);
    EXPECT_FALSE(local_kdb->contains(name));
    EXPECT_TRUE(Lists.contains(name));

    // delete local kdb
    delete local_kdb;
    EXPECT_EQ(Lists.count(), nb_total_comments);
}

TEST_F(KDBListsTest, Merge)
{
    std::string pattern = "C*";

    // create hard copies kdb
    KDBLists kdb0(KDB_LOCAL, pattern);
    KDBLists kdb1(KDB_LOCAL, pattern);
    KDBLists kdb_to_merge(KDB_LOCAL, pattern);

    // add an element to the KDB to be merged
    std::string new_name = "NEW_LIST";
    std::string new_list = "ACAF;ACAG;AOUC;AQC";
    kdb_to_merge.add(new_name, new_list);

    // modify an existing element of the KDB to be merge
    std::string name = "COPY";
    std::string unmodified_list = kdb_to_merge.get(name);
    std::string modified_list = kdb_to_merge.get("COPY0") + kdb_to_merge.get("COPY1");
    kdb_to_merge.update(name, modified_list);


    // merge (overwrite)
    kdb0.merge(kdb_to_merge, true);
    // a) check kdb0 contains new item of KDB to be merged
    EXPECT_TRUE(kdb0.contains(new_name));
    EXPECT_EQ(kdb0.get(new_name), new_list);
    // b) check already existing item has been overwritten
    EXPECT_EQ(kdb0.get(name), modified_list); 

    // merge (NOT overwrite)
    kdb1.merge(kdb_to_merge, false);
    // b) check already existing item has NOT been overwritten
    EXPECT_EQ(kdb1.get(name), unmodified_list);
}

TEST_F(KDBListsTest, AssociatedObjs)
{
    std::string name = "COPY0";
    std::vector<std::string> objs_list;

    load_global_kdb(I_COMMENTS, input_test_dir + "fun.cmt");
    load_global_kdb(I_EQUATIONS, input_test_dir + "fun.eqs");
    load_global_kdb(I_IDENTITIES, input_test_dir + "fun.idt");
    load_global_kdb(I_SCALARS, input_test_dir + "fun.scl");
    load_global_kdb(I_TABLES, input_test_dir + "fun.tbl");
    load_global_kdb(I_VARIABLES, input_test_dir + "fun.var");

    objs_list = Lists.get_associated_objects_list(name, I_COMMENTS);
    EXPECT_EQ(objs_list.size(), 0);

    objs_list = Lists.get_associated_objects_list(name, I_EQUATIONS);
    EXPECT_EQ(objs_list.size(), 0);

    objs_list = Lists.get_associated_objects_list(name, I_IDENTITIES);
    EXPECT_EQ(objs_list.size(), 0);

    std::vector<std::string> expected_lts = { "COPY", "COPY0" };
    objs_list = Lists.get_associated_objects_list(name, I_LISTS);
    EXPECT_EQ(objs_list, expected_lts);

    objs_list = Lists.get_associated_objects_list(name, I_SCALARS);
    EXPECT_EQ(objs_list.size(), 0);

    objs_list = Lists.get_associated_objects_list(name, I_TABLES);
    EXPECT_EQ(objs_list.size(), 0);

    objs_list = Lists.get_associated_objects_list(name, I_VARIABLES);
    EXPECT_EQ(objs_list.size(), 0);
}

TEST_F(KDBListsTest, Hash)
{
    boost::hash<KDBLists> kdb_hasher;
    std::size_t hash_val = kdb_hasher(Lists);

    // change a name
    Lists.rename("COPY0", "COPY_0");
    std::size_t hash_val_modified = kdb_hasher(Lists);
    EXPECT_NE(hash_val, hash_val_modified);
    std::cout << "(rename list) orignal vs modified hash: " << std::to_string(hash_val) << " vs " << std::to_string(hash_val_modified) << std::endl;

    // modify an entry
    hash_val = hash_val_modified;
    std::string expanded_list = Lists.get("COPY_0") + Lists.get("COPY1");
    Lists.update("COPY", expanded_list);
    hash_val_modified = kdb_hasher(Lists);
    EXPECT_NE(hash_val, hash_val_modified);
    std::cout << "(modify list) orignal vs modified hash: " << std::to_string(hash_val) << " vs " << std::to_string(hash_val_modified) << std::endl;

    // remove an entry
    hash_val = hash_val_modified;
    Lists.remove("COPY");
    hash_val_modified = kdb_hasher(Lists);
    EXPECT_NE(hash_val, hash_val_modified);
    std::cout << "(delete list) orignal vs modified hash: " << std::to_string(hash_val) << " vs " << std::to_string(hash_val_modified) << std::endl;

    // add an entry
    hash_val = hash_val_modified;
    std::string new_list = "ACAF;ACAG;AOUC;AQC";
    Lists.add("NEW_ENTRY", new_list);
    hash_val_modified = kdb_hasher(Lists);
    EXPECT_NE(hash_val, hash_val_modified);   
    std::cout << "(new    list) orignal vs modified hash: " << std::to_string(hash_val) << " vs " << std::to_string(hash_val_modified) << std::endl; 
}
