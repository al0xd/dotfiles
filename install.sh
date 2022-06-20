#!/usr/bin/env bash

# Dinh Hung's Dotfiles
unamestr=$(uname)
zshrc_file="$HOME/.zshrc"
vimrc_file="$HOME/.vimrc"
tmuxfile="$HOME/.tmux.conf"
gitconfig="$HOME/.gitconfig"
gitignore="$HOME/.gitignore"
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

  if [ -f "$gitconfig" ]; then
    mv $gitconfig "$gitignore.backup"
  fi

  if [ -f "$gitignore" ]; then
    mv $gitignore "$gitignore.backup"
  fi

  # Create Symbolinks
  ln -s $HOME/.dotfiles/zsh/zshrc $zshrc_file
  ln -s $HOME/.dotfiles/tmux/tmux.conf $tmux_file
  ln -s $HOME/.dotfiles/git/gitconfig $gitconfig 
  ln -s $HOME/.dotfiles/git/gitignore $gitignore 


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

