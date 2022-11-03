#/bin/bash

notes_repo_url="git@github.com:Slackwise/notes.git"
notes_private_repo_url="git@github.com:Slackwise/notes-private.git"

notes_repo_dir="$HOME/src/notes"
notes_private_repo_dir="$HOME/src/notes-private"

notes_dir="$HOME/notes"
notes_private_dir="$HOME/notes/private"


# Clone repos:
if [[ ! -e $notes_repo_dir ]]; then
  git clone $notes_repo_url $notes_repo_dir
fi
if [[ ! -e $notes_private_repo_dir ]]; then
  git clone $notes_private_repo_url $notes_private_repo_dir
fi

# Symlink user-friendly directories:
if [[ ! -e $notes_dir ]]; then
  ln -s $notes_repo_dir $notes_dir
fi
if [[ ! -e $notes_private_dir ]]; then
  ln -s $notes_private_repo_dir $notes_private_dir
fi
