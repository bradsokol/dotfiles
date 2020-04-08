if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
if [ -e /Users/bradsokol/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/bradsokol/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
