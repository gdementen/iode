#include "edit_equation.h"


EditEquation::EditEquation(const QString& equationName, QWidget* parent) : 
	QIodeSettings(parent, Qt::WindowMinMaxButtonsHint | Qt::WindowCloseButtonHint)
{
	setupUi(this);

	completer = new IodeCompleter(false, false, {I_SCALARS, I_VARIABLES}, textEdit_lec);
	textEdit_lec->setCompleter(completer);
	textEdit_lec->setLineWrapMode(QPlainTextEdit::LineWrapMode::WidgetWidth);

    fullScreenShortcut = new QShortcut(QKeySequence(Qt::CTRL | Qt::Key_X), this);
    fullScreenShortcut->setContext(Qt::ShortcutContext::WidgetWithChildrenShortcut);

    connect(fullScreenShortcut, &QShortcut::activated, this, &EditEquation::showMaximized);

	estimation = nullptr;

	int i = 0;
	QList<QString> list_methods;
	for (const std::string& method : vEquationMethods) list_methods << QString::fromStdString(method);

	lineName = new WrapperIodeNameEdit(label_name->text(), *lineEdit_name, I_EQUATIONS, REQUIRED_FIELD);
	comboBoxMethod = new WrapperComboBox(label_method->text(), *comboBox_method, OPTIONAL_FIELD, list_methods);
	sampleFrom = new WrapperSampleEdit(label_from->text(), *sampleEdit_from, OPTIONAL_FIELD);
	sampleTo = new WrapperSampleEdit(label_to->text(), *sampleEdit_to, OPTIONAL_FIELD);
	lineLec = new WrapperQPlainTextEdit(label_lec->text(), *textEdit_lec, REQUIRED_FIELD);
	lineComment = new WrapperQLineEdit(label_comment->text(), *lineEdit_comment, OPTIONAL_FIELD);
	lineBlock = new WrapperQLineEdit(label_block->text(), *lineEdit_block, OPTIONAL_FIELD);
	lineInstruments = new WrapperQLineEdit(label_instruments->text(), *lineEdit_instruments, OPTIONAL_FIELD);

	mapFields["Method"] = comboBoxMethod;
	mapFields["From"] = sampleFrom;
	mapFields["To"] = sampleTo;

	std::string equation_name = equationName.toStdString();
	if(!equation_name.empty() && kdb_eqs.contains(equation_name))
	{
		// --- existing equation ---
		className = "TAB_EDIT_EQUATION";
		lineEdit_name->setReadOnly(true);
		NamedEquation equation(equation_name);
		display_equation(equation);
	}
	else
	{
		// --- new equation ---
		className = "TAB_ADD_EQUATION";
		lineEdit_name->setReadOnly(false);
		loadSettings();
	}
}

EditEquation::~EditEquation() 
{
	delete lineName;
	delete comboBoxMethod;
	delete sampleFrom;
	delete sampleTo;
	delete lineLec;
	delete lineComment;
	delete lineBlock;
	delete lineInstruments;

	delete completer;

	delete fullScreenShortcut;

	if(estimation) delete estimation;
}

void EditEquation::set_estimation()
{
	try
	{
		if(estimation)
		{
			delete estimation;
			estimation = nullptr;
		}

		// sample
		std::string from = sampleFrom->extractAndVerify().toStdString();
		std::string to = sampleTo->extractAndVerify().toStdString();
		Sample sample(from, to);

		// block
		std::string block = lineBlock->extractAndVerify().toStdString();
		if(block.empty()) 
			block = lineName->extractAndVerify().toStdString();
		
		// check method
		int i_method = comboBoxMethod->extractAndVerify();
		if(i_method < 0)
			throw IodeExceptionInvalidArguments("Cannot estimate block or equation " + block, 
				"Please choose a method in the drop-down list");

		estimation = new Estimation(sample, block);

		NamedEquation equation = estimation->current_equation();
		display_equation(equation);
	}
	catch (const std::exception& e)
	{
		QMessageBox::warning(static_cast<QWidget*>(parent()), tr("WARNING"), tr(e.what()));
	}
}

