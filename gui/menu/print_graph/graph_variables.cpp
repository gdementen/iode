#include "graph_variables.h"


QIodeMenuGraphVariables::QIodeMenuGraphVariables(QWidget* parent) : 
    QIodeSettings(parent)
{
    setupUi(this);

    completer = new QIodeCompleter(false, false, I_VARIABLES, textEdit_variables);
    textEdit_variables->setCompleter(completer);

    lineEdit_min_Y->setValidator(new QDoubleValidator(lineEdit_min_Y));
    lineEdit_max_Y->setValidator(new QDoubleValidator(lineEdit_max_Y));

    QList<QString> q_var_modes;
    for(const std::string& var_mode: v_var_modes) q_var_modes << QString::fromStdString(var_mode);
    QList<QString> q_chart_types;
    for(const std::string& chart_type: vGraphsChartTypes) q_chart_types << QString::fromStdString(chart_type);
    QList<QString> q_axis_ticks;
    for(const std::string& axis_ticks: vGraphsAxisThicks) q_axis_ticks << QString::fromStdString(axis_ticks);
    QList<QString> q_langs;
    for(const std::string& lang: vLangs) q_langs << QString::fromStdString(lang);

    wVariables = new WrapperQPlainTextEdit(label_variables->text(), *textEdit_variables, REQUIRED_FIELD);
    wVarMode = new WrapperComboBox(label_x_axis_type->text(), *comboBox_x_axis_type, REQUIRED_FIELD, q_var_modes);
    wFrom = new WrapperSampleEdit(label_sample_from->text(), *sampleEdit_sample_from, REQUIRED_FIELD);
    wTo = new WrapperSampleEdit(label_sample_to->text(), *sampleEdit_sample_to, REQUIRED_FIELD);
    wChartType = new WrapperComboBox(label_chart_type->text(), *comboBox_chart_type, REQUIRED_FIELD, q_chart_types);
    wYAxisScale = new WrapperCheckBox(label_chart_type->text(), *checkBox_log_scale, REQUIRED_FIELD);
    wXTicks = new WrapperComboBox(label_X_ticks->text(), *comboBox_X_ticks, REQUIRED_FIELD, q_axis_ticks);
    wYTicks = new WrapperComboBox(label_Y_ticks->text(), *comboBox_Y_ticks, REQUIRED_FIELD, q_axis_ticks);
    wMinY = new WrapperQLineEdit(label_min_Y->text(), *lineEdit_min_Y, OPTIONAL_FIELD);
    wMaxY = new WrapperQLineEdit(label_max_Y->text(), *lineEdit_max_Y, OPTIONAL_FIELD);
    wLanguage = new WrapperComboBox(label_language->text(), *comboBox_language, REQUIRED_FIELD, q_langs);
    
    mapFields["Variables"]  = wVariables;
    mapFields["VarMode"]    = wVarMode;
    mapFields["From"]       = wFrom;
    mapFields["To"]         = wTo;
    mapFields["ChartType"]  = wChartType;
    mapFields["YAxisScale"] = wYAxisScale;
    mapFields["XTicks"]     = wXTicks;
    mapFields["YTicks"]     = wYTicks;
    mapFields["MinY"]       = wMinY;
    mapFields["MaxY"]       = wMaxY;
    mapFields["Language"]   = wLanguage;

    className = "MENU_GRAPH_VARIABLES";
    loadSettings();
}

QIodeMenuGraphVariables::~QIodeMenuGraphVariables()
{
    delete wVariables;
    delete wVarMode;
    delete wFrom;
    delete wTo;
    delete wChartType;
    delete wYAxisScale;
    delete wXTicks;
    delete wYTicks;
    delete wMinY;
    delete wMaxY;
    delete wLanguage;

    delete completer;
}

void QIodeMenuGraphVariables::display()
{
    try
    {
        EnumIodeGraphChart chartType = (EnumIodeGraphChart) wChartType->extractAndVerify();
        EnumIodeVarMode varMode = (EnumIodeVarMode) wVarMode->extractAndVerify();
        bool logScale = wYAxisScale->extractAndVerify();
        EnumIodeGraphAxisThicks xTicks = (EnumIodeGraphAxisThicks) wXTicks->extractAndVerify();
        EnumIodeGraphAxisThicks yTicks = (EnumIodeGraphAxisThicks) wYTicks->extractAndVerify();

        QIodePlotVariablesDialog* plotDialog = new QIodePlotVariablesDialog(nullptr, chartType, varMode, logScale, xTicks, yTicks);

        // periods for the plot
        QString from = wFrom->extractAndVerify();
        QString to = wTo->extractAndVerify();
        KDBVariables kdb_var;
        plotDialog->setPeriods(kdb_var.get_sample(), from, to);

        // set min and max Y
        QString qMinY = wMinY->extractAndVerify();
        if(!qMinY.isEmpty())
            plotDialog->setMinValue(qMinY.toDouble());

        QString qMaxY = wMaxY->extractAndVerify();
        if(!qMaxY.isEmpty())
            plotDialog->setMaxValue(qMaxY.toDouble());

        // add plot series
        std::string vars_names = wVariables->extractAndVerify().toStdString();
        char** list_vars_names = filter_kdb_names(I_VARIABLES, vars_names);
        int nb_vars = SCR_tbl_size((unsigned char**) list_vars_names);
        for(int i=0; i<nb_vars; i++)
        {
            QString variable = QString::fromStdString(std::string(list_vars_names[i]));
            plotDialog->addSeries(variable);
        }
        
        // not used
        EnumLang lang = (EnumLang) wLanguage->extractAndVerify();

        // build the plot
        plotDialog->plot();
        emit newPlot(plotDialog);
    }
    catch (const std::exception& e)
    {
        QMessageBox::critical(this, tr("ERROR"), tr(e.what()));
        return;
    }
    
    this->accept();
}

void QIodeMenuGraphVariables::apply()
{
    try
    {
        QMessageBox::warning(this, "WARNING", "Apply is not yet implemented");
    }
    catch (const std::exception& e)
    {
        QMessageBox::critical(this, tr("ERROR"), tr(e.what()));
        return;
    }
}

void QIodeMenuGraphVariables::setup()
{
    try
    {
        QIodeMenuFilePrintSetup dialog(this);
        dialog.exec();
    }
    catch (const std::exception& e)
    {
        QMessageBox::critical(this, tr("ERROR"), tr(e.what()));
        return;
    }
}

void QIodeMenuGraphVariables::help()
{
	
	QDesktopServices::openUrl(url_manual);
}
