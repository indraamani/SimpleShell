import QtQuick
import Quickshell
import Quickshell.Io

import qs.core 
import qs.modules.bar
import qs.modules.bezels
import qs.modules.launcher
import qs.modules.wallpicker
import qs.widgets

ShellRoot {
    id: shellRoot
    objectName: "shellRoot"

    property bool launcher: false
    property bool bar: true
    property bool wallpicker: false 


    /* Widgets for all Screen */
    LazyLoader {
        id: barLoader
        active: bar 
        source: "./modules/bar/Bar.qml"

    }
    Loader {
        id: wallpickerLoader
        active: wallpicker 
        source: "./modules/wallpicker/Wallpicker.qml"

    }
    Loader {
        id: bezelLoader
        active: Preferences.bar.floating || !bar ? false : Preferences.bezel.active
        source: "./modules/bezels/Bezels.qml"
    }

    Loader {
        id: launcherLoader
        active: launcher
        source: "./modules/launcher/Launcher.qml"
    }

    /*Global IpcHandlers */

    IpcHandler {
        target: "toggle"

        function toggleBar() {
            shellRoot.bar = !shellRoot.bar
        }

        function toggleLauncher() {
            if(shellRoot.wallpicker) {
                shellRoot.wallpicker = false 
            }
            shellRoot.launcher = !shellRoot.launcher
        }

        function toggleWallpicker() {
            shellRoot.wallpicker = !shellRoot.wallpicker
        }
    }

}
