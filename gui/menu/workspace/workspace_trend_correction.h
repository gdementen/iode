#pragma once

#include <QObject>

#include "ui_workspace_trend_correction.h"
#include "utils.h"
#include "settings.h"
#include "wrapper_classes.h"


/* NOTE FOR THE DEVELOPERS:
 * All Menu Dialog classes MUST 
 * 1. inherit from MixinSettings,
 * 2. use the extractAndVerify() method to extract input data from fields,
 * 3. call the Q_OBJECT macro at the beginning of the class to allow slots and signals (see documentation of Qt),
 * 4. have a private pointer *ui to the associated class generated by the Qt Designer.
 */

class QIodeMenuWorkspaceTrendCorrection: public QIodeSettings, public Ui::QIodeMenuWorkspaceTrendCorrection
{
    Q_OBJECT

    WrapperFileChooser*    wInputFile;
    WrapperDoubleSpinBox*  wLambda;
    WrapperQTextEdit*      wSeries;
    WrapperCheckBox*       wLog;

public:
    QIodeMenuWorkspaceTrendCorrection(QWidget* parent = nullptr, Qt::WindowFlags f = Qt::WindowFlags());
    ~QIodeMenuWorkspaceTrendCorrection();

public slots:
    void trend_correction();
    void help();
};
