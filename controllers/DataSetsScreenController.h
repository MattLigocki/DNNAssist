#pragma once

#include <QObject>
#include <QFileSystemModel>
#include <QStringListModel>
#include <QFutureWatcher>

#include "models/ObjectListModel.h"
#include "utils/PropertyHelpers.h"

/**
 * @brief The DataSetsScreenController class
 *
 */
class DataSetsScreenController : public QObject
{
    Q_OBJECT
    DataSetsScreenController();
    ~DataSetsScreenController() = default;

    AUTO_PROPERTY( QFileSystemModel*, fileSystemModel, fileSystemModel, setFileSystemModel, fileSystemModelChanged)
    AUTO_PROPERTY( QStringListModel*, imagesAdressesModel, imagesAdressesModel, setImagesAdressesModel, imagesAdressesModelChanged)

    QFutureWatcher<void> imagesAdressesModelFillWatcher;

    void handleFillImagesAdressesModel(QString imagesLocation);
public:
    static DataSetsScreenController& getInstance();
    bool checkDirStructure(QString imagesLocation) const noexcept;

signals:
    void fillImagesAdressesModel(QString imagesLocation);

public slots:
    int getDirectoryRole(){ return QFileSystemModel::Roles::FilePathRole;}
    int getNameRole(){ return QFileSystemModel::Roles::FilePathRole;}

};
