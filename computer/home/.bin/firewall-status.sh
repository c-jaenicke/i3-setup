#!/usr/bin/env bash
# Readable summary of firewalld's active zones. Flags services/ports that go
# beyond firewalld's shipped defaults for that zone, and lists direct
# passthrough rules (e.g. the VM forwarding rules from start-service.sh).

set -euo pipefail

if ! command -v firewall-cmd >/dev/null 2>&1; then
    echo "firewall-cmd not found -- this script only supports firewalld." >&2
    exit 1
fi

if ! sudo firewall-cmd --state >/dev/null 2>&1; then
    echo "firewalld is not running." >&2
    exit 1
fi

default_services_for_zone() {
    local file="/usr/lib/firewalld/zones/${1}.xml"
    [ -f "$file" ] || return 0
    grep -oP '<service name="\K[^"]+' "$file"
}

default_ports_for_zone() {
    local file="/usr/lib/firewalld/zones/${1}.xml"
    [ -f "$file" ] || return 0
    grep -oP '<port port="\K[^"]+" protocol="[^"]+' "$file" | sed 's/" protocol="/\//'
}

# Prints items from $1 (space separated) that are absent from $2.
diff_list() {
    local current="$1" defaults="$2" item
    for item in $current; do
        [[ " $defaults " == *" $item "* ]] || printf "%s " "$item"
    done
}

printf "##### firewalld state: %s\n" "$(sudo firewall-cmd --state)"
printf "##### default zone: %s\n\n" "$(sudo firewall-cmd --get-default-zone)"

mapfile -t zones < <(sudo firewall-cmd --get-active-zones | awk 'NR % 2 == 1')

for zone in "${zones[@]}"; do
    interfaces="$(sudo firewall-cmd --zone="$zone" --list-interfaces)"
    services="$(sudo firewall-cmd --zone="$zone" --list-services)"
    ports="$(sudo firewall-cmd --zone="$zone" --list-ports)"
    rich_rules="$(sudo firewall-cmd --zone="$zone" --list-rich-rules)"

    default_services="$(default_services_for_zone "$zone" | tr '\n' ' ')"
    default_ports="$(default_ports_for_zone "$zone" | tr '\n' ' ')"

    extra_services="$(diff_list "$services" "$default_services")"
    extra_ports="$(diff_list "$ports" "$default_ports")"

    printf "== Zone: %s ==\n" "$zone"
    printf "  interfaces : %s\n" "${interfaces:--}"
    printf "  services   : %s\n" "${services:--}"
    printf "  ports      : %s\n" "${ports:--}"
    [ -n "$extra_services" ] && printf "  >> beyond firewalld defaults, services: %s\n" "$extra_services"
    [ -n "$extra_ports" ] && printf "  >> beyond firewalld defaults, ports   : %s\n" "$extra_ports"
    if [ -n "$rich_rules" ]; then
        printf "  rich rules :\n"
        while IFS= read -r rule; do
            printf "    %s\n" "$rule"
        done <<<"$rich_rules"
    fi
    printf "\n"
done

passthroughs="$(sudo firewall-cmd --direct --get-all-passthroughs 2>/dev/null || true)"
if [ -n "$passthroughs" ]; then
    printf "##### direct passthrough rules:\n%s\n" "$passthroughs"
fi
