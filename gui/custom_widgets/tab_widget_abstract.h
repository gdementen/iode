#pragma once

#include <QObject>
#include <QString>
#include <QVector>
#include <QShortcut>
#include <QTabWidget>
#include <QFileSystemWatcher>

#include "utils.h"
#include "util/system_item.h"
#include "tabs/tab_text.h"
#include "tabs/tab_report.h"
#include "tabs/tab_abstract.h"


/**
 * @brief The present class represents the widget displaying tabs. 
 *        Tabs content can represents:
 * 
 *          - an IODE KDB,
 *          - an IODE report,
 *          - a text file.
 * 
 *        Implemented features:
 *   
 *        - Tab text = prefix (CMT, EQS, ..., REP, TXT) + filename of the loaded file (if any).
 *          If the tab represents an IODE KDB not (yet) linked to any file, 'filename' is empty.
 *        - The tab text include an * if modifications have been made but not saved yet.
 *        - Tab tooltip = absolute path to the loaded file (if any) or "Unsaved <IODE type> Database".
 *        - Only one tab can be open per IODE objects type (Comment, Equation, ..., Variable).
 *        - When switching from another project or quiting the GUI, the absolute paths to all loaded files 
 *          (= tooltips) are saved into a project settings file (with the .ini extension).
 *        - When switching to a previous project or starting the GUI, all previously open tabs are restored 
 *          (by reading list of files in the proejct settings file .ini).
 *        - Users are allowed to close tabs if they represent a report or a text files (i.e. not an IODE objects type).
 *        - Users are allowed to move tabs.
 *        - Open files with corresponding application (.xlsx with Excel, ...)
 *        - Reload file content if modified by another program. 
 *        - CTRL + S on a tab saves its content.
 *        - CTRL + SHIFT + S saves all tabs content.
 *        - CTRL + D on a KDB tab clears the corresponding KDB.
 *        - CTRL + SHIFT + D clears the whole workspace. 
 *        - ALT + [C|E|I|L|S|T|V] open the [Comments | Equations | Identities | Lists | Scalars | Tables | Variables] tab.
 *        - Ctrl+[shift]+Tab shift to the next [previous] tab.
 * 
 */
class QIodeAbstractTabWidget: public QTabWidget
{
    Q_OBJECT

protected:
    QStringList filesList;
    QFileSystemWatcher* fileSystemWatcher;

    std::shared_ptr<QIodeCompleter> completer;

    QTextEdit* output;

    QString projectDirPath;
    bool overwrite_all;
    bool discard_all;

    QShortcut* nextTabShortcut;
    QShortcut* previousTabShortcut;
    QShortcut* clearShortcut;

signals:
    void fileContentModified(const QString& filepath, const bool modified);

public:
    QIodeAbstractTabWidget(QWidget* parent = nullptr);
    ~QIodeAbstractTabWidget();

    /**
     * @brief - reopen all tabs (files) that were open (*)
     *        - display the tab that was displayed (*)
     *        (*) the last time the user quitted the IODE gui.
     */
    virtual void loadSettings() = 0;
    
    /**
     * @brief dump in settings:
     *        - the list of open tabs.
     *        - the index of the currently displayed tab.
     *        
     * @note The list of open tabs is actually the list of the tooltip associated with each tab.
     *       The tooltip is either the path to the corresponding file or a default string in case of unsaved KDB.  
     */
    virtual void saveSettings() = 0;

    /**
     * @brief - Initializes settings object and openedFiles list.
     *        - Reload previously opened files.
     * 
     * @param completer std::shared_ptr<QIodeCompleter> completer
     * @param output QTextEdit* output widget to display the output from the execution of a report.
     * 
     * TODO: merge setup() method with updateProjectDir()
     */
    virtual void setup(std::shared_ptr<QIodeCompleter>& completer, QTextEdit* output) = 0;

	/**
	 * @brief load a file and set corresponding tab text (filename) and tooltip (full absolute path).
	 * 
	 * @param filepath QString path to the file to load.
     * @param displayTab bool whether or not displaying the corresponding tab when finished to load the file 
     *                        (used in loadSettings()).
     * @param forceOverwrite bool whether or not forcing overwrite of corresponding KDB (use in loadSetting()).
     * @param moveToPosition int new position of the corresponding tab. 
     *                           Only used when reloading tabs from a previous session.
     * 
     * @return int index of the corresponding tab. -1 if failed to load file.
	 */
	virtual int loadFile(const QString& filepath, const bool displayTab=true, const bool forceOverwrite=false, 
        const int moveToPosition=-1) = 0;

    /**
     * @brief Reload a file if modified by an external program.
     * 
     * @param QString Filepath to the modified file.
     */
    void reloadFile(const QString& filepath);

    /**
     * @brief save current project to another (new) directory.
     * 
     * @param dir (new) directory to save the current project in.
     * @return bool whether or not all files have been saved, i.e. the user as not clicked on the Discard button.
     */
    bool saveProjectAs(QDir& newProjectDir);

    /**
     * @brief create a new tab corresponding to the newly open file.
     *        Called by loadFile().
     * 
     * @param fileType EnumIodeFile type of the loaded file (KDB file, .log, .ini, .txt, other).
     * @param fileInfo QFileInfo path to the loaded file.
     * @return int index of the new tab
     */
    int addNewTab(const EnumIodeFile fileType, const QFileInfo& fileInfo);

    /**
     * @brief show tab corresponding to passed index. 
     *        Update current tab if index is -1.
     * 
     * @param index int index of the tab to show.
     */
	void showTab(int index = -1);

protected:
    virtual int getIodeObjTabIndex(const EnumIodeType iodeType) const = 0;

