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
xbps-install -Sy elogind polkit chrony &&

  # Link the services to enable them
ln -s /etc/sv/{dbus,elogind,polkitd,chronyd} /var/service/

  # Install C compilers, the WM and tools
xbps-install -Sy make pkg-config cparser xorg xinit bspwm sxhkd lightdm lightdm-gtk3-greeter lightdm-gtk-greeter-settings lxappearance picom polybar git rofi xf86-video-intel firefox feh xdg-user-dirs wget curl vim unzip bat neofetch ranger subversion htop fzf tabbed xprop wmctrl slop neovim &&

  # Organise folders and put in wm config
cd ${USERHOME}
mkdir -p .config/{bspwm,sxhkd,gtk,alsa_stuff,eww,ranger,polybar,rofi,picom}
mkdir -p {Downloads,Pictures}

  # Bspwm config
svn checkout https://github.com/siduck/dotfiles/trunk/bspwm/ .config/bspwm/
sed -i '22d' .config/bspwm/bspwmrc
sed -i '22i feh --bg-scale ~/void.png &' .config/bspwm/bspwmrc
sed -i '3d' .config/bspwm/bspwmrc

  # Sxhkd config
mkdir -p .config/sxhkd
install -Dm644 /usr/share/doc/bspwm/examples/sxhkdrc .config/sxhkd/
sed -i 's|dmenu_run|rofi -show drun|g' .config/sxhkd/sxhkdrc
sed -i 's/urxvt/st/g' .config/sxhkd/sxhkdrc


wget git.io/voidlinux -O void.png

cat <<EOF > .xinitrc
#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ];
then
for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

xrandr --output Virtual1 --mode bar
${USERHOME}/.fehbg
setxkbmap -layout gb
exec bspwm
EOF

sed -i 's|bar|'"${RESOLUTION}"'|g' .xinitrc

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

  # .bashrc config
    #Install logo-ls
cd ${USERHOME}/Downloads
wget https://github.com/Yash-Handa/logo-ls/releases/download/v1.3.7/logo-ls_Linux_x86_64.tar.gz &&
tar -xzf logo-ls_Linux_x86_64.tar.gz
cd logo-ls_Linux_x86_64
cp logo-ls /usr/local/bin
cp logo-ls.1.gz /usr/share/man/man1/
cd ${USERHOME}
    # add the config
cat <<EOF! > .bashrc
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
  
xrdb merge ${USERHOME}/st/xresources
EOF!

  # Get part 2
wget https://raw.githubusercontent.com/pwhite1989/void-base-install/main/bspwm-st-2.sh
chmod +x bspwm-st-2.sh

  # Make sure all folders are owned by the user
chown -R ${USERNAME}:${USERNAME} ${USERHOME}

  # Link the lightdm service
ln -s /etc/sv/lightdm /var/service/


