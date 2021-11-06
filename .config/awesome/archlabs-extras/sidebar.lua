local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local icons = require("icons.icons")

-- TODO replace this with spacing property
local function pad(size)
    local str = ""
    for i = 1, size do
        str = str .. " "
    end
    local pad = wibox.widget.textbox(str)
    return pad
end

-- Some commonly used variables
local icon_font = "Font Awesome 5 Free 22"
-- TODO clarify why width and height are reversed
local progress_bar_width = dpi(300)
local progress_bar_height = dpi(40)
-- local progress_bar_margins = dpi(9)

-- Helper function that changes the appearance of progress bars and their icons
local function format_progress_bar(bar, icon)
    icon.font = icon_font
    icon.align = "center"
    icon.valign = "center"
    bar.forced_width = progress_bar_width
    bar.forced_height = progress_bar_height
    bar.shape = gears.shape.rounded_bar
    bar.bar_shape = gears.shape.rounded_bar
    local w = wibox.widget{
        {
            {
                bar,
                widget = wibox.container.rotate,
                direction = "east"
            },
            {
                -- Force height to avoid cutting off some icons
                forced_height = dpi(45),
                widget = icon,
            },
            spacing = dpi(15),
            layout = wibox.layout.fixed.vertical
        },
        nil,
        expand = "none",
        layout = wibox.layout.align.horizontal
    }
    return w
end

local archlabs_icon = wibox.widget.imagebox(icons.archlabs)
archlabs_icon.resize = true
archlabs_icon.forced_width = dpi(200)
archlabs_icon.forced_height = dpi(200)
local archlabs = wibox.widget {
    -- Center archlabs_icon horizontally
    nil,
    archlabs_icon,
    expand = "none",
    layout = wibox.layout.align.horizontal
}

-- Item configuration
local exit_icon = wibox.widget.textbox()
exit_icon.markup = "<span foreground='" .. beautiful.xcolor4 .."'></span>"
exit_icon.font = "Font Awesome 5 Free 22"
exit_icon.align = "center"
exit_icon.valign = "center"
local exit_text = wibox.widget.textbox(" Logout")
exit_text.align = "center"
exit_text.valign = "center"
exit_text.font = "sans 16"

local exit = wibox.widget{
    exit_icon,
    exit_text,
    -- Force height to avoid cutting off the icon
    forced_height = dpi(35),
    layout = wibox.layout.fixed.horizontal
}
exit:buttons(gears.table.join(
                 awful.button({ }, 1, function ()
                     exit_screen_show()
                     sidebar.visible = false
                 end)
))

add_clickable_effect(exit)

-- local weather_widget = require("archlabs-extras.weather")
-- local weather_widget_icon = weather_widget:get_all_children()[1]
-- weather_widget_icon.forced_width = icon_size
-- weather_widget_icon.forced_height = icon_size
-- local weather_widget_text = weather_widget:get_all_children()[2]
-- weather_widget_text.font = "sans 14"

-- Dummy weather_widget for testing
-- (avoid making requests with every awesome restart)
-- local weather_widget = wibox.widget.textbox("[i] bla bla bla!")

-- local weather = wibox.widget{
--     nil,
--     weather_widget,
--     nil,
--     layout = wibox.layout.align.horizontal,
--     expand = "none"
-- }

local temperature_icon = wibox.widget.textbox("")
local temperature_bar = require("archlabs-extras.temperature_bar")
local temperature = format_progress_bar(temperature_bar, temperature_icon)

local battery_icon = wibox.widget.textbox("")
awesome.connect_signal(
  "charger_plugged", function(c)
    battery_icon.image = beautiful.battery_charging_icon
end)
awesome.connect_signal(
  "charger_unplugged", function(c)
    battery_icon.image = beautiful.battery_icon
end)
local battery_bar = require("archlabs-extras.battery_bar")
local battery = format_progress_bar(battery_bar, battery_icon)
battery:buttons(
  gears.table.join(
    awful.button({ }, 1, function ()
        local matcher = function (c)
          return awful.rules.match(c, {class = 'Xfce4-power-manager-settings'})
        end
        awful.client.run_or_raise("xfce4-power-manager-settings", matcher)
    end)
))
add_clickable_effect(battery)

