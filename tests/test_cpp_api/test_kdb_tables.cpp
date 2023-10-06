#include "pch.h"


class KDBTablesTest : public KDBTest, public ::testing::Test
{
protected:
    void SetUp() override
    {
        load_global_kdb(I_TABLES, input_test_dir + "fun.tbl");
    }

    // void TearDown() override {}
};


TEST_F(KDBTablesTest, Load)
{
    KDBTables kdb2;
    EXPECT_EQ(kdb2.count(), 46);

    KDBTables kdb3(input_test_dir + "fun.tbl");
    EXPECT_EQ(kdb3.count(), 46);
}

TEST_F(KDBTablesTest, CopyConstructor)
{
    std::string title = Tables.get_title("C8_1");
    std::string new_title = "modified title";
    Table table = Tables.get("C8_1");
    table.setTitle(0, new_title);

    // GLOBAL KDB
    KDBTables kdb_copy(Tables);
    EXPECT_EQ(kdb_copy.count(), 46);
    EXPECT_TRUE(kdb_copy.is_global_kdb());

    // LOCAL KDB
    KDBTables local_kdb(KDB_LOCAL, "C*");
    KDBTables local_kdb_hard_copy(local_kdb);
    EXPECT_EQ(local_kdb.count(), local_kdb_hard_copy.count());
    EXPECT_TRUE(local_kdb_hard_copy.is_local_kdb());
    local_kdb_hard_copy.update("C8_1", table);
    EXPECT_EQ(local_kdb.get_title("C8_1"), title);
    EXPECT_EQ(local_kdb_hard_copy.get_title("C8_1"), new_title);

    // SHALLOW COPY KDB
    KDBTables shallow_kdb(KDB_SHALLOW_COPY, "C*");
    KDBTables shallow_kdb_copy(shallow_kdb);
    EXPECT_EQ(shallow_kdb.count(), shallow_kdb_copy.count());
    EXPECT_TRUE(shallow_kdb_copy.is_shallow_copy());
    shallow_kdb_copy.update("C8_1", table);
    EXPECT_EQ(shallow_kdb.get_title("C8_1"), new_title);
    EXPECT_EQ(shallow_kdb_copy.get_title("C8_1"), new_title);
}

TEST_F(KDBTablesTest, Save)
{
    // save in binary format
    save_global_kdb(I_TABLES, output_test_dir + "fun.tbl");
    Tables.save(output_test_dir + "fun.tbl");

    // save in ascii format
    save_global_kdb(I_TABLES, output_test_dir + "fun.at");
    Tables.save(output_test_dir + "fun.at");
}

TEST_F(KDBTablesTest, Get)
{
    int pos = K_find(K_WS[I_TABLES], "GFRPC");

    // by position
    Table table = Tables.get(pos);
    EXPECT_EQ(table.getTitle(0), "Compte de l'ensemble des administrations publiques ");
    EXPECT_EQ(table.nbLines(), 31);
    EXPECT_EQ(table.nbColumns(), 2);
    EXPECT_EQ(table.getLineType(0), IT_TITLE);

    // by name
    Table table2 = Tables.get("GFRPC");
    EXPECT_EQ(table2.getTitle(0), "Compte de l'ensemble des administrations publiques ");
    EXPECT_EQ(table2.nbLines(), 31);
    EXPECT_EQ(table2.nbColumns(), 2);
    EXPECT_EQ(table2.getLineType(0), IT_TITLE);
}

TEST_F(KDBTablesTest, GetNames)
{
    std::vector<std::string> expected_names;
    for (int i=0; i < Tables.count(); i++) expected_names.push_back(Tables.get_name(i));
    std::vector<std::string> names = Tables.get_names();
    EXPECT_EQ(names, expected_names);
}

TEST_F(KDBTablesTest, GetTitle)
{
    int pos = 0;
    std::string title;
    std::string expected_title = "Déterminants de la croissance de K";

    // by position
    title = Tables.get_title(pos);
    EXPECT_EQ(expected_title, title);

    // by name
    std::string name = Tables.get_name(pos);
    title = Tables.get_title(name);
    EXPECT_EQ(expected_title, title);
}

