import QtQuick 2.0
import QtQuick.Controls 2.15

Repeater {
    id: detectionRectangle
    property var media
    model: videoFilter.detectedObjects
        delegate: Rectangle{
            property  var r: media.mapNormalizedRectToItem(Qt.rect(modelData.x, modelData.y, modelData.width, modelData.height));
            x:  r.x
            y: r.y
            width: r.width
            height: r.height
            //visible: videoFilter.isActive
            color: "transparent"
            border.color: application.detectionRectanglesColor
            border.width: 1
            Label{
                  id: detectionRectangleLabel
                  anchors{
                      bottom: parent.top
                      left: parent.left
                  }
                  width: parent.width
                  color: application.detectionRectanglesColor
            }

            Behavior on x{NumberAnimation{duration: 100}}
            Behavior on y{NumberAnimation{duration: 100}}
            Behavior on width{NumberAnimation{duration: 100}}
            Behavior on height{NumberAnimation{duration: 100}}

            Component.onCompleted: {
                detectionRectangleLabel.text =modelData.classifier+": "+(modelData.confidenceLvl.toFixed(2)*100) + "%"
            }
        }
    }

