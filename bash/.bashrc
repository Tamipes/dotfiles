#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls -la --color=auto'
alias grep='grep --color=auto'
alias hx='helix'
PS1='\e[1;35m\u\e[0m'
PS1+='\e[0;29m@\e[0m'
PS1+='\e[1;35m\h\e[0m'
PS1+=': \e[0;34m\w\e[0m\n\$ '
# Kitty aliases:
alias icat='kitty +kitten icat'
