-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-----------------------------------------------------
---------------   Error handling   ------------------
-----------------------------------------------------
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end


-----------------------------------------------------
-------------  Variable definitions  ----------------
-----------------------------------------------------
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/archlabs/theme.lua")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

-- Default applications
-- terminal = "xterm"
terminal = "exo-open --launch TerminalEmulator"
web_browser = "exo-open --launch WebBrowser"
file_manager = "exo-open --launch FileManager"
editor = os.getenv("EDITOR") or "nano"
-- editor_cmd = terminal .. " -e " .. editor
editor_cmd = "exo-open "
-- Duckduckgo
web_search_cmd = "exo-open https://duckduckgo.com/?q="
-- Google
-- web_search_cmd = "exo-open https://www.google.com/search?q="

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}

-----------------------------------------------------
---------------   Helper Functions   ----------------
-----------------------------------------------------
-- Add a clickable effect to a widget by changing the cursor on mouse::enter and mouse::leave
function add_clickable_effect(w)
    local original_cursor = "left_ptr"
    local hover_cursor = "hand1"

    w:connect_signal("mouse::enter", function ()
        local w = _G.mouse.current_wibox
        if w then
            w.cursor = hover_cursor
        end
    end)

    w:connect_signal("mouse::leave", function ()
        local w = _G.mouse.current_wibox
        if w then
            w.cursor = original_cursor
        end
    end)
end

-- Move client to screen edge, respecting the screen workarea
function move_to_edge(c, direction)
    local workarea = awful.screen.focused().workarea
    if direction == "up" then
        c:geometry({ nil, y = workarea.y + beautiful.useless_gap * 2, nil, nil })
    elseif direction == "down" then 
        c:geometry({ nil, y = workarea.height + workarea.y - c:geometry().height - beautiful.useless_gap * 2 - beautiful.border_width * 2, nil, nil })
    elseif direction == "left" then 
        c:geometry({ x = workarea.x + beautiful.useless_gap * 2, nil, nil, nil })
    elseif direction == "right" then 
        c:geometry({ x = workarea.width + workarea.x - c:geometry().width - beautiful.useless_gap * 2 - beautiful.border_width * 2, nil, nil, nil })
    end
end

-- Resize client (regardless if it is floating or not)
-- Constants --
local floating_resize_amount = dpi(20)
local tiling_resize_factor= 0.05
---------------
function resize(c, direction)
    if awful.layout.get(mouse.screen) == awful.layout.suit.floating or c.floating then
        if direction == "up" then
            c:relative_move(  0,  0, 0, -floating_resize_amount)
        elseif direction == "down" then
            c:relative_move(  0,  0, 0,  floating_resize_amount)
        elseif direction == "left" then
            c:relative_move(  0,  0, -floating_resize_amount, 0)
        elseif direction == "right" then
            c:relative_move(  0,  0,  floating_resize_amount, 0)
        end
    else
        if direction == "up" then
            awful.client.incwfact(-tiling_resize_factor)
        elseif direction == "down" then
            awful.client.incwfact( tiling_resize_factor)
        elseif direction == "left" then
            awful.tag.incmwfact(-tiling_resize_factor)
        elseif direction == "right" then
            awful.tag.incmwfact( tiling_resize_factor)
        end
    end
end


-----------------------------------------------------
----------------  Extra Features  -------------------
-----------------------------------------------------
local icons = require("icons.icons")
require("archlabs-extras.exit_screen")
require("archlabs-extras.sidebar")
-- local app_drawer = require("archlabs-extras.app_drawer")

-----------------------------------------------------
-----------------   Notifications  ------------------
-----------------------------------------------------
-- TODO: some options are not respected when the notification is created
-- through lib-notify. Naughty works as expected.

-- Icon size
naughty.config.defaults['icon_size'] = beautiful.notification_icon_size

-- Timeouts (set 0 for permanent)
naughty.config.defaults.timeout = 5
naughty.config.presets.low.timeout = 2
naughty.config.presets.critical.timeout = 0

-- Apply theme variables
naughty.config.defaults.padding = beautiful.notification_padding
naughty.config.defaults.spacing = beautiful.notification_spacing
naughty.config.defaults.margin = beautiful.notification_margin
naughty.config.defaults.border_width = beautiful.notification_border_width
-- Apply rounded rectangle shape
beautiful.notification_shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, beautiful.notification_border_radius)
end

