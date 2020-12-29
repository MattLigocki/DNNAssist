import QtQuick 2.15
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtMultimedia 5.8
import QtGraphicalEffects 1.15
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12

import "qrc:/widgets" as Widgets
import "qrc:/screens/AiGymScreen/OpenCv" as AiGymOpenCv
import "qrc:/screens/AiGymScreen/Tensorflow" as AiGymTensorflow
import "qrc:/screens/AiGymScreen/Caffe" as AiGymCaffe
import "qrc:/screens/AiGymScreen/ONNX" as AiGymONNX
import "qrc:/screens/AiGymScreen/DarkNet" as AiGymDarkNet
import "qrc:/screens/AiGymScreen/Torch" as AiGymTorch

ColumnLayout{
    id: root
    spacing: 5

    Component {
        id: aiGymOpenCv
            AiGymOpenCv.AiGymOpenCv{
                anchors.margins: 5
            }
        }

    Component {
        id: aiGymTensorflow
            AiGymTensorflow.AiGymTensorflow{
                anchors.margins: 5
            }
        }

    Component {
        id: aiGymCaffe
            AiGymCaffe.AiGymCaffe{
                anchors.margins: 5
            }
        }

    Component {
        id: aiGymONNX
            AiGymONNX.AiGymONNX{
                anchors.margins: 5
            }
        }

    Component {
        id: aiGymDarkNet
            AiGymDarkNet.AiGymDarknet{
                anchors.margins: 5
            }
        }

    Component {
        id: aiGymTorch
            AiGymTorch.AiGymTorch{
                anchors.margins: 5
            }
        }

    function navigateToItem(item){
        switch(item){
            case "opencv":
                if(aiGymFrameworkStackView.currentItem !== aiGymOpenCv)
                    aiGymFrameworkStackView.replace(aiGymOpenCv)
                break;
            case "tensorflow":
                if(aiGymFrameworkStackView.currentItem !== aiGymTensorflow)
                    aiGymFrameworkStackView.replace(aiGymTensorflow)
                break;
            case "caffe":
                if(aiGymFrameworkStackView.currentItem !== aiGymCaffe)
                    aiGymFrameworkStackView.replace(aiGymCaffe)
                break;
            case "torch":
                if(aiGymFrameworkStackView.currentItem !== aiGymTorch)
                    aiGymFrameworkStackView.replace(aiGymTorch)
                break;
            case "darknet":
                if(aiGymFrameworkStackView.currentItem !== aiGymDarkNet)
                    aiGymFrameworkStackView.replace(aiGymDarkNet)
                break;
            case "onnx":
                if(aiGymFrameworkStackView.currentItem !== aiGymONNX)
                    aiGymFrameworkStackView.replace(aiGymONNX)
                break;
        }
    }

    ComboBox{
        id: combo
        Layout.fillWidth: true

        model: aiManager.neuralNetworkFrameworks

        displayText: aiManager.neuralNetworkFrameworks.at(0).name
        delegate:
            Item{
                height: 20
                width: combo.width
                RowLayout{
                    Image {
                        sourceSize.height:15
                        source: aiManager.neuralNetworkFrameworks.at(index).iconSource
                    }
                    Label
                    {
                        id: frameworkName
                        Layout.alignment: Qt.AlignLeft
                        text: aiManager.neuralNetworkFrameworks.at(index).name
                        font.pixelSize: 15
                    }
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        combo.displayText = frameworkName.text
                        root.navigateToItem(frameworkName.text.toLowerCase())
                        combo.popup.close()
                    }
                }
            }
    }

    Flickable{
        clip: true
        Layout.fillHeight: true
        Layout.fillWidth: true
        contentHeight: implicitHeight
        StackView {
           id: aiGymFrameworkStackView

           anchors.fill: parent
           initialItem: aiGymOpenCv

           replaceEnter: Transition {
               PropertyAnimation {
                   property: "opacity"
                   from: 0
                   to:1
                   duration: 250
                   easing.type: Easing.OutQuad
               }
           }
           replaceExit: Transition {
               PropertyAnimation {
                   property: "opacity"
                   from: 1
                   to:0
                   duration: 250
                   easing.type: Easing.InQuad
               }
           }
        }
    }
    Widgets.SeparatorLine{}
}
