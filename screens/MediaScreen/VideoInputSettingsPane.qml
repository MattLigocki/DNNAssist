import QtQuick 2.15
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtMultimedia 5.8
import QtGraphicalEffects 1.15
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12

import "qrc:/models" as Models
import "qrc:/widgets" as Widgets
Item {
    id: root
    property var mediaSource: mainMediaPanel.mediaSource

    onMediaSourceChanged: {
        switch(mediaSource)
        {
        case "camera":
            videoPropertiesLoader.sourceComponent = cameraComponent
            break;
        case "rstp":
            videoPropertiesLoader.sourceComponent = rstpComponent
            break;
        }
    }


    Pane{
        anchors.fill: parent
        Material.elevation: 6
        Material.background: Material.White
    }
    Flickable{
        clip: true
        anchors.fill: parent
        contentHeight: layout.implicitHeight
        ColumnLayout{
            id: layout
            anchors.fill: parent
            anchors.margins: 5
            spacing: 5

            RowLayout{
                Image {
                    sourceSize.width: 40
                    source: "qrc:/img/res/loadingShutter.png"
                }
                Text {
                    font.pixelSize: 15
                    text: qsTr( "Properties "+root.mediaSource)
                    opacity: 0.6
                }
            }

            Widgets.SeparatorLine{}

            Loader{
                id: videoPropertiesLoader
                sourceComponent:  cameraComponent
            }

            Item{
                Layout.fillHeight: true
            }

            Component{
                id: cameraComponent
                ColumnLayout{
                    Item{
                        Layout.leftMargin: 5
                        Label{
                            text:"Resolution: "+ mainMediaPanel.viewfinder.resolution.width+ "x"+ mainMediaPanel.viewfinder.resolution.height
                        }
                    }
                }
            }

            Component{
                id: rstpComponent
                ColumnLayout{
                    Item{
                        Layout.leftMargin: 5
                        Label{
                            text:"RSTP properties"
                        }
                    }
                }
            }

            Component{
                id: mediaStreamComponent
                ColumnLayout{
                    Item{
                        Layout.leftMargin: 5
                        Label{
                            text:"Youtube stream properties"
                        }
                    }
                }
            }
        }
    }
}

//            Models.CameraExposuresModel{ id: exposureModel }
//            ComboBox{
//                Layout.fillWidth: true
//                Material.accent: Material.Orange
//                Material.foreground: Material.BlueGrey
//                model: exposureModel
//                textRole: "name"
//                onCurrentIndexChanged: {
//                    console.debug(exposureModel.get(currentIndex).name)
//                    camera.exposure.setExposureMode(exposureModel.getCameraExposure(exposureModel.get(currentIndex).name))
//               }
//            }


