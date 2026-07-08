import QtQuick 
import Quickshell 
import Quickshell.Wayland
import QtQuick.Layouts
import QtQuick.Effects

PanelWindow {
 
    WlrLayershell.layer: WlrLayer.Background
    exclusiveZone: 0
    
    anchors {
        top: true
    }

    margins {
      top: 80
    }

    implicitWidth: 1200
    implicitHeight: 260
    color: "transparent"

    SystemClock {
        id: sysTime
        precision: SystemClock.Seconds
    }

    ColumnLayout {
        anchors.centerIn: parent
        anchors.horizontalCenter: parent.horizontalCenter
        
        Text {
            text: Qt.formatDateTime(sysTime.date, "dddd").toUpperCase()
            font.family: "Anurati"
            font.pixelSize: 112 
            font.letterSpacing: 34
            color: "#ffffff"
            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true 
                shadowColor: '#000000'
                shadowBlur: 0.5
                shadowVerticalOffset: 3
                shadowHorizontalOffset: 3
            }
        }

        Row {
            Layout.alignment: Qt.AlignHCenter
            spacing: 34

            Text {
                textFormat: Text.RichText
                text: Qt.formatDateTime(sysTime.date, "hh:mm")
                font {
                    family: "Cascadia Code NF"
                    pixelSize: 34
                    letterSpacing: 2
                    bold: true
                }
                color: '#ffffff'
                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true 
                    shadowColor: '#000000'
                    shadowBlur: 0.5
                    shadowVerticalOffset: 3    // Downward shift
                    shadowHorizontalOffset: 3 
                }
            }
            
            Text {
                textFormat: Text.RichText
                text: Qt.formatDateTime(sysTime.date, "dd:MM:yyyy")
                font {
                    family: "Cascadia Code NF"
                    pixelSize: 34
                    letterSpacing: 2
                    bold: true
                }
                color: '#ffffff' 
                layer.enabled: true 
                layer.effect: MultiEffect {
                    shadowEnabled: true 
                    shadowColor: '#000000'
                    shadowBlur: 0.5
                    shadowVerticalOffset: 3    // Downward shift
                    shadowHorizontalOffset: 3 
                } 
            }
        } 
    }
}
