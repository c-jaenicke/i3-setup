####################################################################################################
# Shell Aliases
####################################################################################################

###########################################################################
# Command aliases
###########################################################################
# Move through directories
alias ..="cd .."
alias cd..="cd .."
alias home="cd ~"

# Clear the terminal
alias c="clear"

# List files
alias ll="ls -lAh --color=auto"
alias ls="ls -F --color=auto"
alias lsl="ls -lhFA | less"

# Filesystem actions and checks
alias df="df -ahiT --total"
alias du="du -ach | sort -h"
alias free="free -mt"
alias folders='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'

# Create files and folders
alias mkdir="mkdir -pv"
alias mkfile="touch"

# Always use color when calling grep
alias grep='grep --color=auto'

# Processes, users and logs
alias psgrep="command ps aux | grep -v grep | grep -i -e VSZ -e"
alias userlist="cut -d: -f1 /etc/passwd"
alias histg="history | grep"
alias logs="find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"

# Bind neovim, only if it is installed, otherwise keep plain vim
if command -v nvim >/dev/null 2>&1; then
    alias vi="nvim"
    alias vim="nvim"
    export SUDO_EDITOR="nvim"
else
    export SUDO_EDITOR="vim"
fi
# Use sudoedit to edit root files, it opens $SUDO_EDITOR as your own user

# Pull all latest images, restart stack
alias docker-compose-update="sudo docker compose pull && sudo docker compose down && sudo docker compose up -d"

# Print last modified
alias last-modified='printf "Last Modified: %s\n" "$(LC_TIME=en_EN.UTF-8 date -u)"'

# Generate a random 32-byte base64 string, e.g. for passwords/secrets
alias randstr="openssl rand -base64 32"
