#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

set colored-stats on

# Aliases come here
alias cal='cal -m'
alias ls='ls -la --color=auto --hyperlink=auto'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
if command -v helix &> /dev/null
then
    alias hx='helix'
fi

if [ "$TERM" == "xterm-kitty" ]; then 
  alias ssh="kitten ssh"
  alias icat='kitty +kitten icat'
fi

# Prompt engineering : D
PS1='\e[1;35m\u\e[0m'
PS1+='\e[0;29m@\e[0m'
PS1+='\e[1;35m\h\e[0m'
PS1+=': \e[0;34m\w\e[0m\n\$ '

# Zoxide???
eval "$(zoxide init --cmd cd bash)"
