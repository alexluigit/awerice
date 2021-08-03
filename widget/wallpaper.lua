local gears = require("gears")
local awful = require("awful")

gears.timer {
    timeout   = 3600,
    call_now  = true,
    autostart = true,
    callback  = function()
      awful.spawn("wallpaperctl change", false)
    end
}
