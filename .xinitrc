#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then







    xrdb -merge $sysresources

fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then







    xrdb -merge "$userresources"

fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

xsetwacom --set "Wacom Bamboo One S Pen stylus" Mode "Relative"

nitrogen --restore &
#picom &
dunst &
redshift-gtk -l 48.78:2.31 &
stalonetray -c /home/alexandre/.config/stalonetray/stalonetrayrc &
ferdi &
nextcloud &
dropbox &
joplin &
birdtray &
mictray &
twitch-indicator &
kdeconnect-indicator &
nm-applet &
exec xmonad