naughty.config.presets.normal = {
    font         = beautiful.notification_font,
    fg           = beautiful.notification_fg,
    bg           = beautiful.notification_bg,
    border_width = beautiful.notification_border_width,
    margin       = beautiful.notification_margin,
    position     = beautiful.notification_position
}

naughty.config.presets.low = {
    font         = beautiful.notification_font,
    fg           = beautiful.notification_fg,
    bg           = beautiful.notification_bg,
    border_width = beautiful.notification_border_width,
    margin       = beautiful.notification_margin,
    position     = beautiful.notification_position
}

naughty.config.presets.ok = naughty.config.presets.low
naughty.config.presets.info = naughty.config.presets.low
naughty.config.presets.warn = naughty.config.presets.normal

naughty.config.presets.critical = {
    font         = beautiful.notification_font,
    fg           = beautiful.notification_crit_fg,
    bg           = beautiful.notification_crit_bg,
    border_width = beautiful.notification_border_width,
    margin       = beautiful.notification_margin,
    position     = beautiful.notification_position
}

-----------------------------------------------------
----------------       Menu       -------------------
-----------------------------------------------------
-- Create a launcher widget and a main menu
-- TODO terminal commands do not work with exo-open
myawesomemenu = {
   { "Edit config", editor_cmd .. " " .. awesome.conffile },
   { "Restart", awesome.restart },
   { "Quit", function() exit_screen_show() end },
}

mymainmenu = awful.menu({ items = { { "Awesome", myawesomemenu, icons.archlabs },
                                    { "Web Browser", web_browser },
                                    { "File Manager", file_manager },
                                    { "Settings", "xfce4-settings-manager" },
                                    { "Run", "rofi_run -r" },
                                    { "Terminal", terminal }
                                  }
                        })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-----------------------------------------------------
----------------       Wibar       ------------------
-----------------------------------------------------
-- Create a launcher
-- mylauncher = awful.widget.launcher({ image = icons.archlabs,
--                                      menu = mymainmenu })

-- Create a keyboard map indicator and switcher
-- mykeyboardlayout = awful.widget.keyboardlayout()

-- Create a clock widget
clock_text = wibox.widget {
    clock_icon,
    wibox.widget.textclock("%H:%M"),
    layout = wibox.layout.align.horizontal
}
clock_icon = wibox.widget.textbox("")
clock_icon.font = "Font Awesome 5 Free 9"
clock_icon.align = "center"
clock_icon.valign = "center"
myclockwidget = wibox.widget{
    {
        {
            clock_icon,
            bg = beautiful.xcolor4,
            shape = gears.shape.circle,
            forced_width = dpi(22),
            widget = wibox.container.background
        },
        {
            clock_text,
            -- Add margins to the top and bottom to force single line text
            -- TODO might not be needed for the clock
            -- top = dpi(3),
            -- bottom = dpi(3),
            -- Add padding to the right for aesthetic reasons
            right = dpi(8),
            -- Add padding to the left for spacing between the clock icon and the clock text
            left = dpi(8),
            widget = wibox.container.margin
        },
        spacing = dpi(10),
        layout = wibox.layout.align.horizontal
    },
    -- forced_width = dpi(300),
    bg = beautiful.xcolor0,
    shape = gears.shape.rounded_bar,
    widget = wibox.container.background
}

-- Create a network button
network_icon = wibox.widget.textbox("")
network_icon.font = "Font Awesome 5 Free 9"
network_icon.align = "center"
network_icon.valign = "center"
mynetworkwidget = wibox.widget{
    network_icon,
    bg = beautiful.xcolor4,
    shape = gears.shape.circle,
    forced_width = dpi(22),
    widget = wibox.container.background
}
mynetworkwidget:buttons(gears.table.join(
                awful.button({ }, 1, function() awful.spawn.with_shell("networkmanager_dmenu") end)
))
add_clickable_effect(mynetworkwidget)

-- Create the tray
tray = wibox.widget.systray()
tray.shape = gears.shape.rounded_bar
-- tray.visible = false

-- Create a widget that toggles the tray when clicked
tray_icon = wibox.widget.textbox("")
tray_icon.font = "Font Awesome 5 Free 9"
tray_icon.align = "center"
tray_icon.valign = "center"

tray_container = wibox.container.background()

