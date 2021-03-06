# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="bullet-train"
if [ -n "$SPIN" ] && [ "$SPIN" ]; then
  BULLETTRAIN_PROMPT_ORDER=(
    time
    context
    status
    dir
    git
  )
  BULLETTRAIN_CONTEXT_BG=green
  BULLETTRAIN_CONTEXT_FG=white
else
  BULLETTRAIN_PROMPT_ORDER=(
    time
    status
    dir
    git
  )
fi
BULLETTRAIN_RUBY_BG=magenta
BULLETTRAIN_RUBY_FG=white
BULLETTRAIN_VIRTUALENV_BG=green
BULLETTRAIN_VIRTUALENV_FG=black
BULLETTRAIN_STATUS_EXIT_SHOW=true

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(bundler colored-man-pages git man osx rails rake ruby tmux zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

LS_COLORS="di=1;34;40:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#! /bin/env zsh
if [ -f ~/.aliases ]; then
    source ~/.aliases
fi

fpath=(/usr/local/share/zsh-completions $fpath)

export EDITOR=vim
export PATH=~/bin:$PATH
export GREP_OPTIONS=--color=auto

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

man-builtin () { man bash | less -p "^       $1 "; }

gcorb()
{
  if [ -z "$1" ]; then
    echo "Branch name not given"
    return 1
  fi
  gco -b $1 origin/$1
}

if [ "$TERM_PROGRAM" = "iTerm.app" ]; then
  test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
  export DEV_ALLOW_ITERM2_INTEGRATION=1
fi

if [ -f /usr/local/share/chruby/chruby.sh ]; then
  # Ubuntu
  source /usr/local/share/chruby/chruby.sh
fi

if [ -f ~/.zshrc_local ]; then
  source ~/.zshrc_local
fi
