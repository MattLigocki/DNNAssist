import QtQuick 2.15
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtMultimedia 5.8
import QtGraphicalEffects 1.15
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12

import "qrc:/widgets" as Widgets

ColumnLayout{
    Widgets.SeparatorLine{}

    RowLayout{
        Layout.leftMargin: -10
        CheckBox{
            id: detectionActiveCheckbox
            checkable: {
                return fileSystemHandler.validateUrl(modelConfigurationUrl)&&
                        fileSystemHandler.validateUrl(modelWeightsUrl)?true:false
            }
            checked: frameworkObj.isActive
            text: "Detection active"
            onCheckStateChanged:
            {
                if(checked && !frameworkObj.isActive){
                    frameworkObj.modelConfigurationUrl = modelConfigurationUrl
                    frameworkObj.modelWeightsUrl = modelWeightsUrl
                    frameworkObj.modelClassNamesUrl = modelClassNamesUrl                    

                    frameworkObj.confidenceThreshold = confidenceSlider.value.toFixed(2)
                    frameworkObj.reloadDnnFramework(frameworkObj.name)
                }else{
                    mainMediaPanel.framevorkView = false
                    frameworkObj.qtVision = false
                    frameworkObj.frameworkVision = false
                }

                frameworkObj.isActive = checked
                videoFilter.clearDetectedItems();
            }
        }

        CheckBox{
            id: useGPUCheckbox
            text: qsTr("Use GPU")
            checked: frameworkObj.useGPU
            onCheckedChanged: {
                frameworkObj.useGPU = checked
            }
        }

        CheckBox{
            text: qsTr("Detection in separate thread")
            checked: true
            onCheckedChanged: {
                frameworkObj.separateThreadDetection= checked
            }
        }

    }
    RowLayout{
        Layout.leftMargin: -10

        Switch{
            text: "Qt vision"
            checked: frameworkObj.qtVision
            onVisualPositionChanged:
            {
                frameworkObj.qtVision = visualPosition === 1.0 ? true:false
            }
        }
        Switch{
            checked: frameworkObj.frameworkVision
            text: "Framework vision"
            onVisualPositionChanged:
            {
                mainMediaPanel.framevorkView = visualPosition === 1.0 ? true:false
                frameworkObj.frameworkVision = visualPosition === 1.0 ? true:false
            }
        }

        Switch{
            text: "Display mask"
            visible: frameworkObj.frameworkVision && frameworkObj.displayMask>0
            checked: frameworkObj.displayMask === 2
            onVisualPositionChanged:
            {
               if(visualPosition === 1.0 )
                   frameworkObj.displayMask = 2
               else
                   frameworkObj.displayMask = 1
            }
        }

       Item{
            Layout.fillWidth: true
        }
    }

    RowLayout{
        Label{
            text: "Confidence threshold: "+ (confidenceSlider.value.toFixed(2)*100) + "%"
        }
        Slider{
            id: confidenceSlider
            Layout.fillWidth: true
            value: frameworkObj.confidenceThreshold
            from: 0.01
            to: 1
            onValueChanged: {
                frameworkObj.confidenceThreshold = value.toFixed(2)
            }
        }
    }
}

