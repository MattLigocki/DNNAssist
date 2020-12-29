#include "OpenCvFramework.h"
#include "../DetectionRectangle.h"
#include <QDir>
#include <QTemporaryFile>
#include "models/modelObjects/Classifier.h"
#include <controllers/MediaScreenController.h>
#include "utils/Colors.h"

OpenCvFramework::OpenCvFramework(QCvDetectFilter* filter, detectionParameters_t* detectionParameters)
    : INeurNetFramework(filter, detectionParameters,"OpenCv","https://github.com/opencv/opencv", "qrc:/img/res/opencv.png")
{
    m_availableClassifiers = new ObjectListModel();
    setActiveClassifier("faceclassifier.xml");

#ifdef __linux__

    QDir base = QDir::currentPath();

    base.cdUp();
    base.cdUp();

    setClassifiersDirectory(base.path()+"/examples/models/opencv/");
    qDebug()<<base.path()<<" LIGOCKI";

#else
     setClassifiersDirectory("d:/work/programming/projects/qt/OpenCvCamera/examples/models/opencv_haar_cassade/classifiers/");
#endif



    QObject::connect(this, &OpenCvFramework::classifiersDirectoryChanged, this, [&]()
    {
        auto classifierList = getPretrainedClassifiers();

        availableClassifiers()->reset();
        for(auto& x : classifierList){
            availableClassifiers()->append(new Classifier(x));
        }
        emit availableClassifiersChanged(availableClassifiers());
    });
    #ifdef __linux__
    QObject::connect(this, &OpenCvFramework::classifiersDirectoryChanged, this, [&](){
        static const QString prefix{"file://"};
        if(classifiersDirectory().contains(prefix)){
            setClassifiersDirectory(classifiersDirectory().replace(prefix, ""));
        }
        qDebug()<<classifiersDirectory();
    });
    #endif

    emit classifiersDirectoryChanged(m_classifiersDirectory);
}

QStringList OpenCvFramework::getPretrainedClassifiers()
{
#ifdef __linux__
        QDir directory(classifiersDirectory().replace(QString("file://"), QString("")));
#else
        QDir directory(classifiersDirectory().replace(QString("file:///"), QString("")));
#endif

    return directory.entryList(QStringList() << "*.xml" << "*.XML",QDir::Files);
}

void OpenCvFramework::processImageByDarknet(QImage image){
    Q_UNUSED(image);
}

void OpenCvFramework::processImageByOpenMp(QImage image){
    Q_UNUSED(image);
}


// Get the names of the output layers
vector<String> OpenCvFramework::getOutputsNames(const Net& net)
{
    static vector<String> names;

    //Get the indices of the output layers, i.e. the layers with unconnected outputs
    vector<int> outLayers = net.getUnconnectedOutLayers();

    //get the names of all the layers in the network
    vector<String> layersNames = net.getLayerNames();

    // Get the names of the output layers in names
    names.resize(outLayers.size());
    for (size_t i = 0; i < outLayers.size(); ++i)
        names[i] = layersNames[outLayers[i] - 1];

    return names;
}

void OpenCvFramework::processImageByOpenCv(QImage image){
    if (loadClassifier()) {
        return;
    }


    // Convert QImage to QImage cv::Mat
    cv::Mat mat(image.height(), image.width(), CV_8UC3, image.bits(),
                image.bytesPerLine());

    // QVideoFrame are reversed so need a flip
    if(filter()->mediaSource()=="camera")
    {
        cv::flip(mat, mat, 0);
    }

    // Output for QML to display multiple detected rectangles
    std::vector<cv::Rect> detected;

    QSize resized = image.size().scaled(
        detectionParameters()->imageDetectionResolution.first,
        detectionParameters()->imageDetectionResolution.second,
        Qt::KeepAspectRatio);
    cv::resize(mat, mat, cv::Size(resized.width(), resized.height()));

    std::vector<double> weights;
    std::vector<int> levels;

    // calculate detection time
    auto start = std::chrono::high_resolution_clock::now();

    // Could be converted to grayscale from UI
    if (detectionParameters()->userGrayScaleConversion) {
        cv::Mat frame_gray;
        cv::cvtColor(mat, frame_gray, cv::COLOR_BGR2GRAY);
        cv::equalizeHist(frame_gray, frame_gray);

        m_classifier.detectMultiScale(frame_gray, detected, levels, weights, 1.1, 3,
                                      0, cv::Size(), cv::Size(), true);
    } else {
        m_classifier.detectMultiScale(mat, detected, levels, weights, 1.1, 3, 0,
                                      cv::Size(), cv::Size(), true);
    }

    // Top timer and calculate duration
    auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(
        std::chrono::high_resolution_clock::now() - start);

    auto count = duration.count();
    double fps = 1000/ (count>0?count:1);

    // Get name of classifier to diplay at AR
    auto urlList = activeClassifier().split('/');
    auto classifierName = urlList.takeLast();
    classifierName.replace(".xml", "")
        .replace("haarcascade", "")
        .replace("classifier", "");

    // Clear previous detection diplayed
    filter()->detectedObjects()->reset();
    filter()->setAmountOfDetectedItems(0);

    QString nameFull {"OpenCV | "};
    nameFull.append(classifierName);
    for (decltype(detected.size()) i{0}; i < detected.size(); ++i) {
        if (weights[i] > detectionParameters()->detectConfidenceLevel) {
            auto rect = rect_float_t(mat, detected[i]);
            emit filter()->objectDetected(rect.x, rect.y, rect.h, rect.w,
                                          weights[i], nameFull, fps);
        }
    }
}

