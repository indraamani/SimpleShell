import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.core
import qs.modules.bar.component

Rectangle {
    id: verticalBar
    property string targetMonitor: ""
    property QtObject clockIns

    anchors.fill: parent
    color: Preferences.bar.background

    radius: Preferences.bar.floating && Preferences.bar.radius

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

    Column {
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            bottomMargin: 12
        }
        spacing: 8

        Rectangle {
            implicitWidth: 32
            implicitHeight: connectivityTile.implicitHeight + 18
            radius: 20
            color: Preferences.bar.background

            Column {
                id: connectivityTile
                anchors.centerIn: parent
                spacing: 4

                Loader {
                    id: networkLoader
                    anchors.horizontalCenter: parent.horizontalCenter
                    asynchronous: true
                    source: "component/Network.qml"
                }

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 12
                    height: 1
                    radius: 0.5
                    color: "black"
                }

                Loader {
                    id: bluetoothLoader
                    anchors.horizontalCenter: parent.horizontalCenter
                    asynchronous: true
                    source: "component/Bluetooth.qml"
                }
            }
        }

    }
}
