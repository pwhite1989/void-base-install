#!/bin/bash

xdg-user-dirs-update

mv void-base-install/* .

  # Install node via the node version manager
nvm install --lts &&

  # Install nody-greeter... this might one day become a package: https://github.com/void-linux/void-packages/pull/34948
git clone https://github.com/JezerM/nody-greeter.git ~/.config/nody-greeter
cd ~/.config/nody-greeter
nmp install &&
npm run rebuild &&
npm run build &&
sudo node make install &&

# http://stackoverfor-complete-with-dots

DISPLAYNAME=$(xrandr -q | awk '/connected primary/{print $1}')
DISPLAYNAME=${DISPLAYNAME:-"Virtual1"}

sed -i 's|Virtual1|'"${DISPLAYNAME}"'|g' .xinitrc

  # Nvim installation 
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
nvim +'hi NormalFloat guibg=#1e222a' +PackerSync &&
  # TODO install eww https://elkowar.github.io/eww/

source .xinitrc
