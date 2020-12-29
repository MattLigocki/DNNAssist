#pragma once
#include "IDnnFrameworkBase.h"

class TensorflowFramework : public IDnnFrameworkBase{

    Q_OBJECT
public:
    TensorflowFramework(QCvDetectFilter* filter,
                        detectionParameters_t* detectionParameters);

    /**
     * @brief writeTextGraph
     * In case lack of a .pbtxt it will be created at given url
     */
    Q_INVOKABLE void writeTextGraph();
    Q_INVOKABLE void readModelParametersFromFile(QString parametersFile);
    Q_INVOKABLE void loadModelFilesFromFolder(QString folder){Q_UNUSED(folder)}
};

