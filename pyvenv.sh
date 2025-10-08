#!/bin/bash

# Python virtual environment functions I wrote for use in interactive shell
# Meant to be sourced in .zshrc or .bashrc
# Dependencies: python3 uv fd

#colors/formatting
red=$(tput setaf 1)
green=$(tput setaf 2)
reset=$(tput sgr0)

# mkvenv creates a project folder under the name given as param 1
# cds into project folder and creates venv called '.venv'
# activates new virtual env
# use when creating a new project
mkvenv() {
  echo "Making Python venv..."
  mkdir -p "$1" && cd "$1"
  uv venv .venv
  source .venv/bin/activate
}

# pyvenv searches for a virtual env in the current dir and activates it
# can activate any environment in the list of names
# use to activate existing venv
#
# NOTE: to add names to the names array any '.' character must be prepended with
# a '\' escape character or fd will not be able to understand the regex
pyvenv() {
  names=("venv" "\.venv" "env" "\.env" "pyenv" "\.pyenv" "pyvenv" "\.pyvenv")

  if [[ "$1" == "--list-names" ]]; then
    echo "${names[*]}"
  else
    for name in "${names[@]}"; do
      result=$(fd --no-ignore --type d --max-depth 1 --hidden "$name" . | head -n 1)
      if [[ -n "$result" ]]; then
        venv_dir="$result"
        break
      fi
    done

    if [[ -n "$venv_dir" ]]; then
      source "$venv_dir"/bin/activate
    else
      echo "${red}error:${reset} no python virtual environment found in $(pwd)\n"
      echo "If you know you have one, did you make sure it was in the list of names?\n"
      echo "${green}tip:${reset} to view the current list of names try '--list-names'"
    fi
  fi
}

# Useful function if you're using a terminal prompt that overrides the
# standard (.venv) that shows up. Saves time
chkvenv() {
  echo "$VIRTUAL_ENV"
}
