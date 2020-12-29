#include <QDebug>
#include <QFile>
#include <QObject>
#include <QTemporaryFile>

#include <vector>

#include <managers/ComputerVisionManager/AiManager.h>
#include "computerVision/NetFrameworks/INeurNetFramework.h"

#include "DetectionParameters.h"
#include "QCvDetectFilter.h"
#include "QCvDetectionFilterRunnable.h"

QCvDetectFilter::QCvDetectFilter()
    : m_detectedObjects(new ObjectListModel),
      m_neuralNetworkFrameworks(new ObjectListModel),
      m_useGrayScale(false),
      m_mediaSource("camera"),
      m_detectionResolution{320, 240},
      m_usedFramework{"OpenCv"},
      m_mediaFPS{0}
{
    //Update of detection parameters from UI
    auto detectionParametersChange = [this]() {
        m_detectionParameters = DetectionParameters({m_detectionResolution.x(), m_detectionResolution.y()},
                                                    detectConfidenceLevel(),
                                                    useGrayScale(),
                                                    mediaSource(),
                                                    usedFramework());
    };
    detectionParametersChange();

    // Filter runnable detects objects and notify UI about it
    QObject::connect(this, &QCvDetectFilter::objectDetected, this,
         [this](float x, float y, float height, float width, float confidenceLvl, QString classifierName, int detectionTime)
         {
             detectedObjects()->append(new DetectedObjects(x, y, height, width, confidenceLvl, classifierName, detectionTime));
             setAmountOfDetectedItems(detectedObjects()->size());
             setDetectionTime(detectionTime);

             //qDebug()<<"Detected item: "<<height <<" "<<width<< " "<<confidenceLvl;
         });

    // Filter runnable detects objects and notify UI about it
    QObject::connect(this, &QCvDetectFilter::objectDetectedPtr, this,
                     [this](DetectedObjects* detectedObject)
                     {
                         detectedObjects()->append(detectedObject);
                         setAmountOfDetectedItems(detectedObjects()->size());
                         setDetectionTime(detectedObject->detectionTime());

                         //qDebug()<<"Detected item: "<<height <<" "<<width<< " "<<confidenceLvl;
                     });


  QObject::connect(this, &QCvDetectFilter::detectConfidenceLevelChanged, this,
                   detectionParametersChange);
  QObject::connect(this, &QCvDetectFilter::useGrayScaleChanged, this,
                   detectionParametersChange);
  QObject::connect(this, &QCvDetectFilter::detectionResolutionChanged, this,
                   detectionParametersChange);
  QObject::connect(this, &QCvDetectFilter::mediaSourceChanged, this,
                   detectionParametersChange);
  QObject::connect(this, &QCvDetectFilter::usedFrameworkChanged, this,
                   detectionParametersChange);

  QObject::connect(this, &QCvDetectFilter::initialize, this,
                   [&](){
                       AiManager::getInstance().initializeNeuralNetworksFrameworks(this,  &m_detectionParameters);
                   });
}

QVideoFilterRunnable *QCvDetectFilter::createFilterRunnable() {
  m_filterRunnable = new QCvDetectionFilterRunnable(this);

  return m_filterRunnable;
}

void QCvDetectFilter::clearDetectedItems()
{
    m_detectedObjects->reset();
    setAmountOfDetectedItems(0);
}

