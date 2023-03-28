#include "dyn_adjustment.h"


QIodeDynAdjustment::QIodeDynAdjustment(QString& lec, const QString& settings_filepath, QWidget* parent, Qt::WindowFlags f) : 
    QIodeSettings(settings_filepath, parent, f), lec(lec)
{
    // TODO: if possible, find a way to initialize className inside MixingSettings
	// NOTE FOR DEVELOPPERS: we cannot simply call the line below from the constructor of MixingSettings 
	//                       since in that case this refers to MixingSettings and NOT the derived class
	className = QString::fromStdString(typeid(this).name());

	setupUi(this);

    textEdit_equation->setText(lec);

    QList<QString> list_methods;
    for(const std::string& method : v_adjstment_method) list_methods.append(QString::fromStdString(method));
    comboMethod = new WrapperComboBox(label_method->text(), *comboBox_method, REQUIRED_FIELD, list_methods);
    lineCoef1 = new WrapperQLineEdit(label_coefs->text(), *lineEdit_coef1, REQUIRED_FIELD);
    lineCoef2 = new WrapperQLineEdit(label_coefs->text(), *lineEdit_coef2, REQUIRED_FIELD);

    mapFields["Method"] = comboMethod;
    mapFields["Coef1"] = lineCoef1;
    mapFields["Coef2"] = lineCoef2;

    loadSettings();
}

QIodeDynAdjustment::~QIodeDynAdjustment()
{
    delete comboMethod;
    delete lineCoef1;
    delete lineCoef2;
}

void QIodeDynAdjustment::adjust()
{
    try
    {
        std::string std_lec = textEdit_equation->toPlainText().toStdString();
        EnumIodeAdjustmentMethod method = (EnumIodeAdjustmentMethod) comboMethod->extractAndVerify();
        std::string coef1 = lineCoef1->extractAndVerify().toStdString();
        std::string coef2 = lineCoef2->extractAndVerify().toStdString();

        std::string adjusted_lec = dynamic_adjustment(method, std_lec, coef1, coef2);
        lec = QString::fromStdString(adjusted_lec);

        this->accept();
    }
    catch(const std::exception& e)
    {
        QMessageBox::warning(static_cast<QWidget*>(parent()), tr("Warning"), tr(e.what()));
    }
}

void QIodeDynAdjustment::help()
{
	QDesktopServices::openUrl(url_manual);
}