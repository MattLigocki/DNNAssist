#pragma once
#include "IDnnFrameworkBase.h"

#include <QFutureWatcher>
#include <QMutex>
#include <tuple>

using namespace cv;
using namespace dnn;
using namespace std;

class DarknetFramework : public IDnnFrameworkBase {

    Q_OBJECT
public:
    DarknetFramework(QCvDetectFilter* filter,
        detectionParameters_t* detectionParameters);

    Q_INVOKABLE void readModelParametersFromFile(QString parametersFile);
    Q_INVOKABLE void loadModelFilesFromFolder(QString folder){Q_UNUSED(folder)}
};
