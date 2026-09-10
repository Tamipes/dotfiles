#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Source old bashrc file
# This is on the top, so if anything clashes the new ones will be used instead.
# I kinda like it that way, but might break some things, so need to be careful.
if [ -f "$HOME/.config/old.bashrc" ]; then
    . "$HOME/.config/old.bashrc"
fi

if [[ $EUID -eq 0 ]]; then
    PSCN='\e[1;31m'
fi

# Shell options
set colored-stats on
shopt -s globstar

# Env vars.
export PATH=$PATH:~/.tamipes/scripts
export EDITOR=hx

# Aliases come here
alias cal='cal -m'
alias ls='ls -lha --color=auto --hyperlink=auto'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
# Nix aliases here:
alias nrun='nix run . --'
alias nbuild='nix build .'
alias ndev='nix develop .'
alias dev='ndev'
# Git aliases here:
alias gs='git status'
alias gl='git log --oneline --graph'
alias gla='git log --oneline --graph --all'
alias gaa='git add .'
alias gp='git push'
gdd() {
  git diff HEAD~$(($1 + 1)) HEAD~$1
}

# ##### Tacit shell code be like: #####

# source for `if [ -t 0 ]`
# https://stackoverflow.com/questions/911168/how-can-i-detect-if-my-shell-script-is-running-through-a-pipe
identity() { if [ -t 0 ]; then printf ""; else exec cat; fi }
alias i="identity"

map() {
  if [[ "$*" == *'{}'* ]]; then
    exec xargs -I{} "$@"
  else
    exec xargs -I{} "$@" '{}'
  fi
}
alias m='map'
alias x='xargs' # this should work similar to map() in simple cases; `which hx | x readlink`
alias rotate="xargs" # TODO: switch the stdout with args; currently only copies stdout to the end of args
alias r='rotate'
alias rot='rotate'

# `rot` is used so even if emtpy it still continues(map filters out empty lines and runs nothing on them)
# example:
# echo "1 2" | u "+"
u() { i | rot echo "$@" | map uiua eval; }

# ##### No more Tacit  #####

if command -v helix &> /dev/null
then
    alias hx='helix'
fi

if command -v hyfetch &> /dev/null
then
  if command -v fastfetch &> /dev/null
  then
    alias hyfetch='hyfetch -b fastfetch'
  fi
else
  if command -v fastfetch &> /dev/null
  then
    alias hyfetch='fastfetch'
  else
    alias hyfetch='neofetch'
  fi
fi

# Prompt engineering : D
if [[ -n "$IN_NIX_SHELL" ]]; then
  echo Entered nix shell!
  label="nix-shell"
  if [[ "$name" != "$label" ]]; then
    label="$label:$name"
  fi
  psx="\e[0;29m#$label\e[0m"
  unset label
fi

# Prompt engineering
if [ "$TAMI_FOREIGN" = 1 ]; then
  if [[ -n "$PSCH" ]]; then
    PSCH="$PSCH"    
  else
    PSCH='\e[1;32m' 
  fi
  alias ls='ls -lh --color=auto'
else
  PSCH='\e[1;35m'
fi

if [[ -n "$PSCN" ]]; then
  PSCN="$PSCN"
else
  PSCN='\e[1;35m'
fi

PS1=$PSCN
PS1+='\u\e[0m'
PS1+='\e[0;29m@\e[0m'
PS1+=$PSCH
PS1+='\h\e[0m'
PS1+=$psx
PS1+=': \e[0;34m\w\e[0m\n\$ '


# Kitty
if test -n "$KITTY_INSTALLATION_DIR"; then
    export KITTY_SHELL_INTEGRATION="enabled"
    source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"
fi
if [ "$TERM" == "xterm-kitty" ]; then 
  alias icat='kitty +kitten icat'
  if command -v kitten &> /dev/null
  then
    alias ssh="kitten ssh"
  fi
fi

# Zoxide
if command -v zoxide &> /dev/null
then
  eval "$(zoxide init --cmd cd bash)"
fi

# Gurl
if command -v gurl &> /dev/null
then
  eval "$(gurl init)"
fi

cd_with_fzf() {
  local dir
  dir=$(find . -maxdepth 1 -type d | fzf) && cd "$dir"
}

# nnn config

# this if checks if the script is run as root
if [ "$EUID" = "0" ]; then
  export NNN_FIFO=/tmp/nnn_root.fifo
else
  export NNN_FIFO=/tmp/nnn.fifo
fi

if command -v nnn &> /dev/null
then
  export NNN_PLUG='p:preview-tui;/:autojump'
  n ()
  {
      # Block nesting of nnn in subshells
      [ "${NNNLVL:-0}" -eq 0 ] || {
          echo "nnn is already running"
          return
      }

      # The behaviour is set to cd on quit (nnn checks if NNN_TMPFILE is set)
      # If NNN_TMPFILE is set to a custom path, it must be exported for nnn to
      # see. To cd on quit only on ^G, remove the "export" and make sure not to
      # use a custom path, i.e. set NNN_TMPFILE *exactly* as follows:
      #      NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
      export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

      # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
      # stty start undef
      # stty stop undef
      # stty lwrap undef
      # stty lnext undef

      # The command builtin allows one to alias nnn to n, if desired, without
      # making an infinitely recursive alias
      command nnn "$@"

      [ ! -f "$NNN_TMPFILE" ] || {
          . "$NNN_TMPFILE"
          rm -f -- "$NNN_TMPFILE" > /dev/null
      }
  }
fi

