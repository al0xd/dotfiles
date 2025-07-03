#!/bin/bash

# Complete setup script for AH Plugin as submodule

echo "🚀 Complete Setup for AH Plugin (al0xd/ah)"
echo "=========================================="
echo ""

echo "This script will:"
echo "1. Setup git repository in the plugin directory"
echo "2. Create initial commit"
echo "3. Configure as submodule in main repository"
echo ""
echo "Continue? (y/N)"
read -r confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "❌ Setup cancelled"
    exit 0
fi

echo ""
echo "📝 Step 1: Setting up plugin repository..."
cd /projects/zsh-plugin-ah

# Make scripts executable
chmod +x *.sh

# Run git setup
if [ -f git-setup.sh ]; then
    ./git-setup.sh
else
    echo "❌ git-setup.sh not found"
    exit 1
fi

echo ""
echo "📝 Step 2: Creating initial commit..."
if [ -f initial-commit.sh ]; then
    ./initial-commit.sh
else
    echo "❌ initial-commit.sh not found"
    exit 1
fi

echo ""
echo "📝 Step 3: Returning to main repository..."
cd /projects

echo ""
echo "🎉 Setup completed!"
echo ""
echo "📋 Next steps to complete the process:"
echo "1. Create repository on GitHub:"
echo "   - Go to https://github.com/new"
echo "   - Repository name: ah"
echo "   - Owner: al0xd"
echo "   - Make it public"
echo "   - Don't initialize with README (we already have files)"
echo ""
echo "2. Push to GitHub:"
echo "   cd /projects/zsh-plugin-ah"
echo "   git push -u origin main"
echo ""
echo "3. Create first release:"
echo "   git tag -a v1.0.0 -m 'Initial release v1.0.0'"
echo "   git push origin v1.0.0"
echo ""
echo "4. Update main repository with submodule:"
echo "   cd /projects"
echo "   git submodule add https://github.com/al0xd/ah.git zsh-plugin-ah"
echo "   git add .gitmodules zsh-plugin-ah"
echo "   git commit -S -m 'feat: add AH plugin as submodule'"
echo ""
echo "🔗 Repository will be available at: https://github.com/al0xd/ah"
echo ""
echo "💡 After creating the GitHub repository, you can run:"
echo "   make publish    # from plugin directory to push everything"
