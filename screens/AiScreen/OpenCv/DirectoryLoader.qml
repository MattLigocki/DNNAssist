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
    property alias directoryText: directoryEditText.text
    property alias labelText: label.text
    property alias folder: folderDialog.folder
    property var onDirectoryChoosen
    id: root
    spacing: 5
    Label{
        id: label
    }

    TextInput{
        height:moreButton.height
        id: directoryEditText 
        clip: true
        Layout.fillWidth: true

        Rectangle{
            objectName: "classifierDirecotryEditText"
            id: classifierDirecotryEditText
            anchors{
                topMargin: -5
                bottomMargin: -5
            }

            opacity: 0.2
            anchors.fill: parent
            border.color: "gray"
            color: "lightgray"

        }
    }
    ToolButton{
        id: moreButton
        icon.source: "/img/res/moreVert.png"
        Material.background: Material.BlueGrey
        onClicked: folderDialog.open()
    }


    FolderDialog {
        id: folderDialog
        folder: "StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]"
        onAccepted: root.onDirectoryChoosen(folder)
    }
}



