#!/bin/bash

read -p "Enter your username: " USER
read -p "Enter your desired screen resolution (i.e. 2560x1440): " RESOLUTION
HOME=/home/${USER}

# Login as root
xbps-install -Suy &&
  # run again
xbps-install -Suy &&

  # Core installation
  # Seat manager: elogind (includes dbus by default)
  # Policy Manager: polkit
xbps-install -Sy elogind polkit &&

  # Link the services to enable them
ln -s /etc/sv/{dbus,elogind,polkitd} /var/service/

  # Install C compilers
xbps-install -Sy make pkg-config cparser &&

  # Install the WM and tools
xbps-install -Sy xorg xinit bspwm sxhkd lightdm lightdm-gtk3-greeter lightdm-gtk-greeter-settings lxappearance picom polybar git rofi xf86-video-intel firefox feh xdg-user-dirs wget curl vim unzip bat neofetch subversion fzf &&
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
xbps-install -Sy libXft-devel libX11-devel harfbuzz-devel libXext-devel libXrender-devel libXinerama-devel &&
git clone https://github.com/siduck/st.git &&
cd ${HOME}/st
sudo make install 
xrdb merge xresources

  # Installing the fonts
cd ${HOME}/Downloads
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip &&
mkdir JetBrainsMono
unzip JetBrainsMono.zip -d JetBrainsMono
mv JetBrainsMono /usr/share/fonts

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Iosevka.zip &&
mkdir Iosevka
unzip Iosevka.zip -d Iosevka
mv Iosevka /usr/share/fonts
fc-cache -fv

cd ${HOME}

  # get some configuration folders
cd .config  
mkdir {gtk,alsa_stuff,eww}
svn https://github.com/siduck/dotfiles/trunk/gtk/ .config/gtk
svn https://github.com/siduck/dotfiles/trunk/alsa_stuff/ .config/alsa_stuff
svn https://github.com/siduck/dotfiles/trunk/eww/ .config/eww
cd ${HOME}

  # Ranger installation
xbps-install -Sy ranger
mkdir .config/ranger
svn https://github.com/siduck/dotfiles/trunk/cli_tools/ranger .config/ranger
ranger --copy-config=rifle
ranger --copy-config=commands
ranger --copy-config=scope

  # Polybar Config
svn https://github.com/siduck/dotfiles/trunk/polybar/ .config/polybar
xbps-install -Sy xprop wmctrl slop &&
sed -i 's/killall -q/pkill/g' .config/polybar/launch.sh
sed -i 's|eDP1|'"${DISPLAY}"'|g' .config/polybar/config
    
  # Rofi Config
svn https://github.com/siduck/dotfiles/trunk/rofi/ .config/rofi
sed -i 's/Sarasa Nerd Font 14/Iosevka 12/g' .config/rofi/config.rasi
sed -i 's/forest/onedark/g' .config/rofi/config.rasi

  # Picom Config
svn https://github.com/siduck/dotfiles/trunk/picom/ .config/picom

  # TODO CLI Tools/Ranger Config

  # TODO .bashrc config
    #Install logo-ls
cd ${HOME}/Downloads
wget https://github.com/Yash-Handa/logo-ls/releases/download/v1.3.7/logo-ls_Linux_x86_64.tar.gz &&
tar -xzf logo-ls_Linux_x86_64.tar.gz
cd logo-ls_Linux_x86_64
cp logo-ls /usr/local/bin
cp logo-ls.1.gz /usr/share/man/man1/
cd ${HOME}
cat <<! > .bashrc
# draw horiz line under prompt
draw_line() {
  local COLUMNS="$COLUMNS"
  while ((COLUMNS-- > 0)); do
    printf '\e[30m\u2500'
  done
}

# prompt
PS1="\[\033[32m\]  \[\033[37m\]\[\033[34m\]\w \[\033[0m\]"
PS2="\[\033[32m\]  > \[\033[0m\]"

# bash history
HISTSIZE=
HISTFILESIZE=

alias ls='logo-ls'
alias la='logo-ls -A'
alias ll='logo-ls -al'
# equivalents with Git Status on by Default
alias lsg='logo-ls -D'
alias lag='logo-ls -AD'
alias llg='logo-ls -alD'

export FZF_DEFAULT_OPTS='
  --color fg:#646a76
  --color bg+:#7797b7,fg+:#2c2f30,hl:#D8DEE9,hl+:#26292a,gutter:#3a404c
  --color pointer:#373d49,info:#606672
  --border
  --color border:#646a76'
  
xrdb merge ${HOME}/st/xresources
!
  
  # TODO nvchad install and config

rm .config/.svn

  # TODO install eww https://elkowar.github.io/eww/

  # Make sure all folders are owned by the user
chown -R ${USER}:${USER} ${HOME}

source .bashrc

  # Link the lightdm service
ln -s /etc/sv/lightdm /var/service/


