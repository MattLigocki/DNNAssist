import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.15
import QtQuick.Window 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12


TabBar {
    ColorHelper{id: colorHelper}
    MethodsHelpers{id: methodsHelpers}

    id: tabBar


    TabButton
    {
        icon.source: "/img/res/camera.png"
        text: qsTr("media")
        Material.accent:  colorHelper.darkPastelOrange
        onClicked: {
            methodsHelpers.navigateToItem("media")
        }
    }

    TabButton
    {
        icon.source: "/img/res/brain.png"
        text: qsTr("Ai")
        Material.accent: colorHelper.darkPasteBlue

        onClicked:
        {
            methodsHelpers.navigateToItem("ai")
        }
    }

//    TabButton
//    {
//        icon.source: "/img/res/dumbbell.png"
//        text: qsTr("Ai gym")
//        Material.accent: colorHelper.lightPasteBlue
//        onClicked:
//        {
//            methodsHelpers.navigateToItem("aigym")
//        }
//    }
//    TabButton
//    {
//        icon.source: "/img/res/pngwave.png"
//        text: qsTr("Data sets")
//        Material.accent: colorHelper.lightPasteOrange
//        onClicked:
//        {
//            methodsHelpers.navigateToItem("data")
//        }
//    }

//    TabButton
//    {
//        icon.source: "/img/res/show_chart.png"
//        text: qsTr("Statistics")
//        Material.accent: colorHelper.lightestPasteBlue
//        onClicked:
//        {
//            methodsHelpers.navigateToItem("statistics")
//        }
//    }


}
