#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQmlContext>
#include <QQuickWindow>
#include <memory>
#include <QTimer>

#include "models/modelObjects/Classifier.h"

#include "computerVision/QCvDetectFilter.h"
#include "controllers/DataSetsScreenController.h"
#include "controllers/MediaScreenController.h"

#include "managers/ComputerVisionManager/AiManager.h"
#include "managers/HttpManager/HttpManager.h"

#include "utils/FileSystemHandler.h"
#include "utils/Common.h"


int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    app.setApplicationName("DNNAssist");
    QQuickStyle::setStyle("Material");

    //Register QML types
    qmlRegisterType<QCvDetectFilter>("com.dnnassist.classes", 1, 0, "CvDetectFilter");
    qmlRegisterType<ObjectListModel>("com.dnnassist.classes", 1, 0, "ObjectListModel");
    qmlRegisterType<FileSystemHandler>("com.dnnassist.classes", 1, 0, "FileSystemHandler");

    QQmlApplicationEngine engine;

    //Register managers
    engine.rootContext()->setContextProperty("aiManager", &AiManager::getInstance());

    //Register controllers
    engine.rootContext()->setContextProperty("dataSetsScreenController", &DataSetsScreenController::getInstance());
    engine.rootContext()->setContextProperty("mediaScreenController", &MediaScreenController::getInstance());

    //Register processed video output
    engine.rootContext()->engine()->addImageProvider(QLatin1String("NwImageProvider"), MediaScreenController::getInstance().getImageProvider());
    engine.rootContext()->setContextProperty("NwImageProvider", MediaScreenController::getInstance().getImageProvider());

    engine.rootContext()->setContextProperty("httpManager", new HttpManager());

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);

    if (engine.rootObjects().isEmpty()) {
        qDebug("Empty rootObjects");
        return -1;
    }

    return app.exec();
}
