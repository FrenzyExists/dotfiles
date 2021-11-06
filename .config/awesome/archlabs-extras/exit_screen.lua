local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
-- local naughty = require("naughty")

local keygrabber = require("awful.keygrabber")

-- Appearance
local icon_font = "Font Awesome 5 Free 90"
local text_font = "sans 25"
local poweroff_text_icon = ""
local reboot_text_icon = ""
local suspend_text_icon = ""
local exit_text_icon = ""
local lock_text_icon = ""
local icon_normal_color = beautiful.xcolor12
local icon_hover_color = beautiful.xcolor4

-- Commands
local poweroff_command = function()
    awful.spawn.with_shell("poweroff")
    awful.keygrabber.stop(exit_screen_grabber)
end
local reboot_command = function()
    awful.spawn.with_shell("reboot")
    awful.keygrabber.stop(exit_screen_grabber)
end
local suspend_command = function()
    awful.spawn.with_shell("systemctl suspend")
    -- awful.spawn.with_shell("i3lock & systemctl suspend")
    exit_screen_hide()
end
local exit_command = function()
    awesome.quit()
end
local lock_command = function()
    exit_screen_hide()
    awful.spawn.with_shell("i3lock-fancy")
end

local username = os.getenv("USER")
-- Capitalize username
local goodbye_widget = wibox.widget.textbox("Goodbye " .. username:sub(1,1):upper()..username:sub(2))
goodbye_widget.font = "sans 70"

local poweroff_icon = wibox.widget.textbox()
poweroff_icon.font = icon_font
poweroff_icon.markup = "<span foreground='" .. icon_normal_color .."'>" .. poweroff_text_icon .. "</span>"

local poweroff_text = wibox.widget.textbox("Poweroff")
poweroff_text.font = text_font

local poweroff = wibox.widget{
    {
        nil,
        poweroff_icon,
        forced_height = dpi(150),
        expand = "none",
        layout = wibox.layout.align.horizontal
    },
    {
        nil,
        poweroff_text,
        expand = "none",
        layout = wibox.layout.align.horizontal
    },
    -- forced_width = 100,
    layout = wibox.layout.fixed.vertical
}
poweroff:buttons(gears.table.join(
awful.button({ }, 1, function ()
    poweroff_command()
end)
))

local reboot_icon = wibox.widget.textbox()
reboot_icon.font = icon_font
reboot_icon.markup = "<span foreground='" .. icon_normal_color .."'>" .. reboot_text_icon .. "</span>"

local reboot_text = wibox.widget.textbox("Reboot")
reboot_text.font = text_font

local reboot = wibox.widget{
    {
        nil,
        reboot_icon,
        forced_height = dpi(150),
        expand = "none",
        layout = wibox.layout.align.horizontal
    },
    {
        nil,
        reboot_text,
        expand = "none",
        layout = wibox.layout.align.horizontal
    },
    -- forced_width = 100,
    layout = wibox.layout.fixed.vertical
}
reboot:buttons(gears.table.join(
awful.button({ }, 1, function ()
    reboot_command()
end)
))

local suspend_icon = wibox.widget.textbox()
suspend_icon.font = icon_font
suspend_icon.markup = "<span foreground='" .. icon_normal_color .."'>" .. suspend_text_icon .. "</span>"

local suspend_text = wibox.widget.textbox("Suspend")
suspend_text.font = text_font

local suspend = wibox.widget{
    {
        nil,
        suspend_icon,
        forced_height = dpi(150),
        expand = "none",
        layout = wibox.layout.align.horizontal
    },
    {
        nil,
        suspend_text,
        expand = "none",
        layout = wibox.layout.align.horizontal
    },
    -- forced_width = 100,
    layout = wibox.layout.fixed.vertical
}
suspend:buttons(gears.table.join(
awful.button({ }, 1, function ()
    suspend_command()
end)
))


local exit_icon = wibox.widget.textbox()
exit_icon.font = icon_font
exit_icon.markup = "<span foreground='" .. icon_normal_color .."'>" .. exit_text_icon .. "</span>"

local exit_text = wibox.widget.textbox("Exit")
exit_text.font = text_font

