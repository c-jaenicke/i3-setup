upload_key () {
  printf "########## 2. Upload the key\n"

  local filename="${1:-}"

  # Prefer explicit argument, else last generated key (for the reminder).
  if [[ -z "$filename" && -n "${GLOBAL_LAST_KEY_FILE:-}" ]]; then
    filename="$GLOBAL_LAST_KEY_FILE"
  fi

  if ! yes_no_prompt "##### Add key to remote host?" "N"; then
    # Show a short how-to if we have a key path.
    if [[ -n "$filename" ]]; then
      local pubfile="$filename"
      if [[ "$pubfile" != *.pub ]]; then
        pubfile="${pubfile}.pub"
      fi
      printf "##### To add the key later, append the contents of:\n"
      printf "      %s\n" "$pubfile"
      printf "##### to the file:\n"
      printf "      ~/.ssh/authorized_keys\n"
      printf "##### on the remote host for the desired user.\n"
    fi
    printf "Skipping upload.\n"
    return 0
  fi

  # From here on, same as before...
  if [[ -z "$filename" ]]; then
    read -r -p "##### Enter the path to the public key to upload: " filename
    case "$filename" in
      /*) ;;
      *)  filename="$(pwd)/$filename" ;;
    esac
  fi

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
