local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local shapes = require("helpers.shape")

local song_title = wibox.widget {
  align = 'center',
  valign = 'center',
  widget = wibox.widget.textbox
}
local song_artist = wibox.widget {
  align = 'center',
  valign = 'center',
  widget = wibox.widget.textbox
}
local song_logo = wibox.widget {
  markup = '<span foreground="' .. beautiful.xcolor6 .. '"></span>',
  font = beautiful.icon_font,
  align = 'center',
  valign = 'center',
  widget = wibox.widget.textbox
}
local playerctl_bar = wibox.widget {
  {
    {
      {
        song_logo,
        left = dpi(3),
        right = dpi(10),
        bottom = dpi(1),
        widget = wibox.container.margin
      },
      {
        {
          song_title,
          expand = "outside",
          layout = wibox.layout.align.vertical
        },
        left = dpi(10),
        right = dpi(10),
        widget = wibox.container.margin
      },
      {
        {
          song_artist,
          expand = "outside",
          layout = wibox.layout.align.vertical
        },
        left = dpi(10),
        widget = wibox.container.margin
      },
      spacing = 1,
      spacing_widget = {
        bg = beautiful.xcolor8,
        widget = wibox.container.background
      },
      layout = wibox.layout.fixed.horizontal
    },
    left = dpi(10),
    right = dpi(10),
    widget = wibox.container.margin
  },
  bg = beautiful.xcolor0,
  shape = shapes.rrect(beautiful.border_radius - 3),
  visible = true,
  widget = wibox.container.background
}

local function playerctl_stopped()
  local s = "Nothing playing"
  song_title.markup = '<span foreground="' .. beautiful.xcolor5 .. '">' .. s .. '</span>'
end

local function playerctl_update(title, artist, _)
  if string.len(title) > 40 then song_title.forced_width = 400
  else song_title.forced_width = nil
  end
  if string.len(artist) > 20 then song_artist.forced_width = 200
  else song_artist.forced_width = nil
  end
  song_title.markup = '<span foreground="' .. beautiful.xcolor5 .. '">' .. title .. '</span>'
  song_artist.markup = '<span foreground="' .. beautiful.xcolor4 .. '">' .. artist .. '</span>'
end

awesome.connect_signal("bling::playerctl::player_stopped", playerctl_stopped)
awesome.connect_signal("bling::playerctl::title_artist_album", playerctl_update)

return playerctl_bar
