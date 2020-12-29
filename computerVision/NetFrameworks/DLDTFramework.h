#pragma once
#include "IDnnFrameworkBase.h"

class DLDTFramework : public IDnnFrameworkBase{

    Q_OBJECT
public:
    DLDTFramework(QCvDetectFilter* filter,
                        detectionParameters_t* detectionParameters)
        : IDnnFrameworkBase(filter, detectionParameters,
                            "DLDT",
                            "https://software.intel.com/openvino-toolkit",
                            "qrc:/img/res/DLDT.png",
                            "*.bin","*.xml"){}
};
