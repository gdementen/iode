#pragma once

#include <QObject>
#include <QWidget>
#include <QGridLayout>
#include <QLineEdit>
#include <QPushButton>
#include <QSizePolicy>
#include <QStringList>

#include "qiode_tab_abstract.h"

#include "iode_objs/models/comments_model.h"
#include "iode_objs/models/equations_model.h"
#include "iode_objs/models/identities_model.h"
#include "iode_objs/models/lists_model.h"
#include "iode_objs/models/scalars_model.h"
#include "iode_objs/models/tables_model.h"
#include "iode_objs/models/variables_model.h"

#include "iode_objs/views/comments_view.h"
#include "iode_objs/views/equations_view.h"
#include "iode_objs/views/identities_view.h"
#include "iode_objs/views/lists_view.h"
#include "iode_objs/views/scalars_view.h"
#include "iode_objs/views/tables_view.h"
#include "iode_objs/views/variables_view.h"

const static QString prefixUnsavedDatabase = "Unsaved";


class AbstractIodeObjectWidget: public AbstractTabWidget
{
protected:
    EnumIodeType iodeType;

    QGridLayout* layout;
    QLineEdit* lineEdit_filter;
    QPushButton* pushButton_filter;
    QPushButton* add_iode_obj;

public:
    AbstractIodeObjectWidget(const EnumIodeType iodeType, QWidget* parent = nullptr) : 
        AbstractTabWidget((EnumIodeFile) iodeType, "", parent)
    {
        this->setObjectName(QString::fromUtf8("widget_iode_obj"));

        // layout
        layout = new QGridLayout(this);
        layout->setObjectName(QString::fromUtf8("layout"));
        layout->setContentsMargins(0, 0, 0, 0);

        // filter 
        lineEdit_filter = new QLineEdit();
        lineEdit_filter->setObjectName(QString::fromUtf8("lineEdit_filter"));
        lineEdit_filter->setPlaceholderText("filter pattern here");
        QSizePolicy sizePolicyFilter(QSizePolicy::Expanding, QSizePolicy::Fixed);
        sizePolicyFilter.setHorizontalStretch(0);
        sizePolicyFilter.setVerticalStretch(0);
        sizePolicyFilter.setHeightForWidth(lineEdit_filter->sizePolicy().hasHeightForWidth());
        lineEdit_filter->setSizePolicy(sizePolicyFilter);
        lineEdit_filter->setMinimumSize(QSize(200, 0));
        layout->addWidget(lineEdit_filter, 0, 0, Qt::AlignLeft);

        pushButton_filter = new QPushButton("Filter");
        pushButton_filter->setObjectName(QString::fromUtf8("pushButton_filter"));
        layout->addWidget(pushButton_filter, 0, 1, Qt::AlignLeft);

        // spacers
        QSpacerItem* horizontalSpacer = new QSpacerItem(828, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);
        layout->addItem(horizontalSpacer, 0, 2);

        // add button
        add_iode_obj = new QPushButton("Add " + QString::fromStdString(vIodeTypes[iodeType]));
        add_iode_obj->setObjectName(QString::fromUtf8("add_iode_obj"));
        QSizePolicy sizePolicyAdd(QSizePolicy::Fixed, QSizePolicy::Fixed);
        sizePolicyAdd.setHorizontalStretch(0);
        sizePolicyAdd.setVerticalStretch(0);
        sizePolicyAdd.setHeightForWidth(add_iode_obj->sizePolicy().hasHeightForWidth());
        add_iode_obj->setSizePolicy(sizePolicyAdd);
        layout->addWidget(add_iode_obj, 0, 3, Qt::AlignRight);
    }

    ~AbstractIodeObjectWidget()
    {
        delete lineEdit_filter;
        delete pushButton_filter;
        delete add_iode_obj;
        delete layout;
    }

    /**
     * @brief Return whether or not the tooltip is associated with a tab representing an unsaved KDB.
     * 
     * @param QString Tooltip of the tab. 
     * @return bool
     */
    bool isUnsavedDatabase() const
    {
        return filepath.isEmpty() || filepath == QString(I_DEFAULT_FILENAME);
    }

    QString getTabText() const
    {
        if(isUnsavedDatabase())
        {
            QString ext = QString::fromStdString(v_binary_ext[fileType]);
            // Note: the * is to tell that the content of the KDB has not been saved in file
            return tabPrefix[fileType] + QString(I_DEFAULT_FILENAME) + ext + "*";
        }
        else
            return AbstractTabWidget::getTabText();
    }

    QString getTooltip() const
    {
        if(isUnsavedDatabase())
            return prefixUnsavedDatabase + " " + QString::fromStdString(vIodeTypes[(EnumIodeType) fileType]) + " Database";
        else
            return AbstractTabWidget::getTooltip();
    }

