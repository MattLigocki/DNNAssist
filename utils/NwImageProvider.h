#pragma once

#include <QObject>
#include <QQuickImageProvider>

class NwImageProvider : public QObject, public QQuickImageProvider
{
    Q_OBJECT
    QImage m_image;
public:
    NwImageProvider() : QQuickImageProvider(QQmlImageProviderBase::Image){};
    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize);

    void setImage(const QImage image) noexcept;
signals:
    Q_SIGNAL void signalNewFrameReady(int frameNumber);

};
