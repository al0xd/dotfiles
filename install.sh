#!/usr/bin/env bash

# Dinh Hung's Dotfiles
unamestr=$(uname)
zshrc_file="$HOME/.zshrc"
vimrc_file="$HOME/.vimrc"
# tmuxfile="$HOME/.tmux.conf"
gitconfig="$HOME/.gitconfig"
gitignore="$HOME/.gitignore"
lvimconfig="$HOME/.config/lvim/config.lua"
kittyconf="$HOME/.config/kitty/kitty.conf"
set -
# Install Packages
function insp(){
  # Config Symbol Links
  if [ -f "$zshrc_file" ]; then
    # Backup Old zshrc file
    mv "${zshrc_file}" "${zshrc_file}.backup"
  fi
  # if [ -f "$tmuxfile" ]; then
  #   mv "${tmuxfile}" "${tmuxfile}.backup"
  # fi

  if [ -f "$gitconfig" ]; then
    mv "${gitconfig}" "${gitignore}.backup"
  fi

  if [ -f "$gitignore" ]; then
    mv "${gitignore}" "${gitignore}.backup"
  fi

  if [ -f "$lvimconfig" ]; then
    mv "${lvimconfig}" "${lvimconfig}.backup"
  fi
  if [ -f "$kittyconf" ]; then
    mv "${kittyconf}" "${kittyconf}.backup"
  fi

  # Create Symbolinks
  ln -s $HOME/.dotfiles/zsh/zshrc $zshrc_file
  ln -s $HOME/.dotfiles/tmux/tmux.conf $tmuxfile
  ln -s $HOME/.dotfiles/git/gitconfig $gitconfig 
  ln -s $HOME/.dotfiles/git/gitignore $gitignore 
  ln -s $HOME/.dotfiles/lunarvim/config.lua $lvimconfig 
  ln -s $HOME/.dotfiles/kitty/kitty.conf $kittyconf 

  echo "Dotfiles installed!"

}

# Check .dotfiles has been installed
if [ ! -d "$HOME/.dotfiles" ]; then
  echo "Installing Dotfiles for the first time"
  git clone --depth=1 https://github.com/al0xd/dotfiles.git "$HOME/.dotfiles"
  cd "$HOME/.dotfiles"
  insp $@
else
  echo "Dotfiles is already installed!"
fi

