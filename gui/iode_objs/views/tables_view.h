#pragma once

#include <QObject>
#include <QShortcut>

#include "abstract_table_view.h"
#include "iode_objs/delegates/tables_delegate.h"
#include "iode_objs/models/tables_model.h"
#include "iode_objs/edit/edit_table.h"
#include "iode_objs/new/add_table.h"
#include "plot/plot_table.h"

#ifndef GSAMPLE_NUMERICAL_WIDGET_HEADER
#define _GSAMPLE_
#include "tabs/iode_objs/tab_numerical_values.h"
#undef _GSAMPLE_
#endif


class TablesView : public IodeAbstractTableView
{
	Q_OBJECT

	QShortcut* shortcutEditEnter;
	QShortcut* shortcutEditReturn;
	QShortcut* shortcutDisplay;
	QShortcut* shortcutPlot;

public:
	TablesView(QWidget* parent = nullptr) : IodeAbstractTableView(I_TABLES, new TablesDelegate(parent), parent)
	{
		shortcutEditEnter = new QShortcut(QKeySequence(Qt::CTRL | Qt::Key_Enter), this);
		connect(shortcutEditEnter, &QShortcut::activated, this, &TablesView::edit_obj);
		
		shortcutEditReturn = new QShortcut(QKeySequence(Qt::CTRL | Qt::Key_Return), this);
		connect(shortcutEditReturn, &QShortcut::activated, this, &TablesView::edit_obj);

		shortcutDisplay = new QShortcut(QKeySequence(Qt::Key_F7), this);
		shortcutDisplay->setContext(Qt::WidgetWithChildrenShortcut);
		connect(shortcutDisplay, &QShortcut::activated, this, &TablesView::display);

		shortcutPlot = new QShortcut(QKeySequence(Qt::Key_F8), this);
		shortcutPlot->setContext(Qt::WidgetWithChildrenShortcut);
		connect(shortcutPlot, &QShortcut::activated, this, &TablesView::plot);
	}

	~TablesView()
	{
		delete shortcutEditEnter;
		delete shortcutEditReturn;
		delete shortcutDisplay;
		delete shortcutPlot;
	}

signals:
    void tableModified();

public slots:
	void new_obj();
	void edit_obj();
	void display();
	void plot();
};
