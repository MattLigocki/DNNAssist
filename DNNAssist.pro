QT += quick quickcontrols2 multimedia concurrent network widgets concurrent

CONFIG += c++17

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

HEADERS += \
    computerVision/DetectionParameters.h \
    computerVision/DetectionRectangle.h \
    computerVision/NetFrameworks/CaffeFramework.h \
    computerVision/NetFrameworks/DLDTFramework.h \
    computerVision/NetFrameworks/DarknetFramework.h \
    computerVision/NetFrameworks/IDnnFrameworkBase.h \
    computerVision/NetFrameworks/INeurNetFramework.h \
    computerVision/NetFrameworks/ONNXFramework.h \
    computerVision/NetFrameworks/OpenCvFramework.h \
    computerVision/NetFrameworks/TensorflowFramework.h \
    computerVision/NetFrameworks/TorchFramework.h \
    computerVision/QCvDetectFilter.h \
    computerVision/QCvDetectionFilterRunnable.h \
    controllers/DataSetsScreenController.h \
    controllers/MediaScreenController.h \
    managers/ComputerVisionManager/AiManager.h \
    managers/HttpManager/HttpManager.h \
    models/ObjectListModel.h \
    models/modelObjects/Classifier.h \
    models/modelObjects/DetectedObjects.h \
    models/modelObjects/YoutubeMediaLink.h \
    utils/Colors.h \
    utils/Common.h \
    utils/FileSystemHandler.h \
    utils/NwImageProvider.h \
    utils/PropertyHelpers.h

SOURCES += \
    computerVision/NetFrameworks/CaffeFramework.cpp \
    computerVision/NetFrameworks/DLDTFramework.cpp \
    computerVision/NetFrameworks/DarknetFramework.cpp \
    computerVision/NetFrameworks/IDnnFrameworkBase.cpp \
    computerVision/NetFrameworks/INeurNetFramework.cpp \
    computerVision/NetFrameworks/ONNXFramework.cpp \
    computerVision/NetFrameworks/OpenCvFramework.cpp \
    computerVision/NetFrameworks/TensorflowFramework.cpp \
    computerVision/NetFrameworks/TorchFramework.cpp \
    computerVision/QCvDetectFilter.cpp \
    computerVision/QCvDetectionFilterRunnable.cpp \
    controllers/DataSetsScreenController.cpp \
    controllers/MediaScreenController.cpp \
        main.cpp \
    managers/ComputerVisionManager/AiManager.cpp \
    managers/HttpManager/HttpManager.cpp \
    models/ObjectListModel.cpp \
    models/modelObjects/Classifier.cpp \
    models/modelObjects/DetectedObjects.cpp \
    models/modelObjects/YoutubeMediaLink.cpp \
    utils/FileSystemHandler.cpp \
    utils/NwImageProvider.cpp

RESOURCES += qml.qrc \
    img.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin sd
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

win32{
INCLUDEPATH += C:\OpenSSL-Win64\include\
INCLUDEPATH += D:\work\programming\enviroment_and_installs\opencv\opencvSources\build\include
LIBS += -LC:\OpenSSL-Win32\bin \
        -LD:\work\programming\enviroment_and_installs\opencv\opencv-build\bin\
        LIBS += -lopencv_core440 \
                -lopencv_highgui440 \
        #        -lopencv_imgcodecs440 \
                -lopencv_dnn440 \
                -lopencv_imgproc440 \
        #        -lopenotencv_features2d440 \
        #        -lopencv_calib3d440\
        #        -lopencv_flann440\
        #        -lopencv_gapi440 \
        #        -lopencv_imgcodecs440 \
        #        -lopencv_ml440 \
                -lopencv_objdetect440 \
        #        -lopencv_photo440 \
        #        -lopencv_stitching440 \
        #        -lopencv_video440 \
        #        -lopencv_videoio440 \
}

unix{
INCLUDEPATH += C:\OpenSSL-Win64\include\
INCLUDEPATH += /usr/local/include/opencv4/
LIBS += -L/usr/local/lib

LIBS += -lopencv_core \
        -lopencv_highgui \
#        -lopencv_imgcodecs440 \
        -lopencv_dnn \
        -lopencv_imgproc \
#        -lopenotencv_features2d440 \
#        -lopencv_calib3d440\
#        -lopencv_flann440\
#        -lopencv_gapi440 \
#        -lopencv_imgcodecs440 \
#        -lopencv_ml440 \
        -lopencv_objdetect \
#        -lopencv_photo440 \
#        -lopencv_stitching440 \
#        -lopencv_video440 \
#        -lopencv_videoio440 \
}
DISTFILES +=


