pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: network

    readonly property list<AccessPoint> networks: []
    readonly property AccessPoint active: networks.find(n => n.active) ?? null
    property bool wifiEnabled: true
    readonly property bool scanning: rescanProc.running

    readonly property bool connected: active !== null
    readonly property string ssid: active?.ssid ?? "Not Connected"
    readonly property int signalStrength: active?.strength ?? null

    property var savedNetworks: []
    property var _preSavedNetwork: []

    // Consumer Functions and variable
    property bool pollingActive: true

    function enableWifi(enabled: bool) : void {
        const cmd = enabled ? "on" : "off"
        enableProc.exec(["nmcli", "radio", "wifi", cmd])
    }

    function toggleWifi() {
        const cmd = wifiEnabled ? "off" : "on"
        enableProc.exec(["nmcli", "radio", "wifi", cmd])
    }

    function rescanWifi() {
        rescanProc.running = true
    }

    function connectToNetwork(ssid: string, password: string) : void{

        if(!ssid || ssid.trim().length === 0) {
            return
        }

        const dangerousChars = [";", "`", "$", "|", "&", "\n", "\r", "\\"]
        for (let i = 0; i < dangerousChars.length; i++) {
            if (ssid.includes(dangerousChars[i])) {
                return
            }
        }

        if (password && password.length > 0) {
            connectProc.exec(["nmcli", "dev", "wifi", "connect", ssid, "password", password]);
        } else {
            connectProc.exec(["nmcli", "connection", "up", "id", ssid]);
        }
    }

    function refreshSavedNetwork() {
        checkSavedWifi.running = true
    }

    function isNetworkSaved(ssid: string): bool {
        return savedNetworks.includes(ssid);
    }

    function disconnectFromNetwork() {
        if(active) {
            disconnectProc.exce(["nmcli", "connection", "down", active.ssid])
        }
    }

    function getWifiStatus() {
        wifiStatus.running = true
    }

    Process {
        running: true
        command: ["nmcli", "m"]
        stdout: SplitParser {
            onRead: getNetworks.running = true
        }
    }
    Process {
        id: wifiStatus
        running: true
        command: ["nmcli", "radio","wifi"]

        stdout: StdioCollector {
            onStreamFinished: {
                network.wifiEnabled = text.trim() === "enabled"
            }
        }
    }

    Process {
        id: enableProc

        onExited: {
            network.getWifiStatus()
            getNetworks.running = true
        }
    }

    Process {
        id: rescanProc
        command: ["nmcli","dev","wifi","list","--rescan", "yes"]
        environment: ({
                LANG: "C.UTF-8",
                LC_ALL: "C.UTF-8"
            })
        onExited: {
            getNetworks.running = true
        }
    }

    Process {
        id: connectWifi

        stdout: SplitParser {
            onRead: data => {
                getNetworks.running = true
            }
        }

        stderr: StdioCollector {
            onStreamFinished: {


            }
        }

        onExited: (code, status) => {
            getNetworks.running = true
        }
    }

    Process {
        id: disconnectProc

        stdout: SplitParser {
            onRead: {
                getNetworks.running = true
            }
        }
    }

    Process {
        id: checkSavedWifi
        command: ["nmcli", "-g", "NAME", "connection", "show"]
        environment: ({
                LANG: "C.UTF-8",
                LC_ALL: "C.UTF-8"
            })
        stdout: StdioCollector {
            onStreamFinished: {
                network.savedNetworks = text.trim().split('\n').filter(n => n.length > 0)
                const current = network.savedNetworks
                const prev = network._preSavedNetwork
                let changed = current.length !== prev.length

                if(!changed) {
                    for(let i = 0; i < current.length; i++) {
                        if(current[i] !== prev[i]) {
                            changed = true
                            break
                        }
                    }
                }

                if(changed) {
                    network._preSavedNetwork = current.slice(0)
                }
            }
        }
    }

    Process {
        id: getNetworks

        running: true
        command: ["nmcli", "-g", "ACTIVE,SIGNAL,FREQ,SSID,BSSID,SECURITY", "d", "w"]
        environment: ({
                LANG: "C.UTF-8",
                LC_ALL: "C.UTF-8"
            })
        stdout: StdioCollector {
            onStreamFinished: {
                const PLACEHOLDER = "STRINGWHICHHOPEFULLYWONTBEUSED";
                const rep = new RegExp("\\\\:", "g");
                const rep2 = new RegExp(PLACEHOLDER, "g");


                const allNetworks = text.trim().split('\n').map(n => {
                    const net = n.replace(rep, PLACEHOLDER).split(":")

                    return {
                        active: net[0] === "yes",
                        strength: parseInt(net[1]),
                        frequency: parseInt(net[2]),
                        ssid: net[3]?.replace(rep2, ":") ?? "",
                        bssid: net[4]?.replace(rep2, ":") ?? "",
                        security: net[5] ?? ""
                    }
                }).filter(n => n.ssid && n.ssid.length > 0)

                const networkMap = new Map()
                for (const networkk of allNetworks) {
                    const existing = networkMap.get(networkk.ssid)
                    if(!existing) {
                        networkMap.set(networkk.ssid, networkk)
                    } else {
                        if (networkk.active && !existing.active) {
                            networkMap.set(networkk.ssid, networkk);
                        } else if (!networkk.active && !existing.active) {
                            // If both are inactive, keep the one with better signal
                            if (networkk.strength > existing.strength) {
                                networkMap.set(networkk.ssid, networkk);
                            }
                        }
                    }
                }

                const networks = Array.from(networkMap.values())

                const rNetworks = network.networks

                const destroyed = rNetworks.filter(rn => !networks.find(n => n.frequency === rn.frequency && n.ssid === rn.ssid && n.bssid === rn.bssid))

                for (const networkk of destroyed)
                    rNetworks.splice(rNetworks.indexOf(networkk), 1).forEach(n => n.destroy())

                for (const networkk of networks) {
                    const match = rNetworks.find(n => n.frequency === networkk.frequency && n.ssid === networkk.ssid && n.bssid === networkk.bssid);
                    if (match) {
                        match.lastIpcObject = networkk;
                    } else {
                        rNetworks.push(apComp.createObject(network, {
                            lastIpcObject: networkk
                        }));
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        refreshSavedNetwork()
    }

    Timer {
        interval: 10000
        running: network.pollingActive
        repeat: true
        onTriggered: refreshSavedNetwork()
    }

    component AccessPoint: QtObject {
        required property var lastIpcObject
        readonly property string ssid: lastIpcObject.ssid
        readonly property string bssid: lastIpcObject.bssid
        readonly property int strength: lastIpcObject.strength
        readonly property int frequency: lastIpcObject.frequency
        readonly property bool active: lastIpcObject.active
        readonly property string security: lastIpcObject.security
        readonly property bool isSecure: security.length > 0
    }

    Component {
        id: apComp

        AccessPoint {}
    }
}