mytraywidget = wibox.widget{
    tray_icon,
    shape = gears.shape.circle,
    forced_width = dpi(22),
    bg = beautiful.xcolor4,
    widget = tray_container
}

local function toggle_tray()
    tray.visible = not tray.visible
    if tray.visible then
        tray_container.bg = beautiful.xcolor4
    else
        tray_container.bg = beautiful.xcolor8
    end
end

mytraywidget:buttons(
  gears.table.join(
    awful.button({ }, 1, function ()
        toggle_tray()
    end)
))

local mytraywidget_tooltip = awful.tooltip {
    objects        = { mytraywidget },
    timer_function = function()
        return "Toggle tray"
    end,
}

add_clickable_effect(mytraywidget)

-- Initialize battery_icon according to power supply status (plugged or unplugged)
awful.spawn.easy_async_with_shell("cat /sys/class/power_supply/*/online", function(out)
    -- Remove trailing whitespaces
    -- out = out:gsub('^%s*(.-)%s*$', '%1')
    status = out:sub(1,1)
    if status == "1" then
        battery_icon.text = ""
    else
        battery_icon.text = ""
    end
end)

-- Create an update button
-- Requires pamac (a GUI for pacman) to be installed
update_icon = wibox.widget.textbox("")
update_icon.font = "Font Awesome 5 Free 9"
update_icon.align = "center"
update_icon.valign = "center"
myupdatewidget = wibox.widget{
    update_icon,
    bg = beautiful.xcolor4,
    shape = gears.shape.circle,
    forced_width = dpi(22),
    widget = wibox.container.background
}
myupdatewidget:buttons(gears.table.join(
                awful.button({ }, 1, function()
                    local matcher = function (c)
                      return awful.rules.match(c, {class = 'Pamac-manager'})
                    end
                    awful.client.run_or_raise("pamac-manager", matcher)
                end)
))

add_clickable_effect(myupdatewidget)

-- Create a battey widget
battery_text = require("archlabs-extras.battery")
battery_text.valign = "center"
battery_text.align = "center"

battery_icon = wibox.widget.textbox()
battery_icon.font = "Font Awesome 5 Free 9"
battery_icon.align = "center"
battery_icon.valign = "center"

-- Initialize battery_icon according to power supply status (plugged or unplugged)
awful.spawn.easy_async_with_shell("cat /sys/class/power_supply/*/online", function(out)
    -- Remove trailing whitespaces
    -- out = out:gsub('^%s*(.-)%s*$', '%1')
    status = out:sub(1,1)
    if status == "1" then
        battery_icon.text = ""
    else
        battery_icon.text = ""
    end
end)

-- Connect to charger signals in order to update battery_icon
awesome.connect_signal(
  "charger_plugged", function(c)
    battery_icon.text = ""
end)
awesome.connect_signal(
  "charger_unplugged", function(c)
    battery_icon.text = ""
end)


mybatterywidget = wibox.widget{
    {
        {
            battery_icon,
            bg = beautiful.xcolor4,
            shape = gears.shape.circle,
            forced_width = dpi(22),
            widget = wibox.container.background
        },
        {
            battery_text,
            -- Add margins to the top and bottom to force single line text
            -- TODO might not be needed for the battery
            -- top = dpi(3),
            -- bottom = dpi(3),
            -- Add padding to the right for aesthetic reasons
            right = dpi(8),
            -- Add padding to the left for spacing between the battery icon and the battery text
            left = dpi(8),
            widget = wibox.container.margin
        },
        spacing = dpi(10),
        layout = wibox.layout.align.horizontal
    },
    -- forced_width = dpi(300),
    bg = beautiful.xcolor0,
    shape = gears.shape.rounded_bar,
    widget = wibox.container.background
}

mybatterywidget:buttons(
  gears.table.join(
    awful.button({ }, 1, function ()
        local matcher = function (c)
          return awful.rules.match(c, {class = 'Xfce4-power-manager-settings'})
        end
        awful.client.run_or_raise("xfce4-power-manager-settings", matcher)
    end)
))
add_clickable_effect(mybatterywidget)



-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t)
                                              if t == t.screen.selected_tag then
                                                  awful.tag.history.restore()
                                              else
                                                  t:view_only()
                                              end
                                          end),
                    awful.button({ modkey }, 1, awful.tag.viewtoggle),
                    awful.button({ }, 3, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end)
                    -- awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
                    -- awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 2, function (c)
                                              c:kill()
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(-1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(1)
                                          end))
