#pragma once

#include <QObject>
#include <QUrl>

class FileSystemHandler : public QObject
{
    Q_OBJECT
public:
    explicit FileSystemHandler(){};

    Q_INVOKABLE bool validateUrl(const QUrl &url) const;
    Q_INVOKABLE QString getCurrentPath() const;
    Q_INVOKABLE QString cdUp(const QString dir) const;

signals:

};
