local gears = require("gears")
local execute = require("helpers.execute")
local double_tap_timer = nil
local kv = {}

function kv.doubletap(single_tap_cmd, double_tap_cmd)
  if double_tap_timer then
    double_tap_timer:stop()
    double_tap_timer = nil
    execute(double_tap_cmd)
    return
  end

  double_tap_timer = gears.timer.start_new(
    0.2,
    function()
      double_tap_timer = nil
      execute(single_tap_cmd)
      return false
  end)
end

function kv.simulate(key_code)
  execute({k=key_code})
end

return kv
