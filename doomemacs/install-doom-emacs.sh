doom_repo_url="https://github.com/doomemacs/doomemacs"
doom_repo_dir=~/src/doomemacs
doom_config_dir=~/.doom.d
dotfile_config_dir=~/src/dotfiles/doomemacs
emacs_config_dir=~/.emacs.d


# Clone doom repo and symlink it to the emacs directory:
if [[ ! -e $doom_repo_dir ]]; then
  git clone --depth 1 $doom_repo_url $doom_repo_dir
fi

# Symlink doom repo to emacs directory:
if [[ ! -e $emacs_config_dir ]]; then
  ln -s $doom_repo_dir $emacs_config_dir
fi

# Symlink my dotfiles config to Doom's config directory:
if [[ ! -L $doom_config_dir ]]; then
  ln -s $dotfile_config_dir $doom_config_dir
fi

# Reload bash config so it can find the doom cmmands:
source ~/.bashrc

# Make Doom fetch and build its elisp packages:
if [[ -x "$(command -v doom)" ]]; then
  doom sync
else
  echo "Doom command can't be found."
fi
