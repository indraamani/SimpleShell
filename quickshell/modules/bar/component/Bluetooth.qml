import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.services
import qs.core

Item {

    readonly property bool isVertical: Preferences.bar.position === "left" || Preferences.bar.position === "right"
    readonly property var adapter: Bluetooth.adapter
    readonly property var connectedDevices: Bluetooth.connectedDevice
    readonly property bool hasConnection: connectedDevices.length > 0
    readonly property bool isEnabled: adapter?.enabled ?? false
    readonly property string deviceName: hasConnection ? (connectedDevices[0]?.name ?? "Device") : ""
    readonly property int deviceCount: connectedDevices.length

    implicitHeight: 20
    implicitWidth: isVertical ? bluetoothRow.implicitWidth : bluetoothRow.implicitWidth + 12

    GridLayout {
        id: bluetoothRow
        anchors.centerIn: parent
        columns: isVertical ? 1 : 2
        rows: 0

        // Wifi icon
        Text {
            id: wifiIcon

            text: {
                if (!isEnabled) return "󰂲"
                if (hasConnection) return "󰂱"
                return "󰂯"
            }

            font {
                pixelSize: 20
            }

            color: {
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
                if (!isEnabled) return "Off"
                if (!hasConnection) return "No Device"
                if (deviceCount > 1) return deviceName + " +" + (deviceCount - 1)
                return deviceName
            }

            font {
                pixelSize: 12
                weight: hasConnection ? Font.Medium : Font.Normal
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
