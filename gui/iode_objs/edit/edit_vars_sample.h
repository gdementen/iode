#pragma once

#include <QWidget>
#include <QString>

#include <string>

#include "ui_edit_vars_sample.h"
#include "utils.h"
#include "wrapper_classes.h"


/* NOTE FOR THE DEVELOPERS:
 * This Dialog class MUST
 * 1. use the extractAndVerify() method to extract input data from fields,
 * 2. call the Q_OBJECT macro at the beginning of the class to allow slots and signals (see documentation of Qt).
 */

class QIodeEditVarsSample : public QDialog, public Ui::QIodeEditVarsSample
{
    Q_OBJECT

    KDBVariables kdb_vars;
    WrapperSampleEdit* sampleFrom;
    WrapperSampleEdit* sampleTo;

public:
    QIodeEditVarsSample(QWidget* parent = Q_NULLPTR);
    ~QIodeEditVarsSample();

public slots:
    void edit();
    void help();
};

