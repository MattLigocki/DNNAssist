import QtQuick 2.15
import QtQuick.Controls 1.4
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtMultimedia 5.8
import QtGraphicalEffects 1.15
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12
import QtQml.Models 2.2

import "qrc:/widgets" as Widgets

Item {
        Widgets.ColorHelper{id: colorHelper}
        Rectangle {
            anchors.fill: parent
            color: colorHelper.lightPasteOrange
            RadialGradient {
                   anchors.fill: parent
                   gradient: Gradient {
                       GradientStop { position: 0.0; color: "white" }
                       GradientStop { position: 0.5; color: "transparent" }
                   }
               }
        }

        SplitView{
            anchors.fill: parent
            anchors.margins: 5
            Pane{
                Material.elevation: 6
                Material.background: Material.White
                TreeView{
                    id: galleryFilebrowserTreeView
                    property var selectedUrl: ""
                    model: dataSetsScreenController.fileSystemModel
                    anchors.fill: parent


                    TableViewColumn {
                        title: "Name"
                        role: "fileName"
                        resizable: true
                    }
                    onActivated: selectedUrl = dataSetsScreenController.fileSystemModel.data(index, dataSetsScreenController.getDirectoryRole())
                }
            }

//            Pane{
//                Material.elevation: 6
//                Material.background: Material.White

//                Widgets.GalleryWidget{
//                    anchors.fill:parent
//                    selectedUrl: galleryFilebrowserTreeView.selectedUrl
//                }
//            }

        }


}
