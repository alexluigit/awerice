local awful = require("awful")
local beautiful = require("beautiful")

-- Only show window border when there are more than 1 clients
local border_adjust = function (c)
  if c.maximized or #c.screen.clients == 1 then
    c.border_width = 0
  elseif #c.screen.clients > 1 then
    c.border_width = beautiful.border_width
    c.border_color = beautiful.border_focus
  end
end
client.connect_signal("focus", function(c) border_adjust(c) end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Enable sloppy focus, so that focus follows mouse.
local focus_follow_mouse = function(c)
  c:emit_signal("request::activate", "mouse_enter", {raise = false})
end
client.connect_signal("mouse::enter", function (c) focus_follow_mouse(c) end)

-- Prevent clients from being unreachable after screen count changes.
local readjust_screen_change = function(c)
  if awesome.startup and not c.size_hints.user_position and
    not c.size_hints.program_position then
    awful.placement.no_offscreen(c)
  end
end
client.connect_signal ("manage", function(c) readjust_screen_change(c) end)

-- Unmaximize all windows when a new window is opened
local unmaximize_all = function(c)
  if c.floating then return end
  local t = screen.primary.selected_tag
  for _, tc in ipairs(t:clients()) do tc.maximized = false end
end
client.connect_signal ("request::manage", function(c) unmaximize_all(c) end)

-- Always maximize the only tiling window
local maximize_singleton = function(c)
  local t = screen.primary.selected_tag
  local tiling_counter = 0
  for _, tc in ipairs(t:clients()) do
    if not tc.floating then tiling_counter = tiling_counter + 1 end
  end
  if tiling_counter == 1 then
    for _, tc in ipairs(t:clients()) do
      if not tc.floating then tc.maximized = true end
    end
  end
end
client.connect_signal ("request::manage", function(c) maximize_singleton(c) end)
client.connect_signal ("request::unmanage", function(c) maximize_singleton(c) end)

-- Hide all windows when a splash is shown
local hide_all = function(vis)
  local t = screen.primary.selected_tag
  if vis then
    for _, c in ipairs(t:clients()) do c.hidden = true end
  else
    for _, c in ipairs(t:clients()) do c.hidden = false end
  end
end
awesome.connect_signal ("widgets::splash::visibility", function(vis) hide_all(vis) end)
