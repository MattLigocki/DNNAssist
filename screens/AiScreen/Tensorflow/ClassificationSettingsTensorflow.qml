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
    property var frameworkName: "Tensorflow"
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

            property var sampleDir: {
                var dir = fileSystemHandler.cdUp(fileSystemHandler.getCurrentPath())
                dir = fileSystemHandler.cdUp(dir)
                if(Qt.platform.os === "linux" ){
                    return "file://"+dir+"/examples/models/tensorflow/mask_rcnn_inception_v2_coco_2018_01_28/"
                }else if(Qt.platform.os === "windows" ){
                    return "file:///d:/work/programming/projects/qt/OpenCvCamera/examples/models/Face_detection/"
                }
            }
            modelConfigurationUrl:sampleDir+"mask_rcnn_inception_v2_coco_2018_01_28.pbtxt"
            modelWeightsUrl: sampleDir+"frozen_inference_graph.pb"
            modelClassNamesUrl: sampleDir+"coco.names"
            pipelineNamesUrl: sampleDir+"pipeline.config"

            frameworkName: root.frameworkName
        }
    }
}
