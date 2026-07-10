import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

import qs.core
import qs.modules.bar

Variants {
    model: Quickshell.screens

    PanelWindow {
        id: mainBar

        property var modelData
        screen: modelData

        property string position: Preferences.bar.position
        property bool isVertical: position === "left" || position === "right"
        property bool isRevealed: {
            if(!Preferences.bar.autohide) {
                return true
            }
            return mouseArea.containsMouse
        }

        // TODO: fix 
        WlrLayershell.exclusiveZone: Preferences.bar.autohide ? -1 : Preferences.bar.barsize
        WlrLayershell.namespace: "quickshell.topbar"

        implicitHeight: !isVertical && Preferences.bar.barsize
        implicitWidth:  isVertical && Preferences.bar.barsize
        color: "transparent"

        anchors {
            top: position === "top" || mainBar.isVertical
            bottom: position === "bottom" || mainBar.isVertical
            left: position === "left" || !mainBar.isVertical
            right: position === "right" || !mainBar.isVertical
        }

        margins {
            top: position === "top" && !isRevealed ? -(mainBar.height-1) : Preferences.bar.floating && Preferences.bar.margin
            bottom: position === "bottom" && !isRevealed ? -(mainBar.height-1) : Preferences.bar.floating && Preferences.bar.margin
            left: position === "left" && !isRevealed ? -(mainBar.width-1) : Preferences.bar.floating && Preferences.bar.margin
            right: position === "right" && !isRevealed ? -(mainBar.width-1) : Preferences.bar.floating && Preferences.bar.margin
        }

        SystemClock {
            id: sysClock
            precision: SystemClock.Minutes
        }
        Loader {
            active: true
            sourceComponent: isVertical ? vertical : horizontal
            anchors.fill: parent

            Component {
                id: vertical
                VerticalBar {
                    targetMonitor: modelData.name
                    clockIns: sysClock
                }
            }

            Component {
                id: horizontal
                HorizontalBar {
                    targetMonitor: modelData.name
                    clockIns: sysClock
                }
            }
        }
        MouseArea {
            id: mouseArea
            anchors.fill: parent 
            hoverEnabled: true 
            propagateComposedEvents: true
        }
    }
}
