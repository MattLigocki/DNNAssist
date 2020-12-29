import QtQuick 2.15
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtMultimedia 5.8
import QtGraphicalEffects 1.15
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12
import com.dnnassist.classes 1.0
import Qt.labs.platform 1.1
//import "qrc:/widgets" as Widgets


RowLayout{
    property alias fileText: fileEditText.text
    property alias labelText: label.text
    property alias file: fileDialog.file
    property alias nameFilters: fileDialog.nameFilters
    property alias moreButtonVisibility: moreButton.visible
    property var onFileChoosen
    property var onEnterPressed

    id: root
    spacing: 5
    Label{
        id: label
    }

    TextInput{
        height:moreButton.height
        id: fileEditText
        clip: true
        Layout.fillWidth: true
        font.pixelSize: 15

        Rectangle{
            opacity: 0.2
            anchors.fill: parent
            border.color: "gray"
            color: "lightgray"
        }
        Keys.onEnterPressed: {
            root.onEnterPressed()
        }
    }
    ToolButton{
        id: moreButton
        icon.source: "/img/res/moreVert.png"
        Material.background: Material.BlueGrey
        onClicked: fileDialog.open()
    }

    FileDialog{
        id:fileDialog
        folder: "StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]"
        onAccepted: root.onFileChoosen(file)
    }
}