-- Set wallpaper function
local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end

        -- AwesomeWM's native method to set the wallpaper
        -- gears.wallpaper.maximized(wallpaper, s, true)

        -- Set the wallpaper using feh
        awful.spawn.with_shell("feh --bg-fill "..beautiful.wallpaper)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)
awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)
end)

awful.screen.connect_for_each_screen(function(s)
    -- Each screen has its own tag table.
    awful.tag({" 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 "}, s, awful.layout.layouts[1])
    -- awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    s.mypromptbox.fg = beautiful.xcolor7
    s.mypromptbox.font = "sans 11"

    -- Create a searchbar widget
    search_icon = wibox.widget.textbox("")
    search_icon.font = "Font Awesome 5 Free 9"
    search_icon.align = "center"
    search_icon.valign = "center"
    s.mysearchwidget = wibox.widget{
        {
            {
                search_icon,
                bg = beautiful.xcolor4,
                shape = gears.shape.circle,
                forced_width = dpi(24),
                widget = wibox.container.background
            },
            {
                s.mypromptbox,
                -- Add margins to the top and bottom to force single line text
                top = dpi(3),
                bottom = dpi(3),
                -- Add padding to the right for aesthetic reasons
                right = dpi(5),
                -- Add padding to the left for spacing between the search icon and the prompt
                left = dpi(5),
                widget = wibox.container.margin
            },
            spacing = dpi(10),
            layout = wibox.layout.align.horizontal
        },
        forced_width = dpi(300),
        bg = beautiful.xcolor0,
        shape = gears.shape.rounded_bar,
        widget = wibox.container.background
    }

    s.mysearchwidget:buttons(gears.table.join(
                        awful.button({ }, 1, function ()
                            awful.prompt.run {
                                prompt       = "<b>Run: </b>",
                                textbox      = s.mypromptbox.widget,
                                exe_callback = awful.spawn,
                                completion_callback = awful.completion.shell,
                                history_path = awful.util.get_cache_dir() .. "/history"
                            }
                        end),
                        awful.button({ }, 3, function ()
                            awful.prompt.run {
                              prompt       = '<b>Web search: </b>',
                              textbox      = s.mypromptbox.widget,
                              history_path = awful.util.get_cache_dir() .. "/history_web",
                              exe_callback = function(input)
                                  if not input or #input == 0 then return end
                                  awful.spawn(web_search_cmd.."\""..input.."\"")
                                  naughty.notify { title = "Searching the web for", text = input, icon = icons.web_browser }
                              end
                            }
                        end)
    ))


    -- Add tooltip to search bar
    local mysearchwidget_tooltip = awful.tooltip {
        objects        = { s.mysearchwidget },
        timer_function = function()
            return "Left Click or Mod+R: <b>Run</b>\nRight click or Mod+S: <b>Web Search</b>\nEscape: <b>Cancel</b>"
        end,
    }

    -- TODO throws error for some reason
    -- add_clickable_effect(mysearchwidget)

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    -- TODO this does not work. Images are too big for the circle
    s.mylayoutbox.forced_width = dpi(10)
    s.mylayoutbox.forced_height = dpi(10)

    -- Create a container for the layoutbox
    s.mylayoutwidget = wibox.widget{
        s.mylayoutbox,
        bg = beautiful.xcolor4,
        shape = gears.shape.circle,
        forced_width = dpi(22),
        widget = wibox.container.background
    }
    s.mylayoutwidget:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    add_clickable_effect(s.mylayoutwidget)


    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        -- Show only non empty tags
        -- filter  = awful.widget.taglist.filter.noempty,
        -- Show all tags, even empty ones
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        layout   = {
            spacing = dpi(0),
            -- spacing_widget = {
            --     color  = beautiful.xcolor8,
            --     shape  = gears.shape.circle,
            --     widget = wibox.widget.separator,
            -- },
            --
            layout  = wibox.layout.fixed.horizontal
        },
    }

    s.mytaglist:buttons(gears.table.join(
                    awful.button({ }, 4, function() awful.tag.viewprev() end),
                    awful.button({ }, 5, function() awful.tag.viewnext() end)
    ))

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen   = s,
        filter   = awful.widget.tasklist.filter.currenttags,
        buttons  = tasklist_buttons,
        style    = {
            shape_border_width = 0,
            shape_border_color = beautiful.fg_normal,
            shape  = gears.shape.rounded_bar,
        },
        layout   = {
            spacing = dpi(10),
            spacing_widget = {
                {
                    forced_width = dpi(5),
                    shape        = gears.shape.circle,
                    color        = beautiful.xcolor8,
                    widget       = wibox.widget.separator
                },
                valign = 'center',
                halign = 'center',
                widget = wibox.container.place,
            },
            layout  = wibox.layout.flex.horizontal
        },
        -- Notice that there is *NO* wibox.wibox prefix, it is a template,
        -- not a widget instance.
        widget_template = {
            {
                {
                    nil,
                    {
                        id     = 'text_role',
                        widget = wibox.widget.textbox,
                    },
                    expand = "none", -- Center text
                    layout = wibox.layout.align.horizontal,
                },
                left  = dpi(10),
                right = dpi(10),
                widget = wibox.container.margin
            },
            id     = 'background_role',
            widget = wibox.container.background,
        },
    }

    -- Create the top bar
    s.mytopwibox = awful.wibar({ position = "top", bg = beautiful.xbackground, height = dpi(35), screen = s })

    -- Add widgets to the top bar
    s.mytopwibox:setup {
        {
            layout = wibox.layout.align.horizontal,
            expand = "none",
            { -- Left widgets
                s.mysearchwidget,
                -- TODO enable this
                -- s.mylayoutwidget,
                spacing = dpi(5),
                layout = wibox.layout.fixed.horizontal
            },
            { -- Middle widgets
                {
                    s.mytaglist,
                    -- Add margins to the taglist for aesthetic reasons
                    -- left = dpi(4),
                    -- right = dpi(4),
                    widget = wibox.container.margin
                },
                bg = beautiful.taglist_bg,
                shape = gears.shape.rounded_bar,
                widget = wibox.container.background
            },
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                spacing = dpi(5),
                -- mykeyboardlayout,
                tray,
                mytraywidget,
                mybatterywidget,
                myupdatewidget,
                mynetworkwidget,
                myclockwidget,
            },
        },
        margins = dpi(5),
        -- top = dpi(5),
        -- bottom = dpi(5),
        -- left = dpi(10),
        -- right = dpi(10),
        -- color = beautiful.xcolor5,
        widget = wibox.container.margin,
    }

    -- Create the bottom bar
    s.mybottomwibox = awful.wibar({ position = "bottom", bg = beautiful.xbackground, height = dpi(35), screen = s })

    -- Add widgets to the bottom bar
    s.mybottomwibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
        },
        { -- Middle widget
            s.mytasklist,
            -- Add top and bottom margins to force text to one line
            top = dpi(2),
            bottom = dpi(2),
            widget = wibox.container.margin,
        },
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
        },
    }

