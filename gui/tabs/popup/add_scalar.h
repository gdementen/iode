#pragma once

#include <QWidget>
#include <QString>

#include <string>

#include "ui_add_scalar.h"
#include "../../utils.h"
#include "../../wrapper_classes.h"


/* NOTE FOR THE DEVELOPERS:
 * This Dialog class MUST
 * 1. use the extractAndVerify() method to extract input data from fields,
 * 2. call the Q_OBJECT macro at the beginning of the class to allow slots and signals (see documentation of Qt).
 */

class QIodeAddScalar : public QDialog, public Ui::QIodeAddScalar
{
    Q_OBJECT

    WrapperIodeNameEdit* lineName;
    WrapperQLineEdit* lineValue;
    WrapperDoubleSpinBox* spinBoxRelax;

public:
    QIodeAddScalar(QWidget* parent = Q_NULLPTR, Qt::WindowFlags f = Qt::WindowFlags());
    ~QIodeAddScalar();

public slots:
    void add();
    void help();
};
