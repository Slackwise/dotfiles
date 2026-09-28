#!/usr/bin/env bash
# Idempotent bash rewrite of the old vim/Rakefile.
# Links ~/.vimrc (or ~/_vimrc on Windows/git-bash) to this repo's vim/vimrc, creates ~/.vim support dirs, and installs Vundle.
set -uo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
vimrc_target="$script_dir/vimrc"
home_vimrc="$HOME/.vimrc"
win_vimrc="$HOME/_vimrc"
vim_dir="$HOME/.vim"
vundle_dir="$vim_dir/bundle/vundle"
vundle_url="https://github.com/gmarik/vundle.git"

is_windows() {
  [[ "${OSTYPE:-}" == msys* || "${OSTYPE:-}" == cygwin* || -n "${MSYSTEM:-}" ]]
}

symlink_vimrc() {
  if [[ -L "$home_vimrc" && "$(readlink "$home_vimrc")" == "$vimrc_target" ]]; then
    echo "~/.vimrc already symlinked to $vimrc_target."
    return
  fi

  if [[ -e "$home_vimrc" || -L "$home_vimrc" ]]; then
    rm -f "$home_vimrc"
  fi

  ln -s "$vimrc_target" "$home_vimrc"
  echo "Symlinked ~/.vimrc -> $vimrc_target."
}

write_windows_vimrc() {
  if [[ -f "$win_vimrc" ]] && grep -Fq "$vimrc_target" "$win_vimrc"; then
    echo "~/_vimrc already redirects to $vimrc_target."
    return
  fi

  printf 'let $MYVIMRC="%s"\nsource $MYVIMRC\n' "$vimrc_target" > "$win_vimrc"
  echo "Created ~/_vimrc redirecting to $vimrc_target."
}

make_dirs() {
  mkdir -p "$vim_dir/swap" "$vim_dir/backup"
  echo "Ensured ~/.vim/swap and ~/.vim/backup exist."
}

install_vundle() {
  if [[ -d "$vundle_dir/.git" ]]; then
    echo "Vundle already installed."
    return
  fi

  if git clone "$vundle_url" "$vundle_dir"; then
    echo "Successfully cloned Vundle repo."
  else
    echo "Failed to clone Vundle repo!" >&2
    exit 1
  fi
}

if is_windows; then
  write_windows_vimrc
else
  symlink_vimrc
fi
make_dirs
install_vundle