end)


-----------------------------------------------------
---------------   Mouse bindings   ------------------
-----------------------------------------------------
root.buttons(gears.table.join(
    awful.button({ }, 1, function () mymainmenu:hide() end),
    awful.button({ }, 2, function () awful.spawn.with_shell("rofi_run -w") end),
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewprev),
    awful.button({ }, 5, awful.tag.viewnext)
))


-----------------------------------------------------
--------------  Global Key bindings   ---------------
-----------------------------------------------------
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "F1",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ "Mod4", "Mod1" }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ "Mod4", "Mod1" }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey, "Shift" }, "b", awful.tag.history.restore,
              {description = "go back", group = "tag"}),
    awful.key({ modkey,         }, "b",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}
    ),

    -- Focus by index
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey, "Shift"   }, "Tab",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),

    -- Toggle sidebar
    awful.key({ modkey }, "grave", function() sidebar.visible = not sidebar.visible end,
              {description = "show or hide sidebar", group = "awesome"}),

    -- Main menu
    awful.key({ modkey, "Shift"  }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),

    -- Toggle tray
    awful.key({ modkey, }, "=", function () toggle_tray() end,
              {description = "toggle tray visibility", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey,           }, "f", function () awful.spawn(file_manager) end,
              {description = "open file manager", group = "launcher"}),
    awful.key({ modkey,           }, "w", function () awful.spawn(web_browser) end,
              {description = "open web browser", group = "launcher"}),
    awful.key({ "Control",           }, "space", function () naughty.destroy_all_notifications() end,
              {description = "dismiss notifications", group = "awesome"}),
    awful.key({  }, "Print", function ()
        awful.spawn("scrot '%S.png' -e 'mv $f $$(xdg-user-dir PICTURES)/ArchLabs-%S-$wx$h.png ; feh --scale-down -B black $$(xdg-user-dir PICTURES)/ArchLabs-%S-$wx$h.png'")
        naughty.notify({ text = "Screenshot taken", icon = icons.camera })
    end,
              {description = "take screenshot", group = "launcher"}),
    -- Audio TODO CHECK IF WORKS OUT OF VM
    awful.key({  }, "XF86AudioPlay", function () awful.spawn.with_shell("playerctl play-pause") end,
              {description = "audio player toggle", group = "audio"}),
    awful.key({  }, "XF86AudioNext", function () awful.spawn.with_shell("playerctl next") end,
              {description = "audio player next", group = "audio"}),
    awful.key({  }, "XF86AudioPrev", function () awful.spawn.with_shell("playerctl previous") end,
              {description = "audio player previous", group = "audio"}),
    awful.key({  }, "XF86AudioStop", function () awful.spawn.with_shell("playerctl stop") end,
              {description = "audio player stop", group = "audio"}),
    awful.key({  }, "XF86AudioMute", function () awful.spawn.with_shell("pamixer -t") end,
              {description = "audio (un)mute", group = "audio"}),
    awful.key({  }, "XF86AudioRaiseVolume", function () awful.spawn.with_shell("pamixer -i 2") end,
              {description = "audio raise", group = "audio"}),
    awful.key({  }, "XF86AudioLowerVolume", function () awful.spawn.with_shell("pamixer -d 2") end,
              {description = "audio lower", group = "audio"}),
    -- Brightness TODO CHECK IF WORKS OUT OF VM
    awful.key({  }, "XF86MonBrightnessUp", function () awful.spawn.with_shell("xbacklight -inc 10") end,
              {description = "increase brightness", group = "brightness"}),
    awful.key({  }, "XF86MonBrightnessDown", function () awful.spawn.with_shell("xbacklight -dec 10") end,
              {description = "decrease brightness", group = "brightness"}),
    -- Awesome
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    -- Exit screen
    awful.key({ modkey, "Shift" }, "x", function() exit_screen_show() end,
              {description = "show exit screen", group = "awesome"}),
    awful.key({ modkey,           }, "Escape", function () exit_screen_show() end,
              {description = "show exit screen", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next layout", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous layout", group = "layout"}),

    awful.key({ modkey, "Shift" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompts
    awful.key({ modkey },            "r",     function ()
        awful.prompt.run {
            prompt       = "<b>Run: </b>",
            textbox      = awful.screen.focused().mypromptbox.widget,
            exe_callback = awful.spawn,
            completion_callback = awful.completion.shell,
            history_path = awful.util.get_cache_dir() .. "/history"
        }
    end,
    {description = "run prompt", group = "prompts"}),

    -- Lua execute prompt
    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "<b>Run Lua code: </b>",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "prompts"}),

    -- Web search prompt
    awful.key({ modkey }, "s",
              function ()
                  awful.prompt.run {
                    prompt       = '<b>Web search: </b>',
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = function(input)
                        if not input or #input == 0 then return end
                        awful.spawn(web_search_cmd.."\""..input.."\"")
                        naughty.notify { title = "Searching the web for", text = input, icon = icons.web_browser }
                    end
                  }
              end,
              {description = "web search prompt", group = "prompts"}),

    -- Rofi
    awful.key({ modkey }, "d", function () awful.spawn("rofi_run -r") end,
              {description = "rofi launcher", group = "launcher"}),

    -- Needed for super to launch rofi through ksuperkey, see ~/.xprofile
    awful.key({ "Mod1" }, "F1", function () awful.spawn("rofi_run -r") end,
              {description = "rofi launcher", group = "launcher"})
)

