#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Script to generate and upload SSH keys to a system.
# Supports regular keys and YubiKey-backed FIDO2 keys (resident, verify-required).

###############################################################################
# Helpers
###############################################################################

print_help () {
  cat <<'EOF'
setup-ssh-keys [-h|--help] [-g|--gen] [-u|--upload]

-h|--help   Print this help text
-g|--gen    Generate a new key
-u|--upload Upload an existing key

Default (no arguments):
  Ask about YubiKey usage, generate a key, then optionally upload it.

Notes:
- For YubiKey-backed keys, this script uses:
    ssh-keygen -t ed25519-sk -O resident -O verify-required
- For regular keys, this script uses:
    ssh-keygen -t ed25519 -a 100
- If the save path is not absolute, the key is stored in the current directory.
EOF
}

require_cmd () {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    printf "Error: required command '%s' not found in PATH.\n" "$cmd" >&2
    exit 1
  fi
}

yes_no_prompt () {
  local prompt="$1"
  local default="${2:-N}"
  local reply

  case "$default" in
    Y|y) prompt="$prompt [Y/n]: " ;;
    N|n|*) prompt="$prompt [y/N]: " ;;
  esac

  read -r -p "$prompt" reply
  if [[ -z "$reply" ]]; then
    reply="$default"
  fi
  [[ "$reply" =~ ^[Yy]$ ]]
}

###############################################################################
# Interactive input
###############################################################################

get_type_of_key () {
  local yubikey="$1"
  local type

  read -r -p "##### (-t) Enter the type of key to create (default=\"ed25519\") [Regular: ed25519 | rsa] [YubiKey: ed25519-sk]: " type
  if [[ -z "$type" ]]; then
    if [[ "$yubikey" == "y" ]]; then
      type="ed25519-sk"
    else
      type="ed25519"
    fi
  fi

  case "$type" in
    ed25519|rsa|ed25519-sk) ;;
    *)
      printf "Unsupported key type '%s'. Allowed: ed25519, rsa, ed25519-sk.\n" "$type" >&2
      exit 1
      ;;
  esac

  printf "%s" "$type"
}

get_comment () {
  local comment
  read -r -p "##### (-C) Enter the comment to add to the new key (default=\"\"): " comment
  printf "%s" "$comment"
}

