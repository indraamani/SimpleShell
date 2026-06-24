local clickCount = 0
local timerActive = false

local function resetClickWindow() 
    clickCount = 0
    timerActive = false 
end

hl.bind(
    "mouse:273",
    function ()
        clickCount = clickCount + 1
        if clickCount == 2 then 
            hl.dispatch(hl.dsp.window.drag())
            resetClickWindow()
        else 
            if not timerActive then
                hl.timer(function ()
                    resetClickWindow()
                end, {
                    timeout = 300,
                    type = "oneshot"
                })
            end
        end
    end,
    {
        non_consuming = true,
        mouse = true
    }
)

hl.bind(
    "mouse:273", 
    function ()
        if clickCount == 0 then 
            resetClickWindow()
        end
    end,
    {
        non_consuming = true,
        release = true,
        mouse = true
    }
)
