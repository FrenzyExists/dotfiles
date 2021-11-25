#!/usr/bin/sh


ID=609
APPNAME="spawn_boi"

alacritty &

bspc node -n last.!automatic -t floating -g hidden=on

#bspc query -N -n focused.automatic 

#params=$(slop -f "%x %y %w %h")

# xdotool search -onlyvisible --class alacritty behave %@focus mouse-enter getwindowpid

#xdotool windowsize $(xdotool search -class alacritty)[0] 564 360

notify-send "Spawn a terminal :3"
