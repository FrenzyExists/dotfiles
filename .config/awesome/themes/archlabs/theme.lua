--[[
 ▄▄▄· ▄▄▄   ▄▄·  ▄ .▄▄▄▌   ▄▄▄· ▄▄▄▄· .▄▄ ·
▐█ ▀█ ▀▄ █·▐█ ▌▪██▪▐███•  ▐█ ▀█ ▐█ ▀█▪▐█ ▀.
▄█▀▀█ ▐▀▀▄ ██ ▄▄██▀▐███▪  ▄█▀▀█ ▐█▀▀█▄▄▀▀▀█▄
▐█ ▪▐▌▐█•█▌▐███▌██▌▐▀▐█▌▐▌▐█ ▪▐▌██▄▪▐█▐█▄▪▐█
 ▀  ▀ .▀  ▀·▀▀▀ ▀▀▀ ·.▀▀▀  ▀  ▀ ·▀▀▀▀  ▀▀▀▀
--]]

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local xrdb = xresources.get_current_theme()
local gears = require("gears")
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

-- Inherit default theme
local theme = dofile(themes_path.."default/theme.lua")
-- Titlebar icon path
local tip = "~/.config/awesome/themes/archlabs/titlebar/"

theme.wallpaper = gears.filesystem.get_configuration_dir() .. "wallpapers/minimal_space.png"

-- Load ~/.Xresources colors and set fallback colors
theme.xbackground = xrdb.background or "#1c2023"
theme.xforeground = xrdb.foreground or "#E1E1E1"
theme.xcolor0 = xrdb.color0 or "#1c2023"
theme.xcolor1 = xrdb.color1 or "#bf616a"
theme.xcolor2 = xrdb.color2 or "#a3be8c"
theme.xcolor3 = xrdb.color3 or "#ebcb8b"
theme.xcolor4 = xrdb.color4 or "#8fa1b3"
theme.xcolor5 = xrdb.color5 or "#b48ead"
theme.xcolor6 = xrdb.color6 or "#96b5b4"
theme.xcolor7 = xrdb.color7 or "#E1E1E1"
theme.xcolor8 = xrdb.color8 or "#919ba0"
theme.xcolor9 = xrdb.color9 or "#bf616a"
theme.xcolor10 = xrdb.color10 or "#a3be8c"
theme.xcolor11 = xrdb.color11 or "#ebcb8b"
theme.xcolor12 = xrdb.color12 or "#8fa1b3"
theme.xcolor13 = xrdb.color13 or "#b48ead"
theme.xcolor14 = xrdb.color14 or "#96b5b4"
theme.xcolor15 = xrdb.color15 or "#c0c5ce"

-- RBGA
local transparent = "#00000000"

theme.font          = "sans 10"

theme.bg_normal     = theme.xcolor8
theme.bg_focus      = theme.xcolor8
theme.bg_urgent     = theme.xcolor9
theme.bg_minimize   = theme.xbackground
theme.bg_systray    = theme.xbackground

theme.fg_normal     = theme.xforeground
theme.fg_focus      = theme.xcolor4
theme.fg_urgent     = theme.xbackground
theme.fg_minimize   = theme.xcolor8

theme.useless_gap   = dpi(4)
theme.border_width  = dpi(0)
theme.border_radius  = dpi(6)
theme.border_normal = theme.xcolor0
theme.border_focus  = theme.bg_focus
theme.border_marked = theme.xcolor10

-- Other variable sets
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]

-- Taglist
theme.taglist_font = "sans bold 10"
theme.taglist_bg = theme.xcolor0
theme.taglist_shape = gears.shape.circle
theme.taglist_bg_focus = theme.xcolor4
theme.taglist_fg_focus = theme.xforeground
theme.taglist_bg_urgent = theme.xcolor1
theme.taglist_fg_urgent = theme.xforeground
theme.taglist_bg_occupied = transparent
theme.taglist_fg_occupied = theme.xcolor4
theme.taglist_bg_empty = transparent
theme.taglist_fg_empty = theme.xforeground
theme.taglist_bg_volatile = transparent
theme.taglist_fg_volatile = theme.xcolor11

-- Tasklist
theme.tasklist_font = "sans bold 10"
theme.tasklist_bg_focus = theme.xbackground
theme.tasklist_fg_focus = theme.xcolor4
theme.tasklist_bg_urgent = theme.xbackground
theme.tasklist_fg_urgent = theme.xcolor9
theme.tasklist_bg_normal = theme.xbackground
theme.tasklist_fg_normal = theme.xcolor7

