###################################################################################################
#        _              _   _           _   _                            
#  ___  | |__     ___  | | | |   __ _  | | (_)   __ _   ___    ___   ___ 
# / __| | '_ \   / _ \ | | | |  / _` | | | | |  / _` | / __|  / _ \ / __|
# \__ \ | | | | |  __/ | | | | | (_| | | | | | | (_| | \__ \ |  __/ \__ \
# |___/ |_| |_|  \___| |_| |_|  \__,_| |_| |_|  \__,_| |___/  \___| |___/
# file containing all shell aliases to be used in different .<shell>rc configs
###################################################################################################

##########################################################################
# COMMAND ALIAS
##########################################################################
# go up one directory
alias ..="cd .."
alias cd..="cd .."

# list files
alias ll="ls -lAh --color=auto"
alias ls="ls -F --color=auto"
alias lsl="ls -lhFA | less"

# go to home directory of current user
alias home="cd ~"

alias df="df -ahiT --total"
alias mkdir="mkdir -pv"
alias mkfile="touch"
alias userlist="cut -d: -f1 /etc/passwd"
alias free="free -mt"
alias du="du -ach | sort -h"
alias ps="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias histg="history | grep"
alias logs="find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"
alias folders='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias grep='grep --color=auto'

# bind neovim to vim
alias vim="nvim"

# go to specific drives
alias hdd="cd /mnt/hdd1"
alias ssd1="cd /mnt/ssd1"
alias ssd2="cd /mnt/ssd2"

# update system using yay
alias yay-systemup="yay -Syu --devel --sudoloop"

# update system using yay without user input
alias yay-systemup-afk="yes | yay -Syu --devel --sudoloop --noconfirm"

alias yay-remove="printf 'yay -Rcuns ...\n'"

##########################################################################
# SCRIPT ALIAS
##########################################################################
# script for authenticating using ssh key
alias athgit="bash ~/.bin/git-ssh"

# script for starting some services
alias start-service="bash ~/.bin/start-service"

# script for creating a template for notes
alias create-notes="bash ~/.bin/create-notes"

# script for taking screenshots using flameshot
alias flameshot-script="bash ~/.bin/flameshot-script"
