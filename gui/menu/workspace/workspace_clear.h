#pragma once

#include <QWidget>

#include "ui_workspace_clear.h"
#include "utils.h"
#include "settings.h"
#include "wrapper_classes.h"


/* NOTE FOR THE DEVELOPERS:
 * All Menu Dialog classes MUST
 * 1. inherit from QIodeSettings,
 * 2. use the extractAndVerify() method to extract input data from fields,
 * 3. call the Q_OBJECT macro at the beginning of the class to allow slots and signals (see documentation of Qt).
 */


class QIodeMenuWorkspaceClear : public QIodeSettings, public Ui::QIodeMenuWorkspaceClear
{
    Q_OBJECT

public:
	QIodeMenuWorkspaceClear(const QString& project_settings_filepath, QWidget* parent = nullptr, Qt::WindowFlags f = Qt::WindowFlags());
	~QIodeMenuWorkspaceClear();

private:
    void clear_objs(const EnumIodeType iode_type, const bool clear_all);

public slots:
    void clear_comments();
    void clear_equations();
    void clear_identities();
    void clear_lists();
    void clear_scalars();
    void clear_tables();
    void clear_variables();
    void clear();
};
