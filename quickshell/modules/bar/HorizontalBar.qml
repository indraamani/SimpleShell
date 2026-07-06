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

    Row {
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
            rightMargin: 12
        }
        spacing: 8

        Rectangle {
            implicitHeight: 32
            implicitWidth: connectivityTile.implicitWidth + 18
            radius: 20
            color: Preferences.bar.background

            Row {
                id: connectivityTile
                anchors.centerIn: parent
                spacing: 4

                Loader {
                    id: networkLoader
                    anchors.verticalCenter: parent.verticalCenter
                    asynchronous: true
                    source: "component/Network.qml"
                }

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: 1
                    height: 12
                    radius: 0.5
                    color: "black"
                }

                Loader {
                    id: bluetoothLoader
                    anchors.verticalCenter: parent.verticalCenter
                    asynchronous: true
                    source: "component/Bluetooth.qml"
                }
            }

            Behavior on color {}

            Behavior on width {}
        }
    }
}
