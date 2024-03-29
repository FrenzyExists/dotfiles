#!/usr/bin/env bash
# ┬┌─┬ ┬┌┐┌┌─┐┌┬┐
# ├┴┐│ ││││└─┐ │
# ┴ ┴└─┘┘└┘└─┘ ┴
# Created by Siddharth Dushantha
#
# Dependencies: sxiv, imagemagick, bash, ffmpeg, mpc, jq, mpd

VERSION=1.3.2
COVER=/tmp/kunst.jpg
METADATA=/tmp/kunst.txt
MUSIC_DIR=$HOME/Music
SIZE=250x250
NO_PIC_ON_NOTIF=false
ARTIST_NOTIF_COLOR="#ebe3b9"
SONG_NOTIF_COLOR="#caf6bb"
DUNST_TOP_STYLE="      "
DUNST_TOP_COLOR="#2c2e3e"
POSITION="+0+0"
ONLINE_ALBUM_ART=false
API="https://api.deezer.com/search/autocomplete?q="
ID=696
APPNAME="mpd_enjoyer"

show_help() {
printf "%s" "\
usage: kunst [-h] [--size \"px\"] [--position \"+x+y\"][--music_dir \"path/to/dir\"] [--silent] [--version]

┬┌─┬ ┬┌┐┌┌─┐┌┬┐
├┴┐│ ││││└─┐ │
┴ ┴└─┘┘└┘└─┘ ┴
Download and display album art or display embedded album art

optional arguments:
   -h, --help            show this help message and exit
   --size                what size to display the album art in
   --position            the position where the album art should be displayed
   --music_dir           the music directory which MPD plays from
   --silent              dont show the output
   --force-online        force getting cover from the internet
   --version             show the version of kunst you are using
"
}

# Parse the arguments
options=$(getopt -o h --long position:,size:,music_dir:,version,force-online,no-send-notifications,no-send-pic,silent,help -- "$@")
eval set -- "$options"

while true; do
    case "$1" in
        --size)
            shift;
            SIZE=$1
            ;;
        --position)
            shift;
            POSITION=$1
            ;;
        --music_dir)
            shift;
            MUSIC_DIR=$1
            ;;
        -h|--help)
		    show_help
			exit
            ;;
        -v|--version)
            echo $VERSION
            exit
            ;;
        --force-online)
            ONLINE_ALBUM_ART=true
            ;;
        --no-send-notifications)
            NO_SEND_NOTIFICATIONS=true
            ;;
        --no-send-pic)
            NO_SEND_PIC=true
            ;;
        --silent)
            SILENT=true
            ;;
        --)
            shift
            break
            ;;
    esac
    shift
done

# This is a base64 endcoded image which will be used if
# the file does not have an emmbeded album art.
# The image is an image of a music note
read -r -d '' MUSIC_NOTE << EOF
iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAJESURBVGhD7Zg/axRRFMVXAtpYphEVREKClnHfJI0MmReSfAC3tRejhaBgo70fwN7aD2BvEU0gfztbu5AqMxNjoVnvG87KZXy7z5m5dxLI/OCw8Pade+7M3n3Dbq+jo6OjY8RwMJhKk+hhlph3eRJ9w/LF5jCOr1PTj6jpD7mNjkjDkbDl4vFjpX87teZJlkSfSD9501zYfv5QJ1fyZHGexuJtZs12ZqMzX8NlwX4+nK3NXMutWaOm39Nd/u5rMCSUao80fjBNwY+p8Y+krNxQVaGsLsfWzFLYS2r4M30Rf5WbaCJE6OILlhIidPEFSwkRuviCpYQIXXzB1WX26bR6ky4v3OPriNCFB1YRHa079Pr6eKk/h1IFfA+WdOGBk+QeXtT0Ft3pV6e2fxf2f+AeLOnCA8tC0xv09H1xGi/cgWUi3I8lXXigEzX8u3gmWPP8JI5uYdt/w2thSRceSM0/zVfnb+CtWvB6WNJFOlC6XhDpQOl6QaQDpesFkQ6UrhdEOlC6XpA6gcPB/avumKXnxCadXHkha766tTr1GlE18CRZvEmN7nHfOMGiS5XA4mdmYg64Z5Jg06VKYHlEQoKtOVIz6zx8f0iwNUNyZt2F+3zjBFt9pGe22gWYFLb6lEckJNjGUmWEssR8ga0+0jNL9Z75fD7Rp7UOW32kZxb/1u37vFyUu+sODtjqozGzxaFADfprFM3vuD3Y3gytmf17LJPHXbgTNb5BWhe58yNan1lpWp9ZDVqdWS1am9mOjo7LRq/3B1ESKyYUVquzAAAAAElFTkSuQmCC
EOF


