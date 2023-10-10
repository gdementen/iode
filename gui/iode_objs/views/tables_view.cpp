#include "tables_view.h"


void TablesView::new_obj()
{
	AddTableDialog dialog(this);
	if(dialog.exec() == QDialog::Accepted)
		emit newObjectInserted();
	filter();
}

void TablesView::display()
{
	// get the selected object
	QModelIndexList selection = this->selectionModel()->selectedRows();
	if(selection.size() == 0) 
		return;
	QModelIndex index = selection[0];

	QString tableName = model()->headerData(index.row(), Qt::Vertical, Qt::DisplayRole).toString();

	try
	{
		// check if global sample is defined
		if(!checkGlobalSample())
			return;

		// generates the GSample representing the whole global sample
		KDBVariables kdb_var;
		Sample smpl = kdb_var.get_sample();
		QString gsample = QString::fromStdString(smpl.start_period().to_string()) + ":" + QString::number(smpl.nb_periods());

		// computes and display the selected table
		MainWindowAbstract* main_window = static_cast<MainWindowAbstract*>(get_main_window_ptr());
		GSampleNumericalDialog* view = new GSampleNumericalDialog(tableName, gsample, 4, "", this);
		main_window->appendDialog(view);
	}
    catch (const std::exception& e)
    {
        QMessageBox::warning(this, "WARNING", "Could not compute table " + tableName + ":\n" + QString::fromStdString(e.what()));
        return;
    }
}

void TablesView::plot()
{
	// get the selected object
	QModelIndexList selection = this->selectionModel()->selectedRows();
	if(selection.size() == 0) 
		return;
	QModelIndex index = selection[0];

	QString tableName = model()->headerData(index.row(), Qt::Vertical, Qt::DisplayRole).toString();

	try
	{
		// check if global sample is defined
		if(!checkGlobalSample())
			return;

		// generates the GSample representing the whole global sample
		KDBVariables kdb_var;
		Sample smpl = kdb_var.get_sample();
		QString gsample = QString::fromStdString(smpl.start_period().to_string()) + ":" + QString::number(smpl.nb_periods());

		// computes the tables and generates the associated graph
		MainWindowAbstract* main_window = static_cast<MainWindowAbstract*>(get_main_window_ptr());
		GSampleGraph* gSampleGraph = new GSampleGraph(tableName.toStdString(), gsample.toStdString());
		PlotTableDialog* plotDialog = new PlotTableDialog(gSampleGraph);
		main_window->appendPlot(plotDialog);
	}
    catch (const std::exception& e)
    {
        QMessageBox::warning(this, "WARNING", "Could not compute table " + tableName + ":\n" + QString::fromStdString(e.what()));
        return;
    }
}
