#include "HttpManager.h"
#include <string>
#include<QMapIterator>
#include<managers/ComputerVisionManager/AiManager.h>
#include <controllers/MediaScreenController.h>

HttpManager::HttpManager(QObject *parent) :
    QObject(parent),
    m_convertedYoutubeLinks(new ObjectListModel){

}

/**
 * @brief HttpManager::getYoutubeRawLinks connect to server and get processed media links
 * @param url
 */
void HttpManager::getYoutubeRawLinks(const QString url)
{
    //Check ssl support
    //qDebug() << QSslSocket::sslLibraryBuildVersionString();
    //qDebug() << QSslSocket::supportsSsl();
    //qDebug() << QSslSocket::sslLibraryVersionString();

    m_currentProcessedUrl = url;

    QNetworkAccessManager *networkAccessManager = new QNetworkAccessManager(this);
    connect(networkAccessManager, SIGNAL(finished(QNetworkReply*)), this, SLOT(processYoutubeLinkSerwerAnswer(QNetworkReply*)));
    connect(networkAccessManager, &QNetworkAccessManager::finished, networkAccessManager, &QNetworkAccessManager::deleteLater);
    networkAccessManager->get(QNetworkRequest(QUrl(youtubeLinkConverterAdress + "?url="+url)));
}


void HttpManager::setSelectedYoutubeLink(const int index)
{
    setSelectedYoutubeLink(qobject_cast<YoutubeMediaLink*>(convertedYoutubeLinks()->at(index)));
}

void HttpManager::resetConvertedYoutubeLinks()
{
    setConvertedYoutubeLinks(new ObjectListModel);
    setSelectedYoutubeLink(nullptr);
}

void HttpManager::processYoutubeLinkSerwerAnswer(QNetworkReply *reply)
{
    setSelectedYoutubeLink(nullptr);

    //get answer from response
    size_t pos{0};
    std::string ss = QString::fromUtf8(reply->readAll()).toStdString();

    //find chunk of url
    pos = ss.find("googlevideo", pos );

    while(pos != std::string::npos){

        size_t pos2 = ss.find( "Download",pos);
        if(pos2 != std::string::npos){
            QString processedUrl = QString::fromStdString(ss.substr(pos-25,pos2-(pos-25)-2 ));
            QString urlResolution = QString::fromStdString(ss.substr(pos2+13, 4));

            urlResolution.remove("<");
            urlResolution.remove("(");
            urlResolution.remove("/");

            if(urlResolution.contains("img"))
                break;

            bool alreadyExists {false};

            for(int i{0}; i<m_convertedYoutubeLinks->size(); i++)
            {
                auto* item = qobject_cast<YoutubeMediaLink*>(m_convertedYoutubeLinks->at(i));
                if(item->resolution() == urlResolution){
                    alreadyExists = true;
                }
            }

            if(urlResolution.contains("P")  &&  !alreadyExists)
            {
                m_convertedYoutubeLinks->append(new YoutubeMediaLink(urlResolution, m_currentProcessedUrl ,processedUrl.replace("href=\"","")));
            }
        }

        pos = ss.find("googlevideo", pos+1 );
    }

    if(m_convertedYoutubeLinks->size()==0){
        emit youtubeLinkProcessingError();
    }
}

void HttpManager::processNetworkImage(const QString url)
{
    if(m_currentProcessedUrl==url){
        //Image cached, no need to download
        if(m_networkImage!=nullptr)
        {
            AiManager::getInstance().processImageByFrameworks(*m_networkImage);
        }
    }
    else{
        m_currentProcessedUrl = url;
        m_networkImage = nullptr;

        QNetworkAccessManager *networkAccessManager = new QNetworkAccessManager(this);
        connect(networkAccessManager, SIGNAL(finished(QNetworkReply*)), this, SLOT(processImageLinkAnswer(QNetworkReply*)));
        connect(networkAccessManager, &QNetworkAccessManager::finished, networkAccessManager, &QNetworkAccessManager::deleteLater);
        networkAccessManager->get(QNetworkRequest{QUrl(url)});
    }
}

void HttpManager::processImageLinkAnswer(QNetworkReply *reply)
{
    QImage img;
    img.load(reply, nullptr);
    img = img.convertToFormat(QImage::Format_RGB888);
    img = img.scaledToHeight(MediaScreenController::getInstance().imageHeigth());

    setNetworkImage(new QImage {img});
    AiManager::getInstance().processImageByFrameworks(*m_networkImage);
}
