local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

-- Set colors
local active_color = beautiful.volume_bar_active_color or "#5AA3CC"
local muted_color = beautiful.volume_bar_muted_color or "#666666"
local active_background_color = beautiful.volume_bar_active_background_color or "#222222"
local muted_background_color = beautiful.volume_bar_muted_background_color or "#222222"

local volume_bar = wibox.widget{
    max_value     = 100,
    value         = 50,
    forced_height = dpi(10),
    margins       = {
      top = dpi(8),
      bottom = dpi(8),
    },
    forced_width  = dpi(200),
    shape         = gears.shape.rounded_bar,
    bar_shape     = gears.shape.rounded_bar,
    color         = active_color,
    background_color = active_background_color,
    border_width  = 0,
    border_color  = beautiful.border_color,
    widget        = wibox.widget.progressbar,
}

local function update_widget()
  awful.spawn.easy_async({"sh", "-c", "pactl list sinks"},
    function(stdout)
      local volume = stdout:match('(%d+)%% /')
      local muted = stdout:match('Mute:(%s+)[yes]')
      local fill_color
      local bg_color
      if muted ~= nil then
        fill_color = muted_color
        bg_color = muted_background_color
      else
        fill_color = active_color
        bg_color = active_background_color
      end
      volume_bar.value = tonumber(volume)
      volume_bar.color = fill_color
      volume_bar.background_color = bg_color
    end
  )
end

update_widget()

-- Sleeps until pactl detects an event (volume up/down/toggle mute)
local volume_script = [[
  bash -c '
  pactl subscribe 2> /dev/null | grep --line-buffered "sink #0"
  ']]


-- Kill old pactl subscribe process
awful.spawn.easy_async_with_shell("ps x | grep \"pactl subscribe\" | grep -v grep | awk '{print $1}' | xargs kill", function ()
    -- Update volume with each line printed
    awful.spawn.with_line_callback(volume_script, {
        stdout = function(line)
            update_widget()
        end
    })
end)

return volume_bar
