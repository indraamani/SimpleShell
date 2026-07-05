import QtQuick 
import QtQuick.Effects
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets

import qs.core

Rectangle {
    id: workspace

    property bool isVertical: Preferences.bar.position === "left" || Preferences.bar.position === "right" 
    property string targetMonitor: ""
    readonly property var sortedWorkspace: {
        var ws = Hyprland.workspaces.values 
        var array = ws.filter(w => (w.id >= 1 && w.monitor?.name === workspace.targetMonitor)).slice(0, 6)
        array.push(true)
        return array
    }

    Component.onCompleted: {
        Hyprland.refreshToplevels()
        Hyprland.refreshWorkspaces()
    }

    Connections {
        target: Hyprland 
        function onWorkspacesChanged() { workspace.updateWorkspaces(); }
        function onEvent(name, data) { workspace.updateWorkspaces(); }
    }

    height: isVertical ? wslist.contentHeight : 34
    width: !isVertical ? wslist.contentWidth : 34
    color: "transparent"
    
    ListView {
        id: wslist
        width: parent.width
        height: parent.height
        orientation: isVertical ? ListView.Vertical : ListView.Horizontal 
        model:  workspace.sortedWorkspace
        spacing: 8
        
        delegate: Item {
            anchors {
                horizontalCenter: isVertical ? parent.horizontalCenter : undefined
                verticalCenter: !isVertical ? parent.verticalCenter : undefined  
            }
            width: {
                if((modelData.active && modelData.focused || typeof modelData == "boolean" && modelData) && !isVertical) {
                    return 32
                }
                return 18
            }
            height: {
                if((modelData.active && modelData.focused || typeof modelData == "boolean" && modelData) && isVertical) {
                    return 32
                }
                return 18
            }

            Rectangle {
                width: parent.width
                height: parent.height
                radius: 100
                color: {
                    if(typeof modelData == "boolean" && modelData) {
                        return "#a48cf2"
                    }
                    if(modelData.active && modelData.focused || mouseArea.containsMouse) {
                        return "#f16c75"
                    }
                    return "#49454F"
                }

                Behavior on color {
                    ColorAnimation {
                        duration: 600
                    }
                }
            }
            MouseArea {
                id: mouseArea 
                anchors.fill: parent 
                hoverEnabled: true
                onClicked: {
                    if (typeof modelData == "boolean" && modelData) {
                        // TODO: Build Workspace Manager 
                    } else {
                        Hyprland.dispatch(`
                            hl.dsp.focus({
                                workspace = ${index + 1}
                            })
                        `)
                    }
                }
            }
            Behavior on width {
                enabled: !isVertical ? true : false
                NumberAnimation {
                    duration: 600
                }
            }

            Behavior on height {
                enabled: isVertical ? true : false 
                NumberAnimation {
                    duration: 300
                }
            }
        }
    }
}