local cpu_icon = wibox.widget.textbox("")
local cpu_bar = require("archlabs-extras.cpu_bar")
local cpu = format_progress_bar(cpu_bar, cpu_icon)

cpu:buttons(
  gears.table.join(
    awful.button({ }, 1, function ()
        local matcher = function (c)
          return awful.rules.match(c, {name = 'htop'})
        end
        awful.client.run_or_raise(terminal .." -e htop", matcher)
    end),
    awful.button({ }, 3, function ()
        local matcher = function (c)
          return awful.rules.match(c, {class = 'Lxtask'})
        end
        awful.client.run_or_raise("lxtask", matcher)
    end)
))

local ram_icon = wibox.widget.textbox("")
local ram_bar = require("archlabs-extras.ram_bar")
local ram = format_progress_bar(ram_bar, ram_icon)

ram:buttons(
  gears.table.join(
    awful.button({ }, 1, function ()
        local matcher = function (c)
          return awful.rules.match(c, {name = 'htop'})
        end
        awful.client.run_or_raise(terminal .." -e htop", matcher)
    end),
    awful.button({ }, 3, function ()
        local matcher = function (c)
          return awful.rules.match(c, {class = 'Lxtask'})
        end
        awful.client.run_or_raise("lxtask", matcher)
    end)
))


-- Time
local hours = wibox.widget.textclock("%H")
hours.font = "sans bold 55"
hours.align = "center"
hours.valign = "center"
local minutes = wibox.widget.textclock(" %M")
minutes.font = "sans 55"
minutes.align = "center"
minutes.valign = "center"
minutes.markup = "<span foreground='" .. beautiful.xcolor4 .."'>" .. minutes.text .. "</span>"
minutes:connect_signal("widget::redraw_needed", function () 
    minutes.markup = "<span foreground='" .. beautiful.xcolor4 .."'>" .. minutes.text .. "</span>"
end)
local time = wibox.widget {
    nil,
    {
        hours,
        minutes,
        layout = wibox.layout.fixed.horizontal
    },
    expand = "none",
    layout = wibox.layout.align.horizontal
}

-- Date
local day_of_the_week = wibox.widget.textclock("%A")
day_of_the_week.font = "sans italic 20"
day_of_the_week.align = "center"
day_of_the_week.valign = "center"
day_of_the_week.markup = "<span foreground='" .. beautiful.xcolor4 .."'>" .. day_of_the_week.text .. "</span>"
day_of_the_week:connect_signal("widget::redraw_needed", function () 
    day_of_the_week.markup = "<span foreground='" .. beautiful.xcolor4 .."'>" .. day_of_the_week.text .. "</span>"
end)
local day_of_the_month = wibox.widget.textclock(" %b %d")
day_of_the_month.font = "sans 20"
day_of_the_month.align = "center"
day_of_the_month.valign = "center"

local date = wibox.widget {
    nil,
    {
        day_of_the_week,
        day_of_the_month,
        layout = wibox.layout.fixed.horizontal
    },
    expand = "none",
    layout = wibox.layout.align.horizontal
}

local disk_space = require("archlabs-extras.disk")
disk_space.font = "sans 14"
local disk_icon = wibox.widget.imagebox(icons.archlabs)
disk_icon.resize = true
disk_icon.forced_width = icon_size
disk_icon.forced_height = icon_size
local disk = wibox.widget{
  nil,
  {
    disk_icon,
    disk_space,
    layout = wibox.layout.fixed.horizontal
  },
  nil,
  expand = "none",
  layout = wibox.layout.align.horizontal
}

disk:buttons(gears.table.join(
                       awful.button({ }, 1, function ()
                           awful.spawn(file_manager, {floating = true})
                       end)
))

local volume_icon = wibox.widget.textbox("")
local volume_bar = require("archlabs-extras.volume_bar")
volume = format_progress_bar(volume_bar, volume_icon)

