####################################################################################################
# Shell Aliases
####################################################################################################

###########################################################################
# COMMAND ALIAS
###########################################################################

# Move through directories
alias ..="cd .."
alias cd..="cd .."
alias home="cd ~"

# List files
alias ll="ls -lAh --color=auto"
alias ls="ls -F --color=auto"
alias lsl="ls -lhFA | less"

# Filesystem actions and checks
alias df="df -ahiT --total"
alias du="du -ach | sort -h"
alias free="free -mt"

# Create files and folders
alias mkdir="mkdir -pv"
alias mkfile="touch"

# Always use color when calling grep
alias grep='grep --color=auto'

# Bind neovim
alias vi="nvim"
alias vim="nvim"

# Always use sudoedit instead of sudo editor
alias 'sudo vim'=sudoedit
alias 'sudo nvim'=sudoedit
alias 'sudo nano'=sudoedit

# Print command to check stat of something
alias 'show_stat'='printf "stat -c \"%%N: %%a %%A %%U\" FILENAME\n"'

# Quickly switch to mounted drives
alias ssd1="cd /mnt/ssd1"
alias ssd2="cd /mnt/ssd2"

# Update system using yay
alias yay-systemup="nice -n 19 yay -Syu --devel --sudoloop"

# Update system using yay without user input
alias yay-systemup-afk="nice -n 19 yes | yay -Syu --devel --sudoloop --noconfirm"

# Print command to remove a package
alias yay-remove="printf 'yay -Rcuns ...\n'"

# Clear package cache of yay
alias yay-clearcache="yay -Scc"

# Pull all latest images, restart stack
# alias docker-compose-update="docker compose pull && docker compose down && docker compose up -d"
alias docker-compose-update="sudo docker compose pull && sudo docker compose down && sudo docker compose up -d"

###########################################################################
# SCRIPT ALIAS
###########################################################################

# Script for authenticating using ssh key
alias athgit="bash ~/.bin/git-ssh.sh"

# Script for starting some services
alias start-service="bash ~/.bin/start-service.sh"

# Script for creating a template for notes
alias create-notes="bash ~/.bin/create-notes.sh"

# Script for taking screenshots using flameshot
alias flameshot-script="bash ~/.bin/flameshot-script.sh"

# Restart dunst, because it sometimes crashes and idk why and dont care enough to investigate
alias restart-dunst="bash ~/.bin/startup/launch-dunst.sh"
