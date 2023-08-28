#include "file_compare.h"


MenuDataFileCompare::MenuDataFileCompare(QWidget* parent)
    : QIodeSettings(parent)
{
    setupUi(this);

    QStringList listIodeTypes;
    for(const std::string& iode_type : vIodeTypes) listIodeTypes << QString::fromStdString(iode_type);

    wComboIodeTypes = new WrapperComboBox(label_iode_types->text(), *comboBox_iode_types, REQUIRED_FIELD, listIodeTypes);
    wThreshold = new WrapperQLineEdit(label_threshold->text(), *lineEdit_threshold, OPTIONAL_FIELD);
    wInputFile = new WrapperFileChooser(label_input_file->text(), *fileChooser_input_file, OPTIONAL_FIELD, I_COMMENTS_FILE, EXISTING_FILE);
    wResultWSOnly = new WrapperQLineEdit(label_list_ws_only->text(), *lineEdit_list_ws_only, REQUIRED_FIELD);
    wResultFileOnly = new WrapperQLineEdit(label_list_file_only->text(), *lineEdit_list_file_only, REQUIRED_FIELD);
    wResultBothEqual = new WrapperQLineEdit(label_list_both_equal->text(), *lineEdit_list_both_equal, REQUIRED_FIELD);
    wResultBothDifferent = new WrapperQLineEdit(label_list_both_different->text(), *lineEdit_list_both_different, REQUIRED_FIELD);

    mapFields["IodeTypes"]           = wComboIodeTypes;
    mapFields["Threshold"]           = wThreshold;
    mapFields["InputFile"]           = wInputFile;
    mapFields["ResultWSOnly"]        = wResultWSOnly;
    mapFields["ResultFileOnly"]      = wResultFileOnly;
    mapFields["ResultBothEqual"]     = wResultBothEqual;
    mapFields["ResultBothDifferent"] = wResultBothDifferent;

    wThreshold->getQField().setValidator(new QDoubleValidator(&wThreshold->getQField()));
    updateThreshold(I_COMMENTS);

    connect(&wComboIodeTypes->getQField(), &QComboBox::currentIndexChanged, this, &MenuDataFileCompare::updateThreshold);
    connect(&wComboIodeTypes->getQField(), &QComboBox::currentIndexChanged, this, &MenuDataFileCompare::updateFileChooser);

    className = "MENU_DATA_FILE_COMPARE";
    loadSettings();
}

MenuDataFileCompare::~MenuDataFileCompare()
{
    delete wComboIodeTypes;
    delete wThreshold;
    delete wInputFile;
    delete wResultWSOnly;
    delete wResultFileOnly;
    delete wResultBothEqual;
    delete wResultBothDifferent;
}

// TODO ALD: implement a file_compare() method in KDBAbstract + tests
// Tests: iode type = COMMENTS, file = fun2.ac
//                  = VARIABLES, threshold = 1e-07, file = fun2.av
void MenuDataFileCompare::compare()
{
    try
    {
        KDBLists kdb_lst;

        int iode_type = wComboIodeTypes->extractAndVerify();
        std::string threshold = wThreshold->extractAndVerify().toStdString();
        std::string input_file = wInputFile->extractAndVerify().toStdString();
        std::string list_ws_ony = wResultWSOnly->extractAndVerify().toStdString();
        std::string list_file_only = wResultFileOnly->extractAndVerify().toStdString();
        std::string list_both_equal = wResultBothEqual->extractAndVerify().toStdString();
        std::string list_both_different = wResultBothDifferent->extractAndVerify().toStdString();

        if(iode_type == I_VARIABLES)
	        B_DataCompareEps(threshold.data());

        std::string buf = input_file + " " + list_ws_ony + " " + list_file_only + " ";
        buf += list_both_equal + " " + list_both_different;
        int res  = B_DataCompare(buf.data(), iode_type);
        if(res < 0) 
            B_display_last_error();

        int nb_elements;
        nb_elements = B_DataListCount(list_ws_ony.data());
        label_nb_elements_ws_only->setText(QString::number(nb_elements) + " Elements");
        nb_elements = B_DataListCount(list_file_only.data());
        label_nb_elements_file_only->setText(QString::number(nb_elements) + " Elements");
        nb_elements = B_DataListCount(list_both_equal.data());
        label_nb_elements_both_equal->setText(QString::number(nb_elements) + " Elements");
        nb_elements = B_DataListCount(list_both_different.data());
        label_nb_elements_both_different->setText(QString::number(nb_elements) + " Elements");
    }
    catch(const std::exception& e)
    {
        QMessageBox::warning(nullptr, "WARNING", QString(e.what()));
    }
}

void MenuDataFileCompare::help()
{
	QDesktopServices::openUrl(url_manual);
}