-----------------------------------------------------
--------------  Client Key bindings   ---------------
-----------------------------------------------------
clientkeys = gears.table.join(
    -- Focus client by direction (arrow keys)
    awful.key({ modkey }, "Down",
        function()
            awful.client.focus.bydirection("down")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus down", group = "client"}),
    awful.key({ modkey }, "Up",
        function()
            awful.client.focus.bydirection("up")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus up", group = "client"}),
    awful.key({ modkey }, "Left",
        function()
            awful.client.focus.bydirection("left")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus left", group = "client"}),
    awful.key({ modkey }, "Right",
        function()
            awful.client.focus.bydirection("right")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus right", group = "client"}),

    -- Relative move floating client (arrow keys)
    awful.key({ modkey, "Control", "Shift"   }, "Down",   function (c) c:relative_move(  0,  dpi(40),   0,   0) end,
        {description =  "relative move", group = "client"}),
    awful.key({ modkey, "Control", "Shift"   }, "Up",     function (c) c:relative_move(  0, -dpi(40),   0,   0) end,
        {description =  "relative move", group = "client"}),
    awful.key({ modkey, "Control", "Shift"   }, "Left",   function (c) c:relative_move(-dpi(40),   0,   0,   0) end,
        {description =  "relative move", group = "client"}),
    awful.key({ modkey, "Control", "Shift"   }, "Right",  function (c) c:relative_move( dpi(40),   0,   0,   0) end,
        {description = "relative move", group = "client"}),

    -- Resize client (arrow keys)
    -- Check helper function "resize" if you need to tweak the resize amount
    awful.key({ modkey, "Control"  }, "Down",
        function (c)
            resize(c, "down")
        end,
        {description = "resize downwards", group = "client"}),
    awful.key({ modkey, "Control"  }, "Up",
        function (c)
            resize(c, "up")
        end,
        {description = "resize upwards", group = "client"}),
    awful.key({ modkey, "Control"  }, "Left",
        function (c)
            resize(c, "left")
        end,
        {description = "resize to the left", group = "client"}),
    awful.key({ modkey, "Control"  }, "Right",
        function (c)
            resize(c, "right")
        end,
        {description = "resize to the right", group = "client"}),

    -- Move FLOATING client to edge or swap TILED client by direction (arrow keys)
    awful.key({ modkey, "Shift"  }, "Down",
        function (c)
            if awful.layout.get(mouse.screen) == awful.layout.suit.floating or c.floating then
                -- Floating: move client to edge
                move_to_edge(c, "down")
            else
                -- Tiled: Swap client by direction
                awful.client.swap.bydirection("down", c, nil)
            end
        end,
        {description = "(floating) move to edge, (tiled) swap by direction", group = "client"}),
    awful.key({ modkey, "Shift"  }, "Up",
        function (c)
            if awful.layout.get(mouse.screen) == awful.layout.suit.floating or c.floating then
                -- Floating: move client to edge
                move_to_edge(c, "up")
            else
                -- Tiled: Swap client by direction
                awful.client.swap.bydirection("up", c, nil)
            end
        end,
        {description = "(floating) move to edge, (tiled) swap by direction", group = "client"}),
    awful.key({ modkey, "Shift"  }, "Left",
        function (c)
            if awful.layout.get(mouse.screen) == awful.layout.suit.floating or c.floating then
                -- Floating: move client to edge
                move_to_edge(c, "left")
            else
                -- Tiled: Swap client by direction
                awful.client.swap.bydirection("left", c, nil)
            end
        end,
        {description = "(floating) move to edge, (tiled) swap by direction", group = "client"}),
    awful.key({ modkey, "Shift"  }, "Right",
        function (c)
            if awful.layout.get(mouse.screen) == awful.layout.suit.floating or c.floating then
                -- Floating: move client to edge
                move_to_edge(c, "right")
            else
                -- Tiled: Swap client by direction
                awful.client.swap.bydirection("right", c, nil)
            end
        end,
        {description = "(floating) move to edge, (tiled) swap by direction", group = "client"}),

    -- Toggle fullscreen
    awful.key({ modkey, "Shift"  }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),

    -- Close client
    awful.key({ modkey, "Shift"   }, "q",      function (c) c:kill() end,
              {description = "close", group = "client"}),
    awful.key({ "Mod1",           }, "F4",      function (c) c:kill() end,
              {description = "close", group = "client"}),

    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey }, "c",  function (c) awful.placement.centered(c,{honor_workarea=true})
             end,
              {description = "center", group = "client"}),

    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag or go back to last tag if it is already selected
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           if tag == screen.selected_tag then
                               awful.tag.history.restore()
                           else
                               tag:view_only()
                           end
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)


-----------------------------------------------------
------------------      Rules      ------------------
-----------------------------------------------------
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     size_hints_honor = false,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Xfce4-power-manager-settings",
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "Lxappearance",
          "Pavucontrol",
          "Nm-connection-editor",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
          "GtkFileChooserDialog",
          "conversation",
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    -- Dialogs are always centered, floating and ontop
    { rule_any = {type = { "dialog" }
      }, properties = { placement = awful.placement.centered, floating = true, ontop = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}

-----------------------------------------------------
------------------     Signals     ------------------
-----------------------------------------------------
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

-- Change border colors on focus/unfocus
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Make rofi able to unminimize minimized clients
client.connect_signal("request::activate", function(c, context, hints)
    if not awesome.startup then
        if c.minimized then
            c.minimized = false
        end
        awful.ewmh.activate(c, context, hints)
    end
end)

-- Center floating client if it is the only visible one or the layout is not floating
client.connect_signal("manage", function (c)
    if not awesome.startup then
        if awful.layout.get(mouse.screen) ~= awful.layout.suit.floating then
            awful.placement.centered(c,{honor_workarea=true})
        else if #mouse.screen.clients == 1 then
                awful.placement.centered(c,{honor_workarea=true})
            end
        end
    end
end)

-- Remember and restore floating client geometry
tag.connect_signal("property::layout", function(t)
    for k, c in ipairs(t:clients()) do
        if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
            c:geometry(awful.client.property.get(c, 'floating_geometry'))
        end
    end
end)
client.connect_signal("manage", function(c)
    if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
        awful.client.property.set(c, 'floating_geometry', c:geometry())
    end
end)
client.connect_signal("property::geometry", function(c)
    if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
        awful.client.property.set(c, 'floating_geometry', c:geometry())
    end
end)

-- Rounded corners
if beautiful.border_radius or beautiful.border_radius ~= 0 then
    client.connect_signal("manage", function (c, startup)
        if not c.fullscreen then
            c.shape = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, beautiful.border_radius)
            end
        end
    end)

    -- Fullscreen clients should not have rounded corners
    client.connect_signal("property::fullscreen", function (c)
        if c.fullscreen then
            c.shape = function(cr, width, height)
                gears.shape.rectangle(cr, width, height)
            end
        else
            c.shape = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, beautiful.border_radius)
            end
        end
    end)
end

-- Subscribe to power supply status changes - Requires inotify-tools
local charger_script = [[
   bash -c "
   while (inotifywait /sys/class/power_supply/*/online -qq) do cat /sys/class/power_supply/*/online; done
"]]

-- Kill old inotifywait process
awful.spawn.easy_async_with_shell("ps x | grep \"inotifywait /sys/class/power_supply\" | grep -v grep | awk '{print $1}' | xargs kill", function ()
    -- Update charger status with each line printed
    awful.spawn.with_line_callback(charger_script, {
        stdout = function(line)
            -- All we need is the first character (remove trailing whitespace)
            status = line:sub(1,1)
            -- You can connect to those signals (for notifications or updating
            -- the power supply status of a battery widget)
            -- TODO some laptops send these events every few seconds instead of only on charger plug/unplug
            -- We could save the last status and check if it changed before emitting the signals in order to avoid sending notifications every few seconds
            if status == "1" then
                awesome.emit_signal("charger_plugged")
            else
                awesome.emit_signal("charger_unplugged")
            end
            -- naughty.notify { title = "DEBUG", text = "Charger event: "..status }
        end
    })
end)

-- TODO charger status notifications

-----------------------------------------------------
---------------      Titlebars      -----------------
-----------------------------------------------------
-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    --------------   Titlebar bindings   ----------------
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 2, function()
            c:kill()
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    --------------   Titlebar items   ----------------
    awful.titlebar(c, { size = beautiful.titlebar_size }) : setup {
        { -- Left
            -- awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            -- awful.titlebar.widget.floatingbutton (c),
            -- awful.titlebar.widget.stickybutton   (c),
            -- awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.minimizebutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)


-----------------------------------------------------
---------------     Autostart      ------------------
-----------------------------------------------------
-- Run with reload
-- awful.spawn.with_shell("nitrogen --restore")
-- If you have a numpad you may want to enable this
-- awful.spawn.with_shell("numlockx on")

-- Check ~/.xprofile for autostarting applications once on login

-----------------------------------------------------
----------  Aggresive Garbage Collection  -----------
-----------------------------------------------------
collectgarbage("setpause", 160)
collectgarbage("setstepmul", 400)
