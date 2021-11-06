local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- Configuration
local update_interval = 30            -- in seconds

local battery_text = wibox.widget.textbox()

local battery = wibox.widget {
    battery_text,
    layout = wibox.layout.align.horizontal,
}

local function update_widget(bat)
    battery_text.markup = bat
end

local bat_script = [[
    bash -c "
    upower -i $(upower -e | grep BAT) | grep percentage | awk '{print $2}'
"]]

-- Update percentage
awful.widget.watch(bat_script, update_interval, function(widget, stdout)
    -- local bat = stdout:match(':%s*(.*)..')
    local bat = string.gsub(stdout, '^%s*(.-)%s*$', '%1')
    update_widget(bat)
end)

return battery
