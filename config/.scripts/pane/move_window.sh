#!/bin/sh

# Move floating windows around

# Defaults
jump=20

# Get current setup information
getInfo() {
	# Get screen dimensions
	screen_info=$(xrandr --query --current | grep -oE 'current [0-9]+ x [0-9]+')
	screen_width=$(printf '%s' "$screen_info" | awk '{print $2}')
	screen_height=$(printf '%s' "$screen_info" | awk '{print $4}')
	# Get current window size
	eval "$(xdotool getactivewindow getwindowgeometry --shell)"
	win_width=$WIDTH
	win_height=$HEIGHT
	# Get BSPWM current settings
	border_width=$(bspc config -d focused border_width)
	border_width=$((border_width*2))
	window_gap=$(bspc config -d focused window_gap)
	left_padding=$(bspc config -m focused left_padding)
	top_padding=$(bspc config -m focused top_padding)
	right_padding=$(bspc config -m focused right_padding)
	bottom_padding=$(bspc config -m focused bottom_padding)
}

# Exit if window is not floating
bspc query --tree --node | grep --silent '"state":"floating"' || exit 10

# Run function to get information
getInfo

# Check arguments
while [ "$#" -gt 0 ]; do
	case $1 in
		left|west)
			# Move window left
			xpos=$((0 - jump))
			xdotool getactivewindow windowmove --relative -- $xpos y
			shift
			;;
		right|east)
			# Move window right
			xpos=$jump
			xdotool getactivewindow windowmove --relative -- $xpos y
			shift
			;;
		up|north)
			# Move window up
			ypos=$((0 - jump))
			xdotool getactivewindow windowmove --relative -- x $ypos
			shift
			;;
		down|south)
			# Move window down
			ypos=$jump
			xdotool getactivewindow windowmove --relative -- x $ypos
			shift
			;;
		edge-left|edge-west)
			# Move window to the left screen edge
			xpos=$((0 + window_gap + left_padding))
			xdotool getactivewindow windowmove -- $xpos y
			shift
			;;
		edge-right|edge-east)
			# Move window to the right screen edge
			xpos=$((screen_width - win_width - window_gap - right_padding - border_width))
			xdotool getactivewindow windowmove -- $xpos y
			shift
			;;
		top|edge-up|edge-north)
			# Move window to the top screen edge
			ypos=$((0 + window_gap + top_padding))
			xdotool getactivewindow windowmove -- x $ypos
			shift
			;;
		bottom|edge-down|edge-south)
			# Move window to the bottom screen edge
			ypos=$((screen_height - win_height - window_gap - bottom_padding - border_width))
			xdotool getactivewindow windowmove -- x $ypos
			shift
			;;
		*)
			# Exit on unknown arguments
			exit 1
			;;
	esac
done
