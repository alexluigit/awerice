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
      except = {class = "Brave-browser"},
      properties = {floating = true}
    }
end)
