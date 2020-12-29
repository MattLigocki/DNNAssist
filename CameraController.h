#ifndef CAMERACONTROLLER_H
#define CAMERACONTROLLER_H

#include <QObject>

class CameraController : public QObject
{
    Q_OBJECT
public:
    explicit CameraController(QObject *parent = nullptr);

signals:

};

#endif // CAMERACONTROLLER_H
