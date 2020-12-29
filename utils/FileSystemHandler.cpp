#include "FileSystemHandler.h"

#include <QFile>
#include <QDebug>
#include <QDir>

bool FileSystemHandler::validateUrl(const QUrl &url) const
{
    if (url.isEmpty()) {
        qDebug()<<tr("Must specify a file");
    }
    else if (!QFile::exists(url.toLocalFile())) {
        qDebug()<<tr("File doesn't exist");
    }
    else{
        return true;
    }
    return false;
}

QString FileSystemHandler::getCurrentPath() const
{
    return QDir::currentPath();
}

QString FileSystemHandler::cdUp(const QString dir) const
{
    QDir tDir(dir);
    tDir.cdUp();
    return tDir.path();
}
