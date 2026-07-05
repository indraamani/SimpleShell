import QtQuick 
import Quickshell 

import qs.core
import qs.bar.widgets

Rectangle {
    id: verticalBar
    property string targetMonitor: ""

    anchors.fill: parent 
    color: Preferences.bar.background

    Workspaces {
        targetMonitor: verticalBar.targetMonitor 
        anchors {
            top: parent.top 
            horizontalCenter: parent.horizontalCenter
            topMargin: 12
        }
    }

    
}
