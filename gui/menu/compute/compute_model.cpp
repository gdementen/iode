#include "compute_model.h"


/* NOTE FOR THE DEVELOPERS:
 * The constructor of a Menu Dialog class deriving from QIodeSettings MUST:
 * 2. call setupUi(this),
 * 3. use the Wrapper classes defined in the wrapper_classes.h header file to wrap the input field items,
 * 4. fill the mapFields member (inherited from QIodeSettings) with the wrapped field items,
 * 5. initialize the inherited className member (using typeid(this).name())
 * 6. call the loadSettings() method (inherited from QIodeSettings).
 */


QIodeMenuComputeModel::QIodeMenuComputeModel(const QString& project_settings_filepath, QWidget* parent, Qt::WindowFlags f) : 
    QIodeSettings(project_settings_filepath, parent, f)
{
    setupUi(this);

	completer = new QIodeCompleter(false, false, I_EQUATIONS, textEdit_equations_list);
	textEdit_equations_list->setCompleter(completer);

    qEquationsList = new WrapperQPlainTextEdit(label_equations_list->text(), *textEdit_equations_list, OPTIONAL_FIELD);
    mapFields["EquationsList"] = qEquationsList;

    className = "MENU_COMPUTE_MODEL";
    loadSettings();
}

QIodeMenuComputeModel::~QIodeMenuComputeModel()
{
    delete qEquationsList;
    delete completer;
}

void QIodeMenuComputeModel::compute()
{
    try
    {
        std::string equations_list = qEquationsList->extractAndVerify().toStdString();

        Simulation sim;

        sim.model_compile(equations_list);

        this->accept();
    }
    catch (const std::exception& e)
    {
        QMessageBox::critical(this, tr("ERROR"), tr(e.what()));
    }
}