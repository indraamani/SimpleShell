pragma Singleton
import QtQuick 
import Quickshell 
import Quickshell.Io

QtObject {
    id: globalConfig

    /* All Available Properties */ 
    readonly property JsonObject bar: jsonAdapter.bar
    readonly property JsonObject bezel: jsonAdapter.bezel

    property var _fileView : FileView {
        path: Quickshell.shellPath("settings/config.json")
        watchChanges: true
        onFileChanged: {
            reload()
            console.log(jsonAdapter.bar.autohide)
            console.log("Config Updated")
        }

        JsonAdapter {
            id: jsonAdapter 

            property JsonObject bar: JsonObject {
                property int barsize: 42
                property int margin: 0
                property string position: "top"
                property string background: "#ffffff"
                property bool autohide: false 
                property bool floating: false 
                property int radius: 0 
                property bool transparency: true 
            }

            property JsonObject bezel: JsonObject {
                property bool active: false 
                property bool isvisible: false 
                property string bgcolor: "#ffffff"
                property bool shadow: true
                property string shadowcolor: "#B0000000"
                property int width: 7
                property int radius: 8
            }

            onBarChanged: {
            }
        }
    }
}
