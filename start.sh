#!/bin/bash
echo "This script will overwrite the folders as well. Don't run it if you aren't sure what you're doing."

echo "Do you want to proceed? (y/n)"
read answer

if [ "$answer" != "y" ]; then
    echo "Script execution aborted. Good choice!"
    exit 1
fi

# This is the directory that the repo is in. So this script is at $HOME/.tamipes/start.sh
dir="$(dirname "$(readlink -f "$0")")"

# Fastfetch
sudo rm /usr/share/fastfetch/presets/tami
sudo ln -s $dir/fastfetch_presets/tami /usr/share/fastfetch/presets/tami

# Create .config file for later use.
mkdir -p $HOME/.config

# Kitty
rm -r $HOME/.config/kitty
ln -s $dir/kitty $HOME/.config/

# Ricemood
rm -r $HOME/.config/ricemood
ln -s $dir/ricemood $HOME/.config/

# Fish
rm -r $HOME/.config/fish
ln -s $dir/fish $HOME/.config/

# Tmux
mkdir -p $HOME/.config/tmux
rm $HOME/.config/tmux/tmux.conf
ln -s $dir/tmux.conf $HOME/.config/tmux/tmux.conf

# Helix
rm $HOME/.config/helix/config.toml
mkdir -p $HOME/.config/helix
ln -s $dir/helix/config.toml $HOME/.config/helix/config.toml
ln -s $dir/helix/languages.toml $HOME/.config/helix/languages.toml
ln -s $dir/helix/themes $HOME/.config/helix

# Cmus
rm $HOME/.config/cmus/autosave
mkdir -p $HOME/.config/cmus
ln -s $dir/cmus/autosave $HOME/.config/cmus/autosave

# i3
rm $HOME/.config/i3/config
mkdir -p $HOME/.config/i3
ln -s $dir/i3/config $HOME/.config/i3/config

# starship
rm $HOME/.config/starship.toml
ln -s $dir/starship.toml $HOME/.config/starship.toml
