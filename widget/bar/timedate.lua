local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local shapes = require("helpers.shape")

local time_text = wibox.widget {
    font = beautiful.font_name .. "13",
    format = "%l:%M %p",
    align = "center",
    valign = "center",
    widget = wibox.widget.textclock
}

time_text.markup = "<span foreground='" .. beautiful.xcolor5 .. "'>"
  .. "<b>" .. time_text.text .. "</b>" .. "</span>"

time_text:connect_signal("widget::redraw_needed", function()
    time_text.markup = "<span foreground='" .. beautiful.xcolor5 .. "'>"
      .. "<b>" .. time_text.text .. "</b>" .. "</span>"
end)

local date_text = wibox.widget {
    font = beautiful.font,
    format = "%m/%d %a",
    align = "center",
    valign = "center",
    widget = wibox.widget.textclock
}

date_text.markup = "<span foreground='" .. beautiful.xcolor11 .. "'>" ..
                       date_text.text .. "</span>"

date_text:connect_signal("widget::redraw_needed", function()
    date_text.markup = "<span foreground='" .. beautiful.xcolor11 .. "'>" ..
                           date_text.text .. "</span>"
end)

return wibox.widget {
    {
        {time_text, top = dpi(1), widget = wibox.container.margin},
        shapes.horizontal_pad(20),
        {date_text, top = dpi(1), widget = wibox.container.margin},
        layout = wibox.layout.fixed.horizontal
    },
    left = dpi(10),
    right = dpi(10),
    widget = wibox.container.margin
}
