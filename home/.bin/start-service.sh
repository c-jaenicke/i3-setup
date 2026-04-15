#!/usr/bin/env bash
# Script for quickly managing services

ALLOWED_COMMANDS="start stop restart status enable disable"
if [[ ! $ALLOWED_COMMANDS =~ (^|[[:space:]])"$1"($|[[:space:]]) ]]; then
    printf "Error: Invalid command '%s'. Use: start, stop, restart, status, enable, or disable.\n" "$1"
    exit 1
fi

case $2 in
ssh)
    sudo systemctl "$1" sshd.service
    ;;
bluetooth)
    sudo systemctl "$1" bluetooth.service
    ;;
vm)
    sudo systemctl "$1" libvirtd.service
    sudo systemctl "$1" virtlogd.service
    printf "##### Remember to allow traffit between host and vm!
    sudo firewall-cmd --direct --passthrough ipv4 -I FORWARD -i virbr0 -j ACCEPT
    sudo firewall-cmd --direct --passthrough ipv4 -I FORWARD -o virbr0 -j ACCEPT
    "
    sudo firewall-cmd --direct --passthrough ipv4 -I FORWARD -i virbr0 -j ACCEPT
    sudo firewall-cmd --direct --passthrough ipv4 -I FORWARD -o virbr0 -j ACCEPT
    ;;

printer | scanner)
    sudo systemctl "$1" cups.service
    sudo systemctl "$1" avahi-daemon.service
    printf "##### Remember to open port 5353/udp!
    firewall-cmd --zone=public --add-port=5353/udp\n"
    ;;
docker)
    # sudo systemctl "$1" docker.service
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
        bluetooth
        debug-list-active
        debug-list-enabled
        debug-list-running
        docker
        printer
        scanner
        ssh
        vm
        yubikey\n"
    ;;
esac
