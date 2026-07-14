import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Io

import qs.core
import qs.services

PanelWindow {
    id: launcher

    implicitHeight: 460
    implicitWidth: 600 

    focusable: true

    color: "transparent"

    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    onVisibleChanged: {
        if (visible) {
            Qt.callLater(inputField.forceActiveFocus);
        }
    }

    DesktopEntriesModel {
        id: applicationModel
        inputText: inputField.text
    }

    Rectangle {
        anchors.fill: parent
        radius: 8
        color: Preferences.bar.background

        Rectangle {
            id: textfield

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }
            implicitHeight: 50
            radius: 8
            color: "#a48cf2"

            /*MouseArea {
                anchors.fill: parent
                onClicked: inputField.forceActiveFocus()
            }*/

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
                    family: Preferences.defaultFont.font.family
                    pixelSize: 16
                    bold: true
                }

                Text {
                    id: placeholder
                    anchors.verticalCenter: parent.verticalCenter
                    text: "\uf002  Enter..."
                    visible: inputField.text.length === 0
                    font {
                        family: Preferences.defaultFont.font.family
                        pixelSize: 16
                        bold: true
                    }
                }
                onTextEdited: {
                    if(inputField.text[0] === '>') 
                        inputField.text = "\uf054 "
                }

                onAccepted: {
                    if(inputField.text[0] === '\uf054') {
                        Quickshell.execDetached({ command: inputField.text.slice(2).split(" ") })
                        shellRoot.launcher = false
                    }
                }
            }
        }

        GridView {
            id: appGridView

            anchors {
                top: textfield.bottom
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }

            clip: true
            cellWidth: width / 4
            cellHeight: 110

            model: applicationModel

            NumberAnimation {
                id: smoothScrollAnim
                target: appGridView
                property: "contentY"
                duration: 350
                easing.type: Easing.OutCubic
            }

            MouseArea {
                anchors.fill: parent
                propagateComposedEvents: true

                onWheel: wheel => {
                    let startPos = smoothScrollAnim.running ? smoothScrollAnim.to : appGridView.contentY;

                    let delta = -wheel.angleDelta.y * 1.2;
                    let targetPos = startPos + delta;

                    let maxScroll = Math.max(0, appGridView.contentHeight - appGridView.height);
                    targetPos = Math.max(0, Math.min(targetPos, maxScroll));

                    smoothScrollAnim.stop();
                    smoothScrollAnim.to = targetPos;
                    smoothScrollAnim.start();

                    wheel.accepted = true;
                }

                onClicked: mouse => mouse.accepted = false
                onPressed: mouse => mouse.accepted = false
                onReleased: mouse => mouse.accepted = false
            }
            delegate: Item {
                width: appGridView.cellWidth
                height: appGridView.cellHeight

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 4
                    color: gridMouse.containsMouse ? "#269D82F2" : Preferences.bar.background
                    radius: 4
                    /* #0D9D82F2 -> Super subtle, #1A9D82F2 -> Gentle glow, #269D82F2 -> Distinct */ 
                }

                MouseArea {
                    id: gridMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        shellRoot.launcher = false
                        modelData.runInTerminal ? 
                            Quickshell.execDetached({ command: ["kitty", "-e", modelData.command] }) : modelData.execute();
                    }
                }

                Column {
                    anchors.centerIn: parent
                    width: parent.width - 16
                    spacing: 8

                    IconImage {
                        width: 48
                        height: 48
                        anchors.horizontalCenter: parent.horizontalCenter
                        source: Quickshell.iconPath(modelData.icon)
                    }

                    Text {
                        text: modelData.name
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                        elide: Text.ElideRight
                        color: "white"
                        font {
                            family: Preferences.defaultFont.font.family
                            pixelSize: 12
                            bold: true
                        }
                    }
                }
            }
        }
    }
}