TEST_F(KDBTablesTest, CreateRemove)
{
    std::string name;
    load_global_kdb(I_VARIABLES, input_test_dir + "fun.var");
    load_global_kdb(I_LISTS, input_test_dir + "fun.lst");

    std::string list_name = "$ENVI";
    // TODO JMP: is there a way to easily calculate the number of variables in a list ?
    int nb_vars_envi = 10;

    // add empty table with 2 columns
    name = "TABLE1";
    Tables.add(name, 2);

    int nb_lines_header = 0;
    int nb_lines_footnotes = 0;
    int nb_lines_vars = 0;
    Table table1(name);
    EXPECT_EQ(table1.nbLines(), nb_lines_header + nb_lines_vars + nb_lines_footnotes);

    // remove table
    Tables.remove(name);

    // add tables and initialize it (variables as list)
    name = "TABLE2";
    std::string def = "A title";
    std::vector<std::string> vars = { "GOSG", "YDTG", "DTH", "DTF", "IT", "YSSG+COTRES", "RIDG", "OCUG", list_name};
    bool mode = true;
    bool files = true;
    bool date = true;
    Tables.add(name, 2, def, vars, mode, files, date);

    // check that list $ENVI has been expanded
    nb_lines_header = 2 + 2; // title + sep line + "#S" + sep line
    nb_lines_footnotes = (mode || files || date) ? 1 + mode + files + date : 0;   // 1 for sep line
    nb_lines_vars = (int) vars.size() + nb_vars_envi - 1;
    Table table2(name);
    EXPECT_EQ(table2.nbLines(), nb_lines_header + nb_lines_vars + nb_lines_footnotes);

    // remove table
    Tables.remove(name);

    // add tables and initialize it (LEC cells as string)
    name = "TABLE3";
    std::string lecs = "GOSG;YDTG;DTH;DTF;IT;YSSG+COTRES;RIDG;OCUG;" + list_name;
    Tables.add(name, 2, def, lecs, mode, files, date);

    // check that list $ENVI has been expanded
    Table table3(name);
    EXPECT_EQ(table3.nbLines(), nb_lines_header + nb_lines_vars + nb_lines_footnotes);
    // remove table
    Tables.remove(name);
}

TEST_F(KDBTablesTest, Copy)
{
    Table original_table = Tables.get("GFRPC");

    Table copy_table = Tables.copy("GFRPC");
    EXPECT_EQ(copy_table, original_table);

    // add copy
    Tables.add("DUP_GFRPC", copy_table);
}

TEST_F(KDBTablesTest, Filter)
{
    std::string pattern = "A*;*2";
    std::vector<std::string> expected_names;
    KDBTables* local_kdb;

    load_global_kdb(I_VARIABLES, input_test_dir + "fun.var");
    load_global_kdb(I_LISTS, input_test_dir + "fun.lst");

    std::vector<std::string> all_names;
    for (int p = 0; p < Tables.count(); p++) all_names.push_back(Tables.get_name(p));

    int nb_total_comments = Tables.count();
    // A*
    for (const std::string& name : all_names) if (name.front() == 'A') expected_names.push_back(name);
    // *2
    for (const std::string& name : all_names) if (name.back() == '2') expected_names.push_back(name);

    // remove duplicate entries
    // NOTE: std::unique only removes consecutive duplicated elements, 
    //       so the vector needst to be sorted first
    std::sort(expected_names.begin(), expected_names.end());
    std::vector<std::string>::iterator it = std::unique(expected_names.begin(), expected_names.end());  
    expected_names.resize(std::distance(expected_names.begin(), it));

    // create local kdb
    local_kdb = new KDBTables(KDB_SHALLOW_COPY, pattern);
    EXPECT_EQ(local_kdb->count(), expected_names.size());

    // add an element to the local KDB and check if it has also 
    // been added to the global KDB
    std::string new_name = "NEW_TABLE";
    std::string def = "A title";
    std::vector<std::string> vars = { "GOSG", "YDTG", "DTH", "DTF", "IT", "YSSG+COTRES", "RIDG", "OCUG", "$ENVI" };
    bool mode = true;
    bool files = true;
    bool date = true;
    local_kdb->add(new_name, 2, def, vars, mode, files, date);
    int nb_vars_envi = 10;
    int nb_lines_header = 2 + 2; // title + sep line + "#S" + sep line
    int nb_lines_footnotes = (mode || files || date) ? 1 + mode + files + date : 0;   // 1 for sep line
    int nb_lines_vars = (int) vars.size() + nb_vars_envi - 1;
    EXPECT_EQ(local_kdb->get(new_name).nbLines(), nb_lines_header + nb_lines_vars + nb_lines_footnotes);
    EXPECT_EQ(Tables.get(new_name).nbLines(), nb_lines_header + nb_lines_vars + nb_lines_footnotes);
    EXPECT_EQ(local_kdb->get(new_name).nbLines(), Tables.get(new_name).nbLines());
    EXPECT_EQ(local_kdb->get(new_name), Tables.get(new_name));

    // rename an element in the local KDB and check if the 
    // corresponding element has also been renamed in the global KDB
    std::string old_name = new_name;
    new_name = "TABLE_NEW";
    local_kdb->rename(old_name, new_name);
    EXPECT_EQ(local_kdb->get(new_name).nbLines(), Tables.get(new_name).nbLines());
    EXPECT_EQ(local_kdb->get(new_name), Tables.get(new_name));

    // delete an element from the local KDB and check if it has also 
    // been deleted from the global KDB
    local_kdb->remove(new_name);
    EXPECT_FALSE(local_kdb->contains(new_name));
    EXPECT_FALSE(Tables.contains(new_name));

    // delete local kdb
    delete local_kdb;
    EXPECT_EQ(Tables.count(), nb_total_comments);
}

