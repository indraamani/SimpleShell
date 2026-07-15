import QtQuick 
import QtQuick.Layouts 
import QtQuick.Effects
import Quickshell 
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Wayland
import Qt.labs.folderlistmodel

import qs.core 

PanelWindow {
    id: wallpicker

    anchors {
        top: Preferences.bar.position === "bottom"
        bottom: Preferences.bar.position === "top" || Preferences.bar.position === "left" || Preferences.bar.position === "right"

    }
    implicitHeight: 260
    implicitWidth: 1220
    color: "transparent"

    
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    WlrLayershell.namespace: "wallpicker"
    WlrLayershell.exclusiveZone: -1

    ClippingRectangle {
        anchors.fill: parent 
        color: Preferences.bar.background

        // radius 
        topRightRadius: Preferences.bar.position === "bottom" ? 0 : 20
        topLeftRadius: Preferences.bar.position === "bottom" ? 0 : 20
        bottomRightRadius: Preferences.bar.position === "top" || Preferences.bar.position === "left" || Preferences.bar.position === "right"  ? 0 : 20
        bottomLeftRadius: Preferences.bar.position === "top" || Preferences.bar.position === "left" || Preferences.bar.position === "right" ? 0 : 20

        RowLayout {
            id: header 
            anchors {
                top: parent.top 
                left: parent.left
                right: parent.right
                margins: 20
            }

            Text {
                text: "\uf03e Wallpaper"
                color: "white"
                font {
                    family: Preferences.defaultFont.font.family
                    pixelSize: 20 
                }
            }

            Item {
                Layout.fillWidth: true 
            }

            Text {
                text: wallpaperModel.count +" total"
                color: "white"
                verticalAlignment: Text.AlignVCenter
                font {
                    family: Preferences.defaultFont.font.family
                    pixelSize: 12 
                }
            }
        }

        ListView {
            id: wallpaperList 
            anchors {
                top: header.bottom 
                left: parent.left 
                right: parent.right
                bottom: parent.bottom 
            }
            model: FolderListModel {
                id: wallpaperModel 

                folder: "file:///home/indra/.cache/wallpapers"
                showDirs: false 
                showDotAndDotDot: false 
                showOnlyReadable: true
            }
            spacing: 20
            anchors.margins: 20
            clip: true 
            snapMode: ListView.SnapToItem
            highlightRangeMode: ListView.ApplyRange //StrictlyEnforceRange
            preferredHighlightBegin: width / 2 - itemWidth / 2
            preferredHighlightEnd: width / 2 + itemWidth / 2
            orientation: ListView.Horizontal
            
            property real itemWidth: 320
            cacheBuffer: itemWidth * 3
            flickDeceleration: 1500 

            Behavior on currentIndex {
                NumberAnimation {
                    duration: 350
                }
            }

            delegate: Rectangle {
                height: 180
                width: 320 
                radius: 20
                clip: true

                Behavior on scale {
                    NumberAnimation {
                        duration: 250
                    }
                }

                Image {
                    anchors.fill: parent
                    source: fileUrl
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    cache: true 
                    sourceSize.width: parent.width 
                    sourceSize.height: parent.height
                }    

                TapHandler {
                onTapped: {
                    Quickshell.execDetached({ command: ["awww", "img", "-t", "random", "/home/indra/.local/share/wallpapers/"+fileName] });
                    //wallpaperList.currentIndex = model.index
                    shellRoot.wallpicker = false 
                }
            }
            } 
        }
    }
}
