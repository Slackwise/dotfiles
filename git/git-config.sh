GITCONFIG_FILE_PATH="~/src/dotfiles/git/gitconfig"
GIT_INCLUDE_MY_CONFIG=$'\n[include]\n\tpath = '
GIT_INCLUDE_MY_CONFIG+=$GITCONFIG_FILE_PATH
GIT_CONFIG_FILE="$HOME/.gitconfig"

if ! grep -Fq "$GITCONFIG_FILE_PATH" "$GIT_CONFIG_FILE"; then
  echo "$GIT_INCLUDE_MY_CONFIG" >> "$GIT_CONFIG_FILE"
fi