#!/bin/bash


# TODO Check if eww is running in the first place :v

if [[ "$1" == "right" ]] ; then
    shift
    if [[ "$1" == "on" ]]; then
        ~/eww/target/release/eww open rightSidebar
    elif [[ "$1" == "off" ]]; then
        ~/eww/target/release/eww close rightSidebar
    else
    		printf "Type 'eww_sidebar on' to fire up side bar or 'eww_sidebar off to close it'"
    fi

elif [[ "$1" == "top" ]] ; then
    shift
    if [[ "$1" == "on" ]] ; then
        ~/eww/target/release/eww open topSidebar
    elif [[ "$1" == "off" ]]; then
        ~/eww/target/release/eww close topSidebar
    else
    		printf "Type 'eww_sidebar on' to fire up side bar or 'eww_sidebar off to close it'"
    fi
elif [[ "$1" == "left" ]] ; then
    shift
    if [[ "$1" == "on" ]] ; then
        ~/eww/target/release/eww open leftSidebar
    elif [[ "$1" == "off" ]]; then
        ~/eww/target/release/eww close leftSidebar
    else
    		printf "Type 'eww_sidebar on' to fire up side bar or 'eww_sidebar off to close it'"
    fi
fi
