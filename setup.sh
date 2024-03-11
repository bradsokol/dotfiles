#! /bin/bash

set -eux

install_package() {
  if $mac_os; then
    # Use reinstall so that this is idempotent
    brew reinstall "$1"
  else
    sudo apt-get -o DPkg::Lock::Timeout=3 install -y "$1"
  fi
}

link_file() {
  ignore_files=("setup.sh" "." ".." ".git" ".config")
  [[ ${ignore_files[*]} =~ $1 ]] && return

  source=$link_source/$1
  link=$HOME/$1

  if [ -e "$link" ]; then
    mkdir -p dotfiles-backup
    mv "$link" dotfiles-backup
  fi

  ln -s "$source" "$link"
}

link_config_file() {
  ignore_files=("setup.sh" "." ".." ".git" ".config")
  [[ ${ignore_files[*]} =~ $1 ]] && return

	source="$link_source"/"$dirname"
	link=$HOME/"$dirname"

  if [ -e "$link" ]; then
    rm "$link"
  fi

  ln -s "$source" "$link"
}

[[ "$(uname -s)" == "Darwin" ]] && mac_os=true || mac_os=false

set +u
link_source="$(pwd)"
set -u


if $mac_os; then
  declare -a packages=(
    "bat"
    "fd"
    "fzf"
    "glow"
    "readline"
    "reattach-to-user-namespace"
    "ripgrep"
    "swiftlint"
    "the_silver_searcher"
    "tree"
    "vim"
    "wget"
    "zsh-completions"
  )

  for package in "${packages[@]}"; do
    install_package "$package"
  done
fi

for filename in .*; do
  link_file "$filename"
done

for dirname in .config/*; do
  link_config_file $(basename $dirname)
done

mkdir -p "$HOME/bin"
for filename in bin/*; do
  filename=$(basename "$filename")
  [ ! -f "$HOME/bin/$filename" ] && ln -s "$link_source/bin/$filename" "$HOME/bin/$filename"
done

if [ ! -d ~/.oh-my-zsh ]; then
  RUNZSH=no sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  mv -f "$HOME/.zshrc" "$HOME/.zshrc-ohmyzsh"
  mv "$HOME/.zshrc.pre-oh-my-zsh" "$HOME/.zshrc"

  mkdir -p "$HOME/.oh-my-zsh/custom/themes"
  curl https://raw.githubusercontent.com/caiogondim/bullet-train-oh-my-zsh-theme/master/bullet-train.zsh-theme > \
    "$HOME/.oh-my-zsh/custom/themes/bullet-train.zsh-theme"

  if $mac_os; then
    brew install zsh-autosuggestions
  else
    mkdir -p "$HOME/.oh-my-zsh/custom/plugins"
    git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  fi
fi

git clone https://github.com/tmux-plugins/tpm ~/.local/share/tmux/plugins/tpm
