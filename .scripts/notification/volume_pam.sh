#!/usr/bin/sh

welcome() {
printf "%s" "\

# Frenzy's
██    ██  ██████  ██      ██    ██ ███    ███ ███████ 
██    ██ ██    ██ ██      ██    ██ ████  ████ ██      
██    ██ ██    ██ ██      ██    ██ ██ ████ ██ █████   
 ██  ██  ██    ██ ██      ██    ██ ██  ██  ██ ██      
  ████    ██████  ███████  ██████  ██      ██ ███████ 

version 0.1: Touch of Katana

Dependencies:
    - pamixer -> Pulseaudio controller
    - dunst -> a nice lil notifier

A pamixer wrapper script that uses dunst to send notifications
  Options:

  up -> Increases the volume

  down -> Decreases the volume

  toggle -> Mutes or Unmutes the volume
"
exit 1
}

ID=500
APPNAME="volume_boi"

# If someone wants to know how to use this
if [[ "$1" == "" ]] ; then
    welcome
fi

# Functions

# Get the volume thingy
function get_volume {
    local yeet=$(pamixer --get-volume-human)
    if [[ "$yeet" != "mute" ]] ; then
        yeet="${yeet%\%*}"
    fi
    echo $yeet
}

# Bar thingy (s t a r s)
function bar_thingy {
    # This is for 5 hearts btw
    #     
    full=""
    half=""
    empty=""

    red="\033[0;31m"

    volume=$(get_volume)

    total_half_hearts=$(( $(echo ${volume} / 10 | cut -f1 -d ".") ))

    half_hearts=$(( ${total_half_hearts} % 2 ))
    full_hearts=$(( ( ${total_half_hearts} - $(( ${total_half_hearts} % 2 )) ) / 2))
    empty_hearts=$(( 5 - ( ${full_hearts} + half_hearts ) ))

    local bar=$(echo $(echo $(seq -s " " $((${full_hearts}+1)) )$(seq -s " " $((${half_hearts}+1)) )$(seq -s " " $(($empty_hearts + 1)) ) ) | sed 's/[0-9]//g') 
    echo $bar
}

# Sends the notification
function dunsty_boi {
    volume=$(get_volume)

    # The other stuff
    if [[ "$volume" == "0"  ]] ; then
        icon_name="~/.config/dunst/icons/skull.svg"
    else
        if [[ "$volume" -lt "30"  ]] ; then
            icon_name="~/.config/dunst/icons/wand.svg"
        else
            if [[ "$volume" -lt "60" ]] ; then
                icon_name="~/.config/dunst/icons/wand_bling.svg"
            else
                if [[ "$volume" -lt "90" ]] ; then
                    icon_name="~/.config/dunst/icons/spell_book.svg"
                else
                    icon_name="~/.config/dunst/icons/wizard_hat.svg"
                fi
            fi
        fi
    fi
    # Send notification thing
    #dunstify -i $icon_name -r ${ID} -a ${APPNAME} -h string:fgcolor:#ebe3ba -h string:frcolor:#ebe3ba $(bar_thingy) 
    #dunstify -h string:fgcolor:#2c2e3e '      ' -i $icon_name -r ${ID} -a ${APPNAME} "<span foreground='#caf6bb' font_desc='UbuntuMono Nerd Font 22'><b>Volume</b></span>\n<span foreground='#ebb9b9' font_desc='Source Code Pro 23'><b>$(bar_thingy)</b></span>"
    dunstify  -i $icon_name -r $ID -a $APPNAME -h string:fgcolor:#2c2e3e '      ' "<span foreground='#ebb9b9' font_desc='Cartograph CF Italic 19'><b>Vo</b></span><span foreground='#ebe3b9' font_desc='Cartograph CF Italic 19'><b>lu</b></span><span foreground='#caf6bb' font_desc='Cartograph CF Italic 19'><b>me</b></span>\n<span foreground='#cddbf9' font_desc='Source Code Pro 23'><b>$(bar_thingy)</b></span>"
}


# Main thing
if [[ $# -gt 0 ]] ; then
    case "$1" in
        help)
            welcome
            ;;
        up)
            volume=$(get_volume)
            if [[ $volume != "muted" ]] ; then
                pamixer -i 10
                dunsty_boi
            fi
            ;;
        down)
            volume=$(get_volume)
            if [[ $volume != "muted" ]] ; then
                pamixer -d 10
                dunsty_boi
            fi
            ;;
        toggle)
            pamixer -t
            volume=$(get_volume)
            echo $volume
            if [[ "$volume" == "muted" ]] ; then
                icon_name="~/.config/dunst/icons/skull.svg"
                #dunstify -i "$icon_name" -r $ID -a $APPNAME -h string:fgcolor:#ebb9ba -h string:frcolor:#ebb9ba "U  D E D"
                dunstify  -i $icon_name -r $ID -a $APPNAME -h string:fgcolor:#2c2e3e '      ' "<span foreground='#ebb9b9' font_desc='Cartograph CF Italic 19'><b>Vo</b></span><span foreground='#ebe3b9' font_desc='Cartograph CF Italic 19'><b>lu</b></span><span foreground='#caf6bb' font_desc='Cartograph CF Italic 19'><b>me</b></span>\n<span foreground='#cddbf9' font_desc='Source Code Pro 23'><b> U  D E D</b></span>"
            else
                dunsty_boi
            fi
            ;;
        *)
            welcome
            ;;
    esac
fi

