
#include "workspace_seasonal_adjustment.h"


QIodeMenuWorkspaceSeasonalAdjustment::QIodeMenuWorkspaceSeasonalAdjustment(const QString& settings_filepath, QWidget* parent, Qt::WindowFlags f) : 
    QIodeSettings(settings_filepath, parent, f)
{
    setupUi(this);

    wInputFile = new WrapperFileChooser(label_input_file->text(), *fileChooser_input_file, REQUIRED_FIELD, 
                                        I_VARIABLES_FILE, EXISTING_FILE); 
    wSeries = new WrapperQTextEdit(label_series->text(), *textEdit_series, OPTIONAL_FIELD);  
    wEPSTest = new WrapperDoubleSpinBox(label_EPS_test->text(), *doubleSpinBox_EPS_test, OPTIONAL_FIELD); 

    mapFields["InputFile"] = wInputFile;
    mapFields["Series"] = wSeries;
    mapFields["EPSTest"] = wEPSTest;

    // TODO: if possible, find a way to initialize className inside MixingSettings
    // NOTE FOR DEVELOPPERS: we cannot simply call the line below from the constructor of MixingSettings 
    //                       since in that case this refers to MixingSettings and NOT the derived class
    className = QString::fromStdString(typeid(this).name());
    loadSettings();
}

QIodeMenuWorkspaceSeasonalAdjustment::~QIodeMenuWorkspaceSeasonalAdjustment()
{
    delete wInputFile;
    delete wSeries;
    delete wEPSTest;
}

void QIodeMenuWorkspaceSeasonalAdjustment::seasonal_adjustment()
{
    try
    {
        std::string filepath = wInputFile->extractAndVerify().toStdString();
        std::string series = wSeries->extractAndVerify().toStdString();
        double EPS_test = wEPSTest->extractAndVerify();

        KDBVariables kdb;
        kdb.seasonal_adjustment(filepath, series, EPS_test);
    }
    catch (const std::exception& e)
    {
        QMessageBox::critical(this, tr("ERROR"), tr(e.what()));
        return;
    }

    this->accept();
}

void QIodeMenuWorkspaceSeasonalAdjustment::help()
{
	QDesktopServices::openUrl(url_manual);
}