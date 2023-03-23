#include "workspace_copy_into.h"


QIodeMenuWorkspaceCopyInto::QIodeMenuWorkspaceCopyInto(const QString& settings_filepath, QWidget* parent, Qt::WindowFlags f) : 
    QIodeSettings(settings_filepath, parent, f)
{
    setupUi(this);

    QList<QString> qIodeTypes;
    for(const std::string& iode_type: vIodeTypes) qIodeTypes << QString::fromStdString(iode_type);

    wComboBoxObjectType = new WrapperComboBox(label_object_type->text(), *comboBox_object_type, REQUIRED_FIELD, qIodeTypes);
    wFileChooserInputFile = new WrapperFileChooser(label_input_file->text(), *fileChooser_input_file, REQUIRED_FIELD, I_COMMENTS_FILE, EXISTING_FILE);
    wSampleEditSampleFrom = new WrapperSampleEdit(label_sample_from->text(), *sampleEdit_sample_from, OPTIONAL_FIELD);
    wSampleEditSampleTo = new WrapperSampleEdit(sampleEdit_sample_to->text(), *sampleEdit_sample_to, OPTIONAL_FIELD);
    wTextEditObjectNames = new WrapperQTextEdit(label_object_names->text(), *textEdit_object_names, OPTIONAL_FIELD);

    mapFields["ObjectType"] = wComboBoxObjectType;
    mapFields["InputFile"] = wFileChooserInputFile;
    mapFields["SampleFrom"] = wSampleEditSampleFrom;
    mapFields["SampleTo"] = wSampleEditSampleTo;
    mapFields["ObjectNames"] = wTextEditObjectNames;

    // TODO: if possible, find a way to initialize className inside MixingSettings
    // NOTE FOR DEVELOPPERS: we cannot simply call the line below from the constructor of MixingSettings 
    //                       since in that case this refers to MixingSettings and NOT the derived class
    className = QString::fromStdString(typeid(this).name());
    loadSettings();
}

QIodeMenuWorkspaceCopyInto::~QIodeMenuWorkspaceCopyInto()
{
    delete wComboBoxObjectType;
    delete wFileChooserInputFile;
    delete wSampleEditSampleFrom;
    delete wSampleEditSampleTo;
    delete wTextEditObjectNames;
}

void QIodeMenuWorkspaceCopyInto::copy_into_workspace()
{
    try
    {
        int iodeType = wComboBoxObjectType->extractAndVerify();
        std::string input_file = wFileChooserInputFile->extractAndVerify().toStdString();
        std::string from = wSampleEditSampleFrom->extractAndVerify().toStdString();
        std::string to = wSampleEditSampleTo->extractAndVerify().toStdString();
        std::string object_names = wTextEditObjectNames->extractAndVerify().toStdString();

        KDBComments kdb_comments;
        KDBEquations kdb_equations;
        KDBIdentities kdb_identities;
        KDBLists kdb_lists;
        KDBScalars kdb_scalars;
        KDBTables kdb_tables;
        KDBVariables kdb_variables;
        switch (iodeType)
        {
        case I_COMMENTS:
            kdb_comments.copy_into(input_file, object_names);
            break;
        case I_EQUATIONS:
            kdb_equations.copy_into(input_file, object_names);
            break;
        case I_IDENTITIES:
            kdb_identities.copy_into(input_file, object_names);
            break;
        case I_LISTS:
            kdb_lists.copy_into(input_file, object_names);
            break;
        case I_SCALARS:
            kdb_scalars.copy_into(input_file, object_names);
            break;
        case I_TABLES:
            kdb_tables.copy_into(input_file, object_names);
            break;
        case I_VARIABLES:
            kdb_variables.copy_into(input_file, from, to, object_names);
            break;
        default:
            break;
        }
    }
    catch (const std::exception& e)
    {
        QMessageBox::critical(this, tr("ERROR"), tr(e.what()));
        return;
    }

    this->accept();
}

void QIodeMenuWorkspaceCopyInto::help()
{
	QDesktopServices::openUrl(url_manual);
}