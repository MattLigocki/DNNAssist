#include "MediaScreenController.h"

#include <QTime>

MediaScreenController::MediaScreenController()
{
}

NwImageProvider *MediaScreenController::getImageProvider() const
{
    return imageProvider;
}

QString MediaScreenController::convertVideoTimeToTimeString(int value)
{
    int seconds = (value/1000) % 60;
    int minutes = (value/60000) % 60;
    int hours = (value/3600000) % 24;

    QTime time(hours, minutes,seconds);
    return time.toString();
}


MediaScreenController &MediaScreenController::getInstance()
{
    static MediaScreenController mediaScreenController;
    return mediaScreenController;
}
