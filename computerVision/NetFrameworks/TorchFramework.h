#pragma once
#include "IDnnFrameworkBase.h"

class TorchFramework : public IDnnFrameworkBase {

    Q_OBJECT
public:
    TorchFramework(
        QCvDetectFilter* filter,
        detectionParameters_t* detectionParameters)
        : IDnnFrameworkBase(filter, detectionParameters,
                            "Torch",
                            "http://torch.ch",
                            "qrc:/img/res/Torch.png",
                            "*.t7","N/A"){}
};
