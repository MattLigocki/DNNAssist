#include "DarknetFramework.h"

DarknetFramework::DarknetFramework(QCvDetectFilter *filter, detectionParameters_t *detectionParameters)
    : IDnnFrameworkBase(filter, detectionParameters,
                        "Darknet",
                        "https://pjreddie.com/darknet/yolo/",
                        "qrc:/img/res/darknet.png",
                        "*.weights","*.cfg"){
    setScaleFactor(0.00097656);
    setOutBlobSize({512,512});
    setMeanR("1");
    setMeanG("1");
    setMeanB("1");
}

void DarknetFramework::readModelParametersFromFile(QString parametersFile)
{
#ifdef __linux__
    parametersFile.remove("file://");
#else
    parametersFile.remove("file:///");
#endif

    QFile inputFile(parametersFile);
    if (inputFile.open(QIODevice::ReadOnly))
    {
        QTextStream in(&inputFile);
        while (!in.atEnd())
        {
            QString line = in.readLine();

            //            if( QString prefix {"type:"}; line.contains(prefix)){

//                return;
//            }
        }
        inputFile.close();
    }
}