local exit = wibox.widget{
    {
        nil,
        exit_icon,
        forced_height = dpi(150),
        expand = "none",
        layout = wibox.layout.align.horizontal
    },
    {
        nil,
        exit_text,
        expand = "none",
        layout = wibox.layout.align.horizontal
    },
    -- forced_width = 100,
    layout = wibox.layout.fixed.vertical
}
exit:buttons(gears.table.join(
awful.button({ }, 1, function ()
    exit_command()
end)
))

local lock_icon = wibox.widget.textbox()
lock_icon.font = icon_font
lock_icon.markup = "<span foreground='" .. icon_normal_color .."'>" .. lock_text_icon .. "</span>"

local lock_text = wibox.widget.textbox("Lock")
lock_text.font = text_font

local lock = wibox.widget{
    {
        nil,
        lock_icon,
        forced_height = dpi(150),
        expand = "none",
        layout = wibox.layout.align.horizontal
    },
    {
        nil,
        lock_text,
        expand = "none",
        layout = wibox.layout.align.horizontal
    },
    -- forced_width = 100,
    layout = wibox.layout.fixed.vertical
}
lock:buttons(gears.table.join(
awful.button({ }, 1, function ()
    lock_command()
end)
))

-- Get screen geometry
local screen_width = awful.screen.focused().geometry.width
local screen_height = awful.screen.focused().geometry.height

-- Create the widget
exit_screen = wibox({x = 0, y = 0, visible = false, ontop = true, type = "dock", height = screen_height, width = screen_width})

exit_screen.bg = beautiful.wibar_bg or beautiful.xbackground.."CC" or "#111111"
exit_screen.fg = beautiful.wibar_fg or beautiful.xforeground or "#FEFEFE"

-- Create an container box
-- local exit_screen_box = wibox.container.background()
-- exit_screen_box.bg = exit_screen.bg
-- exit_screen_box.shape = gears.shape.rounded_rect
-- exit_screen_box.shape_border_radius = 20

local exit_screen_grabber
function exit_screen_hide()
    awful.keygrabber.stop(exit_screen_grabber)
    exit_screen.visible = false
end
function exit_screen_show()
    -- naughty.notify({text = "starting the keygrabber"})
    exit_screen_grabber = awful.keygrabber.run(function(_, key, event)
        if event == "release" then return end

        if     key == 's'    then
            suspend_command()
            -- 'e' for exit
        elseif key == 'e'    then
            exit_command()
        elseif key == 'l'    then
            lock_command()
        elseif key == 'p'    then
            poweroff_command()
        elseif key == 'r'    then
            reboot_command()
        elseif key == 'Escape' or key == 'q' or key == 'x' then
            -- naughty.notify({text = "Cancel"})
            exit_screen_hide()
            -- else awful.keygrabber.stop(exit_screen_grabber)
        end
    end)
    exit_screen.visible = true
end

exit_screen:buttons(gears.table.join(
-- Middle click - Hide exit_screen
awful.button({ }, 2, function ()
    exit_screen_hide()
end),
-- Right click - Hide exit_screen
awful.button({ }, 3, function ()
    exit_screen_hide()
end)
))

-- Add clickable effect on hover
add_clickable_effect(poweroff)
add_clickable_effect(reboot)
add_clickable_effect(suspend)
add_clickable_effect(exit)
add_clickable_effect(lock)
-- Change color on hover
local function add_hover_color(w)
    w:connect_signal("mouse::enter", function ()
        w.markup = "<span foreground='" .. icon_hover_color .."'>" .. w.text .. "</span>"
    end)

    w:connect_signal("mouse::leave", function ()
        w.markup = "<span foreground='" .. icon_normal_color .."'>" .. w.text .. "</span>"
    end)
end
add_hover_color(poweroff_icon)
add_hover_color(reboot_icon)
add_hover_color(suspend_icon)
add_hover_color(exit_icon)
add_hover_color(lock_icon)

-- Item placement
exit_screen:setup {
    nil,
    {
        {
            nil,
            goodbye_widget,
            nil,
            expand = "none",
            layout = wibox.layout.align.horizontal
        },
        {
            nil,
            {
                poweroff,
                reboot,
                suspend,
                exit,
                lock,
                spacing = dpi(70),
                layout = wibox.layout.fixed.horizontal
            },
            nil,
            expand = "none",
            layout = wibox.layout.align.horizontal
            -- layout = wibox.layout.fixed.horizontal
        },
        spacing = dpi(30),
        layout = wibox.layout.fixed.vertical
    },
    nil,
    expand = "none",
    layout = wibox.layout.align.vertical
}
