local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local shapes = require("helpers.shape")
local dpi = xresources.apply_dpi

local tasklist = function(s)
  local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
    if c == client.focus then c.minimized = true
    else c:emit_signal("request::activate", "tasklist", {raise = true}) end
    end),
    awful.button({}, 3, function() awful.menu.client_list({theme = {width = 250}}) end),
    awful.button({}, 4, function() awful.client.focus.byidx(1) end),
    awful.button({}, 5, function() awful.client.focus.byidx(-1) end))
  return awful.widget.tasklist {
    screen = s,
    filter = awful.widget.tasklist.filter.currenttags,
    buttons = tasklist_buttons,
    -- bg = beautiful.wibar_bg,
    style = {bg = beautiful.wibar_bg, shape = shapes.rrect(10)},
    layout = {
        spacing = dpi(8),
        layout = wibox.layout.fixed.horizontal
    },
    widget_template = {
        {
            {
                {
                    awful.widget.clienticon,
                    top = dpi(1),
                    bottom = dpi(1),
                    right = dpi(1),
                    layout = wibox.container.margin
                },
                shapes.horizontal_pad(6),
                {id = 'text_role', widget = wibox.widget.textbox},
                layout = wibox.layout.fixed.horizontal
            },
            top = dpi(5),
            bottom = dpi(5),
            left = dpi(10),
            right = dpi(10),
            widget = wibox.container.margin
        },
        id = "background_role",
        widget = wibox.container.background
    }
} end

return tasklist
