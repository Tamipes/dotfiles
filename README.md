# Tami's dotfiles
This repository contains my dotflies in an unorderly fashion. Some applications have folders, some only have *".conf"* files.

## **Don't run start.sh**
The script deletes your dotfiles or even whole folders and tries to symlink the ones in this repo. And the symlinks are **not configured** to work with different folder setups.
## **Don't run link.py**
This will, like start.sh remove files and instead symlink them. It also does not work correctly on Windows, because only one application should be 'installed'(and that is helix).
## Included programs
- Fish
- Fastfetch
- Kitty
- Ricemood
	- *Might get removed*
- Tmux
- Helix
- Cmus
- i3
