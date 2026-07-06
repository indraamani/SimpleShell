import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.core
import qs.modules.bar.component

Rectangle {
    id: horizontalBar
    property string targetMonitor: ""
    property QtObject clockIns

    anchors.fill: parent
    color: Preferences.bar.background

    RowLayout {
        anchors.fill: parent
        Workspaces {
            id: workspaces
            targetMonitor: horizontalBar.targetMonitor
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: 12
            }
        }

        Text {
            anchors.centerIn: parent
            text: Qt.formatDateTime(clockIns.date, "ddd MMMM dd, hh:mm")
            font {
                pixelSize: 16
                bold: true
            }
            color: "#fff"
        }
    }
}
