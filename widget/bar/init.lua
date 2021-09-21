local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local shapes = require("helpers.shape")

local awesome_icon = require(... .. ".awesome_icon")
local get_taglist = require(... .. ".taglist")
local final_systray = require(... .. ".systray")
local get_tasklist = require(... .. ".tasklist")
local playerctl_bar = require(... .. ".playerctl")
local timedate = require(... .. ".timedate")

local make_pill = function(widget, color, top, left, bottom, right)
  return wibox.widget {
    {
      widget,
      bg = color or beautiful.xcolor0,
      shape = shapes.rrect(10),
      widget = wibox.container.background
    },
    top = dpi(top or 5),
    left = dpi(left or 4),
    bottom = dpi(bottom or 5),
    right = dpi(right or 4),
    widget = wibox.container.margin
  }
end

local setup_wibar = function(s)
  local hrz = wibox.layout.fixed.horizontal
  local ar_layoutbox = awful.widget.layoutbox(s)
  local ar_taglist = get_taglist(s)
  local ar_tasklist = get_tasklist(s)
  s.ar_wibox = awful.wibar({position = "bottom", screen = s})
  s.ar_wibox:setup {
    { -- Left segment
      make_pill({awesome_icon, ar_taglist, spacing = 10, layout = hrz}),
      make_pill(playerctl_bar, beautiful.xcolor8),
      layout = hrz,
    },
    { -- Center segment
      make_pill(ar_tasklist),
      layout = hrz,
    },
    { -- Right segment
      make_pill(timedate, beautiful.xcolor8 .. 95),
      make_pill(ar_layoutbox, beautiful.xcolor8 .. 90, 10, 10, 10, 10),
      make_pill(awful.widget.only_on_screen(final_systray, s)),
      layout = hrz
    },
    expand = "none",
    layout = wibox.layout.align.horizontal,
    widget = wibox.container.background,
  }
end

screen.connect_signal ("request::desktop_decoration", setup_wibar)

awesome.connect_signal(
  "widgets::splash::visibility", function(vis)
    screen.primary.ar_wibox.visible = not vis
end)
