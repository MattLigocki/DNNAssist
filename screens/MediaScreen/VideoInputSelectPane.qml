import QtQuick 2.15
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtMultimedia 5.8
import QtGraphicalEffects 1.15
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12
import com.dnnassist.classes 1.0
import QtQuick.Controls.Styles 1.4

import "qrc:/models" as Models
import "qrc:/widgets" as Widgets
Item {
    Widgets.ColorHelper{id: colorHelper}
    FileSystemHandler{id: fileSystemHandler}
    Pane{
        id: root
        anchors.fill: parent

        Material.elevation: 6
        Material.background: Material.White

        function setMediaButtonState(playing){
            if(playing===false){
                mediaStateButton.icon.source = "qrc:/img/res/play.png"
                mediaStateButton.text = qsTr("Play media")
                mainMediaPanel.stop()

            }else{
                mediaStateButton.icon.source = "qrc:/img/res/stop.png"
                mediaStateButton.text = qsTr("Stop media")
                if(videoMediaSelectionRadiobutton_mediaSteam.checked){
                    mainMediaPanel.mediaUrl = httpManager.selectedYoutubeLink.processedUrl
                }
                mainMediaPanel.play()
            }
        }

        ColumnLayout{
            ButtonGroup { id: mediaSelectorRadioButtons }

            ColumnLayout {
                RowLayout{
                    opacity: 0.5
                    Image {
                        sourceSize.width: 40
                        source: "qrc:/img/res/round_computer_black_48dp.png"
                    }
                    Label{
                       text: "LOCAL MEDIA"
                    }
                }

                Widgets.SeparatorLine{}

                RowLayout{
                    Layout.leftMargin: 5
                    Image {
                        opacity: 0.5
                        sourceSize.width: 30
                        source: "qrc:/img/res/round_insert_photo_black_48dp.png"
                        MouseArea{
                            anchors.fill: parent
                            onClicked: videoMediaSelectionRadiobutton_localImage.checked = !videoMediaSelectionRadiobutton_localImage.checked
                        }
                    }
                    RadioButton {
                        id: videoMediaSelectionRadiobutton_localImage
                        ButtonGroup.group: mediaSelectorRadioButtons
                        text: qsTr("Image")
                        checked: mainMediaPanel.mediaSource === "image"
                        onCheckedChanged: {
                            if(checked){
                                loadImageTimer.start()
                                mediaStateButton.visible = false;
                                lastSeparatorLine.visible = false;
                            }
                            else{
                                loadImageTimer.stop()
                                mediaStateButton.visible = true;
                                lastSeparatorLine.visible = true;
                            }
                        }

                        onClicked: {
                            root.setMediaButtonState(false)

                            mainMediaPanel.mediaSource = "image"
                            mainMediaPanel.mediaUrl = imageLoader.fileText
                            loadImageTimer.url = imageLoader.fileText
                        }
                    }
                    Widgets.FileLoader{
                        id: imageLoader
                        labelText: ""
                        Layout.fillWidth: true
                        fileText:fileSystemHandler.getCurrentPath()
                        nameFilters: ["*.*"]
                        function onLoaded(){
                            fileText=file
                        }
                        function onEnterPressedFnc(){
                            videoMediaSelectionRadiobutton_localImage.clicked()
                            root.setMediaButtonState(true)
                        }
                        onFileChoosen: onLoaded
                        onEnterPressed: onEnterPressedFnc
                    }
                }

                RowLayout{
                    Layout.leftMargin: 5
                    Image {
                        opacity: 0.5
                        sourceSize.width: 30
                        source: "qrc:/img/res/round_local_movies_black_48dp.png"
                        MouseArea{
                            anchors.fill: parent
                            onClicked: videoMediaSelectionRadiobutton_localVideo.checked = !videoMediaSelectionRadiobutton_localVideo.checked
                        }
                    }
                    RadioButton {
                        id: videoMediaSelectionRadiobutton_localVideo
                        ButtonGroup.group: mediaSelectorRadioButtons
                        text: qsTr("Video ")
                        checked: mainMediaPanel.mediaSource === "video"
                        onClicked: {
                            root.setMediaButtonState(false)
                            mainMediaPanel.mediaSource = "video"
                            mainMediaPanel.mediaUrl = videoLoader.fileText
                        }
                    }
                    Widgets.FileLoader{
                        id: videoLoader
                        labelText: ""
                        fileText: fileSystemHandler.getCurrentPath()
                        Layout.fillWidth: true
                        nameFilters: ["*.*"]
                        function onLoaded(){
                            fileText=file
                        }
                        function onEnterPressedFnc(){
                            videoMediaSelectionRadiobutton_localVideo.clicked()
                            root.setMediaButtonState(true)
                        }
                        onFileChoosen: onLoaded
                        onEnterPressed: onEnterPressedFnc
                    }
                }
                RowLayout{
                    Layout.leftMargin: 5
                    Image {
                        opacity: 0.5
                        sourceSize.width: 30
                        source: "qrc:/img/res/camera_black.png"
                        MouseArea{
                            anchors.fill: parent
                            onClicked: videoMediaSelectionRadioButton_Camera.checked = !videoMediaSelectionRadioButton_Camera.checked
                        }
                    }
                    RadioButton {
                        id: videoMediaSelectionRadioButton_Camera
                        ButtonGroup.group: mediaSelectorRadioButtons
                        text: qsTr("Device camera")
                        checked: mainMediaPanel.mediaSource === "camera"
                        onClicked: {
                            root.setMediaButtonState(false)
                            mainMediaPanel.mediaSource = "camera"
                        }
                    }
                    ComboBox{
                        Material.accent: Material.Orange
                        Material.foreground: Material.BlueGrey
                        model: QtMultimedia.availableCameras
                        textRole: "displayName"
                        onActivated:
                        {
                            camera.stop()
                            camera.deviceId = model[currentIndex].deviceId
                            cameraStartTimer.start()
                        }

                        Timer
                        {
                            id: cameraStartTimer; interval: 500;running: false; repeat: false; onTriggered: camera.start();
                        }
                    }
                }


                RowLayout{
                    Layout.topMargin: 20
                    opacity: 0.5
                    Image {
                        sourceSize.width: 50
                        source: "qrc:/img/res/cloud_black.png"
                    }
                    Label{
                       text: "REMOTE MEDIA"
                    }
                }

                Widgets.SeparatorLine{}

                RowLayout{
                    Layout.leftMargin: 5
                    Image {
                        opacity: 0.5
                        sourceSize.width: 30
                        source: "qrc:/img/res/round_link_black_48dp.png"
                        MouseArea{
                            anchors.fill: parent
                            onClicked: videoMediaSelectionRadiobutton_urlUrl.checked = !videoMediaSelectionRadiobutton_urlUrl.checked
                        }
                    }
                    RadioButton {
                        id: videoMediaSelectionRadiobutton_urlUrl
                        ButtonGroup.group: mediaSelectorRadioButtons
                        text: qsTr("Link")
                        checked: mainMediaPanel.mediaSource === "link"
                        onCheckedChanged: {
                            if(checked){
                                loadImageTimer.start()
                                mediaStateButton.visible = false;
                                lastSeparatorLine.visible = false;
                            }
                            else{
                                loadImageTimer.stop()
                                mediaStateButton.visible = true;
                                lastSeparatorLine.visible = true;
                            }
                        }

                        onClicked: {
                            root.setMediaButtonState(false)

                            mainMediaPanel.mediaSource = "link"
                            mainMediaPanel.mediaUrl = urlLoader.fileText
                            loadImageTimer.url = urlLoader.fileText
                        }
                    }
                    Widgets.FileLoader{
                        id: urlLoader
                        labelText: ""
                        Layout.fillWidth: true
                        fileText:  "https://mymodernmet.com/wp/wp-content/uploads/2019/09/100000-ai-faces-thumbnail.jpg"
                        nameFilters: ["*.*"]
                        moreButtonVisibility: false
                        function onLoaded(){
                            fileText=file
                        }
                        function onEnterPressedFnc(){
                            videoMediaSelectionRadiobutton_urlUrl.clicked()
                            root.setMediaButtonState(true)
                        }
                        onFileChoosen: onLoaded
                        onEnterPressed: onEnterPressedFnc
                    }
                }



                RowLayout{
                    Layout.leftMargin: 5
                    Image {
                        opacity: 0.5
                        sourceSize.width: 30
                        source: "qrc:/img/res/cctv.png"
                        MouseArea{
                            anchors.fill: parent
                            onClicked: videoMediaSelectionRadiobutton_RSTP.checked = !videoMediaSelectionRadiobutton_RSTP.checked
                        }
                    }
                    RadioButton {
                        id: videoMediaSelectionRadiobutton_RSTP
                        ButtonGroup.group: mediaSelectorRadioButtons
                        text: qsTr("Rtsp stream")
                        checked: mainMediaPanel.mediaSource === "rstp"
                        onClicked: {
                            root.setMediaButtonState(false)
                            mainMediaPanel.mediaSource = "rstp"
                            mainMediaPanel.mediaUrl = te.text
                        }
                    }
                    TextEdit{
                        id: te
                        clip: true
                        Layout.fillWidth: true
                        font.pixelSize: 16
                        focus: videoMediaSelectionRadiobutton_RSTP.checked
                        text: "rtsp://192.168.8.110:5554/camera"

                        Rectangle{
                            opacity: 0.2
                            anchors.fill: parent
                            border.color: "gray"
                            color: "lightgray"
                        }
                        Keys.onEnterPressed: {
                            videoMediaSelectionRadiobutton_RSTP.clicked()
                            root.setMediaButtonState(true)
                        }
                    }
                }

                RowLayout{
                    Connections{
                        target: httpManager
                        function onYoutubeLinkProcessingError(){
                            convertedLinksLabel.text =  "Sorry, but provided link cannot be processed, try with different one"
                        }
                    }

                    Layout.leftMargin: 5
                    Image {
                        sourceSize.width: 30
                        source: "qrc:/img/res/youtube.png"
                        MouseArea{
                            anchors.fill: parent
                            onClicked: videoMediaSelectionRadiobutton_mediaSteam.checked = !videoMediaSelectionRadiobutton_mediaSteam.checked
                        }
                    }

                    RadioButton {
                        id: videoMediaSelectionRadiobutton_mediaSteam
                        ButtonGroup.group: mediaSelectorRadioButtons
                        text: qsTr("Media stream")
                        checked: mainMediaPanel.mediaSource === "mediaStream"
                        onClicked: {
                            mainMediaPanel.mediaSource = "mediaStream"

                            httpManager.getYoutubeRawLinks(mediaStreamTextEdit.text)
                            root.setMediaButtonState(false)
                          }
                    }
                    TextEdit{
                        id: mediaStreamTextEdit
                        clip: true
                        Layout.fillWidth: true
                        font.pixelSize: 16
                        focus: videoMediaSelectionRadiobutton_mediaSteam.checked
                        text: {
                            return httpManager.selectedYoutubeLink===null?
                                        "https://www.youtube.com/watch?v=o7ixMn50-kM&ab_channel=Awalkaroundtheworld":httpManager.selectedYoutubeLink.baseUrl

                        }

                        Keys.onEnterPressed: {
                            httpManager.resetConvertedYoutubeLinks()
                            convertedLinksLabel.setDefaultText()
                            httpManager.getYoutubeRawLinks(mediaStreamTextEdit.text)
                            mainMediaPanel.mediaSource = "mediaStream"
                            root.setMediaButtonState(false)
                        }

                        Rectangle{
                            opacity: 0.2
                            anchors.fill: parent
                            border.color: "gray"
                            color: "lightgray"

                        }
                    }
                }

                Widgets.SeparatorLine{
                visible: httpManager.convertedYoutubeLinks.count
                }

                ProgressBar {
                    visible: httpManager.convertedYoutubeLinks.count === 0 && videoMediaSelectionRadiobutton_mediaSteam.checked==true
                    Layout.fillWidth: true
                    indeterminate: true
                }


                Label{
                    function setDefaultText(){
                        text= "Video quality: "+ httpManager.convertedYoutubeLinks.count + " available."
                    }

                    id: convertedLinksLabel
                    text: setDefaultText()
                    visible: videoMediaSelectionRadiobutton_mediaSteam.checked
                }

                Item{
                    Layout.fillHeight: true
                    id: youtubeQualityListView
                    visible: videoMediaSelectionRadiobutton_mediaSteam.checked
                    Layout.fillWidth: true

                    ButtonGroup { id: youtubeQualityRadioButtons }

                    GridView{

                        anchors.fill: parent
                        model:httpManager.convertedYoutubeLinks

                        delegate: Label{

                            Item{
                                anchors.margins:10
                                RadioButton{
                                    checked: index === 0? true:false
                                    text: httpManager.convertedYoutubeLinks.at(index).resolution
                                    ButtonGroup.group: youtubeQualityRadioButtons
                                    onCheckedChanged: {
                                        if(checked===true){
                                            httpManager.setSelectedYoutubeLink(index)
                                            convertedLinksLabel.setDefaultText()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Item{
                    Layout.fillHeight: true
                }

               Widgets.SeparatorLine{
                   id: lastSeparatorLine
               }
                ToolButton{
                  visible: {
                      if(videoMediaSelectionRadiobutton_mediaSteam.checked && httpManager.selectedYoutubeLink===null)
                      {
                          return false
                      }else{
                          return true
                      }
                  }

                  id: mediaStateButton
                  Layout.alignment: Qt.AlignCenter

                  text: qsTr("Stop media")
                  icon.source: "/img/res/stop.png"
                  font.family: "Helvetica"
                  antialiasing: true
                  Layout.fillWidth: true
                  onClicked: {
                      root.setMediaButtonState(text==="Play media"?true:false)
                  }
               }
            }
            anchors.fill: parent
        }
    }
}
