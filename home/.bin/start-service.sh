#!/usr/bin/env bash
# Script for quickly managing services

case $2 in
    univpn)
        # start cisco vpn for university
        sudo systemctl "$1" vpnagentd.service
        printf "##### Service: vpnagentd.service %s\n" "$1"
        ;;

    ssh)
        sudo systemctl "$1" sshd.service
        printf "##### Service: sshd.service %s\n" "$1"
        ;;

    bluetooth)
        sudo systemctl "$1" bluetooth.service
        printf "##### Service: sshd.service %s\n" "$1"
        ;;

    vm)
        sudo systemctl "$1" libvirtd.service
        printf "##### Service: libvirtd.service %s\n" "$1"
        sudo systemctl "$1" virtlogd.service
        printf "##### Service: virtlogd.service %s\n" "$1"
        sudo firewall-cmd --direct --passthrough ipv4 -I FORWARD -i virbr0 -j ACCEPT
        sudo firewall-cmd --direct --passthrough ipv4 -I FORWARD -o virbr0 -j ACCEPT
        ;;

    printer|scanner)
        sudo systemctl "$1" cups.service
        printf "##### Service: cups.service %s\n" "$1"
        sudo systemctl "$1" avahi-daemon.service
        printf "##### Service: avahi-daemon.service %s\n" "$1"
        printf "##### Remember to open port 5353/udp\n"
        ;;

    docker)
        sudo systemctl "$1" docker.service
        printf "##### Service: docker.service %s\n" "$1"
        ;;

    yubikey)
        sudo systemctl "$1" pcscd.service
        printf "##### Service: pcscd.service %s\n" "$1"
        ;;

    debug-list-enabled)
        printf "##### Debug: All enabled services:\n"
        sudo systemctl list-unit-files --type=service --state=enabled
        ;;
    
    debug-list-active)
        printf "##### Debug: All active services:\n"
        sudo systemctl list-units --type=service --state=active 
        ;;
    
    debug-list-running)
        printf "##### Debug: All running services:\n"
        sudo systemctl list-units --type=service --state=running
        ;;

    *)
        printf "start-service start|stop|restart|status univpn|ssh|bluetooth|vm|printer|scanner|docker|yubikey|debug-list-enabled|debug-list-active|debug-list-running\n"
        ;;
esac

