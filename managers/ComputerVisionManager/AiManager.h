#pragma once

#include <utils/PropertyHelpers.h>
#include "models/ObjectListModel.h"
#include <utils/Common.h>

#include "computerVision/NetFrameworks/DarknetFramework.h"
#include "computerVision/NetFrameworks/DarknetFramework.h"
#include "computerVision/NetFrameworks/TensorflowFramework.h"
#include "computerVision/NetFrameworks/TorchFramework.h"
#include "computerVision/NetFrameworks/ONNXFramework.h"
#include "computerVision/NetFrameworks/OpenCvFramework.h"
#include "computerVision/NetFrameworks/CaffeFramework.h"
#include "computerVision/NetFrameworks/DLDTFramework.h"

class AiManager : public QObject
{
    Q_OBJECT
    AUTO_PROPERTY(ObjectListModel *, neuralNetworkFrameworks, neuralNetworkFrameworks,setNeuralNetworkFrameworks, neuralNetworkFrameworksChanged)

    explicit AiManager(QObject *parent = nullptr);
    ~AiManager() = default;

public:
    static AiManager& getInstance();

    template<typename T, typename Y>
    void initializeNeuralNetworksFrameworks(T* filter, Y* detectionParameters);

    Q_INVOKABLE QObject* getFrameworkObjectByName(QString name);
    Q_INVOKABLE void processImageByFrameworks(QImage image);
};

template<typename T, typename Y>
void AiManager::initializeNeuralNetworksFrameworks(T* filter, Y* detectionParameters)
{
    m_neuralNetworkFrameworks->append(new OpenCvFramework(filter, detectionParameters));
    m_neuralNetworkFrameworks->append(new TensorflowFramework(filter, detectionParameters));
    m_neuralNetworkFrameworks->append(new CaffeFramework(filter, detectionParameters));
    m_neuralNetworkFrameworks->append(new DarknetFramework(filter, detectionParameters));
    m_neuralNetworkFrameworks->append(new TorchFramework(filter, detectionParameters));
    m_neuralNetworkFrameworks->append(new ONNXFramework(filter, detectionParameters));
    m_neuralNetworkFrameworks->append(new DLDTFramework(filter, detectionParameters));
}
