/* NOTE FOR THE DEVELOPPERS:
 * 1. We do not use the preprocessor directive #pragma once so that two 
 *    different versions of the class _NUMERICAL_VIEW_CLASS_NAME_ below can be built.
 *    Depending on if _GSAMPLE_ is defined or not.
 * 
 * 2. Multiple Inheritance Requires QObject to Be First
 *    If you are using multiple inheritance, moc assumes that the first inherited class
 *    is a subclass of QObject. Also, be sure that only the first inherited class is a QObject.
 *    https://doc.qt.io/qt-6/moc.html#multiple-inheritance-requires-qobject-to-be-first
 *    --> That's why we to play with preprocessor directives to inherit from either 
 *        QTableView or TemplateTableView.
 * 
 * 3. Do NOT forget to add safeguards when including the present hearder!
 */

#include <QList>
#include <QMenu>
#include <QObject>
#include <QString>
#include <QShortcut>
#include <QClipboard>
#include <QTableView>
#include <QMessageBox>

#ifdef _GSAMPLE_
#define GSAMPLE_NUMERICAL_VIEW_HEADER

#include "utils.h"

#define _NUMERICAL_VIEW_CLASS_NAME_ GSampleNumericalTableView

class _NUMERICAL_VIEW_CLASS_NAME_ : public QTableView
#else
#define TEMPLATE_NUMERICAL_VIEW_HEADER

#include "abstract_table_view.h"
#include "iode_objs/delegates/base_delegate.h"
#include "iode_objs/models/abstract_table_model.h"

#define _NUMERICAL_VIEW_CLASS_NAME_ TemplateNumericalTableView

template <class M> class _NUMERICAL_VIEW_CLASS_NAME_ : public TemplateTableView<M>
#endif
{
    QShortcut* shortcutCopy;
    QShortcut* shortcutCopyIncludingHeaders;
    QShortcut* shortcutPast;

protected:
    QMenu* contextMenu;

protected:
    QAction* addAction(const QString& name, const QString& tooltip, const QKeySequence& shortcut = QKeySequence())
    {
        QAction* action = new QAction(name, this);
        action->setToolTip(tooltip);
        action->setVisible(true);
        if(!shortcut.isEmpty()) action->setShortcut(shortcut);
        contextMenu->addAction(action);
        return action;
    }

    void contextMenuEvent(QContextMenuEvent* event) override
    {
        contextMenu->popup(event->globalPos());
        event->accept();
    }

private:
	void setupContextMenu()
    {
        QAction* action;
        contextMenu = new QMenu(this);

        action = addAction("Copy", "Copy selected values to the clipboard", shortcutCopy->key());
        QObject::connect(action, &QAction::triggered, this, &_NUMERICAL_VIEW_CLASS_NAME_::copy);

        action = addAction("Copy Including Headers", "Copy selected values and headers to the clipboard", shortcutCopyIncludingHeaders->key());
        QObject::connect(action, &QAction::triggered, this, &_NUMERICAL_VIEW_CLASS_NAME_::copyIncludingHeaders);

#ifndef _GSAMPLE_
        action = addAction("Paste", "Paste values contained in the clipboard", shortcutPast->key());
        QObject::connect(action, &QAction::triggered, this, &_NUMERICAL_VIEW_CLASS_NAME_::paste);
#endif
    }

public:
#ifdef _GSAMPLE_
    _NUMERICAL_VIEW_CLASS_NAME_(QWidget* parent = nullptr): QTableView(parent)
#else
    _NUMERICAL_VIEW_CLASS_NAME_(EnumIodeType iodeType, BaseDelegate* delegate, QWidget* parent = nullptr):
        TemplateTableView<M>(iodeType, delegate, parent) 
#endif
    {
        shortcutCopy = new QShortcut(QKeySequence::Copy, this);
        shortcutCopy->setContext(Qt::WidgetWithChildrenShortcut);
        QObject::connect(shortcutCopy, &QShortcut::activated, this, &_NUMERICAL_VIEW_CLASS_NAME_::copy);
        
        shortcutCopyIncludingHeaders = new QShortcut(QKeySequence(Qt::CTRL | Qt::SHIFT | Qt::Key_C), this);
        shortcutCopyIncludingHeaders->setContext(Qt::WidgetWithChildrenShortcut);
        QObject::connect(shortcutCopyIncludingHeaders, &QShortcut::activated, this, &_NUMERICAL_VIEW_CLASS_NAME_::copyIncludingHeaders);
        
#ifndef _GSAMPLE_
        shortcutPast = new QShortcut(QKeySequence::Paste, this);
        shortcutPast->setContext(Qt::WidgetWithChildrenShortcut);
        QObject::connect(shortcutPast, &QShortcut::activated, this, &_NUMERICAL_VIEW_CLASS_NAME_::paste);
#endif

        // context menu = popup menu displayed when a user right clicks
        setupContextMenu();
    }

    ~_NUMERICAL_VIEW_CLASS_NAME_()
    {
        delete contextMenu;

        delete shortcutCopy;
        delete shortcutCopyIncludingHeaders;
#ifndef _GSAMPLE_
        delete shortcutPast;
#endif
    }

    void copy()
    {
        try
        {
            QList<QStringList> values = extractValues();

            QString text;
            foreach(const QStringList& rowValues, values)
                text += rowValues.join("\t") + "\n";

            QClipboard* clipboard = QApplication::clipboard();
            clipboard->setText(text);
        }
        catch(const std::exception& e)
        {
            QMessageBox::warning(nullptr, "WARNING", "Can't copy values\n\n" + QString::fromStdString(e.what()));
        }
    }

    void copyIncludingHeaders()
    {
        try
        {
            QStringList objectsNames = extractObjectsNames();
            QStringList sample = extractSample();
            QList<QStringList> values = extractValues();

            QString text = "\t" + sample.join("\t") + "\n";
            for(int row = 0; row < values.size(); row++)
                text += objectsNames[row] + "\t" + values.at(row).join("\t") + "\n";

            QClipboard* clipboard = QApplication::clipboard();
            clipboard->setText(text);
        }
        catch(const std::exception& e)
        {
            QMessageBox::warning(nullptr, "WARNING", "Can't copy values\n\n" + QString::fromStdString(e.what()));
        }
    }

#ifndef _GSAMPLE_
    void paste()
    {
        try
        {
            QModelIndex start = this->selectionModel()->selectedIndexes().first();
            QAbstractItemModel* model_ = this->model();

            QClipboard* clipboard = QApplication::clipboard();
            QString text = clipboard->text();

            // If the text from clipboard ends with the new-line character (which is the case when we copy 
            // from Excel), the QString::split() function returns a list ending by an empty element. 
            // This empty element is then interpreted as a new NaN value by the setData function.
            if(text.endsWith("\n"))
                text.chop(1);

            int i=0, j=0;
            foreach(const QString& row_string, text.split("\n"))
            {
                j=0;
                foreach(const QString& value, row_string.split("\t"))
                {
                    QModelIndex index = model_->index(start.row() + i , start.column()+ j);
                    if(index.isValid())
                        model_->setData(index, value, Qt::EditRole);
                    j++;
                }
                i++;
            }
        }
        catch(const std::exception& e)
        {
            QMessageBox::warning(nullptr, "WARNING", "Can't paste values\n\n" + QString::fromStdString(e.what()));
        }
    }
#endif

protected:
    QStringList extractObjectsNames()
    {
        QItemSelectionRange selection_range =  this->selectionModel()->selection().first();
        QAbstractItemModel* model_ = this->model();

        QStringList objectNames;
        for(int row = selection_range.top(); row <= selection_range.bottom(); row++)
            objectNames << model_->headerData(row, Qt::Vertical, Qt::DisplayRole).toString();

        return objectNames;
    }

    QStringList extractSample()
    {
        QItemSelectionRange selection_range =  this->selectionModel()->selection().first();
        QAbstractItemModel* model_ = this->model();

        QStringList sample;
        for(int column = selection_range.left(); column <= selection_range.right(); column++)
            sample << model_->headerData(column, Qt::Horizontal, Qt::DisplayRole).toString();

        return sample;
    }

	QList<QStringList> extractValues()
    {

        QItemSelectionRange selection_range =  this->selectionModel()->selection().first();
        QAbstractItemModel* model_ = this->model();

        QString value;
        QList<QStringList> values;
        for(int row = selection_range.top(); row <= selection_range.bottom(); row++)
        {
            QStringList rowValues;
            for(int column = selection_range.left(); column <= selection_range.right(); column++)
            {
                value = model_->data(model_->index(row, column), Qt::DisplayRole).toString();
                rowValues << ((value == NAN_REP) ? "" : value);
            }
            values.push_back(rowValues);
        }
        
        return values;
    }
};
