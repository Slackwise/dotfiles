#!/usr/bin/env bash
# Idempotent bash rewrite of the old bash/Rakefile.
# Symlinks ~/.bashrc to this repo's bash/bashrc and ensures ~/.bash_profile sources it.
set -uo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bashrc_target="$script_dir/bashrc"
home_bashrc="$HOME/.bashrc"
home_bashrc_sys="$HOME/.bashrc.sys"
bash_profile="$HOME/.bash_profile"
profile_contents='[ -f $HOME/.bashrc ] && source $HOME/.bashrc'

symlink_bashrc() {
  if [[ -L "$home_bashrc" && "$(readlink "$home_bashrc")" == "$bashrc_target" ]]; then
    echo "~/.bashrc already symlinked to $bashrc_target."
    return
  fi

  if [[ -e "$home_bashrc" || -L "$home_bashrc" ]]; then
    if [[ -e "$home_bashrc_sys" ]]; then
      rm -f "$home_bashrc"
    else
      mv "$home_bashrc" "$home_bashrc_sys"
      echo "Backed up existing ~/.bashrc to $home_bashrc_sys."
    fi
  fi

  ln -s "$bashrc_target" "$home_bashrc"
  echo "Symlinked ~/.bashrc -> $bashrc_target."
}

create_bash_profile() {
  if [[ -f "$bash_profile" ]] && grep -Fq "$profile_contents" "$bash_profile"; then
    echo "~/.bash_profile already sources ~/.bashrc."
    return
  fi

  if [[ -f "$bash_profile" ]]; then
    echo "$profile_contents" >> "$bash_profile"
    echo "Appended ~/.bashrc sourcing to existing ~/.bash_profile."
  else
    echo "$profile_contents" > "$bash_profile"
    echo "Created ~/.bash_profile."
  fi
}

symlink_bashrc
create_bash_profile
