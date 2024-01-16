#include "add_list.h"


AddListDialog::AddListDialog(QWidget* parent) : QDialog(parent)
{
	setupUi(this);

	label_title->setText("Add List");
	label_definition->setText("List");

	lineName = new WrapperIodeNameEdit(label_name->text(), *lineEdit_name, I_LISTS, REQUIRED_FIELD);
	lineDefinition = new WrapperQLineEdit(label_definition->text(), *lineEdit_definition, REQUIRED_FIELD);
}

void AddListDialog::add()
{
	try
	{
		std::string name = lineName->extractAndVerify().toStdString();
		std::string list = lineDefinition->extractAndVerify().toStdString();
		Lists.add(name, list);
		this->accept();
	}
	catch (const std::exception& e)
	{
		QMessageBox::warning(nullptr, "WARNING", QString(e.what()));
	}
}

void AddListDialog::help()
{
	
	QDesktopServices::openUrl(url_manual);
}
