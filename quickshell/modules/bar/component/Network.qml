import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.services
import qs.core

Item {

    readonly property bool isVertical: Preferences.bar.position === "left" || Preferences.bar.position === "right"
    readonly property bool isEnabled: Network.wifiEnabled
    readonly property bool isConnected: Network.active !== null
    readonly property int signalStrength: isConnected ? Network.signalStrength : 0
    readonly property string networkName: isConnected ? (Network.active.ssid ?? "Connected") : ""

    implicitHeight: 20
    implicitWidth: isVertical ? networkRow.implicitWidth : networkRow.implicitWidth + 12

    GridLayout {
        id: networkRow
        anchors.centerIn: parent
        columns: isVertical ? 1 : 2
        rows: 0

        // Wifi icon
        Text {
            id: wifiIcon

            text: {
                if (!isEnabled) return "󰖪"
                if (!isConnected) return "󰖪"
                if (signalStrength >= 75) return "󰤨"
                if (signalStrength >= 50) return "󰤥"
                if (signalStrength >= 25) return "󰤢"
                return "󰤟"
            }

            font {
                pixelSize: 30
            }

            color: {
                if (!isEnabled) {
                    return "gray"
                }
                if (!isConnected) {
                    return "gray"
                }
                if (mouseArea.containsMouse) {
                    return "whitesmoke"
                }
                return "white"
            }

            scale: mouseArea.containsMouse ? 1.15 : 1.0

            Behavior on color {
                ColorAnimation {
                    duration: 300
                }
            }

            Behavior on scale {
                NumberAnimation {
                    duration: 150
                }
            }
        }

        // Wifi name
        Text {
            visible: !isVertical
            text: {
                if (!enabled) {
                    return "Off"
                }
                if(!isConnected) {
                    return "No wifi"
                }
                return networkName
            }

            font {
                pixelSize: 12
                weight: isConnected ? Font.Medium : Font.Normal
                italic: false

            }
            elide: Text.ElideRight
            color: "white"
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true

            onClicked: {

            }
        }
    }
}
