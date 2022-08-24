#pragma once

#include <QWidget>

#include "ui_compute_simulation.h"
#include "utils.h"
#include "settings.h"
#include "wrapper_classes.h"


/* NOTE FOR THE DEVELOPERS:
 * All Menu Dialog classes MUST
 * 1. inherit from QIodeSettings,
 * 2. use the extractAndVerify() method to extract input data from fields,
 * 3. call the Q_OBJECT macro at the beginning of the class to allow slots and signals (see documentation of Qt).
 */

class QIodeMenuComputeSimulation : public QIodeSettings, public Ui::QIodeMenuComputeSimulation
{
    Q_OBJECT

    QList<QString> qInitialisationList;
    QList<QString> qSortAlgoList;

    WrapperQTextEdit* qEquationsList;
    WrapperQTextEdit* qExchange;
    WrapperSampleEdit* qFrom;
    WrapperSampleEdit* qTo;
    WrapperQLineEdit* qConvergence;
    WrapperSpinBox* qMaxIterations;
    WrapperCheckBox* qCheckDebug;
    WrapperQLineEdit* qRelaxation;
    WrapperComboBox* qSimInitialisation;
    WrapperComboBox* qSortAlgorithm;
    WrapperSpinBox* qNbPasses;

public:
	QIodeMenuComputeSimulation(const QString& settings_filepath, QWidget* parent = nullptr, Qt::WindowFlags f = Qt::WindowFlags());
    ~QIodeMenuComputeSimulation();

public slots:
    void compute();
};