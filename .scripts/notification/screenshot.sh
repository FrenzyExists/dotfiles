#!/bin/sh

# Frenzy's dunst maim notification

welcome() {
  printf "%s" "\

███████  ██████ ██████  ███████ ███████ ███    ██ ███████ ██   ██  ██████  ████████ 
██      ██      ██   ██ ██      ██      ████   ██ ██      ██   ██ ██    ██    ██    
███████ ██      ██████  █████   █████   ██ ██  ██ ███████ ███████ ██    ██    ██    
     ██ ██      ██   ██ ██      ██      ██  ██ ██      ██ ██   ██ ██    ██    ██    
███████  ██████ ██   ██ ███████ ███████ ██   ████ ███████ ██   ██  ██████     ██    
                                                                                    

version 0.1: All of you

Dependencies:
  - maim -> a screenshot tool
  - dunst -> a nice lil notifier

Options:
  --store  | -s   -- How you want to store:
            -> clip
            -> save -> if you want to save a second param could be input 
            for the path

  --mode   | -m   -- How you want to take the screenshot
            -> full
            -> select
 "
 exit 1
}


set -e

# If someone wants to know how to use this
if [[ "$1" == "" ]] ; then
  welcome
fi

default_path_to_save="$HOME/Pictures/Screenshots/"
while test $# -gt 0 ; do
  case "$1" in
    -h|--help)
      welcome
      ;;
    -m|--mode)
      shift
      if [[ "$1" == "full" ]] ; then
          mode="full"
      elif [[ "$1" == "select" ]] ; then
          mode="select"
      else
        printf "Specify mode: full or select"
        exit 1
        fi
        shift
        ;;
        -s|--store)
        shift
        if [[ "$1" == "clip" ]] ; then
            store="clip"  
        elif [[ "$1" == "save" ]] ; then
            store="save"
        if [[ -d "$2"  ]] ; then
            case "$2" in
                */) path_to_save="$2"
               # break
                ;;
                *) path_to_save="$2"/
                #break
                ;;
            esac
            shift
        else
            path_to_save="$default_path_to_save"
        fi
        else
            printf "Specify store: save or clip"
            exit 1
        fi
        shift
        ;;
    *)
        break
        ;;
    esac
done

# Dunst Time
send_notification() {
    if >/dev/null 2>&1 command -v notify-send ; then
        if [[ "${store}" == "save" ]] ; then
            #dunstify -i ~/.config/dunst/icons/screenshot.svg 'Screenshot saved!'
            dunstify -h string:fgcolor:#2c2e3e '      ' -i ~/.config/dunst/icons/screenshot.svg   "<span foreground='#ebb9b9' font_desc='Cartograph CF Italic 19'><b>Scr</b></span><span foreground='#ebe3b9' font_desc='Cartograph CF Italic 19'><b>eens</b></span><span foreground='#caf6bb' font_desc='Cartograph CF Italic 19'><b>hot</b></span> \n<span foreground='#cddbf9' font_desc='Cartograph CF 13'><b>Screenshot saved!</b></span>"
        elif [[ "${store}" == "clip" ]] ; then
            #dunstify -h string:fgcolor:#2c2e3e '      ' -i ~/.config/dunst/icons/clipboard.svg 'Screenshot passed to clipboard!'
            dunstify -h string:fgcolor:#2c2e3e '      ' -i ~/.config/dunst/icons/clipboard.svg   "<span foreground='#ebb9b9' font_desc='Cartograph CF Italic 19'><b>Scr</b></span><span foreground='#ebe3b9' font_desc='Cartograph CF Italic 19'><b>eens</b></span><span foreground='#caf6bb' font_desc='Cartograph CF Italic 19'><b>hot</b></span> \n<span foreground='#cddbf9' font_desc='Cartograph CF 13'><b>Passed to clipboard!</b></span>"
        fi
    fi
}

# Main function
take_screenshot() {
    if [[ "${store}" == "save" ]] ; then
        if [[ "${mode}" == "select" ]] ; then
            maim --hidecursor --select  "${path_to_save}$(date +%s.)png" 
        elif [[ "${mode}" == "full" ]] ; then
            maim --hidecursor "${path_to_save}$(date +%s).png"
        fi
    elif [[ "${store}" == "clip" ]] ; then
        if [[ "${mode}" == "select" ]] ; then
            maim --hidecursor --select | xclip -selection clipboard -t image/png
        elif [[ "${mode}" == "full" ]] ; then
            maim --hidecursor | xclip -selection clipboard -t image/png
        fi
    fi
    send_notification
  exit 1
}

take_screenshot
