#include "workspace_extrapolate_variables.h"


QIodeMenuWorkspaceExtrapolateVariables::QIodeMenuWorkspaceExtrapolateVariables(QWidget* parent, Qt::WindowFlags f) : 
    QIodeSettings(parent, f)
{
    setupUi(this);

    completer = new QIodeCompleter(false, false, I_VARIABLES, textEdit_variables_list);
    textEdit_variables_list->setCompleter(completer);

    QList<QString> methodsList; 
    for(const std::string& method : v_simulation_initialization) methodsList << QString::fromStdString(method);

    wFrom = new WrapperSampleEdit(label_sample_from->text(), *sampleEdit_sample_from, REQUIRED_FIELD);
    wTo = new WrapperSampleEdit(label_sample_to->text(), *sampleEdit_sample_to, REQUIRED_FIELD);
    wMethod = new WrapperComboBox(label_method->text(), *comboBox_method, REQUIRED_FIELD, methodsList);
    wVarsList = new WrapperQPlainTextEdit(label_variables_list->text(), *textEdit_variables_list, OPTIONAL_FIELD);

    mapFields["From"] = wFrom;
    mapFields["To"] = wTo;
    mapFields["Method"] = wMethod;
    mapFields["VarsList"] = wVarsList;

    className = "MENU_WORKSPACE_EXTRAPOLATE_VARIABLES";
    loadSettings();
}

QIodeMenuWorkspaceExtrapolateVariables::~QIodeMenuWorkspaceExtrapolateVariables()
{
    delete wFrom;
    delete wTo;
    delete wMethod;
    delete wVarsList;

    delete completer;
}

void QIodeMenuWorkspaceExtrapolateVariables::extrapolate_variables()
{
    try
    {
        std::string s_from = wFrom->extractAndVerify().toStdString();
        std::string s_to = wTo->extractAndVerify().toStdString();
        EnumSimulationInitialization method = (EnumSimulationInitialization) wMethod->extractAndVerify();
        std::string vars_list = wVarsList->extractAndVerify().toStdString();

        KDBVariables kdb;
        kdb.extrapolate(method, s_from, s_to, vars_list);
    }
    catch (const std::exception& e)
    {
        QMessageBox::critical(this, tr("ERROR"), tr(e.what()));
        return;
    }
    
    this->accept();
}

void QIodeMenuWorkspaceExtrapolateVariables::help()
{
	QDesktopServices::openUrl(url_manual);
}
