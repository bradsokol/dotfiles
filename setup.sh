#! /bin/bash

set -eu

install_package() {
  return
  if $mac_os; then
    # Use reinstall so that this is idempotent
    brew reinstall "$1"
  else
    sudo apt-get install -y "$1"
  fi
}

link_file() {
	if [ "$1" == "." ] || [ "$1" == ".." ] || [ "$1" == ".git" ]; then
		return
	fi

  source="$link_source/$1"
  link="$HOME/$1"
  if [ ! -e $link -a ! -d $link ]; then
    ln -s "$source" "$link"
  else
    echo "Skipped link for $link because a file or directory with that name already exists"
  fi
}

[[ "$(uname -s)" == "Darwin" ]] && mac_os=true || mac_os=false

set +u
if [ -n $SPIN ] && [ $SPIN ]; then
  # Container in the Spin Up environment
  link_source="~/dotfiles"
else
  link_source="$(pwd)"
fi
set -u

declare -a packages=(
  "fzf"
  "readline"
  "ripgrep"
  "the_silver_searcher"
  "tree"
  "vim"
  "wget"
  "zsh-completions"
)

if $mac_os; then
  packages+=(
    "bat"
    "reattach-to-user-namespace"
    "swiftlint"
  )
fi

for package in "${packages[@]}"; do
  install_package $package
done

for filename in .*; do
  link_file $filename
done

cd "$HOME/.vim/pack/bundle/start"
git submodule update --init --recursive
cd -

sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
mv $HOME/.zshrc $HOME/.zshrc-ohmyzsh
mv $HOME/.zshrc.pre-oh-my-zsh $HOME/.zshrc

mkdir -p $HOME/.oh-my-zsh/custom/themes
curl https://raw.githubusercontent.com/caiogondim/bullet-train-oh-my-zsh-theme/master/bullet-train.zsh-theme > $HOME/.oh-my-zsh/custom/themes/bullet-train.zsh-theme

if $mac_os; then
  brew install zsh-autosuggestions
else
  ubuntu_release=$(lsb_release -is)_$(lsb_release -rs)
  echo "deb http://download.opensuse.org/repositories/shells:/zsh-users:/zsh-autosuggestions/x$ubuntu_release/ /" | sudo tee /etc/apt/sources.list.d/shells:zsh-users:zsh-autosuggestions.list
  curl -fsSL https://download.opensuse.org/repositories/shells:zsh-users:zsh-autosuggestions/x$ubuntu_release/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_zsh-users_zsh-autosuggestions.gpg > /dev/null
  sudo apt update
  sudo apt-get install -y zsh-autosuggestions
fi
