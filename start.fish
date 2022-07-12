#!/usr/bin/fish
echo "This script will overwrite the folders as well. Don't run it if you arent sure what your doing."


# Fastfetch
sudo rm /usr/share/fastfetch/presets/tami
sudo ln -s $HOME/.tamipes/fastfetch_presets/tami /usr/share/fastfetch/presets/tami

# Kitty
rm $HOME/.config/kitty -r
ln -s $HOME/.tamipes/kitty $HOME/.config/


# Ricemood
rm $HOME/.config/ricemood -r
ln -s $HOME/.tamipes/ricemood $HOME/.config/

# Fish
rm $HOME/.config/fish -r 
ln -s $HOME/.tamipes/fish $HOME/.config/