get_filename () {
  local type="$1"
  local filename
  read -r -p "##### (-f) Enter file in which to save the key (default=\"id_${type}\"): " filename
  if [[ -z "$filename" ]]; then
    filename="id_${type}"
  fi
  # If not absolute, store in current directory explicitly.
  case "$filename" in
    /*) ;;  # absolute path
    *)  filename="$(pwd)/$filename" ;;
  esac
  printf "%s" "$filename"
}

ensure_safe_key_path () {
  local filename="$1"
  if [[ -e "$filename" || -e "${filename}.pub" ]]; then
    if ! yes_no_prompt "File '$filename' or '${filename}.pub' exists. Overwrite?" "N"; then
      printf "Aborting to avoid overwriting existing key files.\n" >&2
      exit 1
    fi
  fi
}

###############################################################################
# Key generation
###############################################################################

# Fills GLOBAL_LAST_KEY_FILE with the private-key path it used.
generate_key_pair () {
  local yubikey="$1"
  local type comment filename

  printf "########## 1. Create new key pair\n"

  comment="$(get_comment)"
  type="$(get_type_of_key "$yubikey")"
  filename="$(get_filename "$type")"

  ensure_safe_key_path "$filename"

  printf "##### Creating a new key pair using the values:\n\tUse YubiKey: %s\n\tType: %s\n\tComment: %s\n" "$yubikey" "$type" "$comment"
  printf "##### Saving files in %s and %s.pub\n" "$filename" "${filename}.pub"

  require_cmd ssh-keygen

  if [[ "$yubikey" == "y" ]]; then
    ssh-keygen -f "$filename" -C "$comment" -t "$type" -a 100 -O resident -O verify-required
  else
    ssh-keygen -f "$filename" -C "$comment" -t "$type" -a 100
  fi

  if [[ "$yubikey" != "y" ]]; then
    chmod 600 "$filename"
    if [[ -f "${filename}.pub" ]]; then
      chmod 644 "${filename}.pub"
    fi
  fi

  printf "##### Key generation complete.\n"

  GLOBAL_LAST_KEY_FILE="$filename"
}

###############################################################################
# Upload key
###############################################################################

upload_key () {
  printf "########## 2. Upload the key\n"

  if ! yes_no_prompt "##### Add key to remote host?" "N"; then
    printf "Skipping upload.\n"
    return 0
  fi

  local filename="${1:-}"

  # Prefer explicit argument, else last generated key, else prompt.
  if [[ -z "$filename" && -n "${GLOBAL_LAST_KEY_FILE:-}" ]]; then
    filename="$GLOBAL_LAST_KEY_FILE"
  fi

  if [[ -z "$filename" ]]; then
    read -r -p "##### Enter the path to the public key to upload: " filename
    # If not absolute, assume current directory.
    case "$filename" in
      /*) ;;
      *)  filename="$(pwd)/$filename" ;;
    esac
  fi

  # Switch to .pub for ssh-copy-id.
  if [[ "$filename" != *.pub ]]; then
    if [[ -f "${filename}.pub" ]]; then
      filename="${filename}.pub"
    else
      printf "Could not find '%s.pub'. Please specify a .pub file.\n" "$filename" >&2
      exit 1
    fi
  fi

  if [[ ! -f "$filename" ]]; then
    printf "Public key '%s' does not exist.\n" "$filename" >&2
    exit 1
  fi

  printf "##### Using public key: %s\n" "$filename"

  require_cmd ssh-copy-id

  local username ip port
  read -r -p "##### Enter username for remote host to add key for: " username
  read -r -p "##### Enter host/ip for remote host to add key for: " ip
  read -r -p "##### Enter ssh port on remote host (default=\"22\"): " port
  if [[ -z "$port" ]]; then
    port="22"
  fi
  if ! [[ "$port" =~ ^[0-9]+$ ]]; then
    printf "Invalid port '%s'. Must be a number.\n" "$port" >&2
    exit 1
  fi
  if [[ -z "$username" || -z "$ip" ]]; then
    printf "Username and host/ip must not be empty.\n" >&2
    exit 1
  fi

  if yes_no_prompt "Are you authenticating using an already existing and assigned identity?" "N"; then
    local pathtoidentity
    read -r -p "Enter the path to that identity: " pathtoidentity
    # Do not auto-normalize identity; user might mean ~/.ssh/...
    if [[ ! -f "$pathtoidentity" ]]; then
      printf "Identity file '%s' does not exist.\n" "$pathtoidentity" >&2
      exit 1
    fi
    ssh-copy-id -f -i "$filename" -o "IdentityFile $pathtoidentity" -p "$port" "$username@$ip"
  else
    ssh-copy-id -i "$filename" -p "$port" "$username@$ip"
  fi

  local privkey="${filename%.pub}"

  printf "##### Use 'ssh -i %s -p %s %s@%s' to connect to the remote host using the key.\n" "$privkey" "$port" "$username" "$ip"
}

###############################################################################
# Main
###############################################################################

main () {
  local action="${1:-}"

  case "$action" in
    -h|--help)
      print_help
      ;;
    -g|--gen)
      if yes_no_prompt "##### Are you using a Yubico YubiKey (with FIDO2) for this setup?" "N"; then
        yubikey="y"
      else
        yubikey="n"
      fi
      GLOBAL_LAST_KEY_FILE=""
      generate_key_pair "$yubikey"
      ;;
    -u|--upload)
      upload_key ""
      ;;
    "" )
      print_help
      if yes_no_prompt "##### Are you using a Yubico YubiKey (with FIDO2) for this setup?" "N"; then
        yubikey="y"
      else
        yubikey="n"
      fi
      GLOBAL_LAST_KEY_FILE=""
      generate_key_pair "$yubikey"
      upload_key ""   # uses GLOBAL_LAST_KEY_FILE
      ;;
    *)
      printf "Unknown option '%s'.\n\n" "$action" >&2
      print_help
      exit 1
      ;;
  esac
}

main "${1:-}"
