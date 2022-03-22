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

  ln -s "$source" "$link"
}

[[ "$(uname -s)" == "Darwin" ]] && mac_os=true || mac_os=false

set +u
if [ $SPIN ]; then
  # Container in the Spin environment
  link_source="/home/spin/dotfiles"
else
  link_source="$(pwd)"
fi
set -u


# Install packages on macOS using Brew. Spin installs packages listed in packages.yml
if $mac_os; then
  declare -a packages=(
    "bat"
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

sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
mv "$HOME/.zshrc" "$HOME/.zshrc-ohmyzsh"
mv "$HOME/.zshrc.pre-oh-my-zsh" "$HOME/.zshrc"

mkdir -p "$HOME/.oh-my-zsh/custom/themes"
curl https://raw.githubusercontent.com/caiogondim/bullet-train-oh-my-zsh-theme/master/bullet-train.zsh-theme > \
  "$HOME/.oh-my-zsh/custom/themes/bullet-train.zsh-theme"

if $mac_os; then
  brew install zsh-autosuggestions
else
  mkdir -p "$HOME/.oh-my-zsh/custom/plugins"
  git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
fi

if [ $SPIN ]; then
  # sudo update-alternatives --remove vi /usr/bin/nvim
  # sudo update-alternatives --remove vim /usr/bin/nvim

  for dir in ~/src/github.com/Shopify/*/ ; do
    cd $dir
    git shopify
    cd - >/dev/null
  done

  sudo timedatectl set-timezone Canada/Eastern
fi
