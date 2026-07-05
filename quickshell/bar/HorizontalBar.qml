import QtQuick 
import Quickshell 

import qs.core
import qs.bar.widgets

Rectangle {
    id: horizontalBar
    property string targetMonitor: ""

    anchors.fill: parent 
    color: Preferences.bar.background

    Workspaces {
        id: workspaces
        targetMonitor: horizontalBar.targetMonitor 
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: 12
        }
    }
}
