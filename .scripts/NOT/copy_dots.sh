#!usr/bin/sh

# Copy dots plz

CONFIG="/home/frenzy/.config"
DOTFILES="/home/frenzy/Documents/dotfiles/config"

# Copy picom
cp "$CONFIG/picom.conf" $DOTFILES/picom/picom.conf

# Copy bspwmrc
cp "$CONFIG/bspwm/bspwmrc" "$DOTFILES/bspwm/bspwmrc"

# Copy mpd
cp "$CONFIG/mpd/*" "$DOTFILES/mpd/"

# Copy ncmpcpp
cp "$CONFIG/ncmpcpp/"

# Copy sxhkd
cp "$CONFIG/sxhkd/sxhkdrc" "$DOTFILES/sxhkd/sxhkdrc"

# Copy polybar
cp "$CONFIG/"

# 
cp "$CONFIG/"

cp "$CONFIG/"

# Copy Xresources
cp "/home/frenzy/.Xresources" "$DOTFILES"

cp "/home/frenzy/.xprofile" "$DOTFILES"

