#include "pch.h"
#include <filesystem>


int W_printf(char* fmt,...)
{
    va_list     myargs;
    char        buf[512];

    va_start(myargs, fmt);
#ifdef _MSC_VER
    vsnprintf_s(buf, sizeof(buf) - 1, _TRUNCATE, fmt, myargs);
#else
    vsnprintf_s(buf, sizeof(buf) - 1, fmt, myargs);
#endif
    va_end(myargs);
    printf("%s\n", buf);
    return(0);
}



class IodeCAPITest : public ::testing::Test 
{
protected:
	char input_test_dir[256];
	char output_test_dir[256];

public:
    void SetUp() override 
    {
        // C++ consider all passed string value of the kind "..." to C function as CONSTANT
        char buf1[64];
        char buf2[64];

        // NOTE: we assume that: 
		//       - current path is binaryDir/tests/test_cpp_api
		//       - data directory has been copied in binaryDir/tests (see CMakeLists.txt in root directory)
		std::filesystem::path cwd = std::filesystem::current_path();
		std::string str_path = cwd.parent_path().string() + "\\";
		strcpy_s(input_test_dir, (str_path + "data\\").c_str());
		strcpy_s(output_test_dir, (str_path + "output\\").c_str());

        // other initializations
        U_test_init();
    }

	int U_cmp_str(char* str1, char* str2)
	{
	    if(str1 == NULL && str2 == NULL) return(1);
	    if(str1 == NULL || str2 == NULL) return(0);
	    return(!strcmp(str1, str2));
	}

	int U_cmp_tbl(char** tbl1, char* vec)
	{
	    int     i, rc = 0;
	    char**  tbl2;
	
	    tbl2 = (char**) SCR_vtoms((unsigned char*) vec, (unsigned char*) " ;,");
	    if(tbl1 == NULL) {
	        if(tbl2 == NULL) return(-1);
	        goto fin;
	    }
	    if(tbl2 == NULL) return(0);
	    if(SCR_tbl_size((unsigned char**) tbl1) != SCR_tbl_size((unsigned char**) tbl2)) goto fin;
	    for(i = 0 ;  tbl1[i] ; i++)
	        if(strcmp(tbl1[i], tbl2[i])) goto fin;
	    rc = -1;
	
	fin:
	    SCR_free_tbl((unsigned char**) tbl2);
	    return(rc);
	
	}

	void U_tests_Objects()
	{
	    char*       lst;
	    SAMPLE*     smpl;
	    IODE_REAL   A[64], B[64];
	    int         nb, i, pos;
	    // C++ consider all passed string value of the kind "..." to C function as CONSTANT
	    char buf1[64];
	    char buf2[64];
	
	    static int done = 0;
	
	    if(done) return;
	    done = 1;
	
	    // Create lists
	    strcpy(buf1, "LST1");
	    strcpy(buf2, "LST2");
	    pos = K_add(KL_WS, buf1, "A;B");
	    EXPECT_TRUE(pos >= 0);
	    K_add(KL_WS, buf2, "A,B");
	    lst = KLPTR("LST1");
	    EXPECT_EQ(strcmp(lst, "A;B"), 0);
	
	    // Set the sample for the variable WS
	    strcpy(buf1, "2000Y1");
	    strcpy(buf2, "2020Y1");
	    smpl = PER_atosmpl(buf1, buf2);
	    KV_sample(KV_WS, smpl);
	    //SW_nfree(smpl);
	
	    // Creates new vars
	    nb = smpl->s_nb;
	    for(i = 0; i < smpl->s_nb; i++) {
	       A[i] = i;
	       B[i] = i*2;
	    }
	
	    strcpy(buf1, "A");
	    strcpy(buf2, "B");
	    pos = K_add(KV_WS, buf1, A, &nb);
	    EXPECT_TRUE(K_find(KV_WS, "A") >= 0);
	    pos = K_add(KV_WS, buf2, B, &nb);
	
	}

	void U_test_lec(char* title, char* lec, int t, IODE_REAL expected_val)
	{
	    CLEC*   clec;
	    //char    buf[256];
	    double  calc_val;
	    PERIOD  *per;
	    char    aper[24];
	
	    per = PER_addper(&(KSMPL(KV_WS)->s_p1), t);
	    PER_pertoa(per, aper);
	
	    clec = L_cc(lec);
	    //S4ASSERT ("L_cc", clec != 0);
	    //S4ASSERT ("L_link", 0 == L_link(KV_WS, KS_WS, clec));
	    L_link(KV_WS, KS_WS, clec);
	    calc_val = L_exec(KV_WS, KS_WS, clec, t);
	    //sprintf(buf, "Res=%10.3lf - Expected=%10.3lf %s L_exec(%s) in %s", calc_val, expected_val, title, lec, aper);
	    EXPECT_EQ(expected_val, calc_val);
	}

	KDB* U_test_K_interpret(int type, char* filename)
	{
	    char    fullfilename[256];
	    KDB     *kdb;
	
	    sprintf(fullfilename,  "%s\\%s", input_test_dir, filename);
	    kdb = K_interpret(type, fullfilename);
	    //S4ASSERT(kdb != NULL, "K_interpret(%d, \"%s\")", type, fullfilename);
	    return(kdb);
	}

	void U_test_init()
	{
	    static int  done = 0;
	
	    if(done) return;
	    done = 1;
	
	    IODE_assign_super_API();            // set *_super fn pointers
	    //strcpy(SCR_NAME_ERR, "iode.msg");   // message file
	    K_init_ws(0);                       // Initialises 7 empty WS
	}


	//void TearDown() override {}

};


TEST_F(IodeCAPITest, Tests_BUF)
{
    EXPECT_EQ(BUF_DATA, nullptr);
    EXPECT_NE(BUF_strcpy("ABCD"), nullptr);
    EXPECT_NE(BUF_alloc(100), nullptr);
    EXPECT_NE(BUF_strcpy("ABCD"), nullptr);
    BUF_free();
    EXPECT_EQ(BUF_DATA, nullptr);
}


TEST_F(IodeCAPITest, Tests_LEC)
{
    IODE_REAL *A, *B;

    // Create objects
    U_tests_Objects();

    A = (IODE_REAL*)KVPTR("A");
    B = (IODE_REAL*)KVPTR("B");
    // Tests LEC
    U_test_lec("LEC", "A+B",  2, A[2]+B[2]);
    U_test_lec("LEC", "ln A", 2, log(A[2]));
    U_test_lec("LEC", "A[2002Y1]",     2, A[2]);
    //S4ASSERT(0, "Erreur forcÃ©e");
    U_test_lec("LEC", "A[2002Y1][-1]", 2, A[2]);
    U_test_lec("LEC", "A[-1]",         2, A[1]);
    U_test_lec("LEC", "A[-1][2002Y1]", 2, A[1]);
    U_test_lec("LEC", "sum(2000Y1, 2010Y1, A)", 2, 55.0);
    U_test_lec("LEC", "sum(2000Y1, A)", 2, 3.0);

    // Using macros in LEC
    U_test_lec("LEC-MACRO", "1 + vmax($LST1)", 2, 1+B[2]);
    U_test_lec("LEC-MACRO", "1 + vmax($LST2)", 2, 1+B[2]);
}


TEST_F(IodeCAPITest, Tests_EQS)
{
//    EQ*     eq;
//    char    lec[521];
//
//    B_DataUpdateEqs("A", "ln A := B + t", NULL, 'L', NULL, NULL, NULL, NULL, NULL);
//    eq = KEPTR("A");
//    strcpy(lec, eq->lec);
//    S4ASSERT(strcmp(eq->lec, "ln A := B + t") == 0, "EQ %s = %s", "A", lec);
//
}


TEST_F(IodeCAPITest, Tests_ARGS)
{
    char **args;
    char *list[] = {"A1", "A2", 0};
    char filename[256];

    // Create objects
    U_tests_Objects();

    // A_init
    args = B_ainit_chk("$LST2", NULL, 0);
    EXPECT_TRUE(U_cmp_tbl(args, "A,B"));
    SCR_free_tbl((unsigned char**) args);
    //args = B_ainit_chk("A*", NULL, 0);

    // Test parameters in a file. test.args must exist in the current dir and contain the line
    // A1 A2
    sprintf(filename, "@%s\\test.args", input_test_dir);
    args = B_ainit_chk(filename, NULL, 0);
    EXPECT_TRUE(U_cmp_tbl(args, "A1;A2"));
    SCR_free_tbl((unsigned char**) args);
}


TEST_F(IodeCAPITest, Tests_ERRMSGS)
{
    B_seterrn(86, "bla bla");
    kerror(0, "Coucou de kerror %s", "Hello");
    kmsg("Coucou de kmsg %s -- %g", "Hello", 3.2);
}


TEST_F(IodeCAPITest, Tests_K_OBJFILE)
{
    char    in_filename[256];
    char    out_filename[256];
    KDB     *kdb_var;
    int     rc;

    sprintf(in_filename,  "%s\\fun.var", input_test_dir);
    sprintf(out_filename, "%s\\fun_copy.var", output_test_dir);

    kdb_var = K_interpret(K_VAR, in_filename);
    EXPECT_NE(kdb_var, nullptr);
    if(kdb_var) {
        EXPECT_EQ(KNB(kdb_var), 394);
        rc = K_save(kdb_var, out_filename);
        EXPECT_EQ(rc, 0);
    }


    /*
    char *K_set_ext(char* res, char* fname, int type)                               deletes left and right spaces in a filename and changes its extension according to the given type.
    void K_strip(char* filename)                                                    deletes left and right spaces in a filename. Keeps the space inside the filename.
    KDB  *K_load(int ftype, FNAME fname, int no, char** objs)                       loads a IODE object file.
    int K_filetype(char* filename, char* descr, int* nobjs, SAMPLE* smpl)           retrieves infos on an IODE file: type, number of objects, SAMPLE
    KDB *K_interpret(int type, char* filename): generalisation of K_load()          interprets the content of a file, ascii files included, and try to load ist content into a KDB.
    int K_copy(KDB* kdb, int nf, char** files, int no, char** objs, SAMPLE* smpl)   reads a list of objects from a list of IODE object files and adds them to an existing KDB.
    int K_backup(char* filename)                                                    takes a backup of a file by renaming the file: filename.xxx => filename.xx$.
    int K_save(KDB* kdb, FNAME fname)                                               saves a KDB in an IODE object file. The extension of fname is replaced by the standard one (.cmt, .eqs...).
    int K_save_ws(KDB* kdb)                                                         saves a KDB in an IODE object file called "ws.<ext>" where <ext> is one of (.cmt, .eqs...).
    int K_setname(char* from, char* to)                                             replaces KNAMEPTR(kdb) in an IODE object file.
    */
}


TEST_F(IodeCAPITest, Tests_TBL32_64)
{
    char    in_filename[256];
    char    out_filename[256];
    KDB     *kdb_tbl;
    int     rc;

    int     pos, col;
    TBL*    c_table;
    char    *cell_content;


    sprintf(in_filename,  "%s\\fun.tbl", input_test_dir);

    kdb_tbl = K_interpret(K_TBL, in_filename);
    EXPECT_NE(kdb_tbl, nullptr);
    if(kdb_tbl) {
        sprintf(out_filename, "%s\\fun_copy.at", output_test_dir);
        rc = KT_save_asc(kdb_tbl, out_filename);
        EXPECT_EQ(rc, 0);
    }

    // Plantage ALD 14/02/2022
    pos = K_find(kdb_tbl, "GFRPC");
    c_table = KTVAL(kdb_tbl, pos);

    // get title
    cell_content = T_cell_cont_tbl(c_table, 0, 0, 1);
    printf("Title %s\n", cell_content);

    // get cell content
    for(col = 0; col < c_table->t_nc; col++) {
        cell_content = T_cell_cont_tbl(c_table, 1, col, 1);
        printf("Cell %d:%s\n",col, cell_content);
    }
}


TEST_F(IodeCAPITest, Tests_ALIGN)
{
    TBL     tbl, *p_tbl = &tbl;
    int     offset;

    offset = (char*)(p_tbl + 1) - (char*)p_tbl;
    printf("sizeof(TBL)    = %d -- Offset = %d\n", sizeof(TBL), offset);
    //printf("sizeof(TBL)    = %d\n", sizeof(TBL));
    //printf("sizeof(TLINE)  = %d\n", sizeof(TLINE));
    //printf("sizeof(TCELL)  = %d\n", sizeof(TCELL));
    //
    //printf("sizeof(TBL32)  = %d\n", sizeof(TBL32));
    //printf("sizeof(TLINE32)= %d\n", sizeof(TLINE32));
    //printf("sizeof(TCELL32)= %d\n", sizeof(TCELL32));
}


