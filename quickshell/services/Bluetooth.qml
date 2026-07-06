pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Blutooth

Singleton {

    readonly property var adapter: Blutooth.defaultAdapter
    readonly property var connectedDevice: Blutooth.devices.values.filter(device => device.connected)
    readonly property bool powered: adapter?.enabled ?? false
    readonly property bool connected: connectedDevice?.length > 0
    readonly property string deviceName: connected ? (connectedDevice[0]?.name ?? connectedDevice[0]?.alias ?? "Device") : ""
    readonly property int connectedCount: connectedDevice.length

    function togglePower() {
        if (adapter)
            adapter.enabled = !adapter.enabled
    }

    function setDiscovering(enabled : bool) {
        if (adapter)
            adapter.discovering = enabled
    }

}