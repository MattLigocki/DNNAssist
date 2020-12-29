import QtQuick 2.15
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtMultimedia 5.8
import QtGraphicalEffects 1.15
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12

import "qrc:/widgets" as Widgets

Pane{
    id: root
    property var frameworkName: "Torch"
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
            Layout.leftMargin: 20
            id: settings
            visible: expandingSectionButton.visibility
            opacity: visible?1:0
            Behavior on opacity {
                NumberAnimation{duration: 500}
            }


            Text {
                Layout.leftMargin: 20
                text: qsTr("Currently not available.")
                opacity: 0.4
            }
        }
    }
}
