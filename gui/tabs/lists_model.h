#pragma once

#include <QObject>

#include "abstract_table_model.h"


class ListsModel : public IODEAbstractTableModel<KDBLists>
{
	Q_OBJECT

public:
	ListsModel(QObject* parent = nullptr) : IODEAbstractTableModel({ "Name", "List" }, parent) {};

private:
	QVariant dataCell(const int row, const int col) const
	{
		if (col == 0)
			return QVariant(QString::fromStdString(kdb.get_name(row)));
		else
			return QVariant(QString::fromStdString(kdb.get(row)));
	}

public slots:
	void reset() { resetModel(); };
};
