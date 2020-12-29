#pragma once

#include <QObject>
#include <QString>
#include "utils/PropertyHelpers.h"

class YoutubeMediaLink : public QObject
{
    Q_OBJECT
    AUTO_PROPERTY(QString, resolution, resolution, setResolution, resolutionChanged);
    AUTO_PROPERTY(QString, baseUrl, baseUrl, setBaseUrl, baseUrlChanged);
    AUTO_PROPERTY(QString, processedUrl, processedUrl, setProcessedUrl, processedUrlChanged);
public:
    explicit YoutubeMediaLink(QString resolution, QString baseUrl, QString processedUrl):
        m_resolution(resolution),
        m_baseUrl(baseUrl),
        m_processedUrl(processedUrl){};
};