    bool updateFilepath(const QString& filepath) override
    {
        if(AbstractTabWidget::updateFilepath(filepath))
        {
            set_kdb_filename(K_WS[fileType], filepath.toStdString());
            return true;
        }
        else
            return false;
    }

    virtual void clearKDB() = 0;
    virtual void resetFilter() = 0;
    virtual QStringList getSelectedObjectsNames() const = 0;
    virtual void computeHash(const bool before=false) = 0;

public slots:
    void KDBModified()
    {
        setModified(true);
    }
};


template <class M, class V> class QIodeObjectWidget: public AbstractIodeObjectWidget
{
protected:
    M* objmodel;
    V* tableview;
    QDir projectDir;

public:
    QIodeObjectWidget(EnumIodeType iodeType, QWidget* parent = nullptr) : 
        AbstractIodeObjectWidget(iodeType, parent), projectDir(QDir::homePath())
    {
        // model table
        QWidget* mainwin = get_main_window_ptr();
        objmodel = new M(mainwin);

        // view table
        tableview = new V(parent);
        tableview->setObjectName(QString::fromUtf8("tableview"));
        tableview->setGeometry(QRect(10, 43, 950, 560));
        tableview->setupView(objmodel, lineEdit_filter);
        
        // signals - slots
        connect(lineEdit_filter, &QLineEdit::returnPressed, tableview, &V::filter);
        connect(pushButton_filter, &QPushButton::clicked, tableview, &V::filter);
        connect(add_iode_obj, &QPushButton::clicked, tableview, &V::new_obj);

        // insert table to layout
        // -1 -> span over all rows/columns
        layout->addWidget(tableview, 1, 0, -1, -1);
    }

    ~QIodeObjectWidget() 
    {
        delete objmodel;
        delete tableview;
    }

    M* get_model() const 
    {
        return objmodel;
    }

    V* get_view() const
    {
        return tableview;
    }

    void clearKDB()
    {
        objmodel->clearKDB();
        tableview->update();
    }

    void resetFilter()
    {
        lineEdit_filter->setText("");
        tableview->filter();
    }

    void update()
    {
        tableview->update();
    }

    void setProjectDir(const QDir& projectDir)
    {
        this->projectDir = projectDir;
        
        clearKDB();
    }

    void setup(std::shared_ptr<QString>& settings_filepath)
    {
        tableview->setup(settings_filepath);
    }

    bool load_(const QString& filepath, const bool forceOverwrite)
    {
        return objmodel->load(filepath, forceOverwrite);
    }

    QString save()
    {
        if(isUnsavedDatabase()) 
            return saveAs();
        else
        {
            QString filepath = objmodel->save(projectDir);
            if(!filepath.isEmpty()) setModified(false);
            return filepath;
        }
    }

    QString saveAs_()
    {
        return objmodel->saveAs(projectDir);
    }

    QStringList getSelectedObjectsNames() const 
    {
        return tableview->getSelectedObjectsNames();
    }

    void computeHash(const bool before=false)
    {
        objmodel->computeHash(before);
    }
};

class QIodeCommentsWidget : public QIodeObjectWidget<CommentsModel, CommentsView>
{
public:
    QIodeCommentsWidget(EnumIodeType iodeType, QWidget* parent = nullptr) : QIodeObjectWidget(iodeType, parent) 
    {
        connect(objmodel, &CommentsModel::dataChanged, this, &QIodeCommentsWidget::KDBModified);
        connect(objmodel, &CommentsModel::headerDataChanged, this, &QIodeCommentsWidget::KDBModified);
        connect(objmodel, &CommentsModel::rowsInserted, this, &QIodeCommentsWidget::KDBModified);
        connect(objmodel, &CommentsModel::rowsRemoved, this, &QIodeCommentsWidget::KDBModified);
        connect(objmodel, &CommentsModel::databaseModified, this, &QIodeCommentsWidget::KDBModified);
        connect(tableview, &CommentsView::newObjectInserted, this, &QIodeCommentsWidget::KDBModified);
    }
};

class QIodeEquationsWidget : public QIodeObjectWidget<EquationsModel, EquationsView>
{
public:
    QIodeEquationsWidget(EnumIodeType iodeType, QWidget* parent = nullptr) : QIodeObjectWidget(iodeType, parent) 
    {
        connect(objmodel, &EquationsModel::dataChanged, this, &QIodeEquationsWidget::KDBModified);
        connect(objmodel, &EquationsModel::headerDataChanged, this, &QIodeEquationsWidget::KDBModified);
        connect(objmodel, &EquationsModel::rowsInserted, this, &QIodeEquationsWidget::KDBModified);
        connect(objmodel, &EquationsModel::rowsRemoved, this, &QIodeEquationsWidget::KDBModified);
        connect(objmodel, &EquationsModel::databaseModified, this, &QIodeEquationsWidget::KDBModified);
        connect(tableview, &EquationsView::newObjectInserted, this, &QIodeEquationsWidget::KDBModified);
    }
};

