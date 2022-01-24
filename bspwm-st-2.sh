#!/bin/bash

xdg-user-dirs-update

git clone https://github.com/pwhite1989/void-base-install.git
#wget https://raw.githubusercontent.com/siduck/dotfiles/master/.Xresources

# http://stackoverflow.com/a/844299
expand-or-complete-with-dots() {
  echo -n "\e[31m...\e[0m"
    zle expand-or-complete
      zle redisplay
}
zle -N expand-or-complete-with-dots
bindkey "^I" expand-or-complete-with-dots

DISPLAYNAME=$(xrandr -q | awk '/connected primary/{print $1}')
DISPLAYNAME=${DISPLAYNAME:-"Virtual1"}

sed -i 's|Virtual1|'"${DISPLAYNAME}"'|g' .xinitrc

  # Nvim installation 
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
nvim +'hi NormalFloat guibg=#1e222a' +PackerSync &&
  # TODO install eww https://elkowar.github.io/eww/

source .xinitrc
