#!/usr/bin/env bash
# start apparmor notifier
aa-notify -p -s 1 -w 60 -f /var/log/audit/audit.log &
