#!/usr/bin/env bash

# Dinh Hung's Dotfiles
unamestr=$(uname)
zshrc_file="$HOME/.zshrc"
vimrc_file="$HOME/.vimrc"
vimbundle_file="$HOME/.vimrc.bundles"
tmux_file="$HOME/.tmux.conf"
eslint_file="$HOME/.eslintrc.yml"
stylelint_file="$HOME/.stylelintrc.yml"
gitconfig_file="$HOME/.gitconfig"
nvimconfig_file="$HOME/.config/nvim/init.vim"
set -e
# Install Packages
function insp(){
  # Config Symbol Links
  if [ -f "$zshrc_file" ]; then
    # Backup Old zshrc file
    mv ~/.zshrc $HOME/.zshrc.backup
  fi
  if [ -f "$vimrc_file" ]; then
    mv $vimrc_file $HOME/.vimrc.backup
  fi
  if [ -f "$vimbundle_file" ]; then
    mv $vimbundle_file $HOME/.vimrc.bundles.backup
  fi
  if [ -f "$tmux_file" ]; then
    mv $tmux_file $HOME/.tmux.conf.backup
  fi
  if [ -f "$eslint_file" ]; then
    mv $eslint_file $HOME/.eslintrc.yml.backup
  fi
  if [ -f "$stylelint_file" ]; then
    mv $stylelint_file $HOME/.stylelintrc.yml.backup
  fi
  if [ ! -d "$HOME/.config" ]; then
    mkdir "$HOME/.config"
  fi

  if [ -d "$HOME/.config/nvim" ]; then
    mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup"
  fi
  mkdir "$HOME/.config/nvim"
  
  if [ -f "$gitconfig_file" ]; then
    mv $gitconfig_file $HOME/.gitconfig.backup
  fi
  
  

  # Create Symbolinks
  ln -s $HOME/.dotfiles/zsh/zshrc $zshrc_file
  ln -s $HOME/.dotfiles/vim/vimrc $vimrc_file
  ln -s $HOME/.dotfiles/vim/vimrc.bundles $vimbundle_file
  ln -s $HOME/.dotfiles/tmux/tmux.conf $tmux_file
  ln -s $HOME/.dotfiles/linter/eslintrc.yml $eslint_file
  ln -s $HOME/.dotfiles/linter/stylelintrc.yml $stylelint_file
  ln -s $HOME/.dotfiles/git/gitconfig $gitconfig_file
  ln -s $HOME/.dotfiles/vim/vimrc $nvimconfig_file

  
  # Install zsh plugins
  brew bundle
  # Install Ruby Bundle
  if ! hash bundle 2>/dev/null; then
    gem install bundler
  fi
  bundle install
  # Install Vim Plug
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}
# End install function
# Start Install Script
# Check Brew exists?
if ! hash brew 2>/dev/null; then
  printf "Please Install HomeBrew First\n"
  exit $?
fi
# Check .dotfiles has been installed
if [ ! -d "$HOME/.dotfiles" ]; then
  echo "Installing Dotfiles for the first time"
  git clone --depth=1 http://gl.it-s.vn/dinhhung/dotfiles.git "$HOME/.dotfiles"
  cd "$HOME/.dotfiles"
  insp $@
else
  echo "Dotfiles is already installed!"
fi

