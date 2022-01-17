#!/bin/bash

DISPLAYNAME=$(xrandr -q | awk '/connected primary/{print $1}')
DISPLAYNAME=${DISPLAYNAME:-Virtual1}

  # get some configuration folders
svn checkout https://github.com/siduck/dotfiles/trunk/gtk/ .config/gtk
svn checkout https://github.com/siduck/dotfiles/trunk/alsa_stuff/ .config/alsa_stuff
svn checkout https://github.com/siduck/dotfiles/trunk/eww/ .config/eww

  # Ranger installation
svn checkout https://github.com/siduck/dotfiles/trunk/cli_tools/ranger .config/ranger
ranger --copy-config=rifle
ranger --copy-config=commands
ranger --copy-config=scope

  # Polybar Config
svn checkout https://github.com/siduck/dotfiles/trunk/polybar/ .config/polybar
sed -i 's/killall -q/pkill/g' .config/polybar/launch.sh
sed -i 's|eDP1|'"${DISPLAYNAME}"'|g' .config/polybar/config
    
  # Rofi Config
svn checkout https://github.com/siduck/dotfiles/trunk/rofi/ .config/rofi
sed -i 's/Sarasa Nerd Font 14/Iosevka 12/g' .config/rofi/config.rasi
sed -i 's/forest/onedark/g' .config/rofi/config.rasi

  # Picom Config
svn checkout https://github.com/siduck/dotfiles/trunk/picom/ .config/picom

  
  # TODO nvchad install and config

  # TODO install eww https://elkowar.github.io/eww/



source .bashrc
