-- Monitor 
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1,
})

-- General 
hl.config({
    general = {
        gaps_in = 4,
        gaps_out = 8,

        border_size = 2,

        col = {
            active_border = "rgba(0DB7D455)",
            inactive_border = "rgba(31313600)"
        },
        resize_on_border = true,

        no_focus_fallback = true,
        allow_tearing = true, -- This just allows the `immediate` window rule to work
        snap = {
            enabled = true,
            window_gap = 4,
            monitor_gap = 5,
            respect_gaps = true
        },
        layout = "dwindle",

    }
})

-- Dwindle Layout 
hl.config({ 
    dwindle = {
        preserve_split = true,
        smart_split = false,
        smart_resizing = false
    }
})

-- Misc 
hl.config({
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        vrr = 0,
        mouse_move_enables_dpms = false,
        key_press_enables_dpms = true ,
        animate_manual_resizes = false,
        animate_mouse_windowdragging = true,
        enable_swallow = false,
        swallow_regex = "^(foot|kitty|allacritty|Alacritty)$",
        focus_on_activate = true,
        allow_session_lock_restore = true ,
        session_lock_xray = true,
        close_special_on_empty = true,
        initial_workspace_tracking = true ,
    },
    xwayland = {
        force_zero_scaling = true
    }
})

-- Extras 
hl.config({ 
    ecosystem = { 
        no_update_news = true,
        no_donation_nag = true,
    },

    plugin = { },

    master = {
        new_status = "master"
    },
})
