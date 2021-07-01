--
-- Provides:
-- bling::playerctl::status
--      playing (boolean)
-- bling::playerctl::title_artist_album
--      title (string)
--      artist (string)
--      arturl (string)
-- bling::playerctl::position
--      interval_sec (number)
--      length_sec (number)
-- bling::playerctl::player_stopped
--
local awful = require("awful")
local beautiful = require("beautiful")

local interval = beautiful.playerctl_position_update_interval or 1

local function emit_player_status()
    local status_cmd = "playerctl status -F"
    -- Follow status
    awful.spawn.easy_async({
        "pkill", "--full", "--uid", os.getenv("USER"), "^playerctl status"
    }, function()
        awful.spawn.with_line_callback(status_cmd, {
            stdout = function(line)
                local playing = false
                if line:find("Playing") then
                    playing = true
                else
                    playing = false
                end
                awesome.emit_signal("bling::playerctl::status", playing)
            end
        })
        collectgarbage("collect")
    end)
end

local function emit_player_info()
  local song_meta_cmd = "playerctl metadata --format 'artist_{{artist}}title_{{title}}arturl_{{mpris:artUrl}}'"
  local prog_cmd = "playerctl position"
  local length_cmd = "playerctl metadata mpris:length"

  -- Follow progress
  awful.widget.watch(prog_cmd, interval, function(_, interval)
      awful.spawn.easy_async_with_shell(length_cmd, function(length)
          local length_sec = tonumber(length) -- in microseconds
          local interval_sec = tonumber(interval) -- in seconds
          if length_sec and interval_sec then
              if interval_sec >= 0 and length_sec > 0 then
                  awesome.emit_signal("bling::playerctl::position",
                                      interval_sec, length_sec / 1000000)
              end
          end
      end)
      collectgarbage("collect")
  end)

  -- Follow metadata
  awful.widget.watch(song_meta_cmd, interval, function(_, meta)
    local artist = meta:match('artist_(.*)title_')
    local title = meta:match('title_(.*)arturl_')
    local arturl = meta:match('arturl_(.*)')
    if title and title ~= "" then
        awesome.emit_signal("bling::playerctl::title_artist_album", title, artist, arturl)
    else
        awesome.emit_signal("bling::playerctl::player_stopped")
    end
    collectgarbage("collect")
  end)
end

-- Emit info
emit_player_status()
emit_player_info()
