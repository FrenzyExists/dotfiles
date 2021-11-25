#!/bin/bash


#░█░░░▀█▀░█▀▀░█░█░▀█▀░░░░█░░░░█▀▄░█▀█░█▀▄░█░█░░░░█░░░▀█▀
#░█░░░░█░░█░█░█▀█░░█░░░░░█░░░░█░█░█▀█░█▀▄░█▀▄░░░░█░░░░█
#░▀▀▀░▀▀▀░▀▀▀░▀░▀░░▀░░░░░▀░░░░▀▀░░▀░▀░▀░▀░▀░▀░░░░▀░░░▀▀▀
#░By░Frenzy░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

# Color files
CONF="$HOME/.config"
POLY="$CONF/polybar/colors.ini"
POLY_2="$CONF/polybar/modules.ini"
ROFI="$CONF/rofi/colors.rasi"
WALL="$HOME/Pictures/wallpapers"
NOTI="$CONF/dunst"
KITT="$CONF/kitty/themes"
BSP="$CONF/bspwm"

# Change colors
change_color() {

    command -v polybar >/dev/null 2>&1 && { 
        echo >&2 "Found Polybar. Updating Colors..."

 	    # polybar
        sed -i -e "s/gui00 = #.*/gui00 = $gui00/g" $POLY
        sed -i -e "s/gui01 = #.*/gui01 = $gui01/g" $POLY
	    sed -i -e "s/gui02 = #.*/gui02 = $gui02/g" $POLY
	    sed -i -e "s/gui03 = #.*/gui03 = $gui03/g" $POLY
	    sed -i -e "s/gui04 = #.*/gui04 = $gui04/g" $POLY
	    sed -i -e "s/gui05 = #.*/gui05 = $gui05/g" $POLY
	    sed -i -e "s/gui06 = #.*/gui06 = $gui06/g" $POLY
	    sed -i -e "s/gui07 = #.*/gui07 = $gui07/g" $POLY
	    sed -i -e "s/gui08 = #.*/gui08 = $gui08/g" $POLY
	    sed -i -e "s/gui09 = #.*/gui09 = $gui09/g" $POLY
	    sed -i -e "s/gui0A = #.*/gui0A = $gui0A/g" $POLY
	    sed -i -e "s/gui0B = #.*/gui0B = $gui0B/g" $POLY
	    sed -i -e "s/gui0C = #.*/gui0C = $gui0C/g" $POLY
	    sed -i -e "s/gui0D = #.*/gui0D = $gui0D/g" $POLY
	    sed -i -e "s/gui0E = #.*/gui0E = $gui0E/g" $POLY
	    sed -i -e "s/gui0F = #.*/gui0F = $gui0F/g" $POLY
    
	    sed -i -e "s/ws-icon-0 = I\;.*/ws-icon-0 = I\;%\{F$gui0D\}%\{T8\} /g" $POLY_2
	    sed -i -e "s/ws-icon-1 = II\;.*/ws-icon-1 = II\;%\{F$gui0B\}%\{T8\} /g" $POLY_2
        sed -i -e "s/ws-icon-2 = III\;.*/ws-icon-2 = III\;%\{F$gui09\}%\{T8\} /g" $POLY_2
        sed -i -e "s/ws-icon-3 = IV\;.*/ws-icon-3 = IV\;%\{F$gui0A\}%\{T3\}/g" $POLY_2
        sed -i -e "s/ws-icon-4 = V\;.*/ws-icon-4 = V\;%\{F$gui0E\}%\{T3\} /g" $POLY_2
        sed -i -e "s/ws-icon-5 = VI\;.*/ws-icon-5 = VI\;%\{F$gui08\}%\{T8\}卵/g" $POLY_2
    
        # Restart Polybar
    	polybar-msg cmd restart
    }

#    command -v dunst >/dev/null 2>&1 && { 
#        echo >&2 "Found BSPWM. Updating Colors..."
        # Change Notifs
#        sed -i "s/background = .*/background = $gui00/g" $NOTI/dunstrc
#        sed -i "s/foreground = .*/foreground = $gui05/g" $NOTI/dunstrc
#        sed -i "s/frame_color = .*/frame_color = $gui03/g" $NOTI/dunstrc
        #sed -i 's/frame_width = .*/frame_width = 0/g' $NOTI/dunstrc
        #sed -i 's/geometry = .*/geometry = "310x100-35+95"/g' $NOTI/dunstrc

        # Restart Dunst
        #sleep 1 && killall dunst
#    }


    command -v bspc >/dev/null 2>&1 && { 
        echo >&2 "Found BSPWM. Updating Colors..."
        # bspwm
        # Change Gaps + Borders
#        sed -i 's/top_padding.*/top_padding 61/g' $BSP/bspwmrc
#        sed -i 's/window_gap .*/window_gap 19/g' $BSP/bspwmrc
#        sed -i 's/border_width .*/border_width 0/g' $BSP/bspwmrc
#        sed -i 's/focused_border_color .*/focused_border_color ${gui00}/g' $BSP/bspwmrc
#        sed -i 's/normal_border_color .*/normal_border_color ${gui00}/g' $BSP/bspwmrc
#        sed -i 's/presel_feedback_color .*/presel_feedback_color ${gui00}/g' $BSP/bspwmrc
        sed -i "s/outer=.*/outer=\'${gui00_}\'/g" $BSP/bspwmrc
        sed -i "s/inner1=.*/inner1=\'${gui06_}\'/g" $BSP/bspwmrc
        sed -i "s/inner2=.*/inner2=\'${gui03_}\'/g" $BSP/bspwmrc

        # Restart bsp
        bspc wm -r
    }


    if test -f "$KITT/$kitty_conf" ; then 
        kitty +kitten themes $name
    else
        printf "$name cannot be found. Make sure its in the themes folder in the configs!\n"
    fi

    # Change Wallpaper
    printf "$WALL/$wall_dir\n"
    if test -f "$WALL/$wall_dir" ; then
        printf "$WALL/$wall_dir\n"
        feh --bg-fill "$WALL/$wall_dir"
    else
        printf "Wallpaper not found. Aborting"
        exit 1
    fi

#    command -v feh >/dev/null 2>&1 && { 
#        echo >&2 "Found feh picture and wallpaper setter..."
#        feh --bg-fill $WALL/$wall_dir 
#    } || command -v nitrogen >/dev/null 2>&1 && {
#        nitrogen --set-zoom-fill $WALL/$wall_dir --save
#    }


    # Notify
    sleep 1.3 && notify-send 'Color Script' "Set $name Scheme"
}

