#pragma once

#include <QAbstractVideoFilter>
#include <QList>
#include <QObject>
#include <QPoint>
#include <QString>
#include <memory>

#include "opencv2/opencv.hpp"

#include "models/ObjectListModel.h"
#include "DetectionParameters.h"
#include "models/modelObjects/DetectedObjects.h"
#include "utils/PropertyHelpers.h"

class QCvDetectionFilterRunnable;

class QCvDetectFilter : public QAbstractVideoFilter {
  Q_OBJECT

  // Detection input parameters
  AUTO_PROPERTY(QPoint, detectionResolution, detectionResolution,setDetectionResolution, detectionResolutionChanged)
  AUTO_PROPERTY(bool, useGrayScale, useGrayScale, setUseGrayScale,useGrayScaleChanged)
  AUTO_PROPERTY(QString, usedFramework, usedFramework, setUsedFramework, usedFrameworkChanged)
  AUTO_PROPERTY(double, detectConfidenceLevel, detectConfidenceLevel, setDetectConfidenceLevel, detectConfidenceLevelChanged)
  AUTO_PROPERTY(QString, mediaSource, mediaSource,setMediaSource, mediaSourceChanged)
  AUTO_PROPERTY(float, mediaFPS, mediaFPS,setMediaFPS, mediaFPSChanged)

  AUTO_PROPERTY(ObjectListModel *, neuralNetworkFrameworks, neuralNetworkFrameworks,setNeuralNetworkFrameworks, neuralNetworkFrameworksChanged)

  // Detected items and detection output parameters
  AUTO_PROPERTY(int, detectionTime, detectionTime, setDetectionTime, detectionTimeChanged)
  AUTO_PROPERTY(int, amountOfDetectedItems, amountOfDetectedItems,setAmountOfDetectedItems, amountOfDetectedItemsChanged)
  AUTO_PROPERTY(ObjectListModel *, detectedObjects, detectedObjects, detectedObjects, detectedObjectsChanged)

  QCvDetectionFilterRunnable *m_filterRunnable;
  detectionParameters_t m_detectionParameters;

public:
  QCvDetectFilter();
  QVideoFilterRunnable *createFilterRunnable();

public slots:
    void clearDetectedItems();

signals:

  void objectDetected(float x, float y, float height, float width,
                      float confidenceLvl, QString classifierName,
                      double detectionTime);
  void objectDetectedPtr(DetectedObjects* detectedObject);

  void initialize();
};
