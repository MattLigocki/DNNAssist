import QtQuick 2.15
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtMultimedia 5.8
import QtGraphicalEffects 1.15
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12

import "qrc:/widgets" as Widgets
import "qrc:/screens/AiScreen/FrameworksCommons" as FrameworksCommons

Pane{
    id: root
    property var frameworkName: "Darknet"
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

        FrameworksCommons.DnnFrameworkDetectionSettings{
            Layout.fillWidth: true
            visible: expandingSectionButton.visibility
            opacity: visible?1:0
            Behavior on opacity {
                NumberAnimation{duration: 500}
            }

//            property var sampleDir: {
//                if(Qt.platform.os === "linux" ){
//                    var dir = fileSystemHandler.cdUp(fileSystemHandler.getCurrentPath())
//                    dir = fileSystemHandler.cdUp(dir)
//                    return "file:////"+dir+"/examples/models/yolo/"
//                }else if(Qt.platform.os === "windows" ){
//                    return "file:///D:/work/programming/AI/yolo/"
//                }
//            }
//            modelConfigurationUrl:sampleDir+"yolov3.cfg"
//            modelWeightsUrl: sampleDir+"yolov3.weights"
//            modelClassNamesUrl: sampleDir+"coco.names"
//            pipelineNamesUrl: sampleDir+"pipeline.config"

            frameworkName: root.frameworkName
        }
    }
}
