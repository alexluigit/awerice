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

local wrap_widget = function(w)
  return wibox.widget {
    w,
    top = dpi(5),
    left = dpi(4),
    bottom = dpi(5),
    right = dpi(4),
    widget = wibox.container.margin
  }
end

local make_pill = function(w, c)
  return wibox.widget {
    w,
    bg = beautiful.xcolor0,
    shape = shapes.rrect(10),
    widget = wibox.container.background
  }
end

screen.connect_signal (
  "request::desktop_decoration", function(s)
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mytaglist = get_taglist(s)
    s.mytasklist = get_tasklist(s)
    s.mywibox = awful.wibar({position = "bottom", screen = s})
    s.mywibox:setup{
      layout = wibox.layout.align.vertical,
      {
        {
          layout = wibox.layout.align.horizontal,
          expand = "none",
          {
            layout = wibox.layout.fixed.horizontal,
            shapes.horizontal_pad(4),
            wrap_widget(
              make_pill(
                {
                  awesome_icon,
                  {
                    s.mytaglist,
                    shapes.horizontal_pad(4),
                    layout = wibox.layout.fixed.horizontal
                  },
                  spacing = 14,
                  spacing_widget = {
                    color = beautiful.xcolor8,
                    shape = shapes.pgram(5),
                    widget = wibox.widget.separator
                  },
                  layout = wibox.layout.fixed.horizontal
                }
              )
            ),
            s.mypromptbox,
            wrap_widget(make_pill(playerctl_bar, beautiful.xcolor8))
          },
          {wrap_widget(s.mytasklist), widget = wibox.container.constraint},
          {
            wrap_widget(make_pill(timedate, beautiful.xcolor0 .. 55)),
            wrap_widget(make_pill(
                          {
                            s.mylayoutbox,
                            top = dpi(5),
                            bottom = dpi(5),
                            right = dpi(8),
                            left = dpi(8),
                            widget = wibox.container.margin
                          },
                          beautiful.xcolor8 .. 90)),
            wrap_widget(awful.widget.only_on_screen(final_systray, screen[1])),
            shapes.horizontal_pad(4),
            layout = wibox.layout.fixed.horizontal
          }
        },
        widget = wibox.container.background,
        bg = beautiful.wibar_bg_secondary
      },
      { -- This is for a bottom border in the bar
        widget = wibox.container.background,
        bg = beautiful.xcolor0,
        forced_height = beautiful.widget_border_width
      }
    }
end)

awesome.connect_signal(
  "widgets::splash::visibility", function(vis)
    screen.primary.mywibox.visible = not vis
end)
