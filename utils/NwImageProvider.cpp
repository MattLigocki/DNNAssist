#include "NwImageProvider.h"

#include "NwImageProvider.h"

void NwImageProvider::setImage(const QImage image) noexcept
{
    static auto nextFrameNumber {0ULL};
    m_image = image;
    emit signalNewFrameReady(nextFrameNumber++);
}

QImage NwImageProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{
    Q_UNUSED(id);
    Q_UNUSED(size);
    Q_UNUSED(requestedSize);

    return m_image;
}

