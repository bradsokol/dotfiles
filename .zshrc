#! /bin/env zsh

[[ "$(uname -s)" == "Darwin" ]] && mac_os=true || mac_os=false

export ZSH=$HOME/.oh-my-zsh

fpath=(/usr/local/share/zsh-completions $fpath)

export EDITOR=vim
export PATH=~/bin:$PATH

LS_COLORS="di=1;34;40:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"

ZSH_THEME="bullet-train"

if [ "$SPIN" ]; then
  BULLETTRAIN_PROMPT_ORDER=(
    time
    status
    dir
    git
  )
  BULLETTRAIN_CONTEXT_BG=green
  BULLETTRAIN_CONTEXT_FG=white

  if [ -e /etc/zsh/zshrc.default.inc.zsh ]; then
    source /etc/zsh/zshrc.default.inc.zsh
  fi
else
  BULLETTRAIN_PROMPT_ORDER=(
    time
    status
    dir
    git
  )
fi
BULLETTRAIN_CONTEXT_BG=green
BULLETTRAIN_CONTEXT_FG=black
BULLETTRAIN_RUBY_BG=magenta
BULLETTRAIN_RUBY_FG=white
BULLETTRAIN_VIRTUALENV_BG=green
BULLETTRAIN_VIRTUALENV_FG=black
BULLETTRAIN_STATUS_EXIT_SHOW=true

plugins=(colored-man-pages git man)
if $mac_os; then
  plugins+=(macos)
fi

source $ZSH/oh-my-zsh.sh

sources=(
  /usr/local/share/chruby/chruby.sh
  /usr/local/opt/chruby/share/chruby/chruby.sh
  /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  ~/.aliases
  ~/.zshrc_local
)
for s in $sources; do
  if [ -f $s ]; then
    source $s
  fi
done

if [ "$TERM_PROGRAM" = "iTerm.app" ]; then
  test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
  export DEV_ALLOW_ITERM2_INTEGRATION=1
fi

man-builtin () { man bash | less -p "^       $1 "; }

pman()
{
  if [ -z "$1" ]; then
    echo "Manual page not given"
    return 1
  fi
  man -t "$@" | open -fa Preview
}

#[[ -f /opt/dev/sh/chruby/chruby.sh ]] && type chruby >/dev/null 2>&1 || chruby () { source /opt/dev/sh/chruby/chruby.sh; chruby "$@"; }
if [ -e /Users/bradsokol/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/bradsokol/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

[[ -x /usr/local/bin/brew ]] && eval $(/usr/local/bin/brew shellenv)

[ -f /opt/dev/dev.sh ] && source /opt/dev/dev.sh

[[ -x /opt/homebrew/bin/brew ]] && eval $(/opt/homebrew/bin/brew shellenv)

[ -f $HOME/.zshrc_local ] && source $HOME/.zshrc_local
