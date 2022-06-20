#!/usr/bin/env bash

# Dinh Hung's Dotfiles
unamestr=$(uname)
zshrc_file="$HOME/.zshrc"
vimrc_file="$HOME/.vimrc"
tmuxfile="$HOME/.tmux.conf"
set -
# Install Packages
function insp(){
  # Config Symbol Links
  if [ -f "$zshrc_file" ]; then
    # Backup Old zshrc file
    mv ~/.zshrc $HOME/.zshrc.backup
  fi
  if [ -f "$tmux_file" ]; then
    mv $tmux_file $HOME/.tmux.conf.backup
  fi



  # Create Symbolinks
  ln -s $HOME/.dotfiles/zsh/zshrc $zshrc_file
  ln -s $HOME/.dotfiles/tmux/tmux.conf $tmux_file


}

# Check .dotfiles has been installed
if [ ! -d "$HOME/.dotfiles" ]; then
  echo "Installing Dotfiles for the first time"
  git clone --depth=1 https://github.com/hungdinhvan/dotfiles.git "$HOME/.dotfiles"
  cd "$HOME/.dotfiles"
  insp $@
else
  echo "Dotfiles is already installed!"
fi

