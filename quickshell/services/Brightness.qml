pragma Singleton 

import QtQuick 
import Quickshell 
import Quickshell.Io 

Singleton {
    id: root 

    property real brightness: 0.5
    property real maxBrightness: 1.0 

    property string _backlitDevice: "" 
    readonly property string backlightPath: _backlitDevice !== "" ? `/sys/class/backlight/${_backlitDevice}/brightness` : ""
    readonly property string maxBrightnessPath: _backlitDevice !== "" ? `/sys/class/backlight/${_backlitDevice}/max_brightness` : ""

    property int currentValue: 0 
    property int maxValue: 255 

    Component.onCompleted: {
        detectBacklitDevice()
        readMaxBrightness()  
        readBrightness() 
        updateTimer.start()
    }

    function detectBacklitDevice() {
        detectProc.running = true
    }
    
    function readMaxBrightness() {
        if (maxBrightnessPath === "") return
        maxBrightnessProcess.command = ["/bin/cat", maxBrightnessPath]
        maxBrightnessProcess.running = true
    }

    function readBrightness() {
        if (backlightPath === "") return
        brightnessProcess.command = ["/bin/cat", backlightPath]
        brightnessProcess.running = true
    }

    function setBrightness(value) {
        // Clamp between 0 and 1
        const newValue = Math.max(0, Math.min(1, value))

        if (backlightPath === "")
            return

        // Use brightnessctl when available (works for most backlight devices)
        // Fallback to sysfs write when brightnessctl isn't present.
        const percent = Math.round(newValue * 100)
        const sysfsValue = Math.round(newValue * maxValue)
        const cmd = `brightnessctl set ${percent}% || echo ${sysfsValue} | sudo tee "${backlightPath}" >/dev/null; cat "${backlightPath}"`
        setBrightnessProcess.command = ["/bin/sh", "-c", cmd]
        setBrightnessProcess.running = true
        
        // Read brightness will be triggered by the update timer
    }
    
    function increaseBrightness() {
        setBrightness(brightness + 0.05)
    }
    
    function decreaseBrightness() {
        setBrightness(brightness - 0.05)
    }
    
    // Read max brightness
    Process {
        id: detectProc
        command: ["/bin/sh", "-c", "ls -1 /sys/class/backlight 2>/dev/null | head -n 1"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                const dev = text.trim()
                if (dev.length > 0) {
                    root._backlitDevice = dev
                } else {
                    root._backlitDevice = ""
                }

                readMaxBrightness()
                readBrightness()
            }
        }
    }

    Process {
        id: maxBrightnessProcess
        running: false
        
        stdout: SplitParser {
            onRead: data => {
                const value = parseInt(data.trim())
                if (!isNaN(value) && value > 0) {
                    maxValue = value
                }
            }
        }
    }
    
    // Read current brightness
    Process {
        id: brightnessProcess
        running: false
        
        stdout: SplitParser {
            onRead: data => {
                const value = parseInt(data.trim())
                if (!isNaN(value)) {
                    currentValue = value
                    brightness = maxValue > 0 ? value / maxValue : 0
                }
            }
        }
    }
    
    // Set brightness process
    Process {
        id: setBrightnessProcess
        running: false
    }
    
    // Update timer - optimized interval
    Timer {
        id: updateTimer
        interval: 2000  // Reduced frequency from 1000ms to 2000ms (brightness changes infrequently)
        repeat: true
        triggeredOnStart: true  // Get immediate first read
        onTriggered: readBrightness()
    }
     
}
