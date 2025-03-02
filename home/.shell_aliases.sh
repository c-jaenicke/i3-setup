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

# use sudoedit instead of regular editors
alias 'sudo vim'=sudoedit
alias 'sudo nvim'=sudoedit
alias 'sudo nano'=sudoedit

# show stat for file
alias 'show_stat'='printf "stat -c \"%%N: %%a %%A %%U\" FILENAME\n"'

##################################################
# DRIVE ALIAS
##################################################
alias ssd1="cd /mnt/ssd1"
alias ssd2="cd /mnt/ssd2"

##################################################
# PACKAGE MANAGEMENT ALIAS
##################################################
# update system using yay
alias yay-systemup="nice -n 19 yay -Syu --devel --sudoloop"

# update system using yay without user input
alias yay-systemup-afk="nice -n 19 yes | yay -Syu --devel --sudoloop --noconfirm"

# print command to remove a package
alias yay-remove="printf 'yay -Rcuns ...\n'"

# clear package cache of yay
alias yay-clearcache="yay -Scc"

##################################################
# DOCKER ALIAS
##################################################
# pull all latest images, restart stack
# alias docker-compose-update="docker compose pull && docker compose down && docker compose up -d"
alias docker-compose-update="sudo docker compose pull && sudo docker compose down && sudo docker compose up -d"

##########################################################################
# SCRIPT ALIAS
##########################################################################
# script for authenticating using ssh key
alias athgit="bash ~/.bin/git-ssh.sh"

# script for starting some services
alias start-service="bash ~/.bin/start-service.sh"

# script for creating a template for notes
alias create-notes="bash ~/.bin/create-notes.sh"

# script for taking screenshots using flameshot
alias flameshot-script="bash ~/.bin/flameshot-script.sh"

# restart dunst, because it sometimes crashes and idk why and dont care enough to investigate
alias restart-dunst="bash ~/.bin/startup/launch-dunst.sh"

