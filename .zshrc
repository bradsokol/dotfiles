#! /bin/env zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ "$(uname -s)" == "Darwin" ]] && mac_os=true || mac_os=false

export ZSH=$HOME/.oh-my-zsh

fpath=(/usr/local/share/zsh-completions $fpath)

export EDITOR=nvim
export PATH=~/.local/bin:~/bin:$PATH

LS_COLORS="di=1;34;40:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"

ZSH_THEME="bullet-train"
ZSH_THEME="powerlevel10k/powerlevel10k"

BULLETTRAIN_PROMPT_ORDER=(
  time
  status
  dir
  git
)
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
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  /opt/homebrew/opt/chruby/share/chruby/chruby.sh
  /opt/homebrew/opt/chruby/share/chruby/auto.sh
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
fi

man-builtin () { man bash | less -p "^       $1 "; }

bindkey \^U backward-kill-line

pman()
{
  if [ -z "$1" ]; then
    echo "Manual page not given"
    return 1
  fi
  man -t "$@" | open -fa Preview
}

[[ -x /usr/local/bin/brew ]] && eval $(/usr/local/bin/brew shellenv)

[[ -x /opt/homebrew/bin/brew ]] && eval $(/opt/homebrew/bin/brew shellenv)

[ -f $HOME/.zshrc_local ] && source $HOME/.zshrc_local

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
