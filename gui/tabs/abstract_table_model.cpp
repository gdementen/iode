#pragma once
#include "abstract_table_model.h"


template <class K>
Qt::ItemFlags IODEAbstractTableModel<K>::flags(const QModelIndex& index) const
{
	if (!index.isValid())
		return Qt::ItemIsEnabled;

	return QAbstractItemModel::flags(index) | Qt::ItemIsEditable;
}

template <class K>
QVariant IODEAbstractTableModel<K>::headerData(int section, Qt::Orientation orientation, int role) const
{
	if (role != Qt::DisplayRole)
		return QVariant();

	if (orientation == Qt::Horizontal)
		return columnNames[section];

	return QVariant("  ");
}

template <class K>
QVariant IODEAbstractTableModel<K>::data(const QModelIndex& index, int role) const
{
	if (!index.isValid())
		return QVariant();

	if (role == Qt::TextAlignmentRole)
		return int(Qt::AlignLeft);

	if (role == Qt::DisplayRole || role == Qt::EditRole)
		return dataCell(index.row(), index.column());
	else
		return QVariant();
}

template <class K>
bool IODEAbstractTableModel<K>::setData(const QModelIndex& index, const QVariant& value, int role)
{
	if (index.isValid() && role == Qt::EditRole)
	{
		bool success = setDataCell(index.row(), index.column(), value);
		if (success)
		{
			emit dataChanged(index, index, { role });
			return true;
		}
		else
		{
			return false;
		}
	}
	else
	{
		return false;
	}
}

template <class K>
bool IODEAbstractTableModel<K>::setName(const int row, const QString& new_name)
{
	try
	{
		kdb.set_name(row, new_name.toStdString());
		return true;
	}
	catch (const std::runtime_error& e)
	{
		QMessageBox::warning(static_cast<QWidget*>(parent()), tr("Warning"), tr(e.what()));
		return false;
	}
}

template <class K>
bool IODEAbstractTableModel<K>::setDataCell(const int row, const int column, const QVariant& value)
{
	if (column == 0)
	{
		return setName(row, value.toString());
	}
	else
	{
		return setValue(row, column, value);
	}
}

template <class K>
bool IODEAbstractTableModel<K>::removeRows(int position, int rows, const QModelIndex& index)
{
	beginRemoveRows(QModelIndex(), position, position + rows - 1);

	std::string name;

	try
	{
		for (int row = position; row < position + rows; ++row)
		{
			name = dataCell(row, 0).toString().toStdString();
			kdb.remove(name);
		}
	}
	catch (const std::runtime_error& e)
	{
		QMessageBox::warning(static_cast<QWidget*>(parent()), tr("Warning"), tr(e.what()));
	}

	endRemoveRows();
	return true;
}