bool OpenCvFramework::loadClassifier() {
    // load it from file
    auto getClassifierPath = [&]() -> QString {
        return classifiersDirectory() + activeClassifier();
    };
    static QString currentClassifierPath;

    // Load classifier is is empty or changed
    if (m_classifier.empty() || currentClassifierPath != getClassifierPath()) {
        currentClassifierPath = getClassifierPath();

        QFile xml(currentClassifierPath);

        if (xml.open(QFile::ReadOnly | QFile::Text)) {
            // Store in temporary file
            QTemporaryFile temp;
            if (temp.open()) {
                temp.write(xml.readAll());
                temp.close();
                if (m_classifier.load(temp.fileName().toStdString())) {
                    qDebug() << "Successfully loaded classifier!";
                    return true;
                } else {
                    qDebug() << "Could not load classifier.";
                }
            } else {
                qDebug() << "Can't open temp file.";
            }
        } else {
            qDebug() << "Can't open XML.";
        }
    }
    return false;
}

QImage OpenCvFramework::Mat2QImage(cv::Mat const& src)
{
    cv::Mat temp;
    cvtColor(src, temp,cv::COLOR_BGR2RGBA);
    QImage dest((const uchar *) temp.data, temp.cols, temp.rows, temp.step, QImage::Format_RGBA8888);
    dest.bits();
    return dest;
}

cv::Mat OpenCvFramework::QImage2Mat(QImage const& src)
{
    cv::Mat tmp(src.height(),src.width(),CV_8UC3,(uchar*)src.bits(),src.bytesPerLine());

    if(tmp.empty())
        return tmp;

    cv::Mat result;
    cvtColor(tmp, result,COLOR_BGR2RGB);
    return result;
}

void OpenCvFramework::insertToOpenCvView(cv::Mat& openCvView, Rect& box, QString& label)
{
    //Draw a rectangle displaying the bounding box
    rectangle(openCvView, Point(box.x, box.y), Point(box.x+box.width, box.y+box.height), Scalar(255, 178, 50), 3);

    //Display the label at the top of the bounding box
    int baseLine;
    float fontSize {( static_cast<float>(openCvView.size().width)/1000)- static_cast<float>(openCvView.size().width)/3000};

    auto labelSize = getTextSize(label.toStdString(), FONT_HERSHEY_PLAIN, fontSize, 1, &baseLine);
    box.y = max(box.y, labelSize.height);
    rectangle(openCvView, Point(box.x, box.y - round(2.6*labelSize.height)), Point(box.x+round(1.9*labelSize.width), box.y + baseLine), Scalar(255, 255, 255), FILLED);
    putText(openCvView, label.toStdString(), Point(box.x, box.y), FONT_HERSHEY_SIMPLEX, fontSize, Scalar(255,0,0),1);
}

