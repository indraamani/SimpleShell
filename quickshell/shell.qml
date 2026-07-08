import QtQuick
import Quickshell

import qs.core 
import qs.modules.bar
import qs.modules.bezels
import qs.modules.launcher
import qs.widgets

ShellRoot {
    id: shellRoot

    /* Widgets for all Screen */

    Bar { }

    Loader {
        id: networkLoader
        active: Preferences.bezel.active
        source: "./modules/bezels/Bezels.qml"
    }

    Launcher { }

    /* Widgets for only main screen */

    DayTimeWidget { }
}
