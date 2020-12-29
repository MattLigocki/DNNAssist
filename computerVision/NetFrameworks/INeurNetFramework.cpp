#include "INeurNetFramework.h"

void INeurNetFramework::processImage(QImage image)
{
    if(detectionParameters()->usedFramework=="OpenCv"){
        processImageByOpenCv(image);
    }else if(detectionParameters()->usedFramework=="Darknet"){
        processImageByDarknet(image);
    }else if(detectionParameters()->usedFramework=="OpenMp"){
        processImageByOpenMp(image);
    }else{
        qDebug()<<"Invalid framework: "<<detectionParameters()->usedFramework;
    }
}

detectionParameters_t* INeurNetFramework::detectionParameters() {
  return m_detectionParameters;
}

QCvDetectFilter* INeurNetFramework::filter() {
    return m_filter;
}

