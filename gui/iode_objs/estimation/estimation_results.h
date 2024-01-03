#pragma once

#include <QWidget>
#include <QLabel>
#include <QLineEdit>
#include <QString>
#include <QVector>
#include <QGridLayout>

#include "ui_estimation_results.h"
#include "correlation_matrix_model.h"
#include "utils.h"
#include "wrapper_classes.h"
#include "iode_objs/models/scalars_model.h"
#include "plot/plot_vars.h"
#include "main_window_abstract.h"


class EstimationResultsDialog : public QDialog, public Ui::EstimationResultsDialog
{
    Q_OBJECT

    int precision;
    EditAndEstimateEquations* edit_est_eqs;

    QString from;
    QString to;
    QList<QString> variables_names;

	QShortcut* fullScreenShortcut;

private:
    void set_coefficients_tab();
    void set_correlation_matrix_tab();
    void set_tests_tab(Equation& eq);
    void dump_table(const QAbstractTableModel* table_model, QTextCursor& cursor);

public:
    EstimationResultsDialog(EditAndEstimateEquations* edit_est_eqs, QWidget* parent = Q_NULLPTR);
    ~EstimationResultsDialog();

signals:
    void newPlot(QDialog* plotDialog);

public slots:
    void plot_yobs_yest();
    void plot_residual();
    void print_output();
    void help();
};
