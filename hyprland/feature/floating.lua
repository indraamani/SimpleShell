local windowMode = false 

hl.bind("XF86Favorites", function () 
    windowMode = not windowMode

    if windowMode then 
        hl.window_rule({
            match = { class = ".*" },
            float = true
        })
    else 
        hl.window_rule({
            match = { class = ".*" },
            float = false
        })
    end
end)
