#ifndef DNNFRAMEWORKBASE_H
#define DNNFRAMEWORKBASE_H

#include "INeurNetFramework.h"

#include <QFutureWatcher>
#include <QMutex>
#include <tuple>

using namespace cv;
using namespace dnn;
using namespace std;

class IDnnFrameworkBase : public INeurNetFramework {

    Q_OBJECT

    AUTO_PROPERTY(QString, modelConfigurationUrl , modelConfigurationUrl , setModelConfigurationUrl , modelConfigurationUrlChanged)
    AUTO_PROPERTY(QString, modelWeightsUrl, modelWeightsUrl, setModelWeightsUrl, modelWeightsUrlChanged)
    AUTO_PROPERTY(QString, modelClassNamesUrl, modelClassNamesUrl, setModelClassNamesUrl, modelClassNamesUrlChanged)

    AUTO_PROPERTY(QString, modelConfigurationUrlFileExtension , modelConfigurationUrlFileExtension , setModelConfigurationUrlFileExtension , modelConfigurationUrlFileExtensionChanged)
    AUTO_PROPERTY(QString, modelWeightsUrlExtension, modelWeightsUrlExtension, setModelWeightsUrlExtension, modelWeightsUrlExtensionChanged)

    AUTO_PROPERTY(QString, currentModelName , currentModelName, setCurrentModelName, currentModelNameChanged)
    AUTO_PROPERTY(double, confidenceThreshold, confidenceThreshold, setConfidenceThreshold, confidenceThresholdChanged)
    AUTO_PROPERTY(double, scaleFactor, scaleFactor, setScaleFactor, scaleFactorChanged)
    AUTO_PROPERTY(QPoint, outBlobSize, outBlobSize, setOutBlobSize, outBlobSizeChanged)
    AUTO_PROPERTY(QString, meanR, meanR, setMeanR, meanRChanged)
    AUTO_PROPERTY(QString, meanG, meanG, setMeanG, meanGChanged)
    AUTO_PROPERTY(QString, meanB, meanB, setMeanB, meanBChanged)
    AUTO_PROPERTY(bool, qtVision, qtVision, setQtVision, qtVisionChanged)
    AUTO_PROPERTY(bool, frameworkVision, frameworkVision, setFrameworkVision, frameworkVisionChanged)
    AUTO_PROPERTY(int, displayMask, displayMask, setDisplayMask, displayMaskChanged)

    AUTO_PROPERTY(bool, separateThreadDetection, separateThreadDetection, setSeparateThreadDetection, separateThreadDetectionChanged)

protected:
    //checks if lodel is already loaded
    bool m_modelLoded{false};

    //OPEN CV dnn network object
    cv::dnn::Net m_dnnNetworkObj;

    //Models nems and clases vectors
    vector<String> m_networkOutputsNames;
    vector<String> m_networkClassesNames;

    //Detected objects that will be forwarded to QML
    QVector<DetectedObjects*> m_detectedObjects;

    //Synchronization of async image processing
    QFutureWatcher<QVector<DetectedObjects*>> m_classificationFutureWatcher;
    QFuture<QVector<DetectedObjects*>> m_classificationFuture;
    void processingFinished();

    //Constructs DNN::Net object according to given parameters
    Net aquireDnnFrameworkObj();

    void reloadModel(Net net);

public:
    IDnnFrameworkBase(QCvDetectFilter *filter,
                     detectionParameters_t *detectionParameters,
                     QString&& frameworkName,
                     QString&& frameworkUrl,
                     QString&& frameworkQrc,
                     QString&& modelWeightsExtension,
                     QString&& modelConfigurationUrlFileExtension);
    virtual ~IDnnFrameworkBase(){}

    //Reload dnn::model
    Q_INVOKABLE void reloadDnnFramework(QString frameworkName);

    //Interface INeurNetFramework
    virtual void processImageByOpenCv(QImage image);
    virtual void processImageByDarknet(QImage image) {Q_UNUSED(image)}
    virtual void processImageByOpenMp(QImage image) {Q_UNUSED(image)}
};

#endif // DNNFRAMEWORKBASE_H
