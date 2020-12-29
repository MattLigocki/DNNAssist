import QtQuick 2.15
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtMultimedia 5.8
import QtGraphicalEffects 1.15
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12

import "qrc:/widgets" as Widgets

ColumnLayout{
    spacing: 5

    Widgets.FileLoader{
        fileText: "choose file"
        labelText: "Tensorflow pd File:"
        function onLoaded(){
            fileText=file
        }
        onFileChoosen: onLoaded
    }

    Widgets.FileLoader{
        fileText: "choose file"
        labelText: "Tensorflow pdTxt File:"
        function onLoaded(){
            fileText=file
        }
        onFileChoosen: onLoaded

    }

    ToolButton{
      id: runFilterButton
      Layout.alignment: Qt.AlignHCenter
      icon.source: "qrc:/img/res/close.png"
      icon.height: 20
      icon.width: 20

      text: qsTr("Launch choosen tensorflow model")
      font.family: "Helvetica"
      antialiasing: true
      contentItem:
      RowLayout{
        Image{
            source: "qrc:/img/res/play.png"
            sourceSize.height: 20
            sourceSize.width: 20
            opacity: 0.4
        }
        Text {
            text: runFilterButton.text
            font: runFilterButton.font
            opacity: enabled ? 1.0 : 0.9
            color: colorHelper.darkPasteBlue
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
      }

      onClicked: {
         //settingLayout.generateSeries()
      }
   }

    Item {
        Layout.fillHeight: true
    }
}
