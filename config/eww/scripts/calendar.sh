#!/bin/bash
# eww ouputs date format as DAY.MONTH.YEAR with no leading zeros

# Need these to be computed lightning fast
# Neither calcurse nor date need leading zeros, so we don't have to worry about those
day="${1%%.*}"
month="${1#*.}"
month="${month%.*}"
month=$((month+1)) # for some reason eww gives the month as a zero-based integer
year="${1##*.}"

IFS=$'\n'
appointments=( $(calcurse --input-datefmt 4 --format-apt "%m\n" --format-recur-apt "%m\n" -d "${year}-${month}-${day}" | tail -n +2) )
appointment_times=( $(calcurse --input-datefmt 4 --format-apt "%S - %E\n" --format-recur-apt "%S - %E\n" -d ${year}-${month}-${day} | tail -n +2) )

# Sort these by approximate expected duration and run in parallel to gain execution time
~/eww/target/release/eww update appointment_times="$(printf '%s\n' "${appointment_times[@]}")" &
~/eww/target/release/eww update appointment_names="$(printf '%s\n' "${appointments[@]}")" &
~/eww/target/release/eww update month_cal="$(date --date="${year}-${month}-${day}" +%b)" &
~/eww/target/release/eww update weekday_cal="$(date --date="${year}-${month}-${day}" +%a)" &
~/eww/target/release/eww update day_num_cal="$day" &
~/eww/target/release/eww update year_cal="$year" &

