local assets = require("beautiful.theme_assets")
local dpi = require("beautiful.xresources").apply_dpi
local shapes = require("helpers.shape")
local theme = dofile(require("gears.filesystem").get_themes_dir().. "default/theme.lua")
local gears = require("gears")
local icon_path = gears.filesystem.get_configuration_dir() .. "icons/"

-- App
theme.browser_class = "Brave-browser"

-- Colors
theme.xbackground = "#1a2026"
theme.xforeground = "#ffffff"
theme.xcolor0 = "#29343d"
theme.xcolor1 = "#f9929b"
theme.xcolor2 = "#7ed491"
theme.xcolor3 = "#fbdf90"
theme.xcolor4 = "#a3b8ef"
theme.xcolor5 = "#ccaced"
theme.xcolor6 = "#9ce5c0"
theme.xcolor7 = "#ffffff"
theme.xcolor8 = "#3b4b58"
theme.xcolor9 = "#fca2aa"
theme.xcolor10 = "#a5d4af"
theme.xcolor11 = "#fbeab9"
theme.xcolor12 = "#bac8ef"
theme.xcolor13 = "#d7c1ed"
theme.xcolor14 = "#c7e5d6"
theme.xcolor15 = "#eaeaea"

-- Logo / Icons
theme.distro_logo = gears.surface.load_uncached(icon_path .. "distro.png")

-- Fonts
theme.font_name = "Sarasa Mono SC "
theme.alter_font_name = "Victor Mono "
theme.font = theme.font_name .. "10"
theme.icon_font = theme.font_name .. "18"
theme.doc_font = theme.alter_font_name .. "14"

-- Background Colors
theme.bg_dark = theme.xcolor0
theme.bg_normal = theme.xbackground
theme.bg_focus = theme.xcolor0
theme.bg_urgent = theme.xcolor8
theme.bg_minimize = theme.xcolor8

-- Foreground Colors
theme.fg_normal = theme.xcolor7
theme.fg_focus = theme.xcolor4
theme.fg_urgent = theme.xcolor3
theme.fg_minimize = theme.xcolor8
theme.button_close = theme.xcolor1

-- Borders
theme.border_width = dpi(3)
theme.oof_border_width = dpi(0)
theme.border_normal = theme.xcolor0
theme.border_focus = theme.xcolor12
theme.border_radius = dpi(12)
theme.client_radius = dpi(12)
theme.widget_border_width = dpi(1)
theme.widget_border_color = theme.xcolor0

-- Taglist
local taglist_square_size = dpi(0)
theme.taglist_squares_sel = assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)
theme.taglist_font = theme.font_taglist
theme.taglist_bg = theme.wibar_bg
theme.taglist_bg_focus = theme.xcolor0
theme.taglist_fg_focus = theme.xcolor3
theme.taglist_bg_urgent = theme.xcolor0
theme.taglist_fg_urgent = theme.xcolor6
theme.taglist_bg_occupied = theme.xcolor0
theme.taglist_fg_occupied = theme.xcolor6
theme.taglist_bg_empty = theme.xcolor0
theme.taglist_fg_empty = theme.xcolor8
theme.taglist_bg_volatile = transparent
theme.taglist_fg_volatile = theme.xcolor11
theme.taglist_disable_icon = true
theme.taglist_shape_focus = shapes.rrect(theme.border_radius - 3)

-- Tasklist
theme.tasklist_font = theme.font
theme.tasklist_font_focus = theme.font
theme.tasklist_plain_task_name = true
theme.tasklist_bg_focus = theme.xcolor0
theme.tasklist_fg_focus = theme.xforeground .. "bb"
theme.tasklist_bg_minimize = theme.xcolor0 .. 55
theme.tasklist_fg_minimize = theme.xforeground .. 55
theme.tasklist_bg_normal = theme.xcolor0 .. 70
theme.tasklist_fg_normal = theme.xforeground .. 60
theme.tasklist_disable_task_name = false
theme.tasklist_disable_icon = true
theme.tasklist_bg_urgent = theme.xcolor0
theme.tasklist_fg_urgent = theme.xcolor1
theme.tasklist_align = "center"

-- Tooltips
theme.tooltip_bg = theme.xbackground
theme.tooltip_fg = theme.xforeground
theme.tooltip_font = theme.font_name .. "12"
theme.tooltip_border_width = theme.widget_border_width - 1
theme.tooltip_border_color = theme.xcolor0
theme.tooltip_opacity = 1
theme.tooltip_align = "left"

-- Hotkeys Pop Up
theme.hotkeys_font = theme.font_name .. "15"
theme.hotkeys_description_font = theme.font_name .. "15"
theme.hotkeys_border_color = theme.xcolor0
theme.hotkeys_modifiers_fg = theme.xcolor4
theme.hotkeys_description_font = theme.doc_font
-- theme.hotkeys_label_fg = theme.xcolor1
theme.hotkeys_group_margin = dpi(18)
theme.hotkeys_shape = shapes.cutting_corner
theme.hotkeys_border_width = 10

-- Layout List
theme.layoutlist_border_color = theme.xcolor8
theme.layoutlist_border_width = theme.border_width
theme = assets.recolor_layout(theme, theme.xforeground)

-- Gaps
theme.useless_gap = dpi(5)

-- Wibar
theme.wibar_height = dpi(40)
theme.wibar_margin = dpi(15)
theme.wibar_spacing = dpi(15)
theme.wibar_bg = theme.xbackground

-- Systray
theme.systray_icon_spacing = dpi(10)
theme.bg_systray = theme.xcolor0
theme.systray_icon_size = dpi(18)

-- Weather
theme.weather_city = "wuhan"

return theme