void OpenCvFramework::displayOpenCvView(Mat& openCvView, std::list<QColor*> masksColors)
{
    //convert from 3 chanels to 4 channels
    cv::cvtColor(openCvView, openCvView, cv::COLOR_BGR2BGRA);

    for (int y = 0; y < openCvView.rows; ++y)
    {
        for (int x = 0; x < openCvView.cols; ++x)
        {
            cv::Vec4b & pixel = openCvView.at<cv::Vec4b>(y, x);
            // if pixel is black
            if (pixel[0] == 0 && pixel[1] == 0 && pixel[2] == 0)
            {
                // set alpha to zero:
                pixel[3] = 0;
            }

            for(const auto& maskColor : masksColors){
                if (maskColor != nullptr &&
                        pixel[0] == maskColor->red() &&
                        pixel[1] == maskColor->green() &&
                        pixel[2] == maskColor->blue())
                    // set alpha to zero:
                {
                    pixel[3] = 128;
                }
            }
        }
    }

    MediaScreenController::getInstance().getImageProvider()->setImage(Mat2QImage(openCvView).convertToFormat(QImage::Format_ARGB32));
}

QVector<DetectedObjects*> OpenCvFramework::processByDNN(QImage image,
                                                  cv::dnn::Net& network,
                                                  vector<String>& networkOutputsNames,
                                                  vector<String>& networkClassesNames,
                                                  DNN_DETECTION_PARAMS parameters)
{
    auto [confidenceThrs,
          inputSize,
          outBlobSize,
          scaleFactor,
          meanR, meanG, meanB,
          showQtView,
          showOpenCvView,
          displayMask,
          frameworkName] = parameters;

    //PREPROCESS

    // Convert QImage to QImage cv::Mat
    cv::Mat frame = OpenCvFramework::QImage2Mat(image);
    // Empty mat for AR overlay
    Mat openCvView =  Mat::zeros(frame.size(), frame.type());

    if(frame.empty()){
        qDebug()<<"ERROR in image processing";
        return {};
    }

    //Make blob for DNN with selected parameters
    Mat inputBlob = cv::dnn::blobFromImage(frame,
                                           scaleFactor,
                                           Size(outBlobSize.x()==2048?frame.cols:outBlobSize.x(), outBlobSize.y()==2048?frame.rows:outBlobSize.y()),
                                           Scalar(meanR, meanG, meanB),
                                           frameworkName=="Caffe"?false:true,
                                           false);

    //PROCESS
    auto start = std::chrono::high_resolution_clock::now();

    std::vector<cv::Mat> outs;
    auto outLayerType = network.getLayer(network.getUnconnectedOutLayers()[0])->type;

    for(auto& x : network.getUnconnectedOutLayersNames()){
        QString layer{ x.c_str()};

        if(layer.contains("mask")){
             outLayerType="MASK";
             networkOutputsNames.clear();
             networkOutputsNames.push_back( "detection_out_final");
             networkOutputsNames.push_back( "detection_masks");
        }
    }

    try{
        network.setInput(inputBlob);
        network.forward(outs,networkOutputsNames);
    }catch(...){
        qDebug()<<"ERROR: Incorrect parameters";
        return {};
    }

    auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(std::chrono::high_resolution_clock::now() - start);

    //POSTPROCESS
    // Remove the bounding boxes with low confidence
    bool isOutputToShow {false};

    QVector<DetectedObjects*> detectedItems;
    QString label {frameworkName.append(": ")};

    if (outLayerType == "DetectionOutput"|| outLayerType=="Softmax" || outLayerType=="Sigmoid" || outLayerType=="MASK") //Tensorflow
    {
        Mat outDetections = outs[0];
        auto data = reinterpret_cast<float*>(outs[0].data);
        std::list<QColor*> masksColors;
        for (auto i {0}; i < outDetections.size[2]; i += 7)
        {
            float confidence = data[i + 2];

            if (confidence > confidenceThrs)
            {
                isOutputToShow = true;
                auto left   = data[i + 3];
                auto top    = data[i + 4];
                auto right  = data[i + 5];
                auto bottom = data[i + 6];
                auto width  = right - left + 1;
                auto height = bottom - top + 1;
                if (width <= 2 || height <= 2)
                {
                    left   = (data[i + 3]);
                    top    = (data[i + 4]);
                    right  = (data[i + 5]);
                    bottom = (data[i + 6]);
                    width  = right - left;
                    height = bottom - top;
                }

                int classId = static_cast<int>(outDetections.at<float>(i, 1));

               // qDebug()<<left << " "<<top << " "<<right << " "<<bottom << " "<<confidence <<" " <<classId << " "<<networkClassesNames.size();

                QString boxLabel = label;
                //Names are not available right now
                if(!networkClassesNames.empty() && outLayerType != "Softmax" )
                {
                    if(classId<0){
                        classId = 0;
                    }
                    boxLabel.append(networkClassesNames[classId].c_str());
                }

                if(showQtView){
                    detectedItems.push_back(new DetectedObjects(left, top, width, height,confidence,boxLabel,duration.count()));
                }
                if(showOpenCvView){
                    left *= frame.cols;
                    top *= frame.rows;
                    right *= frame.cols;
                    bottom *= frame.rows;

                    //Object bounding box
                    Rect box = Rect(left, top, right - left+1, bottom - top+1);

                    //Add confidence to layer
                    boxLabel.append(" ");
                    boxLabel.append(QString::number(static_cast<int>(confidence*100)));
                    boxLabel.append("%");

                    OpenCvFramework::insertToOpenCvView(openCvView, box, boxLabel);

                    if(outs.size() > 1 && displayMask==2){
                        //Get masks
                        Mat outMasks = outs[1];

                        //Get base color point for class
                        int colorId {classId*6};


                        QColor* qColor = new QColor{globalColorsVec.at(colorId).second};
                        masksColors.push_back(qColor);
                        Scalar color(qColor->red(),qColor->green(),qColor->blue(), 0.3);
                        Mat objectMask(outMasks.size[2], outMasks.size[3],CV_32F, outMasks.ptr<float>(i,classId));

                        // Resize the mask, threshold, color and apply it on the image
                        float maskThreshold = 0.3; // Mask threshold
                        resize(objectMask, objectMask, Size(box.width, box.height));
                        Mat mask = (objectMask > maskThreshold);

                        Mat coloredRoi = (color + 0.7 * openCvView(box));
                        coloredRoi.convertTo(coloredRoi, CV_8UC3);

                        // Draw the contours on the image
                        vector<Mat> contours;
                        Mat hierarchy;
                        mask.convertTo(mask, CV_8U);
                        findContours(mask, contours, hierarchy, RETR_CCOMP, CHAIN_APPROX_SIMPLE);

                        QColor* qColorBorder = new QColor{globalColorsVec.at(colorId+2).second};
                        Scalar colorBorder(qColorBorder->red(),qColorBorder->green(),qColorBorder->blue());
                        drawContours(coloredRoi, contours, -1, colorBorder, 5, LINE_8, hierarchy, 100);

                        coloredRoi.copyTo(openCvView(box), mask);
                    }
               }
            }
        }
        if(isOutputToShow)
            OpenCvFramework::displayOpenCvView(openCvView, masksColors);

    }else if (outLayerType == "Region"){ //Darknet,Yolo

        for (size_t i = 0; i < outs.size(); ++i)
        {
            // Network produces output blob with a shape NxC where N is a number of
            // detected objects and C is a number of classes + 4 where the first 4
            // numbers are [center_x, center_y, width, height]

            float* data = (float*)outs[i].data;
            for (int j = 0; j < outs[i].rows; ++j, data += outs[i].cols)
            {
                Mat scores = outs[i].row(j).colRange(5, outs[i].cols);
                Point classIdPoint;
                double confidence;
                minMaxLoc(scores, 0, &confidence, 0, &classIdPoint);
                if (confidence > confidenceThrs)
                {
                    isOutputToShow = true;

                    auto centerX = data[0];// * frame.cols);
                    auto centerY = data[1];// * frame.rows);
                    auto width = data[2];// * frame.cols);
                    auto height = data[3];// * frame.rows);
                    auto left = centerX - width / 2;
                    auto right = centerX + width / 2;
                    auto top = centerY - height / 2;
                    auto bottom = centerY + height / 2;

                    if(!networkClassesNames.empty())
                    {
                        label.append(networkClassesNames[classIdPoint.x].c_str());
                    }

                    if(showQtView){
                        detectedItems.push_back(new DetectedObjects(left, top, width, height,(float)confidence,label,duration.count()));
                    }
                    if(showOpenCvView){
                        left *= frame.cols;
                        top *= frame.rows;
                        right *= frame.cols;
                        bottom *= frame.rows;

                        //Object bounding box
                        Rect box = Rect(left, top, right - left + 1, bottom - top + 1);

                        //Add confidence to layer
                        label.append(" | ");
                        label.append(QString::number((float)confidence));
                        label.append("%");

                        OpenCvFramework::insertToOpenCvView(openCvView, box, label);
                    }
                    label.clear();
                }
            }

            if(isOutputToShow)
                OpenCvFramework::displayOpenCvView(openCvView);
        }
    }

    return detectedItems;
}
