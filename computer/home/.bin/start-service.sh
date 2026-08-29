#!/usr/bin/env bash
# Script for quickly managing services

confirm() {
    local prompt="$1" reply
    read -rp "$prompt [y/N] " reply
    [[ "$reply" =~ ^[Yy]$ ]]
}

# Prompts to open a port in firewalld, e.g. after starting/enabling a service
# that needs one. Hardcoded to firewalld since that's what's in use here.
maybe_open_port() {
    local action="$1" port="$2"

    [[ "$action" == "start" || "$action" == "enable" ]] || return 0
    command -v firewall-cmd >/dev/null 2>&1 || return 0
    sudo firewall-cmd --query-port="$port" >/dev/null 2>&1 && return 0

    confirm "Open port $port in firewalld for this session?" && sudo firewall-cmd --add-port="$port"
}

ALLOWED_COMMANDS="start stop restart status enable disable"
if [[ ! $ALLOWED_COMMANDS =~ (^|[[:space:]])"$1"($|[[:space:]]) ]]; then
    printf "Error: Invalid command '%s'. Use: start, stop, restart, status, enable, or disable.\n" "$1"
    exit 1
fi

case $2 in
ssh)
    sudo systemctl "$1" sshd.service
    maybe_open_port "$1" 22/tcp
    ;;
bluetooth)
    sudo systemctl "$1" bluetooth.service
    ;;
vm)
    sudo systemctl "$1" libvirtd.service
    sudo systemctl "$1" virtlogd.service
    if [[ "$1" == "start" || "$1" == "enable" ]]; then
        for direction in i o; do
            sudo firewall-cmd --direct --query-passthrough ipv4 -I FORWARD -"$direction" virbr0 -j ACCEPT >/dev/null 2>&1 ||
                sudo firewall-cmd --direct --passthrough ipv4 -I FORWARD -"$direction" virbr0 -j ACCEPT
        done
    fi
    ;;

printer | scanner)
    sudo systemctl "$1" cups.service
    sudo systemctl "$1" cups-browsed.service
    sudo systemctl "$1" avahi-daemon.service
    maybe_open_port "$1" 5353/udp
    ;;
avahi)
    sudo systemctl "$1" avahi-daemon.service
    maybe_open_port "$1" 5353/udp
    ;;
smb)
    sudo systemctl "$1" smb.service
    sudo systemctl "$1" nmb.service
    ;;
nfs-server)
    sudo systemctl "$1" nfs-server.service
    ;;
docker)
    systemctl "$1" --user docker.service
    ;;
yubikey)
    sudo systemctl "$1" pcscd.service
    ;;
debug-list-enabled)
    printf "##### Debug: All enabled services:\n"
    systemctl list-unit-files --type=service --state=enabled
    ;;
debug-list-active)
    printf "##### Debug: All active services:\n"
    systemctl list-units --type=service --state=active
    ;;
debug-list-running)
    printf "##### Debug: All running services:\n"
    systemctl list-units --type=service --state=running
    ;;
*)
    printf "start-service start|stop|restart|status
        avahi
        bluetooth
        debug-list-active
        debug-list-enabled
        debug-list-running
        docker
        nfs-server
        printer
        scanner
        smb
        ssh
        vm
        yubikey\n"
    ;;
esac
