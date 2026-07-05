import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.core
import qs.bar.component

Rectangle {
    id: verticalBar
    property string targetMonitor: ""
    property QtObject clockIns

    anchors.fill: parent
    color: Preferences.bar.background

    ColumnLayout {
        anchors.fill: parent
        Workspaces {
            id: workspaces
            targetMonitor: verticalBar.targetMonitor
            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
                topMargin: 12
            }
        }

        Text {
            anchors.centerIn: parent
            text: Preferences.bar.position === "left" ? Qt.formatDateTime(clockIns.date, "ddd MMMM dd, hh:mm") : Qt.formatDateTime(clockIns.date, "ddd MMMM dd, hh:mm")

            rotation: Preferences.bar.position === "left" ? 90 : 270
            font {
                pixelSize: 16
                bold: true
            }
            color: "#fff"
        }

    }
}
