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

    Layout.leftMargin: 20
    property var frameworkName
    property var frameworkObj: aiManager.getFrameworkObjectByName(root.frameworkName)
    property alias modelConfigurationUrl: modelLoader.modelConfigurationUrl
    property alias modelWeightsUrl: modelLoader.modelWeightsUrl
    property alias modelClassNamesUrl: modelLoader.modelClassNamesUrl
    property alias pipelineNamesUrl: modelLoader.pipelineNamesUrl

    Widgets.SeparatorLine{}

    Widgets.ExpandingSectionButton{
        id: detectionPropertiesExp
        //imageLogoSource: frameworkObj.iconSource
        text: "Detection properties"
    }

    DetectionProperties{
        Layout.leftMargin: 20
        visible: detectionPropertiesExp.visibility
        opacity: visible?1:0
        Behavior on opacity {
            NumberAnimation{duration: 500}
        }
    }

    Widgets.ExpandingSectionButton{
        id: modelFilesExp
        //imageLogoSource: frameworkObj.iconSource
        text: "Model files"
    }

    ColumnLayout{

        Layout.leftMargin: 20
        Widgets.SeparatorLine{}

        visible: modelFilesExp.visibility
        opacity: visible?1:0
        Behavior on opacity {
            NumberAnimation{duration: 500}
        }

        ComboBox {
            Layout.fillWidth: true
             id:  filesSizeCombobox
             model: [ "Files","Folder"]

        }

        Widgets.FolderLoader{
            id: modelConfigurationLoader
            Layout.fillWidth: true
            labelText: "Folder:"

            function onLoaded(){
                frameworkObj.loadModelFilesFromFolder(folder)
            }
            onFolderChoosen: onLoaded
            visible: filesSizeCombobox.currentText === "Folder"
            opacity: visible?1:0
            Behavior on opacity {
                NumberAnimation{duration: 500}
            }

        }

        ModelFilesLoader{
            id: modelLoader
            Layout.fillWidth: true
            modelConfigurationUrl:root.modelConfigurationUrl
            modelWeightsUrl: root.modelConfigurationUrl
            modelClassNamesUrl: root.modelClassNamesUrl
            pipelineNamesUrl: root.pipelineNamesUrl

            //parametersFromFile: switchParametersFromFile.visualPosition
            configurationFileFilters: frameworkObj.modelConfigurationUrlFileExtension
            weightsFileFilters: frameworkObj.modelWeightsUrlExtension

            visible: filesSizeCombobox.currentText === "Files"
            opacity: visible?1:0
            Behavior on opacity {
                NumberAnimation{duration: 500}
            }
        }
    }

    Widgets.ExpandingSectionButton{
        id: modelPropertiesExp
        //imageLogoSource: frameworkObj.iconSource
        text: "Model properties"
    }

    ModelProperties{
        Layout.leftMargin: 20

        id: modelProperties
        visible: modelPropertiesExp.visibility
        opacity: visible?1:0
        Behavior on opacity {
            NumberAnimation{duration: 500}
        }
    }
}
