-- Input 
hl.config({
    input = { 
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",

        follow_mouse = 1,

        sensitivity = 0,
    
        touchpad = {
            natural_scroll = true,
            disable_while_typing = true,
            --tap-to-click = true,
            --tap-and-drag = true,
        },
    },
})

-- Gestures
hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

-- Device 
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})
