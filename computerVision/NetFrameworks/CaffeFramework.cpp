#include "CaffeFramework.h"

#include <QDir>

CaffeFramework::CaffeFramework(QCvDetectFilter *filter, detectionParameters_t *detectionParameters)
    : IDnnFrameworkBase(filter,
                        detectionParameters,
                        "Caffe",
                        "https://github.com/BVLC/caffe",
                        "qrc:/img/res/caffe.png",
                        "*.caffemodel","*.prototxt"){
    setScaleFactor(1.0);
    setMeanR("0");
    setMeanG("0");
    setMeanB("0");
}

void CaffeFramework::readModelParametersFromFile(QString parametersFile)
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

            if( QString prefix {"crop_size: "}; line.contains(prefix)){
                line = line.remove(prefix).remove(" ");
               setOutBlobSize({line.toInt(), line.toInt()});

            }else if( QString prefix {"mean_value: "}; line.contains(prefix)){
                line = line.remove(prefix).remove(" ");
                static int cnt;
                if(cnt==0){
                    setMeanR(line);
                }
                else if(cnt==1){
                    setMeanG(line);
                }
                else if(cnt==2){
                    setMeanB(line);
                }

                if(cnt++==2)
                    return;
            }
        }
        inputFile.close();
    }
}

void CaffeFramework::loadModelFilesFromFolder(QString folder)
{
    QDir directory("Pictures/MyPictures");
    QStringList modelConfigurations = directory.entryList(QStringList() << modelConfigurationUrlFileExtension(),QDir::Files);

    for(auto& x : modelConfigurations){
        if(x.contains("deploy")){
            setModelConfigurationUrl(folder+x);
        }
    }
    QStringList modelWeight = directory.entryList(QStringList() << modelWeightsUrlExtension(),QDir::Files);
    if(!modelWeight.empty())
        setModelWeightsUrl(modelWeight.at(0));

    QStringList classes = directory.entryList(QStringList() << "corresp.txt",QDir::Files);
    if(!classes.empty())
        setModelClassNamesUrl(classes.at(0));
}
