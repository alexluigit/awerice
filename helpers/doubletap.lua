local awful = require("awful")
local gears = require("gears")
local double_tap_timer = nil

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
  if cmd then
    awful.spawn(cmd, false)
  else
    awe_cmd(awe_arg)
  end
end

local function doubletap(single_tap_cmd, double_tap_cmd)
  if double_tap_timer then
    double_tap_timer:stop()
    double_tap_timer = nil
    _run_cmd(double_tap_cmd)
    return
  end

  double_tap_timer = gears.timer.start_new(
    0.2,
    function()
      double_tap_timer = nil
      _run_cmd(single_tap_cmd)
      return false
  end)
end

return doubletap
