local mainMod = "SUPER"

-- Apps 
local terminal = "kitty"
local browser = "brave"
local fileManager = "nautilus -w"
local clipboard = "kitty --class clipse -e 'clipse'"
local ssCommand = "grim -g \"$(slurp)\" - | satty --filename - --output-filename ~/Pictures/Screenshots/Image-$(date '+%m%d-%H:%M').png"

-- MainMod Key bind
hl.bind(mainMod .. " + SUPER_L", hl.dsp.exec_cmd("qs ipc call launcher changeVisiblity"))
-- Alphabet Key Binds

hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("android-studio"))
--hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(""))
hl.bind(mainMod .. " + C", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + D", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
--hl.bind(mainMod .. " + G", hl.dsp.exec_cmd())
--hl.bind(mainMod .. " + H", hl.dsp.exec_cmd())
--hl.bind(mainMod .. " + I", hl.dsp.exec_cmd())
hl.bind(mainMod .. " + J", hl.dsp.exec_cmd(terminal))
--hl.bind(mainMod .. " + K", hl.dsp.exec_cmd())
--hl.bind(mainMod .. " + L", hl.dsp.exec_cmd())
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd(clipboard))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("hypremoji"))
--hl.bind(mainMod .. " + O", hl.dsp.exec_cmd())
--hl.bind(mainMod .. " + P", hl.dsp.exec_cmd())
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
--hl.bind(mainMod .. " + R", hl.dsp.exec_cmd())
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(ssCommand))
hl.bind(mainMod .. " + T", hl.dsp.layout("togglesplit"))
--hl.bind(mainMod .. " + U", hl.dsp.exec_cmd())
--hl.bind(mainMod .. " + V", hl.dsp.exec_cmd())
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(browser))
--hl.bind(mainMod .. " + X", hl.dsp.exec_cmd())
--hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd())
--hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd())

-- Special Keys

hl.bind(
    "XF86AudioMute", 
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle "),
    { locked = true } 
)

hl.bind(
    "XF86AudioMicMute", 
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), 
    { locked = true} 
)

hl.bind(
    "XF86MonBrightnessUp", 
    hl.dsp.exec_cmd("brightnessctl s 5%+"), 
    { repeating = true, locked = true }
)

hl.bind(
    "XF86MonBrightnessDown", 
    hl.dsp.exec_cmd("brightnessctl s 5%-"), 
    { repeating = true, locked = true }
)

hl.bind(
    "XF86AudioRaiseVolume", 
    hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"),
    { repeating = true, locked = true }
)

hl.bind(
    "XF86AudioLowerVolume", 
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), 
    { repeating = true, locked = true }
)



hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { release = true, locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { release = true, locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { release = true, locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { release = true, locked = true })


-- Other 

hl.bind(mainMod .. " + ALT + Space", hl.dsp.window.float({ action = "toggle" }))

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" })) 
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" })) 
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" })) 
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" })) 

hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))


hl.bind("CTRL + SUPER + left", hl.dsp.focus({ workspace = "r-1" }))
hl.bind("CTRL + SUPER + right", hl.dsp.focus({ workspace = "r+1" }))


hl.bind("CTRL + SUPER + SHIFT + left", hl.dsp.window.move({ workspace = "r-1" }))
hl.bind("CTRL + SUPER + SHIFT + right", hl.dsp.window.move({ workspace = "r+1" }))

-- Mouse 

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
