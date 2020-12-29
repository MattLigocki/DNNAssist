#include "DataSetsScreenController.h"
#include <QDebug>
#include <QtConcurrent>
#include <QFileInfo>
#include <QThread>

namespace
{
    QString TAG = "[C++][CameraScreenController] - ";
}

DataSetsScreenController::DataSetsScreenController() :
    QObject(nullptr),
    m_fileSystemModel(new QFileSystemModel()),
    m_imagesAdressesModel(new QStringListModel)
{
    m_fileSystemModel->setRootPath("");
    connect(this, &DataSetsScreenController::fillImagesAdressesModel, this, [=](QString imagesLocation){
        QFuture<void> future = QtConcurrent::run(this, &DataSetsScreenController::handleFillImagesAdressesModel,imagesLocation);
        imagesAdressesModelFillWatcher.setFuture(future);
    });
}

DataSetsScreenController& DataSetsScreenController::getInstance()
{
    static DataSetsScreenController dataSetsScreenController;
    return dataSetsScreenController;
}

/**
 * @brief DataSetsScreenController::checkDirStructure
 *        Check for dataset structure in given location.
 *        Data set should contain catalogs:
 *
 *        /negative
 *        /positive
 * @param imagesLocation
 * @return
 */
bool DataSetsScreenController::checkDirStructure(QString imagesLocation) const noexcept
{
    //QDirIterator it(root,QStringList() << "fileE",QDir::Files,QDirIterator::Subdirectories);

       QDirIterator it(imagesLocation, QDir::Dirs, QDirIterator::Subdirectories);

//       while(it.hasNext())
//       {
//           qDebug() << it.next();
//           qDebug() << it.fileName();
//       }
      // (dynamic_cast<ComputerVisionManager*>(mComputerVisionManager))->isDirSuitableForModelTraining<IComputerVisionManager::OPEN_CV_t>(imagesLocation);
}

void DataSetsScreenController::handleFillImagesAdressesModel(QString imagesLocation)
{
    checkDirStructure(imagesLocation);
}
