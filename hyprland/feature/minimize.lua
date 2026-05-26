hl.gesture({
    fingers = 3,
    direction = "bottom",
    action = function () 

        local currentWs = hl.get_active_workspace()
        local allWindow = hl.get_workspace_windows(currentWs)

        for _, win in ipairs(allWindow) do
            hl.dispatch(
                hl.dsp.window.move(
                    {
                        window = "address:" .. win.address,
                        workspace = "special:magic",
                        follow = false
                    }
                )
            )
        end
    end
})

hl.gesture({
    fingers = 3,
    direction = "top",
    action = function () 

        local currentWs = hl.get_active_workspace()
        local allWindow = hl.get_workspace_windows("special:magic")

        for i = #allWindow, 1, -1 do
            local win = allWindow[i]
            hl.dispatch(
                hl.dsp.window.move(
                    {
                        window = "address:" .. win.address,
                        workspace = currentWs,
                        follow = false
                    }
                )
            )
        end
    end
})