-- Titlebars
theme.titlebar_size = dpi(30)
theme.titlebar_bg_focus = theme.xcolor7
theme.titlebar_bg_normal = theme.xcolor7
theme.titlebar_fg_focus = theme.xcolor7
theme.titlebar_fg_normal = theme.xcolor7

-- Tooltips
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
theme.tooltip_fg = theme.fg_normal
theme.tooltip_bg = theme.bg_normal

-- Notifications
-- Position: bottom_left, bottom_right, bottom_middle,
--         top_left, top_right, top_middle
-- BUG: some notifications (e.g. by notify-send) appear at top_right regardless of this setting
theme.notification_position = "top_right" 
theme.notification_border_width = dpi(0)
theme.notification_border_radius = theme.border_radius
theme.notification_border_color = theme.xcolor10
theme.notification_bg = theme.xbackground
theme.notification_fg = theme.xcolor7
theme.notification_crit_bg = theme.xcolor9
theme.notification_crit_fg = theme.xcolor0
theme.notification_icon_size = dpi(60)
-- theme.notification_height = dpi(80)
-- theme.notification_width = dpi(300)
theme.notification_margin = dpi(15)
theme.notification_opacity = 1
theme.notification_font = theme.font
theme.notification_padding = dpi(20)
theme.notification_spacing = dpi(10)

-- Edge snap
theme.snap_bg = theme.xcolor4
theme.snap_shape = gears.shape.rectangle

-- Prompts
theme.prompt_bg = transparent
theme.prompt_fg = theme.xforeground

-- Tooltips
theme.tooltip_bg = theme.xcolor0
theme.tooltip_fg = theme.xforeground
theme.tooltip_font = theme.font
theme.tooltip_border_width = dpi(0)
theme.tooltip_border_color = theme.xcolor0
theme.tooltip_opacity = 1
theme.tooltip_align = "left"

-- Sidebar
-- (Sidebar items can be customized in sidebar.lua)
theme.sidebar_bg = theme.xbackground
theme.sidebar_bg_alt = theme.xcolor0
theme.sidebar_fg = theme.xcolor7
theme.sidebar_opacity = 1
theme.sidebar_position = "right" -- left or right
theme.sidebar_width = dpi(330)
-- theme.sidebar_height = 
theme.sidebar_y = dpi(0)
theme.sidebar_hide_on_mouse_leave = true
theme.sidebar_show_on_mouse_edge = true

-- Mpd song
theme.mpd_song_title_color = theme.xcolor7
theme.mpd_song_artist_color = theme.xcolor7
theme.mpd_song_paused_color = theme.xcolor8

-- Volume bar
theme.volume_bar_active_color = theme.xcolor4
theme.volume_bar_active_background_color = theme.xcolor0
theme.volume_bar_muted_color = theme.xcolor8
theme.volume_bar_muted_background_color = theme.xcolor0

-- Temperature bar
theme.temperature_bar_active_color = theme.xcolor4
theme.temperature_bar_background_color = theme.xcolor0

-- Battery bar
theme.battery_bar_active_color = theme.xcolor4
theme.battery_bar_background_color = theme.xcolor0

-- CPU bar
theme.cpu_bar_active_color = theme.xcolor4
theme.cpu_bar_background_color = theme.xcolor0

-- RAM bar
theme.ram_bar_active_color = theme.xcolor4
theme.ram_bar_background_color = theme.xcolor0


-- Menu
theme.menu_bg_focus = theme.xcolor4
theme.menu_fg_focus = theme.xcolor7
theme.menu_bg_normal = theme.xbackground
theme.menu_fg_normal = theme.xcolor7
theme.menu_submenu_icon = "~/.config/awesome/themes/archlabs/submenu.png"
theme.menu_height = dpi(30)
theme.menu_width  = dpi(180)
theme.menu_border_color  = theme.xbackground
theme.menu_border_width  = dpi(8)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Recolor Layout icons:
theme = theme_assets.recolor_layout(theme, theme.xforeground)

