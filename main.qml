import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.15
import QtMultimedia 5.8
import QtQuick.Controls.Material 2.12
import com.dnnassist.classes 1.0

import "qrc:/screens" as Screens

import "qrc:/screens/AiScreen" as AiScreen
import "qrc:/screens/AiGymScreen" as AiGymScreen
import "qrc:/screens/DataScreen" as DataScreen
import "qrc:/screens/MediaScreen" as MediaScreen
import "qrc:/screens/StatisticsScreen" as StatisticsScreen
import "qrc:/widgets" as Widgets

ApplicationWindow {
    id: application

    property color detectionRectanglesColor: "white"
    Material.theme: Material.Light
    Material.accent: Material.Red

    visible: true
    property double screenFactor: 0.7
    width: Screen.width * screenFactor
    height: Screen.height * screenFactor

    MediaScreen.MediaOutputPane{
        id: mainMediaPanel
        visible: false
        anchors{
            top: parent.top
            left: parent.left
        }
        height: parent.height
        width: parent.width
    }

    CvDetectFilter{
        id: videoFilter
     }
    FileSystemHandler{
        id: fileSystemHandler
    }

    Timer {
        id: loadImageTimer
        property var url;
        interval: 1000; running: false; repeat: true
        onTriggered: {
            httpManager.processNetworkImage(url)
        }
    }

    Component {
        id: mediaScreen
            MediaScreen.MediaScreen{
                anchors.margins: 5
            }
        }
    Component {
        id: dataScreen
            DataScreen.DataScreen{
                anchors.margins: 5
            }
        }
    Component {
        id: statisticsScreen
            StatisticsScreen.StatisticsScreen{
                anchors.margins: 5
            }
        }
    Component {
        id: aiGymScreen
            AiGymScreen.AiGymScreen{
                anchors.margins: 5
            }
        }
    Component {
        id:  aiScreen
            AiScreen.AiScreen{

                anchors.margins: 5
            }
        }
    Component {
        id: loadingScreen
        Screens.LoadingScreen{}
    }

    StackView {

       id: stackView
       anchors.fill: parent
       initialItem: loadingScreen

       replaceEnter: Transition {
           PropertyAnimation {
               property: "opacity"
               from: 0
               to:1
               duration: 1000
               easing.type: Easing.OutQuad
           }
       }
       replaceExit: Transition {
           PropertyAnimation {
               property: "opacity"
               from: 1
               to:0
               duration: 400
               easing.type: Easing.InQuad
           }
       }
   }

    footer:

        Widgets.MenuTapBar{
        id: footer
        visible: false
    }
}
