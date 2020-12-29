#pragma once
#include "IDnnFrameworkBase.h"

class CaffeFramework : public IDnnFrameworkBase {

    Q_OBJECT
public:
    CaffeFramework(
        QCvDetectFilter* filter,
        detectionParameters_t* detectionParameters);

    Q_INVOKABLE void readModelParametersFromFile(QString parametersFile);
    Q_INVOKABLE void loadModelFilesFromFolder(QString folder);
};
