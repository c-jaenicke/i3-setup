#!/usr/bin/env bash
# Shows currently listening TCP/UDP ports with the owning process and pid --
# basically `ss -tulpn` with readable, sorted output.

set -euo pipefail

ss_cmd=(ss -tulpn)
[ "$EUID" -eq 0 ] || ss_cmd=(sudo "${ss_cmd[@]}")

{
    printf "PROTO\tPORT\tADDRESS\tPROCESS\n"
    "${ss_cmd[@]}" | awk '
        NR == 1 { next }
        {
            proto = $1
            local = $5

            if (local ~ /^\[/) {
                split(local, parts, "]:")
                addr = parts[1] "]"
                port = parts[2]
            } else {
                n = split(local, parts, ":")
                port = parts[n]
                addr = parts[1]
                for (i = 2; i < n; i++) addr = addr ":" parts[i]
            }

            procinfo = ""
            line = $0
            while (match(line, /\(\("[^"]+",pid=[0-9]+/)) {
                entry = substr(line, RSTART, RLENGTH)
                name = entry
                sub(/^\(\("/, "", name)
                sub(/",pid=.*/, "", name)
                pid = entry
                sub(/.*pid=/, "", pid)
                procinfo = procinfo (procinfo == "" ? "" : ", ") name "(" pid ")"
                line = substr(line, RSTART + RLENGTH)
            }
            if (procinfo == "") procinfo = "-"

            printf "%s\t%s\t%s\t%s\n", toupper(proto), port, addr, procinfo
        }
    ' | sort -t $'\t' -k2,2n
} | column -t -s $'\t'
