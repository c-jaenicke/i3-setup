#!/usr/bin/env bash
# Script to authenticate using SSH on git.
# This scripts starts a new ssh-agent, adds the needed key, performs the action and kills the
# previously started ssh-agent.

# start ssh agent
eval "$(ssh-agent -s)" > "/dev/null"

# add key to agent
# CHANGE PATH TO KEY HERE
ssh-add "$HOME/.ssh/git/git" > "/dev/null"

if [[ -n "$1" ]]; then
  git $@
fi

ssh-agent -k > "/dev/null"
