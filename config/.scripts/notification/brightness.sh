#!/usr/bin/sh

function welcome {
    printf "%s" "\

version 0.1: Zombie

Dependencies:
  - xbacklightt -> Brightness controller
  - dunst -> a nice lil notifier
 
An xbacklight wrapper script that uses dunst to send notifications

Options:
  up -> increase the brightness

  down -> decrease the brightness
"
    exit 1
}

ID=600
APPNAME="brightness_boi"

# Get the Brightness 
function get_brightness {
    local brighty=$(xbacklight -get | sed 's/[.].*//g')
    echo $brighty
}

# Bar Thingy
function bar_thingy {
    # This is for 5 hearts btw
    # 聯 聯 ﱾ 輦 輦
    full=""
    half=""
    empty=""
    brightness=$(get_brightness)
    total_half_hearts=$(( $(echo ${brightness} / 10 | cut -f1 -d ".") ))

    half_hearts=$(( ${total_half_hearts} % 2 ))
    full_hearts=$(( ( ${total_half_hearts} - $(( ${total_half_hearts} % 2 )) ) / 2))
    empty_hearts=$(( 5 - ( ${full_hearts} + half_hearts ) ))

    local bar=$(echo $(echo $(seq -s ${full} $((${full_hearts}+1)) )$(seq -s ${half} $((${half_hearts}+1)) )$(seq -s ${empty} $(($empty_hearts + 1)) ) ) | sed 's/[0-9]//g')
    echo $bar
}

function dunsty_boi {
    brightness=$(get_brightness)

    # Icon n stuff
    if [[ "$brightness" -lt "20" ]] ; then
        icon_name="~/.config/dunst/icons/moon.svg"
    else
        if [[ "$brightness" -lt "40" ]] ; then
            icon_name="~/.config/dunst/icons/moon_stars.svg"
        else
            if [[ "$brightness" -lt "60" ]] ; then
                icon_name="~/.config/dunst/icons/star.svg"
            else
                if [[ "$brightness" -lt "80" ]] ; then
                    icon_name="~/.config/dunst/icons/star_stars.svg"
                else
                    icon_name="~/.config/dunst/icons/planet.svg"
                fi
            fi
        fi
    fi

    # Send notification thing
    dunstify -i $icon_name -r ${ID} -a {APPNAME} $(bar_thingy)
}


# Main function thingy
if [[ $# -gt 0 ]] ; then
    case "$1" in
        up)
            xbacklight -inc 10
            dunsty_boi
        ;;
        down)
            xbacklight -dec 10
            dunsty_boi
        ;;
    esac
fi
