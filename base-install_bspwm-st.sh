#!/bin/bash
# Login as root
xbps-install -Suy
  # run again
xbps-install -Suy

  # Core installation
  # Seat manager: elogind (includes dbus by default)
  # Policy Manager: polkit
xbps-install -Sy elogind polkit

  # Link the services to enable them
ln -s /etc/sv/{dbus,elogind,polkitd} /var/service/

  # Install C compilers
xbps-install -Sy make pkg-config cparser

  # Install the WM and tools
xbps-install -Sy xorg xinit bspwm sxhkd lightdm lightdm-gtk3-greeter lightdm-gtk-greeter-settings lxappearance picom polybar git dmenu xf86-video-intel firefox feh xdg-user-dirs wget curl vim unzip bat
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

  # Installing the st terminal
xbps-install -Sy libXft-devel libX11-devel harfbuzz-devel libXext-devel libXrender-devel libXinerama-devel
git clone https://github.com/siduck/st.git
cd st
sudo make install 
xrdb merge xresources

  # Installing the font
cd ~/Downloads
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip
mkdir JetBrainsMono
unzip JetBrainsMono.zip -d JetBrainsMono
mv JetBrainsMono /usr/share/fonts

  # Link the lightdm service
ln -s /etc/sv/lightdm /var/service/
