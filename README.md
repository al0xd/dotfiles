![Hero](./img/hero.png)

# ⚡ Dotfiles Configuration

> A minimalist and powerful dotfiles configuration tailored for web developers and productivity enthusiasts.

## 🎯 Overview

This repository contains a carefully curated collection of dotfiles and configurations that provide a seamless development environment. Designed with simplicity and productivity in mind, these configurations help you set up a powerful terminal-based workflow quickly.

## ✨ Features

- **🚀 One-Command Installation**: Automated setup with intelligent backup system
- **🔄 Smart Updates**: Automatic git pull and configuration sync  
- **💾 Safe Backup**: Automatic backup of existing configs with timestamps
- **🖥️ Modern Terminal Setup**: Enhanced terminal experience with Kitty terminal emulator
- **🐚 Powerful Shell Configuration**: ZSH with custom aliases and functions
- **⚡ Advanced Code Editor**: LunarVim configuration for efficient coding
- **🔤 Custom Fonts**: High-quality programming fonts included
- **📦 Git Configuration**: Optimized Git settings and global gitignore
- **🔧 Cross-Platform**: Compatible with macOS (bash 3.2+) and Linux

## 📋 Prerequisites

Before installation, ensure you have the following dependencies installed:

| Tool | Description | Status | Installation Link |
|------|-------------|--------|-------------------|
| **Git** | Version control system | Required | [Install Guide](https://git-scm.com/downloads) |
| [Kitty](https://sw.kovidgoyal.net/kitty/) | Modern, feature-rich terminal emulator | Recommended | [Install Guide](https://sw.kovidgoyal.net/kitty/binary/) |
| [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) | Framework for managing Zsh configuration | Recommended | [Install Guide](https://ohmyz.sh/#install) |
| [LunarVim](https://github.com/LunarVim/LunarVim) | IDE layer for Neovim with sane defaults | Optional | [Install Guide](https://www.lunarvim.org/docs/installation) |
| [Powerlevel10k](https://github.com/romkatv/powerlevel10k) | Fast and customizable Zsh theme | Optional | [Install Guide](https://github.com/romkatv/powerlevel10k#installation) |

## 🚀 Installation

### Quick Install (Recommended)

Open your terminal and run this single command:

```bash
bash <(curl -s https://raw.githubusercontent.com/al0xd/dotfiles/master/install.sh)
```

### Manual Installation

If you prefer to install manually or want more control over the process:

```bash
# Clone the repository
git clone https://github.com/al0xd/dotfiles.git ~/dotfiles

# Navigate to the dotfiles directory
cd ~/dotfiles

# Make install script executable
chmod +x ./install.sh

# Run the installation script
./install.sh
```

### Custom Installation Directory

You can specify a custom directory for dotfiles:

```bash
# Install to custom directory
./install.sh -d /path/to/custom/dotfiles

# Or set environment variable
DOTFILES_DIR=/path/to/custom ./install.sh
```

## 📖 Installation Script Usage

The `install.sh` script comes with several useful options:

```bash
# Show help information
./install.sh --help

# Install with custom dotfiles directory
./install.sh --dir /custom/path

# Short form options
./install.sh -h        # Help
./install.sh -d DIR    # Custom directory
```

### What the script does:

1. **🔍 Environment Validation**: Checks for Git and required permissions
2. **📦 Repository Setup**: Clones repo (first time) or pulls updates (existing)
3. **💾 Smart Backup**: Backs up existing configs with timestamps
4. **🔗 Symlink Creation**: Creates symlinks to dotfiles configurations
5. **✅ Verification**: Validates all operations completed successfully

## 🔄 Updating

To update your dotfiles configuration to the latest version:

```bash
# Navigate to dotfiles directory (default location)
cd ~/dotfiles

# Run the installation script (it will auto-update)
./install.sh
```

The script automatically:
- Pulls latest changes from the repository
- Updates all symlinks
- Backs up any conflicting files

## 📁 Project Structure

```
dotfiles/
├── 📂 fonts/           # Programming fonts collection
│   ├── ComicMono-*.ttf
│   ├── LigaComicMono-*.ttf
│   └── SFMono-*.otf
├── 📂 git/             # Git configuration files
│   ├── gitconfig       # Global git configuration
│   └── gitignore       # Global gitignore patterns
├── 📂 kitty/           # Kitty terminal configuration
│   └── kitty.conf      # Terminal settings and themes
├── 📂 lunarvim/        # LunarVim configuration
│   └── config.lua      # Neovim IDE settings
├── 📂 zsh/             # ZSH configuration and aliases
│   ├── zshrc           # Main ZSH configuration
│   └── aliases.zsh     # Custom shell aliases
├── 📂 img/             # Documentation assets
│   └── hero.png
├── 🔧 install.sh       # Automated installation script
├── 📝 package.json     # Release automation
└── 📖 README.md        # This documentation
```

## ⚙️ What's Included

### 🐚 Shell Configuration (ZSH)
- Custom aliases for common commands
- Enhanced prompt and productivity functions
- Optimized for development workflow

### 🖥️ Terminal Setup (Kitty)
- Optimized terminal settings
- Custom key bindings and shortcuts
- Modern font rendering and themes

### 📦 Git Configuration
- Global settings for optimal workflow
- Comprehensive gitignore patterns
- Aliases for common git operations

### ⚡ Editor Setup (LunarVim)
- IDE-like experience with essential plugins
- Language server configurations
- Custom key bindings and themes

### 🔤 Font Collection
- **Comic Mono**: Playful monospace font
- **Liga Comic Mono**: Comic Mono with ligatures
- **SF Mono**: Apple's system monospace font
- Optimized for programming and terminal use

## 🛠️ Troubleshooting

### Common Issues

**Permission Denied:**
```bash
chmod +x ./install.sh
```

**Bash Version Issues (macOS):**
The script is compatible with bash 3.2+ (macOS default). No additional setup needed.

**Symlink Conflicts:**
The script automatically backs up existing files with timestamps before creating symlinks.

**Git Issues:**
Ensure you have Git installed and configured with your credentials.

## 🔧 Customization

### Adding New Dotfiles

To add new dotfiles to the installation:

1. Add your config file to the appropriate directory
2. Update the `DOTFILE_MAPPINGS` array in `install.sh`:

```bash
readonly DOTFILE_MAPPINGS=(
  # ... existing mappings ...
  "your-config/file|$HOME/.your-config"
)
```

### Modifying Existing Configs

Simply edit the files in their respective directories:
- `zsh/zshrc` - Shell configuration
- `git/gitconfig` - Git settings  
- `kitty/kitty.conf` - Terminal settings
- `lunarvim/config.lua` - Editor configuration

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **🍴 Fork** the repository
2. **🌿 Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **💾 Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **📤 Push** to the branch (`git push origin feature/amazing-feature`)
5. **📋 Open** a Pull Request

### Guidelines

- Follow existing code style and conventions
- Test your changes on multiple systems if possible
- Update documentation for new features
- Keep commits atomic and well-described

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 👨‍💻 Contributors

- **[Alex Dinh](https://github.com/al0xd)** - Creator and maintainer

## 🙏 Acknowledgments

Special thanks to the creators and maintainers of:
- [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh)
- [LunarVim](https://github.com/LunarVim/LunarVim)
- [Kitty Terminal](https://github.com/kovidgoyal/kitty)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)

---

<div align="center">
  <p>Made with ❤️ for the developer community</p>
  <p>⭐ Star this repo if it helped you!</p>
  
  <sub>
    Questions? Issues? Ideas? <br>
    <a href="https://github.com/al0xd/dotfiles/issues">Open an issue</a> or start a discussion!
  </sub>
</div>
