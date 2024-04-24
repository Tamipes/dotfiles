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

set colored-stats on

# Aliases come here
alias cal='cal -m'
alias ls='ls -lha --color=auto --hyperlink=auto'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
# Nix aliases here
alias nrun='nix run .?submodules=1'
alias nbuild='nix build .?submodules=1'
alias ndev='nix develop .?submodules=1'
alias dev='ndev'
if command -v helix &> /dev/null
then
    alias hx='helix'
fi

# Prompt engineering : D
if [[ -n "$IN_NIX_SHELL" ]]; then
    echo something
  label="nix-shell"
  if [[ "$name" != "$label" ]]; then
    label="$label:$name"
  fi
  psx="\e[0;29m#$label\e[0m"
  unset label
fi

PS1='\e[1;35m\u\e[0m'
PS1+='\e[0;29m@\e[0m'
PS1+='\e[1;35m\h\e[0m'
PS1+=$psx
PS1+=': \e[0;34m\w\e[0m\n\$ '


# Env vars.
export PATH=$PATH:~/.tamipes/scripts
export EDITOR=hx

# Kitty
if test -n "$KITTY_INSTALLATION_DIR"; then
    export KITTY_SHELL_INTEGRATION="enabled"
    source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"
fi
if [ "$TERM" == "xterm-kitty" ]; then 
  alias ssh="kitten ssh"
  alias icat='kitty +kitten icat'
fi

# Zoxide
if command -v zoxide &> /dev/null
then
  eval "$(zoxide init --cmd cd bash)"
fi

cd_with_fzf() {
  local dir
  dir=$(find . -maxdepth 1 -type d | fzf) && cd "$dir"
}

#nnn
if command -v nnn &> /dev/null
then
  export NNN_FIFO=/tmp/nnn.fifo
  export NNN_PLUG='p:preview-tui'
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

