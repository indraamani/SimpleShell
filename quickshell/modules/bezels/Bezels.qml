import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland

import qs.core

Variants {
    id: bezels
    model: Quickshell.screens

    PanelWindow {
        id: bezelWindow

        required property var modelData
        screen: modelData

        color: "transparent"

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "quickshells-bezels"
        WlrLayershell.exclusiveZone: -1

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        margins {
            top: Preferences.bar.position === "top" ? Preferences.bar.barsize : 0
            bottom: Preferences.bar.position === "bottom" ? Preferences.bar.barsize : 0 
            left: Preferences.bar.position === "left" ? Preferences.bar.barsize : 0
            right: Preferences.bar.position === "right" ? Preferences.bar.barsize : 0
        }

        mask: Region {
            item: effectContainer
            intersection: Intersection.Xor
        }
        
        Item {
            id: effectContainer
            anchors.fill: parent

            Item {
                id: bezelLayer
                anchors.fill: parent
                layer.enabled: true

                layer.effect: MultiEffect {
                    shadowEnabled: Preferences.bezel.shadow 
                    shadowColor: Preferences.bezel.shadowcolor
                    shadowVerticalOffset: 0
                    shadowHorizontalOffset: 0
                    blurMax: 20
                    shadowBlur: 0.5
                }

                Rectangle {
                    id: bezelBackground
                    anchors.fill: parent
                    color: Preferences.bezel.bgcolor
                    layer.enabled: true

                    layer.effect: MultiEffect {
                        maskSource: cutoutShape
                        maskEnabled: true
                        maskInverted: true
                        maskThresholdMin: 0.5
                        maskSpreadAtMin: 1
                    }
                }
            }

            Item {
                id: cutoutShape
                anchors.fill: parent
                layer.enabled: true
                visible: false

                Rectangle {
                    id: clippingRect
                    anchors.fill: parent

                    anchors {
                        leftMargin: Preferences.bar.position === "left" ? 0 : Preferences.bezel.width 
                        rightMargin: Preferences.bar.position === "right" ? 0 : Preferences.bezel.width
                        topMargin: Preferences.bar.position === "top" ? 0 : Preferences.bezel.width
                        bottomMargin: Preferences.bar.position === "bottom" ? 0 : Preferences.bezel.width
                    }
                    radius: Preferences.bezel.radius 
                }
            }
        }
    }
}
