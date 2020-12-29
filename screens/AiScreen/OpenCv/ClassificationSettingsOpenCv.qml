import QtQuick 2.15
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtMultimedia 5.8
import QtGraphicalEffects 1.15
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12
import com.dnnassist.classes 1.0
import Qt.labs.platform 1.1

import "qrc:/widgets" as Widgets



Pane{
    id: root
    property var frameworkName: "OpenCv"
    property var frameworkObj: aiManager.getFrameworkObjectByName(root.frameworkName)
    Material.elevation: 1
    Material.background: Material.White
    Layout.fillWidth: true

    ColumnLayout{
        anchors.fill:parent
        Widgets.ExpandingSectionButton{
            id: expandingSectionButton
            imageLogoSource: frameworkObj.iconSource
            text: frameworkObj.name
        }

        ColumnLayout{
            spacing: 0
            Layout.leftMargin: 20
            visible: expandingSectionButton.visibility
            opacity: visible?1:0
            Behavior on opacity {
                NumberAnimation{duration: 500}
            }

            RowLayout{
                Layout.leftMargin: -10

                CheckBox{
                    checked: false
                    text: "Detection active"
                    onCheckStateChanged:
                    {
                        frameworkObj.isActive = checked
                        videoFilter.clearDetectedItems();
                    }
                }

                 CheckBox{
                     Layout.leftMargin: -10
                     checked: false
                     text: "Use gray scale conversion"
                     onCheckStateChanged:
                     {
                         videoFilter.useGrayScale = checked
                     }
                 }
            }
             RowLayout{
                 Label{
                     text: "Confidence lvl: "+ confidenceSlider.value.toFixed(2)
                 }
                 Slider{
                     id: confidenceSlider
                     Layout.fillWidth: true
                     value: 0
                     from: 0
                     to: 5
                     onValueChanged: {
                         videoFilter.detectConfidenceLevel = value.toFixed(2)
                     }
                 }
             }

             RowLayout{
                 Text {
                     text: qsTr("Current classifier: ")
                 }
                 ClassifiersChooser{
                     frameworkName: root.frameworkName
                 }
             }

             RowLayout{
                 Text {
                     text: qsTr("Classifier folder: ")
                 }
                 Widgets.FolderLoader{
                     id: classifiersLoader
                     labelText:folder
                     Layout.fillWidth: true
                     function onLoaded(){
                         frameworkObj.setClassifiersDirectory(folder);
                         console.log(folder)
                     }
                     onFolderChoosen: onLoaded
                 }
             }
        }
    }
}




