#include "TensorflowFramework.h"


TensorflowFramework::TensorflowFramework(QCvDetectFilter *filter, detectionParameters_t *detectionParameters)
    : IDnnFrameworkBase(filter, detectionParameters,
                        "Tensorflow",
                        "https://github.com/tensorflow/tensorflow",
                        "qrc:/img/res/tensorflow.jpg",
                        "*.pb","*.pbtxt"){
    setScaleFactor(1.0);
    setOutBlobSize({512,512});
    setMeanR("0");
    setMeanG("0");
    setMeanB("0");

}

void TensorflowFramework::writeTextGraph(){
    cv::dnn::writeTextGraph(modelWeightsUrl().toStdString(), modelConfigurationUrl().toStdString());
}

void TensorflowFramework::readModelParametersFromFile(QString parametersFile)
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

            if( QString prefix {"type:"}; line.contains(prefix)){
                setCurrentModelName(line.remove(prefix).remove("\"").remove(" "));
                return;
            }
        }
        inputFile.close();
    }
}


