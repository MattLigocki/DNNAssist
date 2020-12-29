#pragma once

#include <QObject>
#include <QString>
#include "utils/PropertyHelpers.h"

class DetectedObjects  : public QObject
{
    Q_OBJECT

    AUTO_PROPERTY(float, x, x, setX, xChanged);
    AUTO_PROPERTY(float, y, y, setY, yChanged);
    AUTO_PROPERTY(float, width, width, setWidth, widthChanged);
    AUTO_PROPERTY(float, height, height, setHeight, heightChanged);
    AUTO_PROPERTY(float, confidenceLvl, confidenceLvl, setConfidenceLvl, confidenceLvlChanged);
    AUTO_PROPERTY(int, detectionTime, detectionTime, setDetectionTime, detectionTimeChanged);
    AUTO_PROPERTY(QString, classifier, classifier, setClassifier, classifierChanged);

public:
    DetectedObjects(const DetectedObjects& detectedItem):
        QObject(nullptr),
        m_x(detectedItem.m_x),
        m_y(detectedItem.m_y),
        m_width(detectedItem.m_width),
        m_height(detectedItem.m_height),
        m_confidenceLvl(detectedItem.m_confidenceLvl),
        m_detectionTime(detectedItem.m_detectionTime),
        m_classifier(detectedItem.m_classifier){}

    DetectedObjects(float x, float y, float width, float height, float confidenceLvl, QString classifier, int detectionTime)
      : m_x(x),
        m_y(y),
        m_width(width),
        m_height(height),
        m_confidenceLvl(confidenceLvl),
        m_detectionTime(detectionTime),
        m_classifier(classifier){}
};
