#!/usr/bin/env bash

# Dinh Hung's Dotfiles - Refactored Version  
# Script cài đặt và backup dotfiles an toàn, rõ ràng, dễ mở rộng

set -eo pipefail

# ===== CONFIGURATION =====
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
readonly REPO_URL="https://github.com/al0xd/dotfiles.git"

# Định nghĩa dotfiles mapping - tương thích với bash cũ (macOS default)
# Format: "source_path|destination_path"
readonly DOTFILE_MAPPINGS=(
  "zsh/zshrc|$HOME/.zshrc"
  "git/gitconfig|$HOME/.gitconfig"
  "git/gitignore|$HOME/.gitignore"
  "lunarvim/config.lua|$HOME/.config/lvim/config.lua"
  "kitty/kitty.conf|$HOME/.config/kitty/kitty.conf"
)

# ===== LOGGING FUNCTIONS =====
log_info() {
  echo "ℹ️  $*"
}

log_success() {
  echo "✅ $*"
}

log_warn() {
  echo "⚠️  $*"
}

log_error() {
  echo "❌ $*" >&2
}

# ===== UTILITY FUNCTIONS =====
# Kiểm tra và tạo thư mục nếu chưa tồn tại
ensure_directory() {
  local dir="$1"
  if [[ ! -d "$dir" ]]; then
    log_info "Tạo thư mục: $dir"
    mkdir -p "$dir"
  fi
}

# Backup file với timestamp nếu cần thiết
backup_file() {
  local file="$1"
  
  # Bỏ qua nếu file không tồn tại
  [[ ! -e "$file" && ! -L "$file" ]] && return 0
  
  local backup_file="${file}.backup"
  
  # Nếu backup đã tồn tại, thêm timestamp
  if [[ -e "$backup_file" ]]; then
    backup_file="${file}.backup.$(date +%Y%m%d_%H%M%S)"
  fi
  
  log_info "Backup: $file -> $backup_file"
  mv "$file" "$backup_file"
}

# Tạo symlink an toàn với validation
create_symlink() {
  local src="$1"
  local dest="$2"
  
  # Kiểm tra source file có tồn tại
  if [[ ! -e "$src" ]]; then
    log_warn "Source không tồn tại: $src (bỏ qua)"
    return 0
  fi
  
  # Tạo thư mục đích nếu chưa có
  ensure_directory "$(dirname "$dest")"
  
  # Xóa file/symlink cũ nếu có
  [[ -e "$dest" || -L "$dest" ]] && rm -f "$dest"
  
  # Tạo symlink
  ln -s "$src" "$dest"
  log_success "Linked: $src -> $dest"
}

# ===== MAIN FUNCTIONS =====
# Cài đặt/cập nhật dotfiles
install_dotfiles() {
  log_info "=== Bắt đầu cài đặt dotfiles ==="
  
  # Backup và tạo symlink cho tất cả configs
  for mapping in "${DOTFILE_MAPPINGS[@]}"; do
    # Split string by pipe delimiter
    local src="${mapping%|*}"
    local dest="${mapping#*|}"
    
    # Backup file cũ trước
    backup_file "$dest"
    
    # Tạo symlink
    local full_src="$DOTFILES_DIR/$src"
    create_symlink "$full_src" "$dest"
  done
  
  log_success "Dotfiles đã được cài đặt thành công!"
}

# Khởi tạo repository dotfiles
setup_repository() {
  if [[ ! -d "$DOTFILES_DIR" ]]; then
    log_info "Clone dotfiles repository lần đầu..."
    git clone --depth=1 "$REPO_URL" "$DOTFILES_DIR"
    log_success "Repository đã được clone thành công!"
  else
    log_info "Repository đã tồn tại, cập nhật..."
    cd "$DOTFILES_DIR"
    
    # Pull updates nếu có thể
    if git rev-parse --git-dir > /dev/null 2>&1; then
      log_info "Cập nhật từ remote repository..."
      git pull origin master || log_warn "Không thể pull updates"
    fi
  fi
}

# Validate environment và dependencies
validate_environment() {
  # Kiểm tra git có sẵn
  if ! command -v git &> /dev/null; then
    log_error "Git không được tìm thấy. Vui lòng cài đặt Git trước."
    exit 1
  fi
  
  # Kiểm tra quyền ghi vào HOME
  if [[ ! -w "$HOME" ]]; then
    log_error "Không có quyền ghi vào thư mục HOME: $HOME"
    exit 1
  fi
}

# Tạo file .env trong dotfiles nếu chưa có
ensure_dotfiles_env_file() {
  local env_file="$HOME/.dotfiles/.env"

  ensure_directory "$(dirname "$env_file")"

  if [[ -f "$env_file" ]]; then
    log_info "Đã tồn tại file env: $env_file"
    return 0
  fi

  log_info "Tạo file env mặc định cho shell: $env_file"
  cat > "$env_file" << 'EOF'
# Dotfiles environment variables
# Thêm các biến môi trường cá nhân của bạn vào đây.
EOF
  log_success "Đã tạo file env: $env_file"
}

# Hiển thị help
show_help() {
  cat << EOF
Dotfiles Installer - Cài đặt cấu hình dotfiles

USAGE:
  $0 [OPTIONS]

OPTIONS:
  -h, --help     Hiển thị help này
  -d, --dir DIR  Chỉ định thư mục dotfiles (mặc định: $HOME/dotfiles)

EXAMPLES:
  $0                     # Cài đặt bình thường
  $0 -d /path/to/custom  # Sử dụng thư mục custom

EOF
}

# Parse command line arguments
parse_arguments() {
  while [[ $# -gt 0 ]]; do
    case $1 in
      -h|--help)
        show_help
        exit 0
        ;;
      -d|--dir)
        DOTFILES_DIR="$2"
        shift 2
        ;;
      *)
        log_error "Unknown option: $1"
        show_help
        exit 1
        ;;
    esac
  done
}

# ===== MAIN EXECUTION =====
main() {
  parse_arguments "$@"
  
  log_info "🚀 Khởi động Dotfiles Installer..."
  log_info "Dotfiles directory: $DOTFILES_DIR"
  
  validate_environment
  setup_repository
  ensure_dotfiles_env_file
  
  cd "$DOTFILES_DIR"
  install_dotfiles
  
  log_success "🎉 Hoàn thành! Reload shell để áp dụng thay đổi."
}

# Chạy script với error handling
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi

