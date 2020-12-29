import QtQuick 2.15
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtMultimedia 5.8
import QtGraphicalEffects 1.15
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12

import "qrc:/widgets" as Widgets

ColumnLayout{
    spacing: 0

    id: root
    property alias modelConfigurationUrl: modelConfigurationLoader.fileText
    property alias modelWeightsUrl: modelWeightsLoader.fileText
    property alias modelClassNamesUrl: namesLoader.fileText
    property alias pipelineNamesUrl: pipelineLoader.fileText

    property var parametersFromFile: false

    property var weightsFileFilters
    property var configurationFileFilters

    Widgets.FileLoader{
        id: modelConfigurationLoader
        labelText: "Configuration file:"
        nameFilters: ["Configuration files ("+configurationFileFilters+ ")"]
        Layout.fillWidth: true
        function onLoaded(){
            fileText=file
        }
        onFileChoosen: onLoaded
    }

    Widgets.FileLoader{
        id: modelWeightsLoader
        labelText: "Weights file:"
        Layout.fillWidth: true
        nameFilters: ["Weights files ("+weightsFileFilters+ ")"]
        function onLoaded(){
            fileText=file
        }
        onFileChoosen: onLoaded
    }

    Widgets.FileLoader{
        id: namesLoader
        labelText: "Classes names file:"
        Layout.fillWidth: true
        function onLoaded(){
            fileText=file
        }
        onFileChoosen: onLoaded
    }

    Widgets.SeparatorLine{}

    Widgets.FileLoader{
        id: pipelineLoader
        labelText: "Model params file (pipeline):"
        Layout.fillWidth: true
        function onLoaded(){
            fileText=file
        }
        onFileChoosen: onLoaded
    }
}


