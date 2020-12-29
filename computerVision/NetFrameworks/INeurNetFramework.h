#ifndef INETFRAMEWORK_H
#define INETFRAMEWORK_H

#include "../DetectionParameters.h"
#include "computerVision/QCvDetectFilter.h"
#include <QObject>
#include <opencv2/opencv.hpp>

/**
 * @brief The INeurNetFramework class
 *
 * Interface class with deneral properties for classifiers and dnn networks *
 */
class INeurNetFramework : public QObject {
  Q_OBJECT

    /**
    * @brief m_filter
    */
    QCvDetectFilter* m_filter;
    detectionParameters_t* m_detectionParameters;
    AUTO_PROPERTY(bool,  useGPU , useGPU, setUseGPU, useGPUChanged)
    AUTO_PROPERTY(QString,  name , name, setName, nameChanged)
    AUTO_PROPERTY(QString, frameworkRepoLink , frameworkRepoLink, setframeworkRepoLink, frameworkRepoLinkChanged)
    AUTO_PROPERTY(QString,  iconSource , iconSource, setIconSource, iconSourceChanged)
    AUTO_PROPERTY(bool, isActive , isActive, setIsActive, isActiveChanged);

    virtual void processImageByOpenCv(QImage image)=0;
    virtual void processImageByDarknet(QImage image)=0;
    virtual void processImageByOpenMp(QImage image)=0;

public:
    //CTOR
    explicit INeurNetFramework(
      QCvDetectFilter* filter,
      detectionParameters_t* detectionParameters,
      QString&& name,
      QString&& frameworkRepoLink,
      QString&& iconSource)
      : m_filter(filter),
        m_detectionParameters(detectionParameters),
        m_name(name),
        m_frameworkRepoLink(frameworkRepoLink),
        m_iconSource(iconSource){}

    //Tuple with parameters for image processing
    using DNN_DETECTION_PARAMS = std::tuple<double,  //condifence
                                          QPoint,  //inputRescale
                                          QPoint,  //outBlobSize
                                          double,  //scale factor
                                          double,  //meanR
                                          double,  //meanG
                                          double,  //meanB
                                          bool,    //qtVision
                                          bool,    //frameworkVision
                                          int,     //displayMask
                                          QString  //name
                                          > ;

    //Starting point for image processing
    void processImage(QImage image);

    //Getters
    QCvDetectFilter* filter();
    detectionParameters_t* detectionParameters();

    //DCTOR
    virtual ~INeurNetFramework(){}
};

#endif // INETFRAMEWORK_H
