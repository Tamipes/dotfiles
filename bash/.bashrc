#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls -la --color=auto'
alias grep='grep --color=auto'
alias hx='helix'
PS1='[\u@\h \W]\$ '
