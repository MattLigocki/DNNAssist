import QtQuick 2.15
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtMultimedia 5.8
import QtGraphicalEffects 1.15
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12

import "qrc:/widgets" as Widgets

Item {
    Component.onCompleted: {
        mainMediaPanel.state = "hidden"
    }

    Widgets.ColorHelper{id: colorHelper}
    Rectangle {
        id: background
        anchors.fill: parent
        color: colorHelper.lightPasteBlue
        RadialGradient {
               anchors.fill: parent
               gradient: Gradient {
                   GradientStop { position: 0.0; color: "white" }
                   GradientStop { position: 0.5; color: "transparent" }
               }
           }
    }

    Pane{
        id: configPane
        anchors{
            left: mediaPanel.right
            top: parent.top
            right: parent.right
            bottom: parent.bottom
            margins: 5
        }
        anchors.fill: parent
        Material.elevation: 6
        Material.background: Material.White

        AiGymFrameworkChooser{
            id: aiGymFrameworkChooser
            anchors.fill: parent
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
                maskSource: configPane
            }
    }
}
