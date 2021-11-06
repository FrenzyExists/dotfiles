#!/usr/bin/zsh

sleep .5

if ! pgrep -x polybar; then
			
	polybar -c ~/.config/polybar/config top &
    polybar -c ~/.config/polybar/config bottomboi &
else
	# Kill prev polybar session
	pkill -USR1 polybar
fi

echo "Bar launched..."
