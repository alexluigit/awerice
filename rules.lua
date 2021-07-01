local ruled = require("ruled")
local awful = require("awful")
require("awful.autofocus")

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
      }
    }
    ruled.client.append_rule {
      id = "floating",
      rule_any = {
        role = {"pop-up"}
      },
      properties = {floating = true}
    }
    ruled.client.append_rule {
      id = "ontop",
      rule_any = {
        class = {"mpv", "BraveDev"}
      },
      callback = function(c) c:connect_signal("property::fullscreen", function() if not c.fullscreen then c.ontop = true end end) end,
        properties = {ontop = true}
    }
    ruled.client.append_rule {
      id = "desktop",
      rule_any = {
        name = {"YouTube Music"}
      },
      properties = {
        tag = "3",
        switch_to_tags = true
      },
    }
end)
