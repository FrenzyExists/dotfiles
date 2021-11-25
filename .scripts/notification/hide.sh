#!/usr/bin/env bash

masked=$(bspc query -N -n .hidden -d focused)

if [ -z "$masked" ]; then
    bspc node focused -g hidden=on
else
    bspc node "$masked" -g hidden=off
fi
