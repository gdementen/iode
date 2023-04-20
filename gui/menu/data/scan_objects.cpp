#include "scan_objects.h"


QIodeMenuDataScanObjects::QIodeMenuDataScanObjects(const QString& project_settings_filepath, QWidget* parent, Qt::WindowFlags f)
    : QIodeSettings(project_settings_filepath, parent, f)
{
    setupUi(this);

    completer = new QIodeCompleter(false, false, I_COMMENTS, this);
    textEdit_lists_to_scan->setCompleter(completer);
    comboBox_iode_types->setCurrentIndex(0);

    QStringList listIodeTypes;
    for(const std::string& iode_type : vIodeTypes) listIodeTypes << QString::fromStdString(iode_type);

    wComboIodeTypes = new WrapperComboBox(label_objs_to_scan->text(), *comboBox_iode_types, REQUIRED_FIELD, listIodeTypes);
    wListsToScan = new WrapperQPlainTextEdit(label_lists_to_scan->text(), *textEdit_lists_to_scan, OPTIONAL_FIELD);

    mapFields["IodeType"]    = wComboIodeTypes;
    mapFields["ListsToScan"] = wListsToScan;

    connect(comboBox_iode_types, &QComboBox::currentIndexChanged, textEdit_lists_to_scan, &QIodeCompleteTextEdit::setIodeType);

    // TODO: if possible, find a way to initialize className inside MixingSettings
    // NOTE FOR DEVELOPPERS: we cannot simply call the line below from the constructor of MixingSettings 
    //                       since in that case this refers to MixingSettings and NOT the derived class
    className = QString::fromStdString(typeid(this).name());
    loadSettings();
}

QIodeMenuDataScanObjects::~QIodeMenuDataScanObjects()
{
    delete wComboIodeTypes;
    delete wListsToScan;

    delete completer;
}

// TODO ALD: implement a scan_objects() method in KDBAbstract + tests
// Tests: iode type = I_EQUATIONS, list to scan = ???
void QIodeMenuDataScanObjects::scan()
{
    try
    {
        int iode_type = wComboIodeTypes->extractAndVerify();
        std::string list_to_scan = wListsToScan->extractAndVerify().toStdString();

        int res = B_DataScan(list_to_scan.data(), iode_type);
        if(res < 0)
            B_display_last_error();

        this->accept();
    }
    catch(const std::exception& e)
    {
        QMessageBox::warning(nullptr, "WARNING", QString(e.what()));
    }
}

void QIodeMenuDataScanObjects::help()
{
	QDesktopServices::openUrl(url_manual);
}
