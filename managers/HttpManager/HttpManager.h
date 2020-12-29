#pragma once
#include <QString>
#include <QObject>
#include <QNetworkReply>
#include <QNetworkAccessManager>
#include <QVariantMap>
#include "utils/PropertyHelpers.h"
#include "models/ObjectListModel.h"

#include "models/modelObjects/YoutubeMediaLink.h"

class HttpManager : public QObject
{
    Q_OBJECT

    QString m_currentProcessedUrl;
    const QString youtubeLinkConverterAdress {"https://qtyoutube.000webhostapp.com/"}; //own php server

    AUTO_PROPERTY(ObjectListModel*, convertedYoutubeLinks, convertedYoutubeLinks, setConvertedYoutubeLinks,convertedYoutubeLinksChanged);
    AUTO_PROPERTY(YoutubeMediaLink*, selectedYoutubeLink, selectedYoutubeLink, setSelectedYoutubeLink,selectedYoutubeLinkChanged);
    AUTO_PROPERTY(QImage*, networkImage, networkImage, setNetworkImage, networkImageChanged);

public:
    explicit HttpManager(QObject *parent = nullptr);
    Q_INVOKABLE void getYoutubeRawLinks(const QString url);
    Q_INVOKABLE void processNetworkImage(const QString url);
    Q_INVOKABLE void setSelectedYoutubeLink(const int index);
    Q_INVOKABLE void resetConvertedYoutubeLinks();

signals:
    void youtubeLinkProcessingError();

private slots:
    void processYoutubeLinkSerwerAnswer(QNetworkReply* reply);
    void processImageLinkAnswer(QNetworkReply* reply);
};
