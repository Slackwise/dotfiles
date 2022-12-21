#!/bin/bash

user_font_dir=$HOME/.local/share/fonts

mkdir -p $user_font_dir

ln -s \
  "$HOME/src/dotfiles/fonts" \
  "$user_font_dir/dotfiles-fonts"
