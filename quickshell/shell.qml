import QtQuick
import Quickshell

import qs.core 
import qs.modules.bar
import qs.modules.bezels

ShellRoot {
    id: shellRoot

    /* Widgets for all Screen */

    Bar { }

    Loader {
        id: networkLoader
        active: Preferences.bezel.active
        source: "./modules/bezels/Bezels.qml"
    }

    /* Widgets for only main screen */

}
