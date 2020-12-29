import QtQuick 2.15
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtMultimedia 5.8
import QtGraphicalEffects 1.15
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12

import "qrc:/widgets" as Widgets

ColumnLayout{
    id: root
    property var frameworkName: "Torch"
    RowLayout{
        Layout.fillWidth: true
        Image{
            id: imageLogo
            sourceSize.width: 50
            source: aiManager.getFrameworkObjectByName(frameworkName).iconSource
        }
        Widgets.TextLink{
            linkText: aiManager.getFrameworkObjectByName(frameworkName).frameworkRepoLink
        }
    }
    Widgets.SeparatorLine{}

    RowLayout{
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignHCenter
      Label {
          text: qsTr("Currently not available.")
          font.pixelSize: 25
          opacity: 0.4
      }
    }
}
