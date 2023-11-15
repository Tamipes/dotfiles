#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Aliases come here
alias ls='ls -la --color=auto'
alias grep='grep --color=auto'
alias hx='helix'
alias icat='kitty +kitten icat'
alias df='df -h'
alias du='du -h'

# Prompt engineering : D
PS1='\e[1;35m\u\e[0m'
PS1+='\e[0;29m@\e[0m'
PS1+='\e[1;35m\h\e[0m'
PS1+=': \e[0;34m\w\e[0m\n\$ '
