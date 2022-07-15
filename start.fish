#!/usr/bin/fish
echo "This script will overwrite the folders as well. Don't run it if you arent sure what your doing."

# This is the directory that the repo is in. So this script is at $HOME/.tamipes/start.fish
set -l dir "$HOME/.tamipes"

# Fastfetch
sudo rm /usr/share/fastfetch/presets/tami
sudo ln -s $dir/fastfetch_presets/tami /usr/share/fastfetch/presets/tami

# Kitty
rm $HOME/.config/kitty -r
ln -s $dir/kitty $HOME/.config/


# Ricemood
rm $HOME/.config/ricemood -r
ln -s $dir/ricemood $HOME/.config/

# Fish
rm $HOME/.config/fish -r 
ln -s $dir/fish $HOME/.config/

# Tmux
mkdir $HOME/.config/tmux
rm $HOME/.config/tmux/tmux.conf
ln -s $dir/tmux.conf $HOME/.config/tmux/tmux.conf

# Helix
rm $HOME/.config/helix/config.toml
mkdir $HOME/.config/helix
ln -s $dir/helix/config.toml $HOME/.config/helix/config.toml

# Cmus
rm $HOME/.config/cmus/autosave
mkdir $HOME/.config/cmus
ln -s $dir/cmus/autosave $HOME/.config/cmus/autosave

# i3
rm $HOME/.config/i3/config
mkdir $HOME/.config/i3
ln -s $dir/i3/config $HOME/.config/i3/config