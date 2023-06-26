#include "tab_report.h"


QIodeReportWidget::QIodeReportWidget(const QString& filepath, QTextEdit* output, std::shared_ptr<QIodeCompleter>& completer, 
    QWidget* parent) : QIodeAbstractEditor(I_REPORTS_FILE, filepath, parent)
{
    setupUi(this);

    QList<QString> q_langs;
    for(const std::string& lang: vLangs) q_langs << QString::fromStdString(lang);

    comboBox_language->addItems(q_langs);
    comboBox_language->setEditable(false);

    filter = "IODE report files (*" + QString::fromStdString(report_ext) + ")";

    // autocomplete checkbox
    /*
    QCheckBox* autocomplete = new QCheckBox("autocomplete", this);
    autocomplete->setChecked(true);
    */

    // set report editor
    editor->setOutput(output);
    editor->setCompleter(completer.get());

    // ---- Signals and Slots ----
    connect(editor, &TextEditor::modificationChanged, this, &QIodeReportWidget::setModified);

    // connect(autocomplete, &QCheckBox::stateChanged, this, &QIodeReportWidget::toggleAutocomplete);

    if(!filepath.isEmpty()) 
        load(filepath, true);
}
