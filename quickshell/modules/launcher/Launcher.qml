import Quickshell 
import QtQuick 
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Io 
import Quickshell.Hyprland
import QtQuick.Effects

import qs.core
import qs.services

PanelWindow {
    id: launcher

    implicitHeight: 460 
    implicitWidth: 600

    visible: false 
    focusable: true

    color: "transparent"

    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    onVisibleChanged: {
        if (visible) {
            Qt.callLater(inputField.forceActiveFocus);
        }
    }

    FontMetrics {
        id: localFont
        font.family: "JetBrainsMonoNL Nerd Font"
        font.styleName: "Regular"
    }

    DesktopEntriesModel {
        id: applicationModel

        inputText: inputField.text
    }

    Rectangle {
	    anchors.fill: parent 
	    radius: 8 
	    color: Preferences.bar.background

    	ColumnLayout {
            anchors.fill: parent

            Rectangle {
                id: textfield
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                }
                radius: 8

                implicitHeight: 50
                color: "#a48cf2"

                MouseArea {
                    anchors.fill: parent 
                    onClicked: inputField.forceActiveFocus()
                }

                TextInput {
                    id: inputField
                    focus: true
                    verticalAlignment: Text.AlignVCenter

                    anchors {
                        leftMargin: 15 
                        rightMargin: 15 
                        fill: parent 
                    }

                    font {
                        family: localFont.font.family 
                        pixelSize: 16 
                        bold: true
                    }

                    Text {
                        id: placeholder
                        anchors.verticalCenter: parent.verticalCenter
                        text: "\uf002  Enter..." 
                        font {
                            family: localFont.font.family 
                            pixelSize: 16 
                            bold: true
                        }
                    }

                    onTextChanged: {
                        if(text.length >= 1) {
                            placeholder.visible = false 
                        } else {
                            placeholder.visible = true
                        }
                    }

                }
            }
            
            Flickable {
                id: scrollViewport
                anchors {
                    top: textfield.bottom
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                    topMargin: 12 
                    bottomMargin: 12      
                }
                contentHeight: grid.height  
                clip: true
                pressDelay: 0


                Grid {
                    id: grid

                    anchors {
                        top: textfield.bottom
                        left: parent.left 
                        right: parent.right 
                        margins: 10
                    }

                    columns: 4
                    spacing: 10

                    Repeater {
                        model: applicationModel

                        delegate:  Rectangle {
                            width: (grid.width - (grid.spacing * (grid.columns - 1))) / grid.columns
                            height: 100
                            color: mouseArea.containsMouse ? Preferences.bar.background : "transparent"
                            opacity: 0.8 
                            radius: 4

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 10

                                Image {
                                    Layout.preferredWidth: 48  
                                    Layout.preferredHeight: 48 
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                                    source: Quickshell.iconPath(modelData.icon)
                                }

                                Text {
                                    text: modelData.name
                                    Layout.fillWidth: true

                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter

                                    elide: Text.ElideRight
                                    wrapMode: Text.Wrap
                                    maximumLineCount: 1
                                    anchors.bottom: parent.bottom
                                    

                                    color: "white"
                                    font {
                                        family: localFont.font.family 
                                        pixelSize: 12 
                                        bold: true
                                    }
                                }

                                MouseArea {
                                    id: mouseArea
                                    anchors.fill: parent 
                                    hoverEnabled: true

                                    onClicked: {
                                        launcher.visible = false;
                                        modelData.execute()
                                    }
                                } 
                            }

                            Behavior on color {
                                ColorAnimation {
                                    duration: 460 
                                } 
                            }
                        }
                    }
                }
            }
        }
    }
}

