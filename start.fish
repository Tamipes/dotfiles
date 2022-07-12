#!/usr/bin/fish
echo cwd


# Fastfetch
sudo rm /usr/share/fastfetch/presets/tami
sudo ln -s $HOME/.tamipes/fastfetch_presets/tami /usr/share/fastfetch/presets/tami

# Kitty
rm $HOME/.config/kitty/kitty.conf
ln -s $HOME/.tamipes/kitty/kitty.conf $HOME/.config/kitty/kitty.conf
rm $HOME/.config/kitty/tami_theme.conf
ln -s $HOME/.tamipes/kitty/tami_theme.conf $HOME/.config/kitty/tami_theme.conf

# Ricemood
rm $HOME/.config/ricemood -r
ln -s $HOME/.tamipes/ricemood $HOME/.config/