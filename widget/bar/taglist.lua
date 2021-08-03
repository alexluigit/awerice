local awful = require("awful")
local gears = require("gears")
local cfg = require("gears.filesystem").get_configuration_dir()
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local modkey = "Mod4"

local get_taglist = function(s)
  local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({modkey}, 1, function(t) if client.focus then client.focus:move_to_tag(t) end end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({modkey}, 3, function(t) if client.focus then client.focus:toggle_tag(t) end end),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end))
  local tag_icon = function(name, color)
     local icon_path = gears.surface.load_uncached(cfg .. "icons/" .. name .. ".png")
     return gears.color.recolor_image(icon_path, color)
  end
  local update_tags = function(self, c3)
    local imgbox = self:get_children_by_id('icon_role')[1]
    if c3.selected then
      imgbox.image = tag_icon("pacman", beautiful.xcolor3)
    elseif #c3:clients() == 0 then
      imgbox.image = tag_icon("dot", beautiful.xcolor8)
    else
      imgbox.image = tag_icon("ghost", beautiful.xcolor6)
    end
  end
  local pac_taglist = awful.widget.taglist {
    screen = s,
    filter = awful.widget.taglist.filter.all,
    style = {shape = gears.shape.rectangle},
    layout = {spacing = 0, layout = wibox.layout.fixed.horizontal},
    widget_template = {
      {
        {id = 'icon_role', widget = wibox.widget.imagebox},
        id = 'margin_role',
        top = dpi(7),
        bottom = dpi(7),
        left = dpi(10),
        right = dpi(10),
        widget = wibox.container.margin
      },
      id = 'background_role',
      widget = wibox.container.background,
      create_callback = function(self, c3, index, objects)
        update_tags(self, c3)
        self:connect_signal('mouse::enter', function()
          if self.bg ~= beautiful.xbackground .. "60" then
            self.backup = self.bg
            self.has_backup = true
          end
          self.bg = beautiful.xbackground .. "60"
        end)
        self:connect_signal('mouse::leave', function()
          if self.has_backup then
            self.bg = self.backup
          end
        end)
      end,
      update_callback = function(self, c3, index, objects)
        update_tags(self, c3)
      end
    },
    buttons = taglist_buttons
  }
  return pac_taglist
end

return get_taglist