volume:buttons(gears.table.join(
                 -- Left click - Mute / Unmute
                 awful.button({ }, 1, function ()
                     awful.spawn.with_shell("pamixer -t")
                 end),
                 -- Right click - Run or raise pavucontrol
                 awful.button({ }, 3, function ()
                     local matcher = function (c)
                       return awful.rules.match(c, {class = 'Pavucontrol'})
                     end
                     awful.client.run_or_raise("pavucontrol", matcher)
                 end),
                 -- Scroll - Increase / Decrease volume
                 awful.button({ }, 4, function ()
                     awful.spawn.with_shell("pamixer -i 2")
                 end),
                 awful.button({ }, 5, function ()
                     awful.spawn.with_shell("pamixer -d 2")
                 end)
))
add_clickable_effect(volume)
-- }}}

-- Create the sidebar
sidebar = wibox({x = 0, y = 0, visible = false, ontop = true, type = "dock"})
sidebar.bg = beautiful.sidebar_bg or beautiful.wibar_bg or "#111111"
sidebar.fg = beautiful.sidebar_fg or beautiful.wibar_fg or "#FFFFFF"
sidebar.opacity = beautiful.sidebar_opacity or 1
sidebar.height = beautiful.sidebar_height or awful.screen.focused().geometry.height
sidebar.width = beautiful.sidebar_width or dpi(300)
sidebar.y = beautiful.sidebar_y or 0
if beautiful.sidebar_position == "right" then
  sidebar.x = awful.screen.focused().geometry.width - sidebar.width
else
  sidebar.x = beautiful.sidebar_x or 0
end

sidebar:buttons(gears.table.join(
                  -- Middle click - Hide sidebar
                  awful.button({ }, 2, function ()
                      sidebar.visible = false
                  end)
                  -- Right click - Hide sidebar
                  -- awful.button({ }, 3, function ()
                  --     sidebar.visible = false
                  --     -- mymainmenu:show()
                  -- end)
))

-- Hide sidebar when mouse leaves
if beautiful.sidebar_hide_on_mouse_leave then
  sidebar:connect_signal("mouse::leave", function ()
                           sidebar.visible = false
  end)
end
-- Activate sidebar by moving the mouse at the edge of the screen
if beautiful.sidebar_hide_on_mouse_leave then
  local sidebar_activator = wibox({y = sidebar.y, width = 1, visible = true, ontop = false, opacity = 0, below = true})
  sidebar_activator.height = sidebar.height
  -- sidebar_activator.height = sidebar.height - beautiful.wibar_height
  sidebar_activator:connect_signal("mouse::enter", function ()
                                     sidebar.visible = true
  end)

  if beautiful.sidebar_position == "right" then
    sidebar_activator.x = awful.screen.focused().geometry.width - sidebar_activator.width
  else
    sidebar_activator.x = 0
  end

  sidebar_activator:buttons(
    gears.table.join(
      -- awful.button({ }, 2, function ()
      --     start_screen_show()
      --     -- sidebar.visible = not sidebar.visible
      -- end),
      awful.button({ }, 4, function ()
          awful.tag.viewprev()
      end),
      awful.button({ }, 5, function ()
          awful.tag.viewnext()
      end)
  ))
end

-- Item placement
sidebar:setup {
  { ----------- TOP GROUP -----------
    pad(1),
    pad(1),
    archlabs,
    pad(1),
    time,
    date,
    -- pad(1),
    -- weather,
    pad(1),
    pad(1),
    layout = wibox.layout.fixed.vertical
  },
  { ----------- MIDDLE GROUP -----------
    pad(1),
    pad(1),
    { -- Center bars horizontally
        nil,
        {
            volume,
            cpu,
            temperature,
            ram,
            battery,
            spacing = dpi(10),
            layout = wibox.layout.fixed.horizontal,
        },
        expand = "none",
        layout = wibox.layout.align.horizontal,
    },
    -- disk,
    layout = wibox.layout.fixed.vertical
  },
  { ----------- BOTTOM GROUP -----------
    { -- Logout button
      nil,
      exit,
      layout = wibox.layout.align.horizontal,
      expand = "none"
    },
    pad(1),
    pad(1),
    layout = wibox.layout.fixed.vertical
  },
  layout = wibox.layout.align.vertical,
  -- expand = "none"
}
