#pragma once

#include <QWidget>

#include "ui_duplicate.h"
#include "utils.h"
#include "settings.h"
#include "wrapper_classes.h"
#include "text_edit/complete_line_edit.h"


class QIodeMenuDataDuplicateObj : public QIodeSettings, public Ui::QIodeMenuDataDuplicateObj
{
    Q_OBJECT

    WrapperComboBox*    wComboIodeTypes;
    WrapperQLineEdit*   wObjName;
    WrapperQLineEdit*   wDupObjName;

    IodeCompleter* completer;
    
public:
	QIodeMenuDataDuplicateObj(QWidget* parent = nullptr);
    ~QIodeMenuDataDuplicateObj();

public slots:
    void duplicate();
    void help();
};
