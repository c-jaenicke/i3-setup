###################################################################################################
#        _              _   _    __                          _     _                       
#  ___  | |__     ___  | | | |  / _|  _   _   _ __     ___  | |_  (_)   ___    _ __    ___ 
# / __| | '_ \   / _ \ | | | | | |_  | | | | | '_ \   / __| | __| | |  / _ \  | '_ \  / __|
# \__ \ | | | | |  __/ | | | | |  _| | |_| | | | | | | (__  | |_  | | | (_) | | | | | \__ \
# |___/ |_| |_|  \___| |_| |_| |_|    \__,_| |_| |_|  \___|  \__| |_|  \___/  |_| |_| |___/
# file containing all shell functions to be used in different .<shell>rc configs
###################################################################################################

# find file with pattern in name
function ff() {
    if [[ -z "$*" ]]; then
        printf "No pattern given\n"
    else
        # find specific file only
        # find . -type f -iname '*'"$*"'*' -ls
        # include files and folders, do not show permission denied error
        find . -iname '*'"$*"'*' -ls 2>&1  | awk '!/(Keine Berechtigung)|(Permission denied)/ {print $0}'
    fi
}

# extra archives
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

# create .tar.gz archive from from given directory
function maketar() { 
    tar cvzf "${1%%/}.tar.gz"  "${1%%/}/";
}

# create .zip archive from from given directory
function makezip() {
    zip -r "${1%%/}.zip" "$1" ; 
}

# list processes running under current user
function my_ps() {
    ps "$@" -u "$USER" -o pid,%cpu,%mem,bsdtime,command ; 
}

