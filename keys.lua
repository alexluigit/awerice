local awful = require("awful")
local W = require("helpers.window")
local K = require("helpers.key_event")
local flameshots_selection = "flameshot gui -p " .. os.getenv("HOME") .. "/Pictures/screenshots"
local flameshots_full = "flameshot full -p " .. os.getenv("HOME") .. "/Pictures/screenshots"
local files = "floatwin -T -n dirvish emacsclient -cn --eval '\\(dirvish\\ \"~/\"\\)'"
local hypkey = "Mod3"
local modkey = "Mod4"

-- Global
awful.keyboard.append_global_keybindings(
  {
    -- Main
    awful.key({}, "KP_Equal", function() K.simulate(0x42) end,
      {description = "Send Caps_Lock", group = "awesome"}),
    awful.key({}, "Insert", W.last_window,
      {description = "Focus last client", group = "awesome"}),
    awful.key({}, "XF86Tools", function() K.doubletap({c="rofi -show combi"}, {c="rofi -show run"}) end,
      {description = "App-launcher (single tap) Dmenu (double tap)", group = "awesome" }),
    awful.key({}, "XF86Eject", function () K.doubletap({k="'\\[F12]'"},{c="powermenu"}) end,
      {description = "F12 (single tap) Powermenu (double tap)", group = "launcher"}),
    -- Launcher
    awful.key({modkey}, "e", function () W.ror({class={"Emacs"}}, 1, true, {c="emacsclient -cn"}) end,
      {description = "Emacs", group = "launcher"}),
    awful.key({modkey}, "y", function () W.ror({name={".*YouTube Music"}}, 2, true, {c="bravectl music"}) end,
      {description = "Youtube music", group = "launcher"}),
    awful.key({modkey}, "f", function() awful.spawn(files, false) end,
      {description = "File manager", group = "launcher"}),
    awful.key({modkey}, "w", function() awful.spawn("bravectl web", false) end,
      {description = "Web browser", group = "launcher" }),
    awful.key({modkey}, "a", function() awful.spawn("bravectl incognito", false) end,
      {description = "Incognito browser", group = "launcher" }),
    awful.key({modkey}, "u", function () awful.spawn("murl -P 10801 -f toggle", false) end,
      {description = "murl", group = "launcher"}),
    awful.key({modkey}, "t", function() awful.spawn("floatwin -T alacritty", false) end,
      {description = "Terminal", group = "launcher"}),
    awful.key({modkey}, "c", function() awful.spawn("xdotool click 1", false) end,
      {description = "Mouse click", group = "launcher"}),
    awful.key({modkey}, "s", function() awful.spawn(flameshots_selection, false) end,
      {description = "Take screenshots by selection", group = "launcher"}),
    awful.key({modkey, "Mod1"}, "s", function() awful.spawn(flameshots_full, false) end,
      {description = "Take full screenshot", group = "launcher"}),
    awful.key({modkey}, "q", function() client.focus:kill() end,
      {description = "close window", group = "launcher"}),
    -- Media Keys
    awful.key({}, "F1", function() K.doubletap({k="'\\[F1]'"}, {a=W.hotkeys}) end,
      {description = "show help", group = "media"}),
    awful.key({}, "F7", function() awful.spawn("playerctl previous", false) end,
      {description = "playerctl previous", group = "media"}),
    awful.key({}, "F8", function() awful.spawn("playerctl play-pause", false) end,
      {description = "toggle playerctl", group = "media"}),
    awful.key({}, "F9", function() awful.spawn("playerctl next", false) end,
      {description = "playerctl next", group = "media"}),
    awful.key({}, "F10", function() awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle", false) end,
      {description = "mute volume", group = "media"}),
    awful.key({}, "F11", function() awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -8%", false) end,
      {description = "decrease volume", group = "media"}),
    awful.key({}, "F12", function() awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +8%", false) end,
      {description = "increase volume", group = "media"}),
    -- Num row keybinds
    awful.key {modifiers = {modkey}, keygroup = "numrow", description = "only view tag", group = "tag",
      on_press = function(i) awful.screen.focused().tags[i]:view_only() end},
    awful.key {modifiers = {hypkey}, keygroup = "numrow", description = "move client to tag", group = "tag",
      on_press = function(i) client.focus:move_to_tag(client.focus.screen.tags[i]) end},
    awful.key {modifiers = {modkey, "Control"}, keygroup = "numrow", description = "toggle tag", group = "tag",
      on_press = function(i) awful.tag.viewtoggle(awful.screen.focused().tags[i]) end},
  }
)

-- Client
client.connect_signal(
  "request::default_keybindings", function ()
    awful.keyboard.append_client_keybindings (
      {
        awful.key({hypkey}, " ", function(c) W.toggle_maximize(c) end,
          {description = "toggle maximize", group = "layout"}),
        awful.key({hypkey}, "=", function(c) c:swap(awful.client.getmaster()) end,
          {description = "become master", group = "layout"}),
        awful.key({hypkey}, "XF86Eject", function(c) W.toggle_floating(c) end,
          {description = "toggle floating", group = "layout"}),
        awful.key({hypkey}, "Left", function(c) W.resize_dwim(c, "left") end,
          {description = "increase master width factor", group = "layout"}),
        awful.key({hypkey}, "Right", function(c) W.resize_dwim(c, "right") end,
          {description = "increase master width factor", group = "layout"}),
        awful.key({hypkey}, "Up", function(c) W.resize_dwim(c, "up") end,
          {description = "increase master width factor", group = "layout"}),
        awful.key({hypkey}, "Down", function(c) W.resize_dwim(c, "down") end,
          {description = "increase master width factor", group = "layout"}),
      }
    )
end)

-- Buttons
client.connect_signal(
  "request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({}, 1, function(c) c:activate{context = "mouse_click"} end),
        awful.button({modkey}, 1, function(c) c:activate{context = "mouse_click", action = "mouse_move"} end),
        awful.button({modkey}, 3, function(c) c:activate{context = "mouse_click", action = "mouse_resize"} end)
    })
end)
