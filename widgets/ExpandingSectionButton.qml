import QtQuick 2.15
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtMultimedia 5.8
import QtGraphicalEffects 1.15
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12

import "qrc:/widgets" as Widgets

RowLayout{
    id: root

    property alias imageLogoSource: imageLogo.source
    property alias text : text.text
    property var visibility: false

    function onClick(){
        visibility = !visibility;
        image.rotation = image.rotation===180?-90:180
    }

    Image{
        id: image
        source: "qrc:/img/res/left-arrow.png"
        sourceSize.width: 15
        rotation: 180
        Behavior on rotation{
            NumberAnimation { duration: 50}
        }
        MouseArea{
            anchors.fill: parent
            onClicked: root.onClick()
        }
    }

    Text {
        id: text
        font.pixelSize: 18
        clip: true
        color: "#7a7a7a"

        MouseArea{
            anchors.fill: parent
            onClicked: root.onClick()
        }
    }

    Item{
        Layout.fillWidth: true
        Layout.fillHeight: true
        MouseArea{
            anchors.fill: parent
            onClicked: root.onClick()
        }
    }

    Image{
        id: imageLogo
        sourceSize.width: 20
        Behavior on rotation{
            NumberAnimation { duration: 50}
        }

        MouseArea{
            anchors.fill: parent
            onClicked: root.onClick()
        }
    }
}
