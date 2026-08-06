# AH Plugin Setup Guide

Hướng dẫn thiết lập plugin AH (Awesome Helper) như một submodule trong repository chính.

## 🎯 Tổng quan

Plugin AH đã được tạo hoàn chỉnh tại `/projects/zsh-plugin-ah/` với:
- ✅ Cấu trúc plugin hoàn chỉnh cho Oh-My-Zsh
- ✅ Tài liệu đầy đủ (README, INSTALL, CONTRIBUTING, etc.)
- ✅ CI/CD workflows cho GitHub Actions
- ✅ Scripts tiện ích (install, test, demo, publish)
- ✅ Makefile với các commands phát triển

## 🚀 Thiết lập nhanh

Chạy script setup tự động:

```bash
cd /projects
chmod +x setup-ah-plugin.sh
./setup-ah-plugin.sh
```

Script này sẽ:
1. Khởi tạo git repository trong thư mục plugin
2. Tạo commit đầu tiên với tất cả files
3. Cấu hình remote origin cho `al0xd/ah`

## 📋 Các bước thủ công

### 1. Khởi tạo Git Repository

```bash
cd /projects/zsh-plugin-ah
chmod +x git-setup.sh initial-commit.sh
./git-setup.sh
./initial-commit.sh
```

### 2. Tạo Repository trên GitHub

1. Truy cập https://github.com/new
2. Repository name: `ah`
3. Owner: `al0xd`
4. Public repository
5. **Không** initialize với README (đã có sẵn)

### 3. Push lên GitHub

```bash
cd /projects/zsh-plugin-ah
git push -u origin main
git tag -a v1.0.0 -m "Initial release v1.0.0"
git push origin v1.0.0
```

### 4. Thêm như Submodule vào Repository chính

```bash
cd /projects
git submodule add https://github.com/al0xd/ah.git zsh-plugin-ah
git add .gitmodules zsh-plugin-ah
git commit -S -m "feat: add AH plugin as submodule"
git push
```

## 🔧 Development Commands

Sau khi setup, có thể sử dụng các commands sau trong thư mục plugin:

```bash
make help          # Xem tất cả commands có sẵn
make install       # Cài đặt plugin vào Oh-My-Zsh
make test          # Test plugin functionality
make demo          # Xem demo plugin
make publish       # Publish changes lên GitHub
make info          # Thông tin plugin
make validate      # Validate cấu trúc plugin
```

## 📁 Cấu trúc Files

```
zsh-plugin-ah/
├── ah.plugin.zsh              # File plugin chính
├── README.md                  # Tài liệu chính
├── INSTALL.md                 # Hướng dẫn cài đặt
├── LICENSE                    # MIT License
├── CHANGELOG.md               # Lịch sử thay đổi
├── CONTRIBUTING.md            # Hướng dẫn contribute
├── SECURITY.md                # Security policy
├── Makefile                   # Development commands
├── package.json               # NPM metadata
├── *.sh                       # Utility scripts
├── .github/                   # GitHub templates & workflows
└── .gitignore                 # Git ignore rules
```

## 🎯 Tính năng Plugin

### Docker & Docker Compose
- `dcu`, `dc`, `dce`, `dcb`, `dcd`, `dcrs` - Basic aliases
- `dceb <service>` - Enter container bash
- `dclog <service>` - View container logs
- `dcr <service> [cmd]` - Run command in new container

### Image Management
- `dimages` - List all images
- `dsearch <keyword>` - Search images
- `drmi <keyword>` - Remove images by keyword
- `drmino` - Remove dangling images
- `drmiun` - Remove unused images

### Container Management
- `dps` - Show running containers
- `drmcon` - Remove stopped containers
- `dstopkey <keyword>` - Stop containers by keyword (lists names first)
- `drmkey <keyword>` - Remove containers by keyword (lists names first)
- `ah search <keyword>` - Semantic search AH commands (e.g. `ah search stop`)

### Cloud Platforms
- `clr` - Cloudflare tunnel run
- `fssh` - Fly.io SSH console
- `fsshc` - Fly.io Rails console
- `flog` - Fly.io logs

### Help System
- `ah` - Show complete help with all commands

## 🌟 Đặc điểm

- 🛡️ **Safety First**: Confirmation prompts cho destructive operations
- 🎨 **User Friendly**: Emoji indicators và error messages rõ ràng
- 📖 **Self Documenting**: Built-in help system
- 🔧 **Extensible**: Dễ dàng thêm aliases mới
- ⚡ **Performance**: Optimized loading và execution

## 🔗 Links

- **GitHub Repository**: https://github.com/al0xd/ah
- **Installation Guide**: [INSTALL.md](./zsh-plugin-ah/INSTALL.md)
- **Contributing**: [CONTRIBUTING.md](./zsh-plugin-ah/CONTRIBUTING.md)
- **Changelog**: [CHANGELOG.md](./zsh-plugin-ah/CHANGELOG.md)

## 📞 Support

Nếu gặp vấn đề:
1. Kiểm tra [Issues](https://github.com/al0xd/ah/issues)
2. Tạo issue mới với thông tin chi tiết
3. Sử dụng bug report template có sẵn

---

**Made with ❤️ for developer productivity**
