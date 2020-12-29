#pragma once
#include "IDnnFrameworkBase.h"

class ONNXFramework : public IDnnFrameworkBase {

    Q_OBJECT
public:
    ONNXFramework(
        QCvDetectFilter* filter,
        detectionParameters_t* detectionParameters)
        : IDnnFrameworkBase(filter, detectionParameters,
                            "ONNX",
                            "https://onnx.ai/",
                            "qrc:/img/res/ONNX.png",
                            "*.onnx","N/A"){}
};