if  [[ $1 = "--light" ]]; then
    gui00_="0xE6E6F1"
    gui06_="0x9CA6B9"
    gui03_="0xCCCBD9"

    gui00="#E6E6F1"
    gui01="#D5D4E0"
    gui02="#3D4059"
    gui03="#CCCBD9"
    gui04="#7F8E9D" 
    gui05="#708190" 
    gui06="#9CA6B9" 
    gui07="#D9DBE6" 
    gui08="#C34864" 
    gui09="#D66652" 
    gui0A="#DE956F" 
    gui0B="#7D9685" 
    gui0C="#829FB0" 
    gui0D="#6A8CBC" 
    gui0E="#8787BF" 
    gui0F="#E06B6B" 

    name="Aquarium Light"
    wall_dir="Flowers/veri-ivanova.jpg"
    kitty_conf="kitty_aquarium_light.conf"

    # These nuts
	change_color

elif  [[ $1 = "--dark" ]]; then
    gui00_="0x20202A"
    gui06_="0x414560"
    gui03_="0x63718B"

    gui00="#20202A"
    gui01="#2C2E3E"
    gui02="#3D4059"
    gui03="#63718B"
    gui04="#63718b"
    gui05="#CED4DF"
    gui06="#414560"
    gui07="#313449" # I switched it with gui03
    gui08="#EBB9B9"
    gui09="#E8CCA7"
    gui0A="#E6DFB8"
    gui0B="#B1DBA4"
    gui0C="#B8DCEB"
    gui0D="#A3B8EF"
    gui0E="#F6BBE7"
    gui0F="#EAC1C1"

    name="Aquarium Dark"
    wall_dir="Cherry Blossoms/wallhaven-8o3o7k.jpg"
    kitty_conf="kitty_aquarium_dark.conf"

    # These nuts
	change_color

elif  [[ $1 = "--mish" ]]; then
    gui00="#20202A"
    gui01="#2C2E3E"
    gui02="#3D4059"
    gui03="#313449"
    gui04="#63718b"
    gui05="#CED4DF"
    gui06="#414560"
    gui07="#63718B"
    gui08="#EBB9B9"
    gui09="#E8CCA7"
    gui0A="#E6DFB8"
    gui0B="#B1DBA4"
    gui0C="#B8DCEB"
    gui0D="#A3B8EF"
    gui0E="#F6BBE7"
    gui0F="#EAC1C1"

    name="Aquarium Mish"
    wall_dir="Aquarium/gen_1_starters-mish.png"
    kitty_conf="kitty_aquarium_mish.conf"

    # These nuts
	change_color

else
	cat <<- _EOF_
	No option specified, Available options:
	--light    --dark    --mish
	_EOF_
fi





