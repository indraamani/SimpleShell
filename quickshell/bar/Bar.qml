import QtQuick 
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell 
import Quickshell.Wayland 
import Quickshell.Io 

Variants {

    model: Quickshell.screens

    PanelWindow {
        id: mainBar 

        property var modelData
        screen: modelData 

        implicitHeight: 42
        implicitWidth:  -1

        anchors {
            top: true
            bottom: false
            left: true
            right: true
        }

        margins {
            top: 4
            bottom: 4
            left: 4
            right: 4
        }

        MouseArea {
            id: mouseArea 
            hoverEnabled: true 
            anchors.fill: parent
        }
    }
}
