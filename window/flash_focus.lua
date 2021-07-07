local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

local op_st = beautiful.flash_focus_start_opacity or 0.6
local op_ed = beautiful.flash_focus_start_opacity or 1
local step = beautiful.flash_focus_step or 0.01
local fg_rule = beautiful.flash_focus_transparent_fg_rule
local bg_rule = beautiful.flash_focus_transparent_bg_rule

local flashfocus = function(c)
  local clients = awful.screen.focused().selected_tag:clients()
  if c then
    -- Make apps match fg_rule use lower opacity value
    if bg_rule then
      for _, client in ipairs(clients) do
        if awful.rules.match_any(client, bg_rule) then
          op_ed = 0.7
          break
        end
      end
    end
    c.opacity = op_st
    local q = op_st
    local g = gears.timer {
      timeout = step,
      call_now = false,
      autostart = true
    }
    -- Increase opacity to maximum by step
    g:connect_signal (
      "timeout",
      function()
        if not c.valid then return end
        if not awful.rules.match_any(c, fg_rule) then op_ed = 1 end
        if q >= op_ed then c.opacity = op_ed; g:stop()
        else c.opacity = q; q = q + step
        end
    end)
  end
  -- Bring the focused client to the top
  if c then c:raise() end
end

client.connect_signal("focus", flashfocus)
