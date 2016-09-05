#! /bin/bash

OS=$(uname)
if [ $OS != "Darwin" ]; then
  alias ls='ls --color=always'
fi

alias be='bundle exec'
alias ll='ls -ahlF'
alias la='ls -A'
alias l='ls -CF'

# OS X Vim is crashy. Running just vi always runs OS X Vim.
# This alias forces Home Brew Vim
alias vi=vim

alias pj='python -m json.tool'

if [ -f /usr/bin/xdg-open ]; then
    alias open='xdg-open'
fi