TEST_F(KDBTablesTest, HardCopy)
{
    std::string pattern = "A*;*2";
    std::vector<std::string> expected_names;
    KDBTables* local_kdb;

    load_global_kdb(I_VARIABLES, input_test_dir + "fun.var");
    load_global_kdb(I_LISTS, input_test_dir + "fun.lst");

    std::vector<std::string> all_names;
    for (int p = 0; p < Tables.count(); p++) all_names.push_back(Tables.get_name(p));

    int nb_total_comments = Tables.count();
    // A*
    for (const std::string& name : all_names) if (name.front() == 'A') expected_names.push_back(name);
    // *2
    for (const std::string& name : all_names) if (name.back() == '2') expected_names.push_back(name);

    // remove duplicate entries
    // NOTE: std::unique only removes consecutive duplicated elements, 
    //       so the vector needst to be sorted first
    std::sort(expected_names.begin(), expected_names.end());
    std::vector<std::string>::iterator it = std::unique(expected_names.begin(), expected_names.end());  
    expected_names.resize(std::distance(expected_names.begin(), it));

    // create local kdb
    local_kdb = new KDBTables(KDB_LOCAL, pattern);
    EXPECT_EQ(local_kdb->count(), expected_names.size());

    // add an element to the local KDB and check if it has not 
    // been added to the global KDB
    std::string new_name = "NEW_TABLE";
    std::string def = "A title";
    std::vector<std::string> vars = { "GOSG", "YDTG", "DTH", "DTF", "IT", "YSSG+COTRES", "RIDG", "OCUG", "$ENVI" };
    bool mode = true;
    bool files = true;
    bool date = true;
    local_kdb->add(new_name, 2, def, vars, mode, files, date);
    int nb_vars_envi = 10;
    int nb_lines_header = 2 + 2; // title + sep line + "#S" + sep line
    int nb_lines_footnotes = (mode || files || date) ? 1 + mode + files + date : 0;   // 1 for sep line
    int nb_lines_vars = (int) vars.size() + nb_vars_envi - 1;
    EXPECT_TRUE(local_kdb->contains(new_name));
    EXPECT_FALSE(Tables.contains(new_name));
    EXPECT_EQ(local_kdb->get(new_name).nbLines(), nb_lines_header + nb_lines_vars + nb_lines_footnotes);

    // rename an element in the local KDB and check if the 
    // corresponding element has not been renamed in the global KDB
    std::string name = "DEF2";
    new_name = "TABLE_NEW";
    local_kdb->rename(name, new_name);
    EXPECT_TRUE(local_kdb->contains(new_name));
    EXPECT_FALSE(Tables.contains(new_name));

    // delete an element from the local KDB and check if it has not 
    // been deleted from the global KDB
    name = "T2";
    local_kdb->remove(name);
    EXPECT_FALSE(local_kdb->contains(name));
    EXPECT_TRUE(Tables.contains(name));

    // delete local kdb
    delete local_kdb;
    EXPECT_EQ(Tables.count(), nb_total_comments);
}

