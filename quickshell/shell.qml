import QtQuick
import Quickshell
import Quickshell.Io

import qs.core 
import qs.modules.bar
import qs.modules.bezels
import qs.modules.launcher
import qs.widgets

ShellRoot {
    id: shellRoot
    objectName: "shellRoot"

    property bool launcher: false 

    /* Widgets for all Screen */

    Bar { }

    Loader {
        id: networkLoader
        active: Preferences.bar.floating ? false : Preferences.bezel.active
        source: "./modules/bezels/Bezels.qml"
    }

    Loader {
        id: launcherLoader
        active: launcher
        source: "./modules/launcher/Launcher.qml"
    }

    /* Widgets for only main screen */

    DayTimeWidget { }


    /*Global IpcHandlers */

    IpcHandler {
        target: "launcher"

        function changeVisiblity() {
            shellRoot.launcher = !shellRoot.launcher
        }
    }

}
