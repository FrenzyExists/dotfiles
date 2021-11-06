local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- Configuration
local update_interval = 15            -- in seconds

local temperature = wibox.widget{
    text = "?? °C",
    align  = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
}

-- Mouse control
-- temperature:buttons(gears.table.join(
--     -- 
--     awful.button({ }, 1, function ()
--     end),
--     -- 
--     awful.button({ }, 2, function () 
--     end),
--     -- 
--     awful.button({ }, 3, function () 
--     end),
--     -- 
--     awful.button({ }, 4, function () 
--     end),
--     awful.button({ }, 5, function () 
--     end)
-- ))

local function update_widget(temp)
  temperature.markup = temp
  -- temperature.markup = temp .. "°C"
end

-- Signals
-- temperature:connect_signal("mouse::enter", function ()
--     update_widget()
-- end)

-- update_widget()

local temp_script = [[
  bash -c "
  sensors | grep Package | awk '{print $4}' | cut -c 2-3,6-8
  "]]

awful.widget.watch(temp_script, update_interval, function(widget, stdout)
                     -- local temp = stdout:match('+(.*)%.%d...(.*)%(')
                     local temp = stdout
                     temp = string.gsub(temp, '^%s*(.-)%s*$', '%1')
                     update_widget(temp)
end)

return temperature
