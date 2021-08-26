#!/usr/bin/sh

# Frenzy's totally not stolen (liar) from someone else welcome script

# This lil script gives you a warm welcome cuz it feels good to not feel alone XD

# Dependencies:
# dunstify

NAME="Pikachu"
APPNAME=609

while true ; do


    datey=$(date +%H)

    if [[ "$datey" -lt 11 ]] ; then
        dunstify -i ~/.config/dunst/icons/d-8.svg "Good Morning" "$NAME!" -u low -a $APPNAME
    elif [[ "$datey" -lt 16 ]] ; then
        dunstify -i ~/.config/dunst/icons/d-4.svg "Good Afternoon" "$NAME!" -u low -a $APPNAME
    elif [[ "$datey" -lt 18 ]] ; then
        dunstify -i ~/.config/dunst/icons/d-6.svg "Good Evening" "$NAME!" -u low -a $APPNAME
    elif [[ "$datey" -lt 22 ]] ; then
        dunstify -i ~/.config/dunst/icons/d-10.svg "Nighty" "$NAME!" -u low -a $APPNAME
    elif [[ "$datey" -lt 0 ]] ; then
        dunstify -i ~/.config/dunst/icons/d-12 "Go to sleep" "$NAME!" -u low -a $APPNAME
    elif [[ "$datey" -lt 3 ]] ; then
        dunstify -i ~/.config/icons/evil.svg "Demons are watching you..." -u low -a $APPNAME
    fi
    sleep 3600

done
