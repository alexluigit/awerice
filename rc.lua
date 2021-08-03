require("beautiful").init(os.getenv("XDG_CONFIG_HOME") .. "/awesome/theme.lua")
require("widget")
require("window")
require("keys")
require("rules")
require("ears")

collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