    /**
     * @brief update the paths (to directories and files) registered in the file system watcher.
     * 
     * @param projectDir QDir new project directory.      
     */
    void resetFileSystemWatcher(const QDir& projectDir);

private:
    /**
     * @brief add tab for editing reports.
     * 
     * @param fileInfo QFileInfo path to the report file.
     * 
     * @return int index of the new tab.
     */
    int addReportTab(const QFileInfo& fileInfo);

    /**
     * @brief add tab for editing a text file (.log, .ini, .txt).
     * 
     * @param fileInfo QFileInfo path to the text file.
     * 
     * @return int index of the new tab.
     */
    int addTextTab(const QFileInfo& fileInfo, const EnumIodeFile iodeFile);

    /**
     * @brief save the content of the tab at a given index.
     *        Ask for a filepath if the tab represents a KDB and the KDB is not linked to any file.
     * 
     * @param index int index of the tab to be saved.
     * 
     * @return bool whether or not the method has succeeded.
     */
    bool saveTabContent(const int index);

public slots:
    /**
     * @brief updates the tab name and sends the fileContentModified signal to be 
     *        catched by the File Explorer.
     * 
     * @param filepath 
     * @param modified 
     */
    void tabContentModified(const QString& filepath, const bool modified)
    {
        try
        {
            // get index
            int index = filesList.indexOf(filepath);
            if(index < 0) 
                return;

            // get the tab widget at the given index
            AbstractTabWidget* tabWidget = static_cast<AbstractTabWidget*>(this->widget(index));

            // updates the text of the tab
            setTabText(index, tabWidget->getTabText());

            // sends a signal to the File Explorer widget
            emit fileContentModified(tabWidget->getFilepath(), modified);
        }
        catch(const std::exception& e)
        {
            QMessageBox::critical(nullptr, "ERROR", QString(e.what()));
        }
    }

    /**
     * @brief compute the hash of each database before/after executing 
     *        a report command or an iode report.
     *        If hash is different after report command/iode report, 
     *        a databaseModified signal is emited.
     * 
     * @param before whether the hash is calculated before or after the 
     *               execution of the report command/iode report.
     */
    virtual void computeHash(const bool before=false) = 0;

    /**
     * @brief Ask to save if modified then close the tab + remove path from the 
     *        system file watcher.
     * 
     * @param index 
     */
    void removeTab(const int index);

    /**
     * @brief show next tab.
     */
    void showNextTab()
    {
        int lastIndex = this->count() - 1;
        if(this->currentIndex() != lastIndex) this->setCurrentIndex(this->currentIndex() + 1);
    }

    /**
     * @brief show previous tab.
     * 
     */
    void showPreviousTab()
    {
        if(this->currentIndex() != 0) this->setCurrentIndex(this->currentIndex() - 1); 
    }

    /**
     * @brief save the content of the current tab.
     *        Ask for a filepath if the tab represents a KDB and the KDB is not linked to any file.
     * 
     * @return bool whether or not the method has succeeded.
     */
    bool saveCurrentTab();

    /**
     * @brief save all open tabs. 
     *        Ask for a filepath if the tab represents a KDB and the KDB is not linked to any file.
     * 
     * @return bool whether or not the method has succeeded. 
     */
    bool saveAllTabs();

    /**
     * @brief clear KDB of the current open tab if the later represents a KDB.
     * 
     */
    virtual void clearCurrentTab() = 0;
    
    /**
     * @brief Update the path to the current project directory.
     *        Slot method called each time the project directory is changed.
     * 
     * @param projectDirPath Path to the root directory of the File Explorer  
     */
    virtual void updateProjectDir(const QString& projectDirPath) = 0;

    /**
     * @brief Method called when a user moves a file using the File Explorer.
     *        Update the name and tooltip af tab associated with the file if open.
     * 
     * @param oldFilepath Previous filepath
     * @param newFilepath New filepath
     */
    void fileMoved(const QString &oldFilepath, const QString &newFilepath);

    /**
     * @brief Method called when a user renames a file using the File Explorer.
     *        Update the name and tooltip af tab associated with the renamed file if open.
     * 
     * @param path Path to the parent directory
     * @param oldName Name of the file before renaming
     * @param newName Name of the file after renaming
     */
    void fileRenamed(const QString &path, const QString &oldName, const QString &newName)
    {
        QDir parentDir(path);
        QString oldFilepath = parentDir.absoluteFilePath(oldName);
        QString newFilepath = parentDir.absoluteFilePath(newName);
        fileMoved(oldFilepath, newFilepath);
    }

protected slots:
    /**
     * @brief build the list of filepaths associated to open tabs
     * 
     * @return QStringList list of open files (tabs)
     */
    QStringList buildFilesList()
    {
        filesList.clear();
        AbstractTabWidget* tabWidget;
        for (int i=0; i < this->count(); i++)
        {
            tabWidget = static_cast<AbstractTabWidget*>(this->widget(i));
            filesList << tabWidget->getFilepath();
        }
        return filesList;
    }

    /**
     * @brief This virtual handler is called AFTER a new tab was added or 
     *        inserted at position index.
     * 
     * @param index 
     */
    void tabInserted(int index)
    {
        buildFilesList();
        AbstractTabWidget* tabWidget = static_cast<AbstractTabWidget*>(this->widget(index));
        fileSystemWatcher->addPath(tabWidget->getFilepath());
        QTabWidget::tabInserted(index);
    }

    /**
     * @brief This virtual handler is called AFTER a tab was removed 
     *        from position index
     * 
     * @param index 
     */
    void tabRemoved(int index)
    {
        buildFilesList();
    }
};