TEST_F(KDBTablesTest, Merge)
{
    std::string pattern = "A*";

    // create hard copies kdb
    KDBTables kdb0(KDB_LOCAL, pattern);
    KDBTables kdb1(KDB_LOCAL, pattern);
    KDBTables kdb_to_merge(KDB_LOCAL, pattern);

    // add an element to the KDB to be merged
    std::string new_name = "NEW_TABLE";
    std::string def = "A title";
    std::vector<std::string> vars = { "GOSG", "YDTG", "DTH", "DTF", "IT", "YSSG+COTRES", "RIDG", "OCUG", "$ENVI" };
    bool mode = true;
    bool files = true;
    bool date = true;
    kdb_to_merge.add(new_name, 2, def, vars, mode, files, date);
    Table new_table(new_name, kdb_to_merge.get_KDB());

    // modify an existing element of the KDB to be merge
    std::string name = "ANAPRIX";
    Table unmodified_table = kdb_to_merge.get(name);
    Table modified_table = kdb_to_merge.copy(name);
    modified_table.setTitle(0, "New Title");
    kdb_to_merge.update(name, modified_table);

    // merge (overwrite)
    kdb0.merge(kdb_to_merge, true);
    // a) check kdb0 contains new item of KDB to be merged
    EXPECT_TRUE(kdb0.contains(new_name));
    EXPECT_EQ(kdb0.get(new_name), new_table);
    // b) check already existing item has been overwritten
    EXPECT_EQ(kdb0.get(name), modified_table); 

    // merge (NOT overwrite)
    kdb1.merge(kdb_to_merge, false);
    // b) check already existing item has NOT been overwritten
    EXPECT_EQ(kdb1.get(name), unmodified_table);
}

TEST_F(KDBTablesTest, AssociatedObjs)
{
    std::string name = "ENVI";
    std::vector<std::string> objs_list;

    load_global_kdb(I_COMMENTS, input_test_dir + "fun.cmt");
    load_global_kdb(I_EQUATIONS, input_test_dir + "fun.eqs");
    load_global_kdb(I_IDENTITIES, input_test_dir + "fun.idt");
    load_global_kdb(I_LISTS, input_test_dir + "fun.lst");
    load_global_kdb(I_SCALARS, input_test_dir + "fun.scl");
    load_global_kdb(I_VARIABLES, input_test_dir + "fun.var");

    objs_list = Tables.get_associated_objects_list(name, I_COMMENTS);
    EXPECT_EQ(objs_list.size(), 0);

    objs_list = Tables.get_associated_objects_list(name, I_EQUATIONS);
    EXPECT_EQ(objs_list.size(), 0);

    objs_list = Tables.get_associated_objects_list(name, I_IDENTITIES);
    EXPECT_EQ(objs_list.size(), 0);

    std::vector<std::string> expected_lst = { name };
    objs_list = Tables.get_associated_objects_list(name, I_LISTS);
    EXPECT_EQ(objs_list, expected_lst);

    objs_list = Tables.get_associated_objects_list(name, I_SCALARS);
    EXPECT_EQ(objs_list.size(), 0);

    std::vector<std::string> expected_tbl = { name };
    objs_list = Tables.get_associated_objects_list(name, I_TABLES);
    EXPECT_EQ(objs_list, expected_tbl);

    objs_list = Tables.get_associated_objects_list(name, I_VARIABLES);
    EXPECT_EQ(objs_list.size(), 0);
}

TEST_F(KDBTablesTest, Hash)
{
    boost::hash<KDBTables> kdb_hasher;
    std::size_t hash_val = kdb_hasher(Tables);

    // change a name
    Tables.rename("GFRPC", "NEW_NAME");
    std::size_t hash_val_modified = kdb_hasher(Tables);
    EXPECT_NE(hash_val, hash_val_modified);
    std::cout << "(rename table) orignal vs modified hash: " << std::to_string(hash_val) << " vs " << std::to_string(hash_val_modified) << std::endl;

    // remove an entry
    hash_val = hash_val_modified;
    Tables.remove("NEW_NAME");
    hash_val_modified = kdb_hasher(Tables);
    EXPECT_NE(hash_val, hash_val_modified);
    std::cout << "(delete table) orignal vs modified hash: " << std::to_string(hash_val) << " vs " << std::to_string(hash_val_modified) << std::endl;

    // add an entry
    hash_val = hash_val_modified;
    std::string def = "A title";
    std::vector<std::string> vars = { "GOSG", "YDTG", "DTH", "DTF", "IT", "YSSG+COTRES", "RIDG", "OCUG"};
    bool mode = true;
    bool files = true;
    bool date = true;
    Tables.add("NEW_ENTRY", 2, def, vars, mode, files, date);
    hash_val_modified = kdb_hasher(Tables);
    EXPECT_NE(hash_val, hash_val_modified);   
    std::cout << "(new    table) orignal vs modified hash: " << std::to_string(hash_val) << " vs " << std::to_string(hash_val_modified) << std::endl; 
}
