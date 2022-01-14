#!/bin/bash
# Login as root
xbps-install -Suy
  # run again
xbps-install -Suy

  # Core installation
  # Seat manager: elogind (includes dbus by default)
  # Policy Manager: polkit
xbps-install -S elogind polkit

  # Link the services to enable them
ln -s /etc/sv/{dbus,elogind,polkitd} /var/service/

  # Install the WM and tools
xbps-install -S xorg xinit dwm st git dmenu xf86-video-intel firefox feh xdg-user-dirs wget curl vim

wget git.io/voidlinux -O void.png
feh --bg-scale void.png
mkdir -p .scripts

cat <<! > .scripts/xsetloop.sh
#!/bin/bash

_w$(curl wttr.in?format=1)

while : ; do
        xsetroot -name " ${_w} | $(date '+%b %d %a') | $(date +%H:%M)"
        sleep 1
done
!

chmod +x .scripts/xsetloop.sh

cat <<! > .xinitrc
xrandr --output Virtual1 --mode 2560x1440
${HOME}/.fehbg
sh ${HOME}/.scripts/xsetloop.sh &
setxkbmap -layout gb
exec dwm
!
