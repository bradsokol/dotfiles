#! /bin/env zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ "$(uname -s)" == "Darwin" ]] && mac_os=true || mac_os=false

export ZSH=$HOME/.oh-my-zsh

fpath=(
  /usr/local/share/zsh-completions
  /opt/homebrew/share/zsh/site-functions
  $fpath
)

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
  ~/.cargo/env
  ~/.aliases
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

eval "$(fzf --zsh)"

show_file_or_dir_preview="if [ -d {} ]; then tree -d {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
# export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'tree -d {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo ${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

source ~/.zshrc_local
