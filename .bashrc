export EDITOR=vim
export PATH=~/bin:$PATH

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000

shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [ -f ~/.bash_prompt ]; then
    . ~/.bash_prompt
fi
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

erbfind()
{
  if [ -z "$2" ]; then
    SEARCH_ROOT="."
  else
    SEARCH_ROOT="$2"
  fi
  (cd $SEARCH_ROOT && find . -name "*.erb" -exec grep -Hn "$1" {} \;)
}

pyfind()
{
  if [ -z "$2" ]; then
    SEARCH_ROOT="."
  else
    SEARCH_ROOT="$2"
  fi
  (cd $SEARCH_ROOT && find . -name "*.py" -exec grep -Hn "$1" {} \;)
}

rbfind()
{
  if [ -z "$2" ]; then
    SEARCH_ROOT="."
  else
    SEARCH_ROOT="$2"
  fi
  (cd $SEARCH_ROOT && find . -name "*.rb" -exec grep -Hn "$1" {} \;)
}

VIRTUALENVS_HOME=~/.virtualenvs
export WORKON_HOME=$VIRTUALENVS_HOME
if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
  source /usr/local/bin/virtualenvwrapper.sh
fi
if [ -f /usr/local/opt/autoenv/activate.sh ]; then
  # OS X with Home Brew
  source /usr/local/opt/autoenv/activate.sh
elif [ -f /usr/local/bin/activate.sh ]; then
  source /usr/local/bin/activate.sh
fi

export GREP_OPTIONS=--color=auto

if [ -f ~/.bash_local ]; then
    source ~/.bash_local
fi

export PATH="$HOME/.yarn/bin:$PATH"
