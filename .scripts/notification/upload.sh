#!/u2sr/bin/sh

function welcome {
    printf "%s" "\"

version 0.1: Steven is installed twice

Dependencies:
    0x0.sh -> some random server from Germany
    dunst -> a nice lil notifier

"
exit 1
}

icon_name="~/.config/dunst/icons/to_the_moon.svg"
ID=666
APPNAME="0x0_send"

myclip=$(xclip -o)
echo $myclip

if [ -n "$myclip" ]; then
    
    #xclip -i ${op:-echo} "${1:-`cat -`}" | curl -F file='@-' 'http://0x0.st'
    dunstify  -i $icon_name -r ${ID} -a ${APPNAME} "Sent to the Moon!" 
fi


# xclip -i ${op:-echo} "${1:-`cat -`}" | curl -F file='@-' 'http://0x0.st'