void EditEquation::display_equation(const NamedEquation& equation)
{
	lineName->setQValue(QString::fromStdString(equation.name));
	Equation eq = equation.eq;

	// editable values
	comboBoxMethod->setQValue(eq.get_method_as_int());
	Sample sample = eq.get_sample();
	sampleFrom->setQValue(QString::fromStdString(sample.start_period().to_string()));
	sampleTo->setQValue(QString::fromStdString(sample.end_period().to_string()));
	lineLec->setQValue(QString::fromStdString(eq.get_lec()));
	lineComment->setQValue(QString::fromStdString(eq.get_comment()));
	lineBlock->setQValue(QString::fromStdString(eq.get_block()));
	lineInstruments->setQValue(QString::fromStdString(eq.get_instruments()));

	// read-only values
	std::array<float, EQS_NBTESTS> tests = eq.get_tests();
	lineEdit_tests_r2adj->setText(QString::number(tests[IE_R2ADJ], 'g', 3));
	lineEdit_tests_durbw->setText(QString::number(tests[IE_DW], 'g', 3));
	lineEdit_tests_fstat->setText(QString::number(tests[IE_FSTAT], 'g', 3));
	lineEdit_tests_loglk->setText(QString::number(tests[IE_LOGLIK], 'g', 3));
}

void EditEquation::edit()
{
	try
	{
		std::string equation_name = lineName->extractAndVerify().toStdString();

		// TODO : remove extra \n
		std::string lec = lineLec->extractAndVerify().toStdString();
		int i_method = comboBoxMethod->extractAndVerify();
		std::string method = (i_method > 0) ? vEquationMethods[i_method] : "";
		std::string from = sampleFrom->extractAndVerify().toStdString();
		std::string to = sampleTo->extractAndVerify().toStdString();
		std::string comment = lineComment->extractAndVerify().toStdString();
		std::string block = lineBlock->extractAndVerify().toStdString();
		std::string instruments = lineInstruments->extractAndVerify().toStdString();


		Sample* sample = nullptr; 
		if(!(from.empty() || to.empty()))
			sample = new Sample(from, to);
		
		std::array<float, EQS_NBTESTS> tests = { 0.0 };

		// update equation
		if (kdb_eqs.contains(equation_name))
		{
			Equation eq = kdb_eqs.get(equation_name);
			computeHash(eq, true);

			kdb_eqs.update(equation_name, lec, comment, method, sample, instruments, block, &tests);
		
			Equation updated_eq = kdb_eqs.get(equation_name);
			computeHash(updated_eq);
		}
		// new equation
		else
		{
			kdb_eqs.add(equation_name, lec, comment, method, sample, instruments, block, tests, true);
			emit equationModified();
		}

		if(estimation) 
			estimation->save();

		if(sample) 
			delete sample;
		
		this->accept();
	}
	catch (const std::exception& e)
	{
		QMessageBox::warning(static_cast<QWidget*>(parent()), tr("WARNING"), tr(e.what()));
	}
}

void EditEquation::display_coefs()
{
	if(estimation)
	{
		try
		{
			KDBScalars* kdb_scl = estimation->get_coefficients();
			QIodeEstimationCoefs dialog(kdb_scl, this);
			dialog.exec();
		}
		catch (const std::exception& e)
		{
			QMessageBox::warning(static_cast<QWidget*>(parent()), tr("WARNING"), tr(e.what()));
		}	
	}
	else
	{
		QMessageBox::warning(static_cast<QWidget*>(parent()), tr("WARNING"), "No estimation has been done yet");
	}
}

void EditEquation::estimate()
{
	set_estimation();
	if(estimation)
	{
		try
		{
			estimation->equations_estimate();
		}
		catch (const std::exception& e)
		{
			QMessageBox::warning(static_cast<QWidget*>(parent()), tr("WARNING"), tr(e.what()));
		}
	}
}

void EditEquation::next()
{
	if(estimation)
	{
		try
		{
			NamedEquation equation = estimation->next_equation();
			display_equation(equation);
		}
		catch (const std::exception& e)
		{
			QMessageBox::warning(static_cast<QWidget*>(parent()), tr("WARNING"), tr(e.what()));
		}
	}
}

void EditEquation::dynamic_adjustment()
{
	QString lec = lineLec->extractAndVerify();
	QIodeDynAdjustment dialog(lec, this);
	dialog.exec();
	lineLec->setQValue(lec);
}

void EditEquation::results()
{
	if(estimation)
	{
		try
		{
			QIodeEstimationResults dialog(estimation, this);
			dialog.exec();
		}
		catch (const std::exception& e)
		{
			QMessageBox::warning(static_cast<QWidget*>(parent()), tr("WARNING"), tr(e.what()));
		}
	}
	else
	{
		QMessageBox::warning(static_cast<QWidget*>(parent()), tr("WARNING"), "No estimation has been done yet");
	}
}

void EditEquation::unit_root()
{
	QIodeUnitRoot dialog(this);
	dialog.exec();
}

void EditEquation::help()
{
	QDesktopServices::openUrl(url_manual);
}