class QIodeIdentitiesWidget : public QIodeObjectWidget<IdentitiesModel, IdentitiesView>
{
public:
    QIodeIdentitiesWidget(EnumIodeType iodeType, QWidget* parent = nullptr) : QIodeObjectWidget(iodeType, parent) 
    {
        connect(objmodel, &IdentitiesModel::dataChanged, this, &QIodeIdentitiesWidget::KDBModified);
        connect(objmodel, &IdentitiesModel::headerDataChanged, this, &QIodeIdentitiesWidget::KDBModified);
        connect(objmodel, &IdentitiesModel::rowsInserted, this, &QIodeIdentitiesWidget::KDBModified);
        connect(objmodel, &IdentitiesModel::rowsRemoved, this, &QIodeIdentitiesWidget::KDBModified);
        connect(objmodel, &IdentitiesModel::databaseModified, this, &QIodeIdentitiesWidget::KDBModified);
        connect(tableview, &IdentitiesView::newObjectInserted, this, &QIodeIdentitiesWidget::KDBModified);
    }
};

class QIodeListsWidget : public QIodeObjectWidget<ListsModel, ListsView>
{
public:
    QIodeListsWidget(EnumIodeType iodeType, QWidget* parent = nullptr) : QIodeObjectWidget(iodeType, parent) 
    {
        connect(objmodel, &ListsModel::dataChanged, this, &QIodeListsWidget::KDBModified);
        connect(objmodel, &ListsModel::headerDataChanged, this, &QIodeListsWidget::KDBModified);
        connect(objmodel, &ListsModel::rowsInserted, this, &QIodeListsWidget::KDBModified);
        connect(objmodel, &ListsModel::rowsRemoved, this, &QIodeListsWidget::KDBModified);
        connect(objmodel, &ListsModel::databaseModified, this, &QIodeListsWidget::KDBModified);
        connect(tableview, &ListsView::newObjectInserted, this, &QIodeListsWidget::KDBModified);
    }
};

class QIodeScalarsWidget : public QIodeObjectWidget<ScalarsModel, ScalarsView>
{
public:
    QIodeScalarsWidget(EnumIodeType iodeType, QWidget* parent = nullptr) : QIodeObjectWidget(iodeType, parent) 
    {
        connect(objmodel, &ScalarsModel::dataChanged, this, &QIodeScalarsWidget::KDBModified);
        connect(objmodel, &ScalarsModel::headerDataChanged, this, &QIodeScalarsWidget::KDBModified);
        connect(objmodel, &ScalarsModel::rowsInserted, this, &QIodeScalarsWidget::KDBModified);
        connect(objmodel, &ScalarsModel::rowsRemoved, this, &QIodeScalarsWidget::KDBModified);
        connect(objmodel, &ScalarsModel::databaseModified, this, &QIodeScalarsWidget::KDBModified);
        connect(tableview, &ScalarsView::newObjectInserted, this, &QIodeScalarsWidget::KDBModified);
    }
};

class QIodeTablesWidget : public QIodeObjectWidget<TablesModel, TablesView>
{
public:
    QIodeTablesWidget(EnumIodeType iodeType, QWidget* parent = nullptr) : QIodeObjectWidget(iodeType, parent) 
    {
        connect(objmodel, &TablesModel::dataChanged, this, &QIodeTablesWidget::KDBModified);
        connect(objmodel, &TablesModel::headerDataChanged, this, &QIodeTablesWidget::KDBModified);
        connect(objmodel, &TablesModel::rowsInserted, this, &QIodeTablesWidget::KDBModified);
        connect(objmodel, &TablesModel::rowsRemoved, this, &QIodeTablesWidget::KDBModified);
        connect(objmodel, &TablesModel::databaseModified, this, &QIodeTablesWidget::KDBModified);
        connect(tableview, &TablesView::newObjectInserted, this, &QIodeTablesWidget::KDBModified);
    }
};

class QIodeVariablesWidget : public QIodeObjectWidget<VariablesModel, VariablesView>
{
public:
    QIodeVariablesWidget(EnumIodeType iodeType, QWidget* parent = nullptr) : QIodeObjectWidget(iodeType, parent) 
    {
        connect(objmodel, &VariablesModel::dataChanged, this, &QIodeVariablesWidget::KDBModified);
        connect(objmodel, &VariablesModel::headerDataChanged, this, &QIodeVariablesWidget::KDBModified);
        connect(objmodel, &VariablesModel::rowsInserted, this, &QIodeVariablesWidget::KDBModified);
        connect(objmodel, &VariablesModel::rowsRemoved, this, &QIodeVariablesWidget::KDBModified);
        connect(objmodel, &VariablesModel::databaseModified, this, &QIodeVariablesWidget::KDBModified);
        connect(tableview, &VariablesView::newObjectInserted, this, &QIodeVariablesWidget::KDBModified);
    }
};
