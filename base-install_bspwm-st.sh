#!/bin/bash

read -p "Enter your username: " USER
read -p "Enter your desired screen resolution (i.e. 2560x1440): " RESOLUTION
HOME=/home/${USER}

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
xbps-install -Sy xorg xinit bspwm sxhkd lightdm lightdm-gtk3-greeter lightdm-gtk-greeter-settings lxappearance picom polybar git rofi xf86-video-intel firefox feh xdg-user-dirs wget curl vim unzip bat neofetch svn
  # Organise folders and put in wm config
cd ${HOME}
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

DISPLAY=$(xrandr -q | awk '/connected primary/{print $1}')

cat <<! > .xinitrc
xrandr --output ${DISPLAY} --mode ${RESOLUTION}
${HOME}/.fehbg
setxkbmap -layout gb
sxhkd &
exec bspwm
!

  # Installing the st terminal
xbps-install -Sy libXft-devel libX11-devel harfbuzz-devel libXext-devel libXrender-devel libXinerama-devel
git clone https://github.com/siduck/st.git
cd ${HOME}/st
sudo make install 
xrdb merge xresources

  # Installing the fonts
cd ${HOME}/Downloads
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip
mkdir JetBrainsMono
unzip JetBrainsMono.zip -d JetBrainsMono
mv JetBrainsMono /usr/share/fonts

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Iosevka.zip
mkdir Iosevka
unzip Iosevka.zip -d Iosevka
mv Iosevka /usr/share/fonts
fc-cache -fv

cd ${HOME}

ehco 'xrdb merge ${HOME}/st/xresources' >> .bashrc
source .bashrc

  # TODO Polybar Config
svn https://github.com/siduck/dotfiles/trunk/polybar/ .config
xbps-install -S xprop wmctrl slop
sed 's/kill -q/pkill/g' .config/polybar/launch.sh
    
  # TODO Rofi Config
svn https://github.com/siduck/dotfiles/trunk/rofi/ .config
sed -i 's/Sarasa Nerd Font 14/Iosevka 12/g' .config/rofi/config.rasi
sed -i 's/forest/onedark/g' .config/rofi/config.rasi

  # TODO Picom Config
svn https://github.com/siduck/dotfiles/trunk/picom/ .config

  # TODO CLI Tools/Ranger Config

  # TODO .bashrc config
  # TODO nvchad install and config

rm .config/.svn

  # Make sure all folders are owned by the user
chown -R ${USER}:${USER} ${HOME}

  # Link the lightdm service
ln -s /etc/sv/lightdm /var/service/
