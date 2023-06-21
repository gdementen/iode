#pragma once

#include <QWidget>

#include "ui_compute_scc_decomposition.h"
#include "utils.h"
#include "settings.h"
#include "wrapper_classes.h"
#include "custom_widgets/completer.h"


/* NOTE FOR THE DEVELOPERS:
 * All Menu Dialog classes MUST
 * 1. inherit from QIodeSettings,
 * 2. use the extractAndVerify() method to extract input data from fields,
 * 3. call the Q_OBJECT macro at the beginning of the class to allow slots and signals (see documentation of Qt).
 */

class QIodeMenuComputeSCCDecomposition : public QIodeSettings, public Ui::QIodeMenuComputeSCCDecomposition
{
    Q_OBJECT

    WrapperQPlainTextEdit*  qEquationsList;
    WrapperSpinBox*         qTriangulationIterations;
    WrapperQLineEdit*       qPreRecursiveListName;
    WrapperQLineEdit*       qInterRecursiveListName;
    WrapperQLineEdit*       qPostRecursiveListName;

    QIodeCompleter*         completer;

public:
	QIodeMenuComputeSCCDecomposition(QWidget* parent = nullptr);
    ~QIodeMenuComputeSCCDecomposition();

public slots:
    void compute();
};