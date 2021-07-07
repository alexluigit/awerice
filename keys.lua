local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local altkey = "Mod1"
local hypkey = "Mod3"
local modkey = "Mod4"
local ctrl = "Control"
local window = require("helpers.window")

local key_on_match = function (rule, key_match, no_match)
  if awful.rules.match_any(client.focus, rule) then
    awful.spawn("xvkbd -xsendevent -text " .. key_match, false)
  else
    awful.spawn("xvkbd -xsendevent -text " .. no_match, false)
  end
end

local visit = function (rule, tag, restore, cmd, ...)
  local s = awful.screen.focused()
  local focus = client.focus
  local has_instance
  if focus and awful.rules.match(focus, rule) and restore then
    if type(restore) == "boolean" then
      awful.tag.history.restore(s, 1)
    else awful.spawn(restore, false)
    end
  else
    for _, c in ipairs(s.tags[tag]:clients()) do
      if awful.rules.match(c, rule) then
        has_instance = c
        break
      end
    end
    s.tags[tag]:view_only()
    if has_instance then
      client.focus = has_instance
    else
      if type(cmd) ~= "string" then cmd(...)
      else awful.spawn(cmd, false) end
    end
  end
end

-- Main Bindings
awful.keyboard.append_global_keybindings(
  {
    awful.key({ctrl}, "n", function() key_on_match({class={"Brave-browser"}}, "'\\[Down]'", "'\\Cn'") end,
      {description = "Send down arrow or C-n", group = "awesome"}),
    awful.key({ctrl}, "p", function() key_on_match({class={"Brave-browser"}}, "'\\[Up]'", "'\\Cp'") end,
      {description = "Send up arrow or C-p", group = "awesome"}),
    awful.key({altkey}, "n", function() awful.client.focus.byidx(1) end,
      {description = "focus next", group = "awesome"}),
    awful.key({altkey}, "p", function() awful.client.focus.byidx(-1) end,
      {description = "focus previous", group = "awesome"}),
    awful.key({altkey}, "q", function() client.focus:kill() end,
      {description = "focus previous", group = "awesome"}),
    awful.key({modkey}, "Left", function() awful.tag.viewprev() end,
      {description = "focus the next tag(desktop)", group = "tag"}),
    awful.key({modkey}, "Right", function() awful.tag.viewnext() end,
      {description = "focus the previous tag(desktop)", group = "tag"}),
    awful.key({modkey}, "Down", function() awful.client.swap.byidx(1) end,
      {description = "swap with next client by index", group = "client" }),
    awful.key({modkey}, "Up", function() awful.client.swap.byidx(-1) end,
      {description = "swap with previous client by index", group = "client" }),
    awful.key({}, "Insert", function() awful.spawn("rofi -show run -theme dmenu.rasi", false) end,
      {description = "App menu", group = "awesome" }),
  }
)

-- Launcher
awful.keyboard.append_global_keybindings (
  {
    awful.key({hypkey}, "n", function() awful.spawn("floatwin -d 2460x2060+1360+15 -c Brave-browser: bravectl start", false) end,
      {description = "toggle browser", group = "launcher"}),
    awful.key({hypkey}, "e", function() visit({class="Emacs"}, 1, false, "emacsclient -cn") end,
      {description = "Launch emacs", group = "launcher"}),
    awful.key({hypkey}, "y", function() visit({name=".*YouTube Music$"}, 2, true, "bravectl music") end,
      {description = "open YouTube music", group = "launcher"}),
    awful.key({hypkey}, "/", function() visit({class="Alacritty"}, 3, true, "alacritty") end,
      {description = "Open terminal", group = "launcher" }),
    awful.key({hypkey}, "l", function() awful.spawn("floatwin -d 75%x96%+24%+1% -n lf-emacs emacsclient -ne '\\(lf-new-frame\\)'", false) end,
      {description = "open lf (in emacs)", group = "launcher"}),
    awful.key({hypkey}, "h", function() awful.spawn("floatwin -t -d 1920x2000+80+80 htop", false) end,
      {description = "open htop", group = "launcher"}),
    awful.key({hypkey}, "u", function() awful.spawn("murl -P 1088 -d 25%x25%+2870+10 toggle", false) end,
      {description = "toggle murl", group = "launcher"}),
    awful.key({hypkey}, "s", function() awful.spawn("flameshot full -p " .. os.getenv("HOME") .. "/Pictures/screenshots", false) end,
      {description = "take screenshots", group = "launcher"}),
    awful.key({hypkey}, "m", function() awful.spawn("floatwin -c mpv:emacs-mpv", false) end,
      {description = "toggle playing video", group = "launcher"}),
    awful.key({hypkey}, "Delete", function() awful.spawn("powermenu", false) end,
      {description = "Power menu", group = "awesome" }),
    awful.key({hypkey}, "Return", function() awful.spawn("alacritty", false) end,
      {description = "open terminal", group = "launcher"}),
  }
)

