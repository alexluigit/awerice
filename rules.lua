local ruled = require("ruled")
local awful = require("awful")
local browser_class = require("beautiful").browser_class
require("awful.autofocus")

screen.connect_signal(
  "request::desktop_decoration", function(s)
    screen[s].padding = {left = 0, right = 0, top = 0, bottom = 0}
    awful.tag({"1", "2", "3", "4", "5"}, s, awful.layout.layouts[1])
end)

ruled.client.connect_signal (
  "request::rules", function()
    ruled.client.append_rule {
      id = "global",
      rule = {},
      properties = {
        focus = awful.client.focus.filter,
        raise = true,
        size_hints_honor = false,
        screen = awful.screen.preferred,
        placement = awful.placement.centered + awful.placement.no_overlap +
          awful.placement.no_offscreen
      },
      callback = awful.client.setslave
    }
    ruled.client.append_rule {
      id = "floating",
      rule_any = {
        role = {"pop-up"}
      },
      except = {class = browser_class},
      properties = {floating = true}
    }
    ruled.client.append_rule {
      rule = {class="kdenlive"},
      properties = {
        tag = "3",
        raise = true,
        switch_to_tags = true
      }
    }
    ruled.client.append_rule {
      rule_any = { class = {"Gimp.*", "Inkscape" } },
      properties = {
        tag = "4",
        raise = true,
        switch_to_tags = true
      }
    }
    ruled.client.append_rule {
      rule = {class="obs"},
      properties = {
        tag = "5",
        raise = true,
        switch_to_tags = true
      }
    }
end)
