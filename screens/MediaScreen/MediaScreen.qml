import QtQuick 2.15
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtMultimedia 5.8
import QtGraphicalEffects 1.15
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12
import com.dnnassist.classes 1.0

import "qrc:/widgets" as Widgets

Item {
    id: cameraScreenItem

    Component.onCompleted: {
        footer.visible = true
        mainMediaPanel.visible = true
        mainMediaPanel.state = "small"
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#F4DCD6" //pastel orange
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

    VideoInputSelectPane{
       id: cameraSelectorWidget
       anchors{
           top: parent.top
           bottom: parent.bottom
           right: parent.right
           left: mediaPanel.right

           leftMargin: 5
           bottomMargin: 5
       }
   }

   VideoInputSettingsPane{
       id: videoPropertiesPanel
       anchors{
           top: mediaPanel.bottom
           left: parent.left
           right: mediaPanel.right
           bottom: parent.bottom

           topMargin: 5
           bottomMargin: 5
       }
   }
}




