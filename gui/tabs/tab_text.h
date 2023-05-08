#pragma once

#include <QPrinter>
#include <QFileInfo>
#include <QFileDialog>
#include <QMessageBox>
#include <QPlainTextEdit>
#include <QTextStream>
#include <QGridLayout>

#include "custom_widgets/text_editor.h"
#include "tab_abstract.h"
#include "ui_tab_text.h"


class QIodeAbstractEditor: public AbstractTabWidget
{
    Q_OBJECT

protected:
    QString filter;

public:
    QIodeAbstractEditor(const EnumIodeFile fileType, const QString& filepath, QWidget* parent = nullptr);

    void update() {}
    bool load__(TextEditor* editor, const QString& filepath, const bool forceOverwrite);
    virtual bool load_(const QString& filepath, const bool forceOverwrite) = 0;
    QString save_(TextEditor* editor, const QString& filepath);
    virtual QString save(const QString& filepath) = 0;
    QString save();
    QString saveAs_();
};


class QIodeTextWidget : public QIodeAbstractEditor, public Ui::QIodeTextWidget
{
    Q_OBJECT

    const static QStringList textExtensions;

public:
    QIodeTextWidget(const EnumIodeFile fileType, const QString& filepath, QWidget* parent = nullptr) 
        : QIodeAbstractEditor(fileType, filepath, parent) 
    {
        setupUi(this);

        filter = "Text files (*" + textExtensions.join(", *") + ")";

        connect(editor, &TextEditor::modificationChanged, this, &QIodeTextWidget::setModified);

        if(!filepath.isEmpty()) 
            load(filepath, true);
    }

    static bool isTextExtension(const QString& ext)
    {
        return textExtensions.contains(ext);
    }

    bool load_(const QString& filepath, const bool forceOverwrite)
    {
        return load__(editor, filepath, forceOverwrite);
    }

    QString save(const QString& filepath)
    {
        return save_(editor, filepath);
    }

public slots:
    void print()
    {
        QMessageBox::warning(nullptr, "WARNING", "Not implemented yet");
    }
};
