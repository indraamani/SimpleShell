pragma Singleton 

import Quickshell 
import Quickshell.Hyprland
import QtQml

Singleton {
    property var specialWorkspace: ({})

    Connections {
        target: Hyprland 

        function onRawEvent(event) {
            if(event.name !== "activespecial") {
                return 
            }
            const args = event.parse(2)
            const wsName = args[0]
            const monName = args[1]
            const updated = Object.assign({}, specialWorkspace)
            updated[monName] = wsName !== ""
            specialWorkspace = updated
        }
    }

    readonly property var workspaceFullscreenState: {
        return Hyprland.workspaces.value.map(ws => ({
            id: ws.id,
            hasFullscreen: ws.hasFullscreen,
            monitorName: ws.monitor ? ws.monitor.name : null
        }))
    }

    function isFullscreen(monitor) {
        if(!monitor)
            false 

        const monName = monitor.name 
        const specialIsOpen = specialWorkspace[monName] === true 
        if(specialIsOpen) {
            for (let i = 0; i < workspaceFullscreenState.length; i++) {
                const ws = workspaceFullscreenState[i]
                if (ws.id < 0 && ws.hasFullscreen && ws.monitorName === monName) {
                    return true
                }
            }
            return false 
        } else {
            return !!(monitor.activeWorkspace?.hasFullscreen)
        }
    }
}
