#!/usr/bin/env bash

# extremely simple system info script.
# written by Nathaniel Maia, 2017-2020

# fallback
FB="unknown"

# colours, FG(0-7) and BG(0-7)
RST=$'\e[0m'
for n in {0..7}; do
	printf -v "FG${n}" "%b" "\e[3${n}m"
	printf -v "BG${n}" "%b" "\e[4${n}m"
done

# source whichever distro release file is available
if [[ -e /etc/os-release ]] && . /etc/os-release 2>/dev/null; then
	DIST="${ID,,}"
elif [[ -e /etc/lsb-release ]] && . /etc/lsb-release 2>/dev/null; then
	DIST="${DISTRIB_ID,,}"
fi

# system uptime
UPT="$(uptime -p)"
UPT="${UPT/up /}"
UPT="${UPT/ day?/d}"
UPT="${UPT/ hour?/h}"
UPT="${UPT/ minute?/m}"

# check if root user
USR="${FG4}${USER}"
(( UID == 0 )) &&USR="${FG1}root"

# install date
if [[ -e /var/log/pacman.log ]]; then
	INST="$(sed 1q /var/log/pacman.log)"
	INST="${INST/ */}"
	INST="${INST/T*/}" # newer pacman adds a different timestamp (TXX:XX:XX+0000), we just want the date
	INST="${INST/\[/}"
	INST="${INST//\-/ }"
fi

# gtk settings
if [[ -e ~/.config/gtk-3.0/settings.ini ]]; then
	THEME="$(awk -F'=' '/gtk-theme-name/ {print $2}' ~/.config/gtk-3.0/settings.ini)"
	ICONS="$(awk -F'=' '/gtk-icon-theme-name/ {print $2}' ~/.config/gtk-3.0/settings.ini)"
elif [[ -e ~/.gtkrc-2.0 ]]; then
	THEME="$(awk -F'"' '/gtk-theme-name/ {print $2}' ~/.gtkrc-2.0)"
	ICONS="$(awk -F'"' '/gtk-icon-theme-name/ {print $2}' ~/.gtkrc-2.0)"
fi

# login shell
SHLL="${SHELL##*/}"

# terminal name
TRM="${TERM/-256color/}"        # many terminals use a -256color suffix, remove it
TRM="${TRM/-unicode/}"          # rxvt can be rxvt-unicode, remove the -unicode suffix
TRM="${TRM/*-termite*/termite}" # termite is xterm-termite, truncate to just termite

# hostname
HOST="${HOST:-$(cat /etc/hostname 2>/dev/null)}"
HOST="${HOST:-$FB}"

# kernel version
KERN="${KERN:-$(uname -sr)}"
KERN="${KERN/-*/}"
KERN="${KERN,,}"

# MEM = used / total
FREE="$(free --mega)"
MB=$(awk 'NR==2 {print $3}' <<< "$FREE")
GB=$(awk 'NR==2 {printf "%.2f", $3 / 1000}' <<< "$FREE")
TOT=$(awk 'NR==2 {printf "%.2f", $2 / 1000}' <<< "$FREE")
if (( MB > 1000 )); then #  show in GB
	MEM="${GB:0:5}gb / ${TOT/\.*}gb"
else # show in MB
	MEM="${MB}mb / ${TOT/\.*}gb"
fi

# CPU threads and cores
THREADS=$(grep -c '^processor' /proc/cpuinfo)
THREADS=${THREADS:-1}
CORES=$(grep '^core' /proc/cpuinfo | sort | uniq | wc -l)
CORES=${CORES:-1}
# CPU usage needs to be divided by number of threads to get an average percentage
USAGE=$(ps aux | awk -v i="$THREADS" 'BEGIN{sum = 0} {sum += $3} END{printf "%.2f", sum / i}')
USAGE="${CORES}c/${THREADS}t @ $USAGE% avg"