is_connected() {
	# Check if internet is connected. We are using api.deezer.com to test
	# if the internet is connected because if api.deezer.com is down or
	# the internet is not connected this script will work as expected
	if ping -q -c 1 -W 1 api.deezer.com >/dev/null; then
		connected=true
	else
        [ ! "$SILENT" ] && echo "kunst: unable to check online for the album art"
		connected=false
	fi
}

# Gets the album metadata from the internet via some api like Deeser or something
get_cover_online() {
	# Check if connected to internet
	is_connected

	if [ "$connected" == false ];then
		ARTLESS=true
		return
	fi

    # If the current playing song ends with .mp3 or something similar, remove
    # it before searching for the album art because including the file extension
    # reduces the chance of good results in the search query
    QUERY=$(mpc current | sed 's/\.[^.]*$//' | iconv -t ascii//TRANSLIT -f utf8)

	# Try to get the album cover online from api.deezer.com
	API_URL="$API$QUERY" && API_URL=${API_URL//' '/'%20'}

	# Extract the albumcover from the json returned
	IMG_URL=$(curl -s "$API_URL" | jq -r '.tracks.data[0].album.cover_big')

	if [ "$IMG_URL" = '' ] || [ "$IMG_URL" = 'null' ];then
        [ ! "$SILENT" ] && echo "error: cover not found online"
		ARTLESS=true
	else
        [ ! "$SILENT" ] && echo "kunst: cover found online"
        curl -o "$COVER" -s "$IMG_URL"
	    ARTLESS=false
	fi
}

# Gets the album metadata from the song itself
get_album_offline() {
    # Get music location

    echo "Getting Music Location..."
    SONG=$(mpc current -f %file%)

    # Performs a copy of the album found in the metadata of the song
    ffmpeg -hide_banner -loglevel error -i "$MUSIC_DIR/$SONG" -an -vcodec copy $COVER
}

# Override Metadata
send_notification() { 

    if [ "$(mpc current -f %artist%)" == "" ] || [ "$(mpc current -f %name%)" == "" ] ; then
        
        if [ "$connected" == false ] ; then
            ARTIST_NAME=" MPD PLAYER "
            SONG_NAME=" Groovy "
        else
            [ ! "$SILENT" ] && echo "No Artist metadata: Searching on the internet..."
        
            curl -s "$API_URL" -o $METADATA
        
            ARTIST_NAME=$(jq -r '.tracks.data[0].artist.name' $METADATA)
            SONG_NAME=$(jq -r '.tracks.data[0].title' $METADATA)
            
            if [ "$ARTIST_NAME" == null ] || [ "$SONG_NAME" == null ]; then
                ARTIST_NAME=" MPD PLAYER "
                SONG_NAME=" Groovy "
            fi
       fi
    else
        ARTIST_NAME=$(mpc current -f %artist%)
        SONG_NAME=$(mpc current -f %name%)
    fi 
    
    if [ "$NO_PIC_ON_NOTIF" == true ] ; then
        dunstify -r $ID -a $APPNAME -h string:fgcolor:$DUNST_TOP_COLOR "$DUNST_TOP_STYLE" "<span foreground='$ARTIST_NOTIF_COLOR' font_desc='Cartograph CF Italic 12.5'><b>$ARTIST_NAME</b></span>\n<span foreground='$SONG_NOTIF_COLOR' font_desc='Cartograph CF Italic 14'><b>$SONG_NAME</b></span>"
    else
        dunstify  -i $COVER -r $ID -a $APPNAME -h string:fgcolor:$DUNST_TOP_COLOR "$DUNST_TOP_STYLE" "<span foreground='$ARTIST_NOTIF_COLOR' font_desc='Cartograph CF Italic 12'><b>$ARTIST_NAME</b></span>\n<span foreground='$SONG_NOTIF_COLOR' font_desc='Cartograph CF Italic 12'><b>$SONG_NAME</b></span>"
    fi

}

find_album_art() {
    # Check if the user wants to get the album art from the internet,
    # regardless if the curent song has an embedded album art or not
    if [ "$ONLINE_ALBUM_ART" == true ];then
        [ ! "$SILENT" ] && echo "kunst: getting cover from internet"
		get_cover_online
        return
    fi

	# Extract the album art from the mp3 file and dont show the messsy
	# output of ffmpeg
	#ffmpeg -i "$MUSIC_DIR/$(mpc current -f %file%)" "$COVER" -y &> /dev/null

    SONG=$(mpc current -f %file%)
    ffmpeg -hide_banner -loglevel error -i "$MUSIC_DIR/$SONG" -an -vcodec copy "$COVER" -y &> /dev/null

	# Get the status of the previous command
	STATUS=$?

    # Check if the file has a embbeded album art
    if [ "$STATUS" -eq 0 ];then
        [ ! "$SILENT" ] && echo "kunst: extracted album art"
        ARTLESS=false
    else

        DIR="$MUSIC_DIR$(dirname "$(mpc current -f %file%)")"

        [ ! "$SILENT" ] && echo "kunst: inspecting $DIR"
        
        # Check if there is an album cover/art in the folder.
        # Look at issue #9 for more details
        for CANDIDATE in "$DIR/cover."{png,jpg}; do
            if [ -f "$CANDIDATE" ]; then
                STATUS=0
                ARTLESS=false
                convert "$CANDIDATE" $COVER &> /dev/null
                [ ! "$SILENT" ] && echo "kunst: found cover.png"
            fi
        done
    fi

	if [ "$STATUS" -ne 0 ];then
        [ ! "$SILENT" ] && echo "error: file does not have an album art"
		get_cover_online
	fi
}


update_cover() {
    find_album_art

	if [ "$ARTLESS" == false ]; then
		convert "$COVER" -resize "$SIZE" "$COVER" &> /dev/null
        [ ! "$SILENT" ] && echo "kunst: resized album art to $SIZE"
	fi

}

pre_exit() {
	# Get the proccess ID of kunst and kill it.
    # We are dumping the output of kill to /dev/null
    # because if the user quits sxiv before they
    # exit kunst, an error will be shown
    # from kill and we dont want that
	kill -9 "$(cat /tmp/kunst.pid)" &>/dev/null

}

main() {

    dependencies=(sxiv convert bash ffmpeg mpc jq mpd dunstify dunst)
    for dependency in "${dependencies[@]}"; do
        type -p "$dependency" &>/dev/null || {
            echo "error: Could not find '${dependency}', is it installed?" >&2
            exit 1
        }
    done

    [ "$KUNST_MUSIC_DIR" != "" ] && MUSIC_DIR="$KUNST_MUSIC_DIR"
    [ "$KUNST_SIZE" != "" ] && SIZE="$KUNST_SIZE"
    [ "$KUNST_POSITION" != "" ] && POSITION="$KUNST_POSITION"

	# Flag to run some commands only once in the loop
	FIRST_RUN=true

    while true; do
		update_cover

		if [ "$ARTLESS" == true ];then
			# Dhange the path to COVER because the music note
            # image is a png not jpg
            COVER=/tmp/kunst.png
            
            # Decode the base64 encoded image and save it
            # to /tmp/kunst.png
            echo "$MUSIC_NOTE" | base64 --decode > "$COVER"
        fi

        # Notifications thingy
        if [ ! "$NO_SEND_NOTIFICATIONS" ] ; then
            send_notification
        fi

        if [ ! "$SILENT" ];then
            echo "kunst: swapped album art to $(mpc current)"
            printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
        fi
        

		if [ "$FIRST_RUN" == true ]; then
			FIRST_RUN=false

			# Display the album art using sxiv
            if [ "$NO_SEND_PIC" != true ] ; then
    			sxiv -g "$SIZE$POSITION" -b "$COVER" -N "Kunst" &
            fi

			# Save the process ID so that we can kill
			# sxiv when the user exits the script
			echo $! >/tmp/kunst.pid
		fi
        
	    # Waiting for an event from mpd; play/pause/next/previous
	    # this is lets kunst use less CPU :)
        while true; do
            mpc idle player &>/dev/null && (mpc status | grep "\[playing\]" &>/dev/null) && break
        done
        [ ! "$SILENT" ] && echo "kunst: received event from mpd"
	done
}

# Disable CTRL-Z because if we allowed this key press,
# then the script would exit but, sxiv would still be
# running
trap "" SIGTSTP

trap pre_exit EXIT
main
