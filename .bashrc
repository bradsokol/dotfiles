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
if [ -f ~/.aliases ]; then
    . ~/.aliases
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

if [ "$TERM_PROGRAM" = "iTerm.app" ]; then
  test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
fi

export PATH="$HOME/.yarn/bin:$PATH"

[[ -f /opt/dev/sh/chruby/chruby.sh ]] && type chruby >/dev/null 2>&1 || chruby () { source /opt/dev/sh/chruby/chruby.sh; chruby "$@"; }

[[ -x /usr/local/bin/brew ]] && eval $(/usr/local/bin/brew shellenv)

[[ -x /opt/homebrew/bin/brew ]] && eval $(/opt/homebrew/bin/brew shellenv)
