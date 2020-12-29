import QtQuick 2.15
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtMultimedia 5.8
import QtGraphicalEffects 1.15
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12
import com.dnnassist.classes 1.0

Item {
    id: rootPanel

    property alias viewfinder: camera.viewfinder

    property var mediaUrl: ""
    property var mediaSource: "camera"
    property bool framevorkView: false
    onMediaSourceChanged: {
        videoFilter.mediaSource = mediaSource
    }

    property var urlMediaStatePlay

    function getCurrentVideoOutput(){

        if(mediaLoader.sourceComponent == cameraOutputComponent){
            return "camera"
        }
        else if(mediaLoader.sourceComponent == rstpOutputComponent)
        {
            return "rstp"
        }
    }

    function play(){
        //mediaLoader.visible = true

        switch(mediaSource)
        {

        case "image":
        case "link":
            mediaLoader.sourceComponent = imageOutputComponent
            //camera.stop()
            mediaPlayer.stop()
            mediaControls.visible = false
            break;

        case "video":
            mediaLoader.sourceComponent = rstpOutputComponent
            //camera.stop()
            mediaPlayer.play()
            mediaControls.visible = true
            break;
        case "camera":
            //camera.stop()
            mediaLoader.sourceComponent = cameraOutputComponent
            camera.start()
            mediaPlayer.stop()
            mediaControls.visible = false
            break;

        case "rstp":
            mediaLoader.sourceComponent = rstpOutputComponent
            //camera.stop()
            mediaPlayer.play()
            mediaControls.visible = false
            break;
        case "mediaStream":
            mediaLoader.sourceComponent = rstpOutputComponent
            //camera.stop()
            mediaPlayer.play()
            mediaControls.visible = true
            break;
        }
    }

    function stop(){
        camera.stop()
        mediaPlayer.stop()
    }

    state: "small"


    Camera{ id: camera}

    MediaPlayer {
       id: mediaPlayer
       source: rootPanel.mediaUrl
       muted: true
       autoPlay: false
    }

    Loader{
        id: mediaLoader
        anchors.fill: rootPanel
        sourceComponent: cameraOutputComponent
    }

    property int currentFrameNumber: 0

    Component{
        id: cameraOutputComponent
        VideoOutput{
            id: mediaOutput
            anchors.fill: mediaLoader
            source: camera
            autoOrientation: false
            filters: [videoFilter]
            DetectedItems{media: mediaOutput}

            Image {
                id: frame
                visible: rootPanel.framevorkView
                property int currentFrameNumber: 0
                source: "image://NwImageProvider/" + currentFrameNumber
                anchors.fill: mediaOutput
            }

            Connections {
                target: NwImageProvider
                onSignalNewFrameReady: {
                    frame.currentFrameNumber = frameNumber;
                }
            }
        }
    }

    Component{
        id: rstpOutputComponent

        VideoOutput{
            id: mediaOutput
            anchors.fill: mediaLoader
            source: mediaPlayer
            autoOrientation: false
            filters: [videoFilter]
            DetectedItems{media: mediaOutput}

            Image {
                id: frame
                visible: rootPanel.framevorkView
                property int currentFrameNumber: 0
                source: "image://NwImageProvider/" + currentFrameNumber
                anchors.fill: mediaOutput
            }

            Connections {
                target: NwImageProvider
                onSignalNewFrameReady: {
                    frame.currentFrameNumber = frameNumber;
                }
            }
        }
    }

    Component{
        id: imageOutputComponent
        Pane{
            Material.elevation: 6
            Material.background: Material.White
            onWidthChanged: mediaScreenController.setImageWidth(width)
            onHeightChanged: mediaScreenController.setImageHeigth(height)

            Image {
                id: imageFrame
                source: mainMediaPanel.mediaUrl
                sourceSize.height: parent.height
                sourceSize.width: parent.width

                anchors.fill: parent

                //DetectedItems{media: imageFrame}

                Image {
                    id: frame
                    visible: rootPanel.framevorkView
                    property int currentFrameNumber: 0
                    source: "image://NwImageProvider/" + currentFrameNumber
                    anchors.fill: imageFrame
                }

                Connections {
                    target: NwImageProvider
                    onSignalNewFrameReady: {
                        frame.currentFrameNumber = frameNumber;
                    }
                }
            }
        }
    }

    width: parent.width
    height: parent.height

    anchors{
        top: parent.top
    }

    Image{
        id: fulscreenButton
        anchors{
            top: rootPanel.top
            right: rootPanel.right
            margins: 10
        }

        sourceSize.width: 50
        sourceSize.height: 50
        visible: (rootPanel.state == "fullscreen" || rootPanel.state == "small" )

        source: "/img/res/round_fullscreen_white_48dp.png"
        MouseArea{
            anchors.fill: parent
            onClicked:
            {

                switch (rootPanel.state){

                    case "fullscreen":
                         fulscreenButton.state = "small"
                         rootPanel.state = "small"
                    break;
                    case "small":
                        rootPanel.state = "fullscreen"
                        fulscreenButton.state = "fullscreen"
                    break;

                }
           }
        }

        states: [
            State {
                name: "small"
                PropertyChanges {
                    target: fulscreenButton
                    source: "/img/res/round_fullscreen_white_48dp.png"
                }
            },
            State {
                name: "fullscreen"
                PropertyChanges {
                    target: fulscreenButton
                    source: "/img/res/round_close_fullscreen_white_48dp.png"
                }
            }
        ]
    }

    Label{
        text: "FPS: " + videoFilter.mediaFPS.toFixed(2)
        color: "white"
        anchors{
            top: fulscreenButton.bottom
            right: rootPanel.right
            margins: 10
        }
    }

    Rectangle{
         radius: 4
         color: "white"
         opacity:0.5
         height: 40
         id: mediaControls
         visible: false
         anchors{
             bottom: parent.bottom
             left: parent.left
             right: parent.right
             margins: 10
         }

         Image {
             width:height
             states: [
                 State {
                     name: "play"
                     PropertyChanges {
                         target: playButton
                         source: "/img/res/pause.png"
                     }
                 },
                 State {
                     name: "stop"
                     PropertyChanges {
                         target: playButton
                         source: "/img/res/stop.png"
                     }
                 },
                 State {
                     name: "pause"
                     PropertyChanges {
                         target: playButton
                         source: "/img/res/play.png"
                     }
                 }
             ]
             id: playButton
             state: "play"
             source: "/img/res/play.png"
             anchors{
                 top: parent.top
                 left: parent.left
                 bottom: parent.bottom
                 margins: 5
             }

             MouseArea{
                 anchors.fill:parent
                 onClicked: {

                     switch(playButton.state){
                     case "play":
                         mediaPlayer.pause()
                         playButton.state = "pause"
                         break;
                     case "stop":
                         mediaPlayer.play()
                         playButton.state = "stop"
                         break;
                     case "pause":
                         mediaPlayer.play()
                         playButton.state = "play"
                         break;
                     }
                 }
             }
         }

         Label{
             id: durationLabel
             text: {
                 return mediaScreenController.convertVideoTimeToTimeString(mediaPlayer.position)
                        +" / "+
                        mediaScreenController.convertVideoTimeToTimeString(mediaPlayer.duration)
             }
             anchors{
                 left: playButton.right
                 verticalCenter: parent.verticalCenter
                 margins: 5
             }
             onTextChanged: {
                 durationSLider.changeValue(mediaPlayer.position)
             }
         }

         Slider{
             anchors{
                 top: parent.top
                 left: durationLabel.right
                 right: parent.right
                 bottom: parent.bottom
                 margins: 5
             }

             function changeValue(value){
                 if(value!= durationSLider.value)
                      durationSLider.value = value;
             }

             onValueChanged: mediaPlayer.seek(value)

             id: durationSLider
             from: 0
             to: mediaPlayer.duration
         }
    }

    Behavior on height {
        NumberAnimation{duration: 300}
    }
    states: [
        State {
            name: "fullscreen"
            PropertyChanges {
                target: rootPanel
                height: application.height
                width: application.width

            }
        },
        State {
            name: "small"

            PropertyChanges {
                target: rootPanel
                height: application.height/2
                width: application.width/2
            }
        },
        State {
            name: "tile"

            PropertyChanges {
                target: rootPanel
                height: application.height/8
                width: application.width/8
            }
        },
        State {
            name: "hidden"

            PropertyChanges {
                target: rootPanel
                height: 0
                width: 0
            }
        }
    ]
}
