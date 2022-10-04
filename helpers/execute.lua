local awful = require("awful")

local execute = function (t)
  if t.k then
    if type(t.k) == "string" then
      awful.spawn("xvkbd -xsendevent -text " .. t.k)
    else
      root.fake_input("key_press", t.k)
      root.fake_input("key_release", t.k)
    end
  elseif t.c then
    awful.spawn(t.c, false)
  else
    local awe_cmd = t.a
    local awe_args = t.A
    awe_cmd(awe_args)
  end
end

return execute
