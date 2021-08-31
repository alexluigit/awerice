local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gears = require("gears")

local awesome_icon = wibox.widget {
    {
        wibox.widget {
            widget = wibox.widget.imagebox,
            image = beautiful.distro_logo,
            resize = true
        },
        top = dpi(5),
        bottom = dpi(5),
        left = dpi(10),
        right = dpi(5),
        widget = wibox.container.margin
    },
    bg = beautiful.xcolor0,
    widget = wibox.container.background
}

awesome_icon:buttons(gears.table.join(awful.button({}, 1, function()
    awful.spawn("rofi -show run", false)
end)))

return awesome_icon
