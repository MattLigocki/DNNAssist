import QtQuick 2.15
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtMultimedia 5.8
import QtGraphicalEffects 1.15
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12

import "qrc:/widgets" as Widgets

ColumnLayout {
    property alias scaleFactorSlider: scaleFactorSlider.value

    Widgets.SeparatorLine{}

    RowLayout{

        Label{
            Layout.alignment: Qt.AlignRight
            text: "Loaded model name: "
        }
        Label{
            id: modelNameLabel
            Layout.alignment: Qt.AlignRight
            text: frameworkObj.currentModelName===frameworkName?"N/A" : frameworkObj.currentModelName
            color: colorHelper.darkPasteBlue
        }
    }

    Button{
        id: switchParametersFromFile
        text: "Read params from file"
        font.pixelSize: 10
        Layout.fillWidth: true
        onClicked: {
            frameworkObj.readModelParametersFromFile(modelLoader.pipelineNamesUrl)
            blobSizeCombobox.currentIndex= 1
        }
        Material.background: "white"
    }

    Widgets.SeparatorLine{}

    RowLayout{
        Layout.fillWidth: true

        Label{
            text: "DNN input blob size: "
        }
        ComboBox {
             id:  blobSizeCombobox
             model: ["Uniform", "Manual"]
             onAccepted: {
                scaleFactorSlider.value = scaleFactorSlider.value
            }
        }
    }

    RowLayout{
        visible: blobSizeCombobox.currentText === "Manual"
        opacity: visible?1:0
        Behavior on opacity {
            NumberAnimation{duration: 500}
        }
        Label{
            text: " Width: "
        }
        TextEdit{
            id: widthEditText
            text: frameworkObj.outBlobSize.x
            color: "gray"
            font.bold: true
            font.pixelSize: 15
        }
        Label{
            text: ", Height: "
        }
        TextEdit{
            id: heightEditText
            text: frameworkObj.outBlobSize.y
            color: "gray"
            font.bold: true
            font.pixelSize: 15
        }
        ToolButton{
          id: applyBlob
          text: qsTr("Apply blob output size")
          font.pixelSize: 15
          antialiasing: true
          contentItem:

              RowLayout{
                anchors.centerIn: parent
                Text {
                    text: applyMean.text
                    font: applyMean.font
                    opacity: enabled ? 1.0 : 0.9
                    color: "gray"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                Image{
                    source: "qrc:/img/res/round_check_black_48dp.png"
                    sourceSize.height: 20
                    sourceSize.width: 20
                    opacity: 0.4
                }

          }
          onClicked: {
              frameworkObj.outBlobSize = Qt.point(parseInt(widthEditText.text), parseInt(widthEditText.text))
          }
        }
    }

    RowLayout{
        visible: blobSizeCombobox.currentText === "Uniform"
        opacity: visible?1:0
        Behavior on opacity {
            NumberAnimation{duration: 500}
        }
        Label{
            text:
            {
                if(frameworkObj.outBlobSize.x === 2048){
                    return "Width: "+ "as frame" + ", Height: "+ "as frame"
                }else{
                    return "Width: "+ frameworkObj.outBlobSize.x + ", Height: "+frameworkObj.outBlobSize.x
                }
            }
        }
        Slider{
            id: blobSizeSlider
            Layout.fillWidth: true
            value:  Math.log2(frameworkObj.outBlobSize.x)
            from: 5
            to: 11
            stepSize: 1
            onValueChanged: {
                var v = Math.pow(2,value.toFixed(0))
                frameworkObj.outBlobSize = Qt.point(v,v)
            }
        }
    }

    Widgets.SeparatorLine{}

    RowLayout{
        id: scaleFactorSliderLayout
        Label{
            text: "Scale factor: "+ frameworkObj.scaleFactor.toFixed(8)
        }
        Slider{

            property var vale: frameworkObj.scaleFactor.toFixed(8)
            id: scaleFactorSlider
            Layout.fillWidth: true
            value: Math.log2(1.0/frameworkObj.scaleFactor)
            stepSize: 1
            from: 0
            to: 10
            onValueChanged: {
                frameworkObj.scaleFactor = 1/Math.pow(2,value.toFixed(0))
            }
        }
    }

    RowLayout{
        Label{
            text: "Mean R: "
        }
        TextEdit{
            id: meanR
            text: frameworkObj.meanR
            color: "gray"
            font.pixelSize: 15
            font.bold: true
        }
        Label{
            text: "|  G: "
        }
        TextEdit{
            id: meanG
            text: frameworkObj.meanG
            color: "gray"
            font.bold: true
            font.pixelSize: 15
        }
        Label{
            text: "|  B: "
        }
        TextEdit{
            id: meanB
            text: frameworkObj.meanB
            color: "gray"
            font.bold: true
            font.pixelSize: 15
        }
        ToolButton{
          id: applyMean
          opacity: visible?1:0
          Behavior on opacity {
              NumberAnimation{duration: 500}
          }

          text: qsTr("Apply")
          font.pixelSize: 15
          antialiasing: true
          contentItem:

              RowLayout{
                anchors.centerIn: parent
                Text {
                    text: applyMean.text
                    font: applyMean.font
                    opacity: enabled ? 1.0 : 0.9
                    color: "gray"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                Image{
                    source: "qrc:/img/res/round_check_black_48dp.png"
                    sourceSize.height: 20
                    sourceSize.width: 20
                    opacity: 0.4
                }

          }
          onClicked: {
              frameworkObj.meanR = meanR.text
              frameworkObj.meanG = meanG.text
              frameworkObj.meanB = meanB.text
          }
        }
    }
}