rep_char()
{
	local char num str

	char="${1:-=}"
	num="${2:-$((${#USR} + 3 + ${#HOST}))}"
	str="$(printf "%${num}s")"
	echo "${str// /$char}"
}

pkg_count()
{
	pacman -Qq 2>/dev/null | wc -l || echo "$FB"
}

cur_wm()
{
	if [[ -z $WM && $DISPLAY ]] && hash xprop >/dev/null 2>&1; then
		ID="$(xprop -root -notype _NET_SUPPORTING_WM_CHECK)"
		WM="$(xprop -id "${ID##* }" -notype -len 100 -f _NET_WM_NAME 8t)"
		WM="${WM/*WM_NAME = }"
		WM="${WM/\"}"
		WM="${WM/\"*}"
		WM="${WM,,}"
		echo "${WM:-$FB}"
	else
		echo "${WM:-tty$XDG_VTNR}"
	fi
}

# terminal colour blocks under the info
BLOCKS="$BG1    $BG2    $BG3    $BG4    $BG5    $BG6    $BG7    ${RST}"

# clear the screen and print everything out
clear
cat << EOF
${FG4}                     'c'
${FG4}                    'kKk,                   ${FG5}===>$RST ${USR}${FG2} @ ${FG6}${HOST}
${FG4}                   .dKKKx.                  ${FG5}$(rep_char '=' $((${#USR} + 3 + ${#HOST})))>
${FG4}                  .oKXKXKd.                 ${FG6}->$RST   wm$FG1:     ${FG4}$(cur_wm)
${FG4}                 .l0XXXXKKo.                ${FG6}->$RST   term$FG1:   ${FG4}${TRM:-$FB}
${FG4}                 c0KXXXXKX0l.               ${FG6}->$RST   shell$FG1:  ${FG4}${SHLL:-$FB}
${FG4}                :0XKKOxxOKX0l.              ${FG6}->$RST   uptime$FG1: ${FG4}${UPT:-$FB}
${FG4}               :OXKOc.,.c0XX0l.
${FG4}              :OK0o, ${FG1}...${FG4}'dKKX0l.            ${FG6}->$RST   packages$FG1:  ${FG4}$(pkg_count)
${FG4}             :OX0c, ${FG1};xOx'${FG4}'dKXX0l.           ${FG6}->$RST   kernel$FG1:    ${FG4}${KERN:-$FB}
${FG4}            :0KKo.${FG1}.o0XXKd'.${FG4}lKXX0l.          ${FG6}->$RST   distro$FG1:    ${FG4}${DIST:-$FB}
${FG4}           c0XKd.${FG1}.oKXXXXKd..${FG4}oKKX0l.         ${FG6}->$RST   installed$FG1: ${FG4}${INST:-$FB}
${FG4}         .c0XKk;${FG1}.l0K0OO0XKd..${FG4}oKXXKo.
${FG4}        .l0XXXk:${FG1},dKx,.'l0XKo.${FG4}.kXXXKo.       ${FG6}->$RST   ram$FG1: ${FG4}${MEM}
${FG4}       .o0XXXX0d,${FG1}:x;   .oKKx'${FG4}.dXKXXKd.      ${FG6}->$RST   cpu$FG1: ${FG4}${USAGE}
${FG4}      .oKXXXXKK0c.${FG1};.    :00c'${FG4}cOXXXXXKd.
${FG4}     .dKXXXXXXXXk,${FG1}.     cKx'${FG4}'xKXXXXXXKx'    ${FG6}->$RST   theme$FG1: ${FG4}${THEME:-$FB}
${FG4}    'xKXXXXK0kdl:.     ${FG1}.ok; ${FG4}.cdk0KKXXXKx'   ${FG6}->$RST   icons$FG1: ${FG4}${ICONS:-$FB}
${FG4}   'xKK0koc,..         ${FG1}'c, ${FG4}    ..,cok0KKk,
${FG4}  ,xko:'.                           .':okx, $BLOCKS

EOF
