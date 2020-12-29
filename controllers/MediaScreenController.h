#pragma once

#include <QObject>
#include "utils/NwImageProvider.h"
#include "utils/PropertyHelpers.h"

class MediaScreenController: public QObject
{
    Q_OBJECT
    MediaScreenController();
    AUTO_PROPERTY(int, imageWidth, imageWidth,setImageWidth, imageWidthChanged)
    AUTO_PROPERTY(int, imageHeigth, imageHeigth,setImageHeigth, imageHeigthChanged)

    NwImageProvider* imageProvider { new NwImageProvider() };

public:
    static MediaScreenController& getInstance();
    NwImageProvider *getImageProvider() const;

    Q_INVOKABLE QString convertVideoTimeToTimeString(int value);
};
