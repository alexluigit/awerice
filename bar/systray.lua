local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local shapes = require("helpers.shape")

local systray = function()
  local mysystray = wibox.widget.systray()
  mysystray:set_base_size(beautiful.systray_icon_size)
  return wibox.widget {{{
        mysystray,
        left = dpi(8),
        right = dpi(8),
        top = dpi(6),
        widget = wibox.container.margin
      },
      layout = wibox.container.margin
    },
    bg = beautiful.xcolor0,
    shape = shapes.rrect(beautiful.border_radius - 3),
    widget = wibox.container.background
  }
end

return systray
