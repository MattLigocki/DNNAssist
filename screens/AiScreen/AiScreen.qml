import QtQuick 2.15
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtMultimedia 5.8
import QtGraphicalEffects 1.15
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12

import "qrc:/widgets" as Widgets

import "qrc:/screens/AiScreen/OpenCv" as OpenCv
import "qrc:/screens/AiScreen/Tensorflow" as Tensorflow
import "qrc:/screens/AiScreen/Caffe" as Caffe
import "qrc:/screens/AiScreen/ONNX" as ONNX
import "qrc:/screens/AiScreen/DarkNet" as DarkNet
import "qrc:/screens/AiScreen/Torch" as Torch

Item {
    Component.onCompleted: {
        mainMediaPanel.state = "small"
    }

    Widgets.ColorHelper{id: colorHelper}
    Rectangle {
        id: background
        anchors.fill: parent
        color: colorHelper.darkPasteBlue
        RadialGradient {
           anchors.fill: parent
           gradient: Gradient {
               GradientStop { position: 0.0; color: "white" }
               GradientStop { position: 0.5; color: "transparent" }
           }
       }
    }

    Item
    {
        id: mediaPanel
        anchors{
            top: parent.top
            left: parent.left
        }
        height: mainMediaPanel.height
        width: mainMediaPanel.width

        OpacityMask {
                anchors.fill: mediaPanel
                source: mainMediaPanel
                maskSource: background
        }
    }

    Pane{
        id: configPane
        anchors{
            left: mediaPanel.right
            top: parent.top
            right: parent.right
            bottom: parent.bottom
            rightMargin: 5
            bottomMargin: 5
            leftMargin: 5
        }
        Material.elevation: 6
        Material.background: Material.White

        Flickable{
            clip: true
            anchors.fill: parent
            contentHeight: settingsLayout.implicitHeight
            ColumnLayout{
                id: settingsLayout
                anchors.fill: parent
                spacing: 0
                anchors.margins: 1          

                //Common
                AiCommonSettings{}

                //ProcessingFrameworks
                Label{
                    Layout.topMargin: 30
                    opacity: 0.4
                    text: "CURRENT MEDIA PROCESSING FRAMEWORK:"
                }

                Component{
                    id: openCvFrameworkSettings
                    OpenCv.OpenCvFrameworkSettings{}
                }
                Component{
                    id: darknetrameworkSettings
                    DarkNet.DarknetFrameworkSettings{}
                }

                Loader{
                    Layout.fillWidth: true
                    id: frameworkSettingsLoader
                    sourceComponent: openCvFrameworkSettings
                }

                //Models
                Label{
                    Layout.topMargin: 30
                    opacity: 0.4
                    text: "AVAILABLE MEDIA PROCESSING MODELS:"
                }
                OpenCv.ClassificationSettingsOpenCv{
                    visible: videoFilter.usedFramework==="OpenCv"
                    opacity: visible?1:0
                    Behavior on opacity {
                        NumberAnimation{duration: 500}
                    }
                }

                Tensorflow.ClassificationSettingsTensorflow{}
                DarkNet.ClassificationSettingsDarknet{}
                Caffe.ClassificatoinSettingsCaffe{}
            }
        }
    }

    Pane{
        id: statsPane
        anchors{
            left: parent.left
            top: mediaPanel.bottom
            right: mediaPanel.right
            bottom: parent.bottom
            bottomMargin: 5
            topMargin: 5
        }
        Material.elevation: 6
        Material.background: Material.White

        Flickable{
            clip: true
            anchors.fill: parent
            contentHeight: settingsLayout.implicitHeight
            ColumnLayout{
                id: statsLayout
                anchors.fill: parent
                RowLayout{
                    Image {
                        sourceSize.width: 40
                        source: "qrc:/img/res/showchart_black.png"
                    }
                    Text {
                        font.pixelSize: 15
                        text: qsTr("Objects detection statistics")
                        opacity: 0.6
                    }
                }


                Widgets.SeparatorLine{Layout.fillWidth: true}

                ColumnLayout{
                    spacing: 5
                    Label{
                        id: detectedObjectsCount
                        text: "Detected objects: " + videoFilter.amountOfDetectedItems
                    }
                    Label{
                        text: "Detection time  : "+videoFilter.detectionTime + " ms"
                    }
                }

                Item {
                    Layout.fillHeight: true
                }
            }
        }
    }
}
