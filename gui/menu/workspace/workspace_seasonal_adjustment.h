
#pragma once

#include <QObject>

#include "ui_workspace_seasonal_adjustment.h"
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


class MenuWorkspaceSeasonalAdjustment : public IodeSettingsDialog, public Ui::MenuWorkspaceSeasonalAdjustment
{
    Q_OBJECT

    WrapperFileChooser*   wInputFile;
    WrapperQTextEdit*     wSeries;
    WrapperDoubleSpinBox* wEPSTest;

public:
    MenuWorkspaceSeasonalAdjustment(QWidget* parent = nullptr);
    ~MenuWorkspaceSeasonalAdjustment();

public slots:
    void seasonal_adjustment();
    void help();
};
