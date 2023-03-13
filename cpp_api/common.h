#pragma once

#include "api/iode.h"
#include "api/iodeapi.h"

#include <string>
#include <array>
#include <vector>
#include <map>
#include <bitset>
#include <stdexcept>
#include <iostream>


using int_bitset = std::bitset<sizeof(int)>;


/* ****************************** *
 *           CONSTANTS            *
 * ****************************** */

// should be moved to iode.h
const static char* ORGANIZATION_NAME = "Federal Planning Bureau";
const static char* DEFAULT_INSTALLATION_DIR = "c:/iode";               // see function HLP_filename() in dos/o_help.c
const static char* IODE_WEBSITE = "https://iode.plan.be/doku.php";
const static char NAN_REP[3] = "--";


/* ****************************** *
 *             ENUMS              *
 * ****************************** */

 /* NOTE FOR THE DEVELOPPERS:
  * enum documentation: https://en.cppreference.com/w/cpp/language/enum
  */


// TODO: replace K by I as below in C api + group them in an enum
enum EnumIodeType
{
    I_COMMENTS = K_CMT,
    I_EQUATIONS = K_EQS,
    I_IDENTITIES = K_IDT,
    I_LISTS = K_LST,
    I_SCALARS = K_SCL,
    I_TABLES = K_TBL,
    I_VARIABLES = K_VAR
};

// TODO: rename K_NBR_OBJ as I_NB_TYPES in C api
const static int I_NB_TYPES = K_NBR_OBJ;

const static std::array<std::string, I_NB_TYPES> vIodeTypes = { "Comment", "Equation", "Identity", "List", "Scalar", "Table", "Variable" };
const static std::array<std::string, I_NB_TYPES> v_binary_ext = { "cmt", "eqs", "idt", "lst", "scl", "tbl", "var" };
const static std::array<std::string, I_NB_TYPES> v_ascii_ext = { "ac", "ae", "ai", "al", "as", "at", "av" };

struct IodeRegexName
{
    std::string regex;
    std::string type;
};

// TODO: replace K by I as below in C api + group them in an enum
enum EnumLang
{
    IT_ENGLISH = KT_ENGLISH,
    IT_DUTCH = KT_DUTCH,
    IT_FRENCH = KT_FRENCH,
};

const static int I_NB_LANGS = 3;

const static std::array<std::string, I_NB_LANGS> vLangs = { "English", "Dutch", "French" };


enum EnumIodeFile
{
    I_COMMENTS_FILE,
    I_EQUATIONS_FILE,
    I_IDENTITIES_FILE,
    I_LISTS_FILE,
    I_SCALARS_FILE,
    I_TABLES_FILE,
    I_VARIABLES_FILE,
    I_REPORTS_FILE,
    I_TEXT_FILE,
    I_LOGS_FILE,
    I_SETTINGS_FILE,
    I_ANY_FILE,
    I_DIRECTORY
};

const static int I_NB_ENUM_FILE_EXT = 13;

// same as k_ext defined in k_objfile.c
const static std::array<std::string, 26> v_ext = 
{
    "cmt", "eqs", "idt", "lst", "scl", "tbl", "var",
    "ac",  "ae",  "ai",  "al",  "as",  "at",  "av",
    "rep", "a2m", "agl", "prf", "dif", "mif", "rtf",
    "ref", "ps",  "asc", "txt", "csv"
};

const static int I_NB_TEXT_EXT = 9;

const static std::array<std::string, I_NB_TEXT_EXT> v_text_ext = 
{
    "txt", "a2m", "agl", "prf", "dif", "mif", "rtf", 
    "asc", "ref"
};

// (iode objs) 14 + report (1) + any (1) + directory (1) = 17 
// logs (1) + settings (1) + text (9) = 11
const static int I_NB_FILE_EXT = 28;

const static std::map<std::string, EnumIodeFile> mFileExtensions =
{
    {".cmt", I_COMMENTS_FILE},
    {".ac",  I_COMMENTS_FILE},
    {".eqs", I_EQUATIONS_FILE},
    {".ae",  I_EQUATIONS_FILE},
    {".idt", I_IDENTITIES_FILE},
    {".ai",  I_IDENTITIES_FILE},
    {".lst", I_LISTS_FILE},
    {".al",  I_LISTS_FILE},
    {".scl", I_SCALARS_FILE},
    {".as",  I_SCALARS_FILE},
    {".tbl", I_TABLES_FILE},
    {".at",  I_TABLES_FILE},
    {".var", I_VARIABLES_FILE},
    {".av",  I_VARIABLES_FILE},
    {".rep", I_REPORTS_FILE},
    {".txt", I_TEXT_FILE},
    {".a2m", I_TEXT_FILE},
    {".rtf", I_TEXT_FILE},
    {".ref", I_TEXT_FILE},
    {".agl", I_TEXT_FILE},
    {".prf", I_TEXT_FILE},
    {".dif", I_TEXT_FILE},
    {".mif", I_TEXT_FILE},
    {".asc", I_TEXT_FILE},
    {".log", I_LOGS_FILE},
    {".ini", I_SETTINGS_FILE},
};


// TODO: replace K by I as below in C api + group them in an enum
enum EnumIodeCase
{
    I_UPPER = K_UPPER,
    I_LOWER = K_LOWER,
    I_ASIS = K_ASIS
};


enum EnumIodeExportFormat
{
    I_EXP_FMT_CSV,
    I_EXP_FMT_DIF,
    I_EXP_FMT_WKS,
    I_EXP_FMT_TSP,
    I_EXP_FMT_RCSV
};

const static int I_NB_EXPORT_FORMATS = 5;

const static std::array<std::string, I_NB_EXPORT_FORMATS> vExportFormats = 
	{ "CSV", "DIF", "WKS", "TSP", "Reverse CSV" };


// ====== Graphs ======

enum EnumIodeGraphAxisType
{
    I_G_LEVEL,
    I_G_DIFF,
    I_G_GROWTH_RATE,
    I_G_Y0Y_DIFF,
    I_G_Y0Y_GROWTH_RATE
};

const static int I_NB_X_AXIS_TYPES = 5;

const static std::array<std::string, I_NB_X_AXIS_TYPES> vGraphsXAxisTypes = 
    { "Level", "Differences", "Growth rates", "YoY Diffs", "YoY Grt" };


enum EnumIodeGraphAxisThicks
{
    I_G_MAJOR_THICKS,
    I_G_NO_THICKS,
    I_G_MINOR_THICKS
};

const static int I_NB_AXIS_THICKS = 3;

const static std::array<std::string, I_NB_AXIS_THICKS> vGraphsAxisThicks = 
    { "Major thicks", "No grids", "Minor thicks" };


enum EnumIodeGraphChart
{
    I_G_CHART_LINE,
    I_G_CHART_SCATTER,
    I_G_CHART_BAR
};

const static int I_NB_CHART_TYPES = 3;

const static std::array<std::string, I_NB_CHART_TYPES> vGraphsChartTypes = 
    { "Line chart", "Scatter chart", "Bar chart" };
