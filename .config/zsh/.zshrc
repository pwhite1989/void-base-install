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

xrdb merge /home/paddle/st/xresources
