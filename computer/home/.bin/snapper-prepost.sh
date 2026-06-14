#!/bin/bash
# Create pre/post snapshot around a command

if [ "$EUID" -ne 0 ]; then
    echo "##### Error: Please run as root."
    exit 1
fi

if [ "$#" -eq 0 ]; then
    echo "##### Error: No arguments provided."
    echo "##### Usage: sudo ./snap-wrap.sh [\"DESCRIPTION\"] \"COMMAND\""
    echo "##### Example 1 (Prompt): sudo ./snap-wrap.sh \"zypper dup\""
    echo "##### Example 2 (Custom): sudo ./snap-wrap.sh \"Updating system\" \"zypper dup\""
    exit 1
fi

DESCRIPTION=""
COMMAND=""

if [ "$#" -eq 1 ]; then
    # Only one argument provided, assume it is the command
    COMMAND="$1"
    TEMP_DESCRIPTION="Pre/Post Snapshot $(date --iso-8601="minutes")"

    read -p "##### No description set, will use \"$TEMP_DESCRIPTION\". Do you want to continue? [y/N]: " -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        DESCRIPTION="$TEMP_DESCRIPTION"
    else
        echo "##### No description, exiting!"
        echo "##### Usage: sudo ./snap-wrap.sh \"DESCRIPTION\" \"COMMAND\""
        exit 1
    fi
else
    # Multiple arguments: first is description, the rest make up the command
    DESCRIPTION="$1"
    shift
    COMMAND="$*"
fi

echo "##### Creating PRE snapshot..."
# Create PRE snapshot and capture the ID number (no sudo needed)
PRE_NUM=$(snapper create --type pre --print-number --description "PRE: $DESCRIPTION")

if [ -z "$PRE_NUM" ]; then
    echo "##### Error: Failed to create PRE snapshot."
    exit 1
fi

echo "##### PRE snapshot created with ID: $PRE_NUM"
echo "##### Executing command: $COMMAND"
echo "########################################"

# Execute the user's command
$COMMAND
COMMAND_EXIT_CODE=$?

echo "########################################"
echo "##### Command finished with exit code: $COMMAND_EXIT_CODE"
echo "##### Creating POST snapshot..."

# Create POST snapshot linked to the PRE snapshot (no sudo needed)
snapper create --type post --pre-number "$PRE_NUM" --description "POST: $DESCRIPTION"

echo "##### -> POST snapshot created successfully. Current snapshots:"
snapper list | tail -n 5
