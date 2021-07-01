local gears = require("gears")
local beautiful = require("beautiful")

local op_st = beautiful.flash_focus_start_opacity or 0.6
local op_ed = 1
local stp = beautiful.flash_focus_step or 0.01

local flashfocus = function(c)
    if c then
        if c.class == "Emacs" then op_ed = 0.92 end
        c.opacity = op_st
        local q = op_st
        local g = gears.timer {
            timeout = stp,
            call_now = false,
            autostart = true
        }

        g:connect_signal("timeout", function()
            if not c.valid then return end
            if q >= op_ed then
                c.opacity = op_ed
                g:stop()
            else
                c.opacity = q
                q = q + stp
            end
        end)
    end

    -- Bring the focused client to the top
    if c then c:raise() end
end

client.connect_signal("focus", flashfocus)
