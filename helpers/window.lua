local awful = require("awful")

local _window = {}

--- Turn off passed client
-- Remove current tag from window's tags
-- @param c a client
function _window.turn_off(c)
    local current_tag = awful.tag.selected(c.screen)
    local ctags = {}
    for k, tag in pairs(c:tags()) do
        if tag ~= current_tag then table.insert(ctags, tag) end
    end
    c:tags(ctags)
end

--- Turn on passed client (add current tag to window's tags)
-- @param c A client
function _window.turn_on(c)
    local current_tag = awful.tag.selected(c.screen)
    ctags = {current_tag}
    for k, tag in pairs(c:tags()) do
        if tag ~= current_tag then table.insert(ctags, tag) end
    end
    c:tags(ctags)
    c:raise()
    client.focus = c
end

--- Sync two clients
-- @param to_c The client to which to write all properties
-- @param from_c The client from which to read all properties
function _window.sync(to_c, from_c)
    if not from_c or not to_c then return end
    if not from_c.valid or not to_c.valid then return end
    if from_c.modal then return end
    to_c.floating = from_c.floating
    to_c.maximized = from_c.maximized
    to_c.above = from_c.above
    to_c.below = from_c.below
    to_c:geometry(from_c:geometry())
end

-- Resize client
local floating_resize_amount = require("beautiful").xresources.apply_dpi(20)
local tiling_resize_factor = 0.05
---------------
function _window.resize_dwim(c, direction)
    if awful.layout.get(mouse.screen) == awful.layout.suit.floating or
        (c and c.floating) then
        if direction == "up" then
            c:relative_move(0, 0, 0, -floating_resize_amount)
        elseif direction == "down" then
            c:relative_move(0, 0, 0, floating_resize_amount)
        elseif direction == "left" then
            c:relative_move(0, 0, -floating_resize_amount, 0)
        elseif direction == "right" then
            c:relative_move(0, 0, floating_resize_amount, 0)
        end
    else
        if direction == "up" then
            awful.client.incwfact(-tiling_resize_factor)
        elseif direction == "down" then
            awful.client.incwfact(tiling_resize_factor)
        elseif direction == "left" then
            awful.tag.incmwfact(-tiling_resize_factor)
        elseif direction == "right" then
            awful.tag.incmwfact(tiling_resize_factor)
        end
    end
end

function _window.toggle_maximize (c)
  c.maximized = not c.maximized
  if c.maximized then c.border_width = 0 end
  c:raise()
end

local _run_cmd = function (t)
  local cmd = nil
  local awe_cmd
  local awe_args
  if t.k then
    cmd = "xvkbd -xsendevent -text " .. t.k
  elseif t.c then
    cmd = t.c
  else
    awe_cmd = t.a; awe_arg = t.A
  end
  if cmd then awful.spawn(cmd, false) else awe_cmd(awe_arg) end
end

function _window.last_window ()
  local c = awful.client.focus.history.list[2]
  local s = awful.screen.focused()
  client.focus = c
  local t = client.focus and client.focus.first_tag or nil
  if t then t:view_only() else awful.tag.history.restore (s, -1) end
  c:raise()
end

function _window.if_match (rule, match, no_match)
  local c = client.focus
  if c and awful.rules.match_any(c, rule) then
    _run_cmd(match)
  else
    _run_cmd(no_match)
  end
end

-- ror stands for 'run or raise'
function _window.ror (rule, tag, match, no_match)
  local s = awful.screen.focused()
  local focus = client.focus
  local target_tag = tag or awful.tag.selected().index
  local has_instance
  if focus and awful.rules.match_any(focus, rule) then
    if type(match) == "boolean" then
      if match then _window.last_window() end
    else _run_cmd(match)
    end
  else
    for _, c in ipairs(s.tags[target_tag]:clients()) do
      if awful.rules.match_any(c, rule) then
        has_instance = c
        break
      end
    end
    s.tags[target_tag]:view_only()
    if has_instance then
      client.focus = has_instance
      has_instance:raise()
    else
      _run_cmd(no_match)
    end
  end
end

return _window