-- Titlebar buttons: Define the images to load
theme.titlebar_close_button_normal = tip .. "close_normal.svg"
theme.titlebar_close_button_focus  = tip .. "close_focus.svg"
theme.titlebar_minimize_button_normal = tip .. "minimize_normal.svg"
theme.titlebar_minimize_button_focus  = tip .. "minimize_focus.svg"
theme.titlebar_ontop_button_normal_inactive = tip .. "ontop_normal_inactive.svg"
theme.titlebar_ontop_button_focus_inactive  = tip .. "ontop_focus_inactive.svg"
theme.titlebar_ontop_button_normal_active = tip .. "ontop_normal_active.svg"
theme.titlebar_ontop_button_focus_active  = tip .. "ontop_focus_active.svg"
theme.titlebar_sticky_button_normal_inactive = tip .. "sticky_normal_inactive.svg"
theme.titlebar_sticky_button_focus_inactive  = tip .. "sticky_focus_inactive.svg"
theme.titlebar_sticky_button_normal_active = tip .. "sticky_normal_active.svg"
theme.titlebar_sticky_button_focus_active  = tip .. "sticky_focus_active.svg"
theme.titlebar_floating_button_normal_inactive = tip .. "floating_normal_inactive.svg"
theme.titlebar_floating_button_focus_inactive  = tip .. "floating_focus_inactive.svg"
theme.titlebar_floating_button_normal_active = tip .. "floating_normal_active.svg"
theme.titlebar_floating_button_focus_active  = tip .. "floating_focus_active.svg"
theme.titlebar_maximized_button_normal_inactive = tip .. "maximized_normal_inactive.svg"
theme.titlebar_maximized_button_focus_inactive  = tip .. "maximized_focus_inactive.svg"
theme.titlebar_maximized_button_normal_active = tip .. "maximized_normal_active.svg"
theme.titlebar_maximized_button_focus_active  = tip .. "maximized_focus_active.svg"
-- (hover)
theme.titlebar_close_button_normal_hover = tip .. "close_normal_hover.svg"
theme.titlebar_close_button_focus_hover  = tip .. "close_focus_hover.svg"
theme.titlebar_minimize_button_normal_hover = tip .. "minimize_normal_hover.svg"
theme.titlebar_minimize_button_focus_hover  = tip .. "minimize_focus_hover.svg"
theme.titlebar_ontop_button_normal_inactive_hover = tip .. "ontop_normal_inactive_hover.svg"
theme.titlebar_ontop_button_focus_inactive_hover  = tip .. "ontop_focus_inactive_hover.svg"
theme.titlebar_ontop_button_normal_active_hover = tip .. "ontop_normal_active_hover.svg"
theme.titlebar_ontop_button_focus_active_hover  = tip .. "ontop_focus_active_hover.svg"
theme.titlebar_sticky_button_normal_inactive_hover = tip .. "sticky_normal_inactive_hover.svg"
theme.titlebar_sticky_button_focus_inactive_hover  = tip .. "sticky_focus_inactive_hover.svg"
theme.titlebar_sticky_button_normal_active_hover = tip .. "sticky_normal_active_hover.svg"
theme.titlebar_sticky_button_focus_active_hover  = tip .. "sticky_focus_active_hover.svg"
theme.titlebar_floating_button_normal_inactive_hover = tip .. "floating_normal_inactive_hover.svg"
theme.titlebar_floating_button_focus_inactive_hover  = tip .. "floating_focus_inactive_hover.svg"
theme.titlebar_floating_button_normal_active_hover = tip .. "floating_normal_active_hover.svg"
theme.titlebar_floating_button_focus_active_hover  = tip .. "floating_focus_active_hover.svg"
theme.titlebar_maximized_button_normal_inactive_hover = tip .. "maximized_normal_inactive_hover.svg"
theme.titlebar_maximized_button_focus_inactive_hover  = tip .. "maximized_focus_inactive_hover.svg"
theme.titlebar_maximized_button_normal_active_hover = tip .. "maximized_normal_active_hover.svg"
theme.titlebar_maximized_button_focus_active_hover  = tip .. "maximized_focus_active_hover.svg"

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Generate taglist squares:
-- Set size 0 to disable
local taglist_square_size = dpi(0)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.xcolor4
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.xcolor7
)

-- Try to determine if we are running light or dark colorscheme:
local bg_numberic_value = 0;
for s in theme.bg_normal:gmatch("[a-fA-F0-9][a-fA-F0-9]") do
    bg_numberic_value = bg_numberic_value + tonumber("0x"..s);
end
local is_dark_bg = (bg_numberic_value < 383)

return theme


