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

  # Enter home directory
cd ${USERHOME}

  # Set up some directories
mkdir -p ${USERHOME}/.config/{zsh,local/share,cache}

  # Install zsh for better shell
xbps-install -Sy zsh &&
cat <<EOF > ${USERHOME}/.zshenv
# XDG
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$XDG_CONFIG_HOME/local/share"
export XDG_CACHE_HOME="$XDG_CONFIG_HOME/cache"

# editor
#export EDITOR="nvim"
#export VISUAL="nvim"

# zsh
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export HISTFILE="$ZDOTDIR/.zhistory"
export HISTSIZE=10000
export SAVEHIST=10000

# other software
export VIMCONFIG="$XDG_CONFIG_HOME/nvim"
export FZF_DEFAULT_OPTS='
  --color fg:#646a76
  --color bg+:#7797b7,fg+:#2c2f30,hl:#D8DEE9,hl+:#26292a,gutter:#3a404c
  --color pointer:#373d49,info:#606672
  --border
  --color border:#664a76'
 #PATH
 EOF
 
 cat <<EOF > ${USERHOME}/.config/zsh/.zshrc
 #!/usr/bin/env zsh

# Much inspiration taken from https://thevaluable.dev/zsh-install-configure-mouseless/

# +------------+
# | NAVIGATION |
# +------------+
setopt AUTO_CD              # Go to folder path without using cd.
setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
setopt CORRECT              # Spelling correction
setopt CDABLE_VARS          # Change directory to a path stored in a variable.
setopt EXTENDED_GLOB        # Use extended globbing syntax.
setopt nomatch notify

# +---------+
# | HISTORY |
# +---------+
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.

unsetopt beep
bindkey -v
zstyle :compinstall filename '~/.config/zsh/.zshrc'

# +-------------+
# | COMPLETIONS |
# +-------------+
autoload -Uz compinit
compinit
_comp_options+=(globdots) # With hidden files
source ~/.config/zsh/completion.zsh

# +---------+
# | PROMPT  |
# +---------+
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )

setopt prompt_subst

PS1=$'%F{green}%}  %(?.%F{blue}%~${vcs_info_msg_0_} .%F{red}☣ %~ ) %f' # sets the prompt to go red on exit code 1
zstyle ':vcs_info:git:*' formats '%F{red} (%b)%f'
zstyle ':vcs_info:*' enable git
PS2=$'%F{green}   > %f'

# +---------+
# | LOGO-LS |
# +---------+
alias ls='logo-ls'
alias la='logo-ls -A'
alias ll='logo-ls -al'
# equivalents with Git Status on by Default
alias lsg='logo-ls -D'
alias lag='logo-ls -AD'
alias llg='logo-ls -alD'

#xrdb merge ~/st/xresources

EOF

cat <<EOF > ${USERHOME}/.config/zsh/completion.zsh
#!/usr/bin/env zsh

# Inspiration from https://thevaluable.dev/zsh-completion-guide-examples/

# Defining the completers
zstyle ':completion:*' completer _extensions _complete _approximate

# Caching the completion
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"

# The completion menu
zstyle ':completion:*' menu select # interactive search

# Formatting the display
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'

# Grouping the results
# zstyle ':completion:*' group-name ''

# Squeezing the slashes
zstyle ':completion:*' squeeze-slashes true

# Directory stack completion
zstyle ':completion:*' complete-options true

# Allow partial word matching, case insensitive
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

EOF

  # Install C compilers
xbps-install -Sy make pkg-config gcc &&

  # Install X11 programs
xbps-install -Sy xorg xinit libXft-devel libX11-devel harfbuzz-devel libXext-devel libXrender-devel libXinerama-devel &&

  # Install the Window Manager & menus
xbps-install -Sy bspwm sxhkd picom polybar rofi &&

  # Install the utils
xbps-install -Sy git firefox feh xdg-user-dirs wget curl vim unzip bat neofetch htop xclip neovim ripgrep &&

 # Installing the st terminal
git clone https://github.com/siduck/st.git &&
cd ${USERHOME}/st
sudo make install 
#xrdb merge xresources

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

  # Clone the dotfiles repo
git clone https://github.com/pwhite1989/void-base-install.git
mv ~/void-base-install/bspwm-st-2.sh .
chmod +x bspwm-st-2.sh

wget https://upload.wikimedia.org/wikipedia/commons/0/02/Void_Linux_logo.svg

  #ToDo 
  # Make .xinitrc


  # Make sure all folders are owned by the user
chown -R ${USERNAME}:${USERNAME} ${USERHOME}

  # Link the lightdm service
#ln -s /etc/sv/lightdm /var/service/

# Others 
#xbps-install -Sy gobject-introspection cparser lightdm lightdm-gtk3-greeter lightdm-gtk-greeter-settings xf86-video-intel ranger subversion fzf tabbed xprop wmctrl slop  &&
