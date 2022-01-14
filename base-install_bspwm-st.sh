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
xbps-install -S xorg xinit bspwm sxhkd lightdm lightdm-gtk3-greeter lightdm-gtk-greeter-settings lxappearance picom polybar st git dmenu xf86-video-intel firefox feh xdg-user-dirs wget curl vim
  # Organise folders and put in wm config
xdg-user-dirs-update
mkdir -p .config/{bspwm,sxhkd}
install -Dm755 /usr/share/doc/bspwm/examples/bspwmrc .config/bspwm/
install -Dm644 /usr/share/doc/bspwm/examples/sxhkdrc .config/sxhkd/
sed -i 's/urxvt/st/g' .config/sxhkd/sxhkdrc

cat <<! > wmAddons

setxkbmap GB &
${HOME}/.fehbg
picom
!

sed -i '/sxhkd/ r wmAddons' .config/bspwm/bspwmrc
rm wmAddons

wget git.io/voidlinux -O void.png
feh --bg-scale void.png

cat <<! > .xinitrc
xrandr --output Virtual1 --mode 2560x1440
${HOME}/.fehbg
setxkbmap -layout gb
sxhkd &
exec bspwm
!

  # Link the lightdm service
ln -s /etc/sv/lightdm /var/service/
