local awful = require("awful")
local hotkeys = require("awful.hotkeys_popup.widget").new({width=1000,height=2000})
local W = require("helpers.window")
local flameshots = "flameshot full -p " .. os.getenv("HOME") .. "/Pictures/screenshots"
local altkey = "Mod1"
local hypkey = "Mod3"
local modkey = "Mod4"
local ctrl = "Control"

-- Main Bindings
awful.keyboard.append_global_keybindings(
  {
    awful.key({}, "KP_Equal", function() awful.spawn("xdotool key Caps_Lock", false) end,
      {description = "Send Caps_Lock", group = "awesome"}),
    awful.key({}, "Insert", W.last_window,
      {description = "Focus last client", group = "awesome"}),
    awful.key({}, "XF86Tools", function() awful.spawn("rofi -show combi", false) end,
      {description = "Rofi combi", group = "rofi"}),
    awful.key({}, "Delete", function () W.if_match({class={"Brave-browser"}},{k="'\\[F12]'"},{k="'\\[Delete]'"}) end,
      {description = "launch or focus emacs", group = "launcher"}),
    awful.key({ctrl}, "n", function() W.if_match({class={"Brave-browser"}},{k="'\\[Down]'"},{k="'\\Cn'"}) end,
      {description = "send down arrow or C-n", group = "awesome"}),
    awful.key({ctrl}, "p", function() W.if_match({class={"Brave-browser"}},{k="'\\[Up]'"},{k="'\\Cp'"}) end,
      {description = "send up arrow or C-p", group = "awesome"}),
    awful.key({modkey}, "XF86Tools", function() awful.spawn("rofi -show run", false) end,
      {description = "dmenu", group = "rofi" }),
    awful.key({modkey}, "q", function() client.focus:kill() end,
      {description = "close window", group = "awesome"}),
    awful.key({modkey}, "Left", function() awful.tag.viewprev() end,
      {description = "focus the next tag(desktop)", group = "tag"}),
    awful.key({modkey}, "Right", function() awful.tag.viewnext() end,
      {description = "focus the previous tag(desktop)", group = "tag"}),
    awful.key({modkey}, "Down", function() awful.client.swap.byidx(1) end,
      {description = "swap with next client by index", group = "layout" }),
    awful.key({modkey}, "Up", function() awful.client.swap.byidx(-1) end,
      {description = "swap with previous client by index", group = "layout" }),
    awful.key({hypkey}, "F1", function() hotkeys:show_help() end,
      {description = "show help", group = "awesome"}),
    awful.key({hypkey}, "c", function() awful.spawn("xdotool click 1", false) end,
      {description = "emulate mouse click", group = "awesome"}),
    awful.key({hypkey}, "s", function() awful.spawn(flameshots, false) end,
      {description = "take screenshots", group = "awesome"}),
    awful.key({hypkey}, "Delete", function() awful.spawn("powermenu", false) end,
      {description = "power menu", group = "rofi" }),
  }
)

-- Launcher Bindings
awful.keyboard.append_global_keybindings(
  {
    awful.key({modkey}, "e", function () W.ror({class={"Emacs"}}, 1, true, {c="em new"}) end,
      {description = "launch or focus emacs", group = "launcher"}),
    awful.key({modkey}, "y", function () W.ror({name={".*YouTube Music"}}, 2, true, {c="bravectl music"}) end,
      {description = "launch or focus youtube music", group = "launcher"}),
    awful.key({modkey}, "f", function () W.ror({name={"lf-emacs"}}, nil, true, {c="em lf"}) end,
      {description = "launch or focus emacs", group = "launcher"}),
    awful.key({modkey}, "w", function() awful.spawn("bravectl web", false) end,
      {description = "launch browser", group = "launcher" }),
    awful.key({modkey}, "u", function () awful.spawn("murl -P 1088 -d 40%x40%+2300+10 toggle", false) end,
      {description = "toggle murl", group = "launcher"}),
    awful.key({modkey}, "t", function() awful.spawn("floatwin -T -t", false) end,
      {description = "toggle terminal", group = "launcher"}),
  }
)

-- Layout
client.connect_signal(
  "request::default_keybindings", function ()
    awful.keyboard.append_client_keybindings (
      {
        awful.key({hypkey}, " ", function(c) W.toggle_maximize(c) end,
          {description = "toggle maximize", group = "layout"}),
        awful.key({hypkey}, "Left", function(c) W.resize_dwim(c, "left") end,
          {description = "increase master width factor", group = "layout"}),
        awful.key({hypkey}, "Right", function(c) W.resize_dwim(c, "right") end,
          {description = "increase master width factor", group = "layout"}),
        awful.key({hypkey}, "Up", function(c) W.resize_dwim(c, "up") end,
          {description = "increase master width factor", group = "layout"}),
        awful.key({hypkey}, "Down", function(c) W.resize_dwim(c, "down") end,
          {description = "increase master width factor", group = "layout"}),
        awful.key({hypkey}, "=", function(c) c:swap(awful.client.getmaster()) end,
          {description = "become master", group = "layout"}),
        awful.key({hypkey}, "/", function(c) c.ontop = not c.ontop end,
          {description = "toggle keep top", group = "layout"}),
        awful.key({hypkey}, "Return", function(c) W.toggle_floating(c) end,
          {description = "toggle floating", group = "layout"}),
      }
    )
end)

-- Media Keys
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
      description = "move client to tag",
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
