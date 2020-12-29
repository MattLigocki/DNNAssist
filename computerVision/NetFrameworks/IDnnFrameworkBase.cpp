#include "IDnnFrameworkBase.h"

#include <QMutex>
#include <QFuture>
#include <QtConcurrent>
#include <QFutureWatcher>
#include <fstream>

#include "OpenCvFramework.h"
#include <computerVision/DetectionRectangle.h>
#include <controllers/MediaScreenController.h>

IDnnFrameworkBase::IDnnFrameworkBase(QCvDetectFilter *filter,
                     detectionParameters_t *detectionParameters,
                     QString&& frameworkName,
                     QString&& frameworkUrl,
                     QString&& frameworkQrc,
                     QString&& modelWeightsExtension,
                     QString&& modelConfigurationUrlFileExtension)
    : INeurNetFramework(filter, detectionParameters,
                        move(frameworkName),
                        move(frameworkUrl),
                        move(frameworkQrc)),
      m_confidenceThreshold(0.6),
      m_scaleFactor(1/255.0),
      m_meanR("300"),m_meanG("300"),m_meanB("300"),
      m_separateThreadDetection(true),
      m_outBlobSize{256,256},
      m_modelConfigurationUrlFileExtension(modelConfigurationUrlFileExtension),
      m_modelWeightsUrlExtension(modelWeightsExtension),
      m_displayMask(0)
{
    setCurrentModelName(name());

    QObject::connect(this, &IDnnFrameworkBase::modelConfigurationUrlChanged, this, [&](){
        m_modelLoded=false;
#ifdef __linux__
        m_modelConfigurationUrl.replace(QString("file://"), QString(""));
#else
        m_modelConfigurationUrl.replace(QString("file:///"), QString(""));
#endif
        m_modelConfigurationUrl.replace(QString("file:///"), QString(""));
    });

    QObject::connect(this, &IDnnFrameworkBase::modelWeightsUrlChanged, this, [&](){
#ifdef __linux__
        m_modelWeightsUrl.replace(QString("file://"), QString(""));
#else
        m_modelWeightsUrl.replace(QString("file:///"), QString(""));
#endif

    });

    QObject::connect(this, &IDnnFrameworkBase::modelClassNamesUrlChanged, this, [&](){
#ifdef __linux__
        m_modelClassNamesUrl.replace(QString("file://"), QString(""));
#else
        m_modelClassNamesUrl.replace(QString("file:///"), QString(""));
#endif

        m_networkClassesNames.clear();
        ifstream ifs;
        ifs.open(m_modelClassNamesUrl.toStdString().c_str(),std::ifstream::in);

        string line;
        while (ifs >> line){
            m_networkClassesNames.push_back({line.c_str()});
        }
        ifs.close();

        qDebug()<< name()<< " classes names reloaded, found "<<m_networkClassesNames.size()<< " items";
    });

    connect(&m_classificationFutureWatcher, &QFutureWatcher<bool>::finished,this, &IDnnFrameworkBase::processingFinished);

    connect(this, &IDnnFrameworkBase::useGPUChanged,this, [&](bool gpu){
        if(gpu){
            qDebug() <<"Using GPU for detection";
            m_dnnNetworkObj.setPreferableBackend(cv::dnn::DNN_BACKEND_CUDA);
            m_dnnNetworkObj.setPreferableTarget(cv::dnn::DNN_TARGET_CUDA);
        }else{
            qDebug() <<"Not using GPU for detection";
            m_dnnNetworkObj.setPreferableBackend(cv::dnn::DNN_BACKEND_OPENCV);
            m_dnnNetworkObj.setPreferableTarget(cv::dnn::DNN_TARGET_CPU);
        }
    });
}

void IDnnFrameworkBase::processingFinished(){

    try{
        m_detectedObjects = m_classificationFuture.result();
    }catch(...){
        qDebug()<<"ERROR while processing";
    }

    filter()->detectedObjects()->reset();
    //filter()->setAmountOfDetectedItems(0);
}

void IDnnFrameworkBase::reloadModel(Net net)
{
    m_dnnNetworkObj = net;
    m_modelLoded = true;
    m_networkOutputsNames = OpenCvFramework::getOutputsNames(m_dnnNetworkObj);

    for(auto& x : m_networkOutputsNames){
        QString layer{ x.c_str()};
        if(layer.contains("mask") && displayMask()==0){
            setDisplayMask(1);
        }
    }
}

void IDnnFrameworkBase::reloadDnnFramework(QString frameworkName){
    if(frameworkName==name()){
       qDebug()<<frameworkName<<" reloaded";
       QtConcurrent::run(this, &IDnnFrameworkBase::reloadModel, aquireDnnFrameworkObj());
    }
}

Net IDnnFrameworkBase::aquireDnnFrameworkObj()
{
    auto net = readNet(modelWeightsUrl().toStdString(),modelConfigurationUrl().toStdString(), name().toStdString());

    if(useGPU()){
        qDebug() <<"Using GPU for detection";
        net.setPreferableBackend(cv::dnn::DNN_BACKEND_CUDA);
        net.setPreferableTarget(cv::dnn::DNN_TARGET_CUDA);
    }else{
        qDebug() <<"Not using GPU for detection";
        net.setPreferableBackend(cv::dnn::DNN_BACKEND_OPENCV);
        net.setPreferableTarget(cv::dnn::DNN_TARGET_CPU);
    }

    return net;
}

void IDnnFrameworkBase::processImageByOpenCv(QImage image) {
    //If model is not loaded yes skip this frame
    if(m_modelLoded==false)
    {
        return;
    }

    //Display items detected object buffer
    for(DetectedObjects* x : m_detectedObjects){
        emit filter()->objectDetected(x->x(),x->y(),x->width(),x->height(),x->confidenceLvl(),x->classifier(),x->detectionTime());
    }

    if(!m_classificationFuture.isRunning()){

        //Prepare parameters of detection
        DNN_DETECTION_PARAMS parameters
        {
            confidenceThreshold(),
            {detectionParameters()->imageDetectionResolution.first, detectionParameters()->imageDetectionResolution.second},
            outBlobSize(),
            scaleFactor(),
            meanR().toDouble(),meanG().toDouble(),meanB().toDouble(),
            qtVision(), frameworkVision(),displayMask(),
            currentModelName()
        };

        //IMPORTANT!!!
        //If separateThreadDetection==true than detection will be moved to separate thread
        //it will not throttle media playback, but it will lead to detection not from every frame
        if(separateThreadDetection()){
            m_classificationFuture = QtConcurrent::run(OpenCvFramework::processByDNN,
                                       image,
                                       m_dnnNetworkObj,
                                       m_networkOutputsNames,
                                       m_networkClassesNames,
                                       parameters);
            m_classificationFutureWatcher.setFuture(m_classificationFuture);
        }else{
            OpenCvFramework::processByDNN(image,
                    m_dnnNetworkObj,
                    m_networkOutputsNames,
                    m_networkClassesNames,
                    parameters);
        }
    }
}
