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

pyfind()
{
  find . -name "*.py" -exec grep -Hn "$*" {} \;
}

VIRTUALENVS_HOME=~/.virtualenvs
export WORKON_HOME=$VIRTUALENVS_HOME
source /usr/local/bin/virtualenvwrapper.sh
if [ -f /usr/local/opt/autoenv/activate.sh ]; then
  # OS X with Home Brew
  source /usr/local/opt/autoenv/activate.sh
else
  source /usr/local/bin/activate.sh
fi

export GREP_OPTIONS=--color=auto

if [ -f ~/.bash_local ]; then
    source ~/.bash_local
fi