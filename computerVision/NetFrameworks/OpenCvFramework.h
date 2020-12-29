#pragma once

#include "../DetectionParameters.h"
#include "INeurNetFramework.h"
#include "opencv2/opencv.hpp"

using namespace cv;
using namespace dnn;
using namespace std;

class OpenCvFramework : public INeurNetFramework {

  Q_OBJECT
  cv::CascadeClassifier m_classifier;

  //Properties
  AUTO_PROPERTY(ObjectListModel*, availableClassifiers, availableClassifiers, setAvailableClassifiers, availableClassifiersChanged)
  AUTO_PROPERTY(QString, classifiersDirectory, classifiersDirectory, setClassifiersDirectory, classifiersDirectoryChanged)
  AUTO_PROPERTY(QString, activeClassifier, activeClassifier, setActiveClassifier, activeClassifierChanged)

  //Interface methods
  virtual void processImageByOpenCv(QImage image);
  virtual void processImageByDarknet(QImage image);
  virtual void processImageByOpenMp(QImage image);

  //Object methods
  bool loadClassifier();
  QStringList getPretrainedClassifiers();

public:
  //CV methods
  OpenCvFramework(
        QCvDetectFilter* filter,
        detectionParameters_t* detectionParameters);

  static QImage Mat2QImage(cv::Mat const& src);
  static cv::Mat QImage2Mat(QImage const& src);
  static void displayOpenCvView(Mat& openCvView, std::list<QColor*> masksColors = {});
  static void insertToOpenCvView(cv::Mat& openCvView, Rect& box, QString& label);

  static vector<String> getOutputsNames(const Net& net);

  static QVector<DetectedObjects*> processByDNN(QImage image,
                                            cv::dnn::Net& network,
                                            vector<String>& networkOutputsNames,
                                            vector<String>& networkClassesNames,
                                            DNN_DETECTION_PARAMS parameters);
  virtual ~OpenCvFramework(){}

};