-- Client
client.connect_signal(
  "request::default_keybindings", function ()
    awful.keyboard.append_client_keybindings (
      {
        awful.key({hypkey}, " ", function(c) c.maximized = not c.maximized c:raise() end,
          {description = "(un)maximize", group = "client"}),
        awful.key({hypkey}, "Left", function(c) window.resize_dwim(c, "left") end,
          {description = "increase master width factor", group = "layout"}),
        awful.key({hypkey}, "Right", function(c) window.resize_dwim(c, "right") end,
          {description = "increase master width factor", group = "layout"}),
        awful.key({hypkey}, "Up", function(c) window.resize_dwim(c, "up") end,
          {description = "increase master width factor", group = "layout"}),
        awful.key({hypkey}, "Down", function(c) window.resize_dwim(c, "down") end,
          {description = "increase master width factor", group = "layout"}),
        awful.key({hypkey}, "=", function(c) c:swap(awful.client.getmaster()) end,
          {description = "become master", group = "client"}),
        awful.key({hypkey}, "Backspace", function(c) c.ontop = not c.ontop end,
          {description = "toggle keep top", group = "client"}),
      }
    )
end)

-- Function Keys
awful.keyboard.append_global_keybindings (
  {
    awful.key({}, "F7", function() awful.spawn("playerctl previous", false) end,
      {description = "playerctl previous", group = "media"}),
    awful.key({}, "F8", function() awful.spawn("playerctl play-pause", false) end,
      {description = "toggle playerctl", group = "media"}),
    awful.key({}, "F9", function() awful.spawn("playerctl next", false) end,
      {description = "playerctl next", group = "media"}),
    awful.key({}, "F10", function() awful.spawn("pulsemixer --toggle-mute", false) end,
      {description = "mute volume", group = "media"}),
    awful.key({}, "F11", function() awful.spawn("pulsemixer --change-volume -8", false) end,
      {description = "decrease volume", group = "media"}),
    awful.key({}, "F12", function() awful.spawn("pulsemixer --change-volume +8", false) end,
      {description = "increase volume", group = "media"}),
    awful.key({}, "F1", function() awful.spawn("rofi -show run -theme dmenu.rasi", false) end,
      {description = "App menu", group = "awesome" }),
    awful.key({hypkey}, "F1", hotkeys_popup.show_help,
      {description = "show help", group = "awesome"}),
    awful.key({}, "Delete", function() awful.spawn("xvkbd -xsendevent -text '\\[F12]'", false) end,
      {description = "F12 key [Browser Devtool]", group = "awesome" }),
  }
)

-- Num row keybinds
awful.keyboard.append_global_keybindings(
  {
    awful.key {
      modifiers = {modkey},
      keygroup = "numrow",
      description = "only view tag",
      group = "tag",
      on_press = function(index)
        local screen = awful.screen.focused()
        local tag = screen.tags[index]
        if tag then tag:view_only() end
      end
    },
    awful.key {
      modifiers = {modkey, "Control"},
      keygroup = "numrow",
      description = "toggle tag",
      group = "tag",
      on_press = function(index)
        local screen = awful.screen.focused()
        local tag = screen.tags[index]
        if tag then awful.tag.viewtoggle(tag) end
      end
    },
    awful.key {
      modifiers = {hypkey},
      keygroup = "numrow",
      description = "move focused client to tag",
      group = "tag",
      on_press = function(index)
        if client.focus then
          local tag = client.focus.screen.tags[index]
          if tag then client.focus:move_to_tag(tag) end
        end
      end
    },
  }
)

client.connect_signal(
  "request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({}, 1, function(c) c:activate{context = "mouse_click"} end),
        awful.button({modkey}, 1, function(c) c:activate{context = "mouse_click", action = "mouse_move"} end),
        awful.button({modkey}, 3, function(c) c:activate{context = "mouse_click", action = "mouse_resize"} end)
    })
end)
