#!/bin/bash

printf "Enter your username: "
read USERNAME
USERNAME=${USERNAME:-paddle}
printf "Username set to: ${USERNAME}\n"
printf "Enter your desired screen resolution (i.e. 2560x1440): "
read RESOLUTION
RESOLUTION=${RESOLUTION:-1920x1080}
printf "Screen resolution set to: ${RESOLUTION}\n"
printf "Are you installing in a Virtual Machine? (y/n) "
read VM
case VM in

  y)
  VM="Virtual1"
  ;;
  
  n)
  VM="eDP1"
  ;;
  
  *)
  VM="Virtual1"
  ;;
esac

printf "Display set to: ${VM}\n"
USERHOME=/home/${USERNAME}

# Login as root
xbps-install -Suy &&
  # run again
xbps-install -Suy &&

  # Core installation
  # Seat manager: elogind (includes dbus by default)
  # Policy Manager: polkit
  # Time daemon: chrony
xbps-install -Sy elogind polkit chrony &&

  # Link the services to enable them
ln -s /etc/sv/{dbus,elogind,polkitd,chronyd} /var/service/

  # Install C compilers, the WM and tools
xbps-install -Sy make pkg-config cparser xorg xinit bspwm sxhkd lightdm lightdm-gtk3-greeter lightdm-gtk-greeter-settings lxappearance picom polybar git rofi xf86-video-intel firefox feh xdg-user-dirs wget curl vim unzip bat neofetch ranger subversion htop fzf tabbed xprop wmctrl slop neovim xclip zsh &&

cd ${USERHOME}

 # Installing the st terminal
xbps-install -Sy libXft-devel libX11-devel harfbuzz-devel libXext-devel libXrender-devel libXinerama-devel &&
git clone https://github.com/siduck/st.git &&
cd ${USERHOME}/st
sudo make install 
xrdb merge xresources

  # Installing the fonts
cd ${USERHOME}/Downloads
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip &&
mkdir JetBrainsMono
unzip JetBrainsMono.zip -d JetBrainsMono
mv JetBrainsMono /usr/share/fonts

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Iosevka.zip &&
mkdir Iosevka
unzip Iosevka.zip -d Iosevka
mv Iosevka /usr/share/fonts
fc-cache -fv

cd ${USERHOME}

  #Install logo-ls
cd ${USERHOME}/Downloads
wget https://github.com/Yash-Handa/logo-ls/releases/download/v1.3.7/logo-ls_Linux_x86_64.tar.gz &&
tar -xzf logo-ls_Linux_x86_64.tar.gz
cd logo-ls_Linux_x86_64
cp logo-ls /usr/local/bin
cp logo-ls.1.gz /usr/share/man/man1/
cd ${USERHOME}

  # Make sure all folders are owned by the user
chown -R ${USERNAME}:${USERNAME} ${USERHOME}

  # Link the lightdm service
ln -s /etc/sv/lightdm /var/service/
