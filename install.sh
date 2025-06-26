#!/usr/bin/env bash

# Dinh Hung's Dotfiles - Refactored by AI
# Script cài đặt và backup dotfiles an toàn, rõ ràng

set -e

# Định nghĩa đường dẫn nguồn và đích
DOTFILES_DIR="$HOME/dotfiles"
ZSHRC_SRC="$DOTFILES_DIR/zsh/zshrc"
ZSHRC_DEST="$HOME/.zshrc"
TMUX_SRC="$DOTFILES_DIR/tmux/tmux.conf"
TMUX_DEST="$HOME/.tmux.conf"
GITCONFIG_SRC="$DOTFILES_DIR/git/gitconfig"
GITCONFIG_DEST="$HOME/.gitconfig"
GITIGNORE_SRC="$DOTFILES_DIR/git/gitignore"
GITIGNORE_DEST="$HOME/.gitignore"
LVIM_SRC="$DOTFILES_DIR/lunarvim/config.lua"
LVIM_DEST="$HOME/.config/lvim/config.lua"
KITTY_SRC="$DOTFILES_DIR/kitty/kitty.conf"
KITTY_DEST="$HOME/.config/kitty/kitty.conf"

# Hàm backup file nếu tồn tại, không ghi đè backup cũ
backup_file() {
  local file="$1"
  if [ -f "$file" ] || [ -L "$file" ]; then
    local backup_file="${file}.backup"
    if [ -e "$backup_file" ]; then
      backup_file="${file}.backup.$(date +%Y%m%d%H%M%S)"
    fi
    echo "Backup $file -> $backup_file"
    mv "$file" "$backup_file"
  fi
}

# Hàm tạo symlink an toàn
safe_symlink() {
  local src="$1"
  local dest="$2"
  local dest_dir
  dest_dir=$(dirname "$dest")
  if [ ! -d "$dest_dir" ]; then
    mkdir -p "$dest_dir"
  fi
  if [ -L "$dest" ] || [ -f "$dest" ]; then
    rm -f "$dest"
  fi
  if [ -e "$src" ]; then
    ln -s "$src" "$dest"
    echo "Linked $src -> $dest"
  else
    echo "[WARN] Source $src không tồn tại, bỏ qua."
  fi
}

install_dotfiles() {
  echo "--- Backup các file cấu hình cũ (nếu có) ---"
  backup_file "$ZSHRC_DEST"
  backup_file "$TMUX_DEST"
  backup_file "$GITCONFIG_DEST"
  backup_file "$GITIGNORE_DEST"
  backup_file "$LVIM_DEST"
  backup_file "$KITTY_DEST"

  echo "--- Tạo symlink cho dotfiles ---"
  safe_symlink "$ZSHRC_SRC" "$ZSHRC_DEST"
  safe_symlink "$TMUX_SRC" "$TMUX_DEST"
  safe_symlink "$GITCONFIG_SRC" "$GITCONFIG_DEST"
  safe_symlink "$GITIGNORE_SRC" "$GITIGNORE_DEST"
  safe_symlink "$LVIM_SRC" "$LVIM_DEST"
  safe_symlink "$KITTY_SRC" "$KITTY_DEST"

  echo "✅ Dotfiles đã được cài đặt thành công!"
}

# Main
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "Installing Dotfiles for the first time..."
  git clone --depth=1 https://github.com/al0xd/dotfiles.git "$DOTFILES_DIR"
  cd "$DOTFILES_DIR"
  install_dotfiles "$@"
else
  echo "Dotfiles đã tồn tại, tiến hành cập nhật..."
  cd "$DOTFILES_DIR"
  install_dotfiles "$@"
fi

