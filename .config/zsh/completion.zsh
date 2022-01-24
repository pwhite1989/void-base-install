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


