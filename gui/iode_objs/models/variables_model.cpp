#pragma once
#include "variables_model.h"


QVariant VariablesModel::dataCell(const int row, const int col) const
{
	IODE_REAL var;

	try
	{
		var = kdb->get_var(row, col, mode);
		return valueToString(var);
	}
	catch(const std::exception& e)
	{
		return QVariant(" ");
	}
}

bool VariablesModel::setValue(const int row, const int column, const QVariant& value)
{
	try
	{
		double val = (value == NAN_REP || value == "") ? L_NAN : value.toDouble();
		kdb->set_var(row, column, val);
		return true;
	}
	catch (const std::exception& e)
	{
		QMessageBox::warning(nullptr, "WARNING", QString(e.what()));
		return false;
	}
}

void VariablesModel::reset()
{
	columnNames = QVector<QString>();
	for (const std::string& period: Variables.get_list_periods()) 
		columnNames.append(QString::fromStdString(period));

	IodeAbstractTableModel::reset();
}
