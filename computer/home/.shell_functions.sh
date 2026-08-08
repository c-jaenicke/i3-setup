###################################################################################################
# Shell Functions
###################################################################################################

# Find file with pattern in name
function ffolder() {
    if [[ -z "$*" ]]; then
        printf "No pattern given. Call using ffolder \"pattern\"\n"
    else
        # find specific file only
        # find . -type f -iname '*'"$*"'*' -ls
        # include files and folders, do not show permission denied error
        find . -iname '*'"$*"'*' -ls 2>&1  | awk '!/(Keine Berechtigung)|(Permission denied)/ {print $0}'
    fi
}

# Find files which contain a specific string
function fstring() {
    if [[ -z "$*" ]]; then
        printf "No pattern and file given. Call using fstring \"string to find\" \"path to search in\"\n"
    else
        grep -rni "$1" "$2"
    fi
}

# Extract archives
function extract() {
    if [ -z "$1" ]; then
        # display usage if no parameters given
        printf "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>\n"
    else
        if [ -f "$1" ] ; then
            case $1 in
                *.tar.bz2)   
                    tar xvjf "$1"    
                    ;;
                *.tar.gz)    
                    tar xvzf "$1"    
                    ;;
                *.tar.xz)
                    tar xvJf "$1"    
                    ;;
                *.lzma)      
                    unlzma "$1"      
                    ;;
                *.bz2)       
                    bunzip2 "$1"     
                    ;;
                *.rar)       
                    unrar x -ad "$1" 
                    ;;
                *.gz)        
                    gunzip "$1"      
                    ;;
                *.tar)       
                    tar xvf "$1"    
                    ;;
                *.tbz2)      
                    tar xvjf "$1"    
                    ;;
                *.tgz)       
                    tar xvzf "$1"   
                    ;;
                *.zip)       
                    unzip "$1"   
                    ;;
                *.Z)         
                    uncompress "$1"  
                    ;;
                *.7z)        
                    7z x "$1"        
                    ;;
                *.xz)        
                    unxz "$1"        
                    ;;
                *.exe)       
                    cabextract "$1"  
                    ;;
                *)           
                    printf "extract: %s - unknown archive method\n" "$1" 
                    ;;
            esac
        else
            printf "%s - file does not exist\n" "$1"
        fi
    fi
}

# Create .tar.gz archive from from given directory
function maketar() { 
    tar cvzf "${1%%/}.tar.gz"  "${1%%/}/";
}

# Create .zip archive from from given directory
function makezip() {
    zip -r "${1%%/}.zip" "$1" ; 
}

# List processes running under current user
function my_ps() {
    ps "$@" -u "$USER" -o pid,%cpu,%mem,bsdtime,command ;
}

# Quickly create (or attach to) a tmux session with a 1x2 layout
function tmux-quick() {
    local name="${1:-QUICK}"
    if tmux has-session -t "$name" 2>/dev/null; then
        tmux attach-session -t "$name"
    else
        tmux new-session -d -s "$name" \; split-window -h \; split-window -v \; select-pane -t 0 \; attach-session -t "$name"
    fi
}

# Show stat info for a file
function show_stat() {
    if [ -z "$1" ]; then
        printf "Usage: show_stat FILENAME\n"
    else
        stat -c "%N: (%a/%A) (U: %U/%u ; G: %G/%g) (C: %w ; A: %x ; M: %y)" "$1"
    fi
}

# Remove a package using yay
function yay-remove() {
    if [ -z "$1" ]; then
        printf "Usage: yay-remove PACKAGE...\n"
    else
        yay -Rcuns "$@"
    fi
}

# Create a directory and cd into it
function mkcd() {
    if [ -z "$1" ]; then
        printf "Usage: mkcd DIR\n"
    else
        mkdir -p "$1" && cd "$1"
    fi
}

# Back up a file by copying it alongside itself with an ISO datetime suffix
function bak() {
    if [ -z "$1" ]; then
        printf "Usage: bak FILE\n"
    else
        cp -- "$1" "$1.bak-$(date -Iseconds)"
    fi
}

# List listening ports in a readable table
function ports() {
    ss -tulpn
}
