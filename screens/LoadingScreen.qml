import QtQuick 2.15
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.15
import QtQuick.Window 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12

Item {

    id: root
   MouseArea{
        anchors.fill: parent
        onClicked: clickToStartLabel.state = "animated"

    Rectangle {
        id: background
        anchors.fill: parent
        anchors.margins: 10
        color: "#B2D9EA" //pastel blue


        RadialGradient {

               anchors.fill: parent
               gradient: Gradient {
                   GradientStop { position: 0.0; color: "white" }
                   GradientStop { position: 0.5; color: "transparent" }
               }
           }

        Image{
            id: shutterImage
            anchors.verticalCenter: parent.verticalCenter
            height: root.height-200
            width: height
            x: 50
            source: "/img/res/loadingShutter.png"
            RotationAnimator {
                target: shutterImage;
                from: 0;
                to: 360;
                duration: 20000
                loops: Animation.Infinite
                running: true
            }
        }

        Text {
            id: clickToStartLabel
            anchors{
                verticalCenter: shutterImage.verticalCenter
                left: shutterImage.right
            }
            color: "#F4DCD6"
            font.pixelSize: 80
            text: "DNNAssist"
            state: "idle"

            SequentialAnimation {
                id: textAnimation
                running: false

                PropertyAnimation { target: clickToStartLabel; property: "color"; to: "#DFC7C1"; duration: 400;}
                NumberAnimation { target: clickToStartLabel; property: "opacity"; to: 0; duration: 200 ; }
                NumberAnimation { target: shutterImage;property: "x";to: root.width*0.5-shutterImage.width*0.5; duration: 500;}
                NumberAnimation { target: shutterImage; property: "opacity"; to: 0; duration: 400 ;}
                onRunningChanged: {
                    if(running == false){
                        stackView.replace(mediaScreen)
                    }
                }
            }

            states: [
                State {
                    name: "idle"
                    PropertyChanges {
                        target: textAnimation
                        running: false
                    }
                },
                State {
                    name: "animated"
                    PropertyChanges {
                        target: textAnimation
                        running: true
                    }
                }]
            }
        }
    }
}
