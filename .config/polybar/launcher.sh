# etc/bin/bash

killall -q polybar

polybar -c ~/.config/polybar/config top &

polybar -c ~/.config/polybar/config bottom &
