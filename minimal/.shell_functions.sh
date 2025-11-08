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
            # NAME=${1%.*}
            # mkdir $NAME && cd $NAME
            case $1 in
                *.tar.bz2)   
                    tar xvjf ../"$1"    
                    ;;
                *.tar.gz)    
                    tar xvzf ../"$1"    
                    ;;
                *.tar.xz)
                    tar xvJf ../"$1"    
                    ;;
                *.lzma)      
                    unlzma ../"$1"      
                    ;;
                *.bz2)       
                    bunzip2 ../"$1"     
                    ;;
                *.rar)       
                    unrar x -ad ../"$1" 
                    ;;
                *.gz)        
                    gunzip ../"$1"      
                    ;;
                *.tar)       
                    tar xvf ../"$1"    
                    ;;
                *.tbz2)      
                    tar xvjf ../"$1"    
                    ;;
                *.tgz)       
                    tar xvzf ../"$1"   
                    ;;
                *.zip)       
                    unzip ../"$1"   
                    ;;
                *.Z)         
                    uncompress ../"$1"  
                    ;;
                *.7z)        
                    7z x ../"$1"        
                    ;;
                *.xz)        
                    unxz ../"$1"        
                    ;;
                *.exe)       
                    cabextract ../"$1"  
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

