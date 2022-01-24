#!/bin/sh

xrandr --output Virtual1 --mode 1920x1080
/home/paddle/.fehbg

if [ -d /etc/X11/xinit/xinitrc.d ];
then
for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

setxkbmap -layout gb
sxhkd &
exec bspwm
