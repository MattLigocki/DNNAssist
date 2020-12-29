import QtQuick 2.15
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtMultimedia 5.8
import QtGraphicalEffects 1.15
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12
import com.dnnassist.classes 1.0
import Qt.labs.platform 1.1
//import "qrc:/widgets" as Widgets

ColumnLayout {
    property var frameworkName: ""
    ComboBox{
        id: classifiersComboBox
        model: aiManager.getFrameworkObjectByName(frameworkName).availableClassifiers
        Layout.fillWidth: true
        Material.accent: Material.Orange
        Material.foreground: Material.BlueGrey
        displayText: {
            aiManager.getFrameworkObjectByName(frameworkName).activeClassifier
        }
        delegate: ItemDelegate {
                width: parent.width
                contentItem: Text {
                    id: placesComboItem
                    text: {
                        aiManager.getFrameworkObjectByName(frameworkName).availableClassifiers.at(index).name
                    }
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }
            }
            onCurrentIndexChanged: {
                var text = aiManager.getFrameworkObjectByName(frameworkName).availableClassifiers.at(currentIndex).name
                classifiersComboBox.displayText = text;
                aiManager.getFrameworkObjectByName(frameworkName).activeClassifier = text
            }
    }
}
