#!/usr/bin/zsh

# Close all windows of focused workspace
# Shitty implementation by Frenzy
# I am once again asking you to  S H I T

topNode=`echo "$(bspc query -N -d focused)" | head -1`

if [[ $"(bspc query -N -n focused)" ]] ; then 
    bspc node ${topNode} -k
fi

