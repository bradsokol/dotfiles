#! /bin/bash

OS=$(uname)
if [ $OS != "Darwin" ]; then
  alias ls='ls --color=always'
fi

alias ll='ls -ahlF'
alias la='ls -A'
alias l='ls -CF'

alias pj='python -m json.tool'

if [ -f /usr/bin/xdg-open ]; then
    alias open='xdg-open'
fi

