#include "AiManager.h"

AiManager::AiManager(QObject *parent) :
    QObject(parent),
    m_neuralNetworkFrameworks(new ObjectListModel)
{
}

AiManager& AiManager::getInstance()
{
    static AiManager computerVisionManager;
    return computerVisionManager;
}

QObject *AiManager::getFrameworkObjectByName(QString name){

    for(auto* frameworkObj : neuralNetworkFrameworks()->getRawData()){
        auto obj = qobject_cast<INeurNetFramework*>(frameworkObj);
        if( obj->name().toLower() == name.toLower())
            return obj;
    }
    return nullptr;
}

void AiManager::processImageByFrameworks(QImage image)
{
    for(auto framework : neuralNetworkFrameworks()->getRawData()){
        auto obj = qobject_cast<INeurNetFramework*>(framework);
        if( obj->isActive() ){
            obj->processImage(image);
        }
    }
}
