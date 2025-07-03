#!/bin/bash

# Script to add AH plugin as a submodule to the main projects repository

echo "🔗 Adding AH plugin as submodule to main repository..."

# Go to main projects directory
cd /projects

# Remove the current directory if it exists (since we need to add it as submodule)
if [ -d "zsh-plugin-ah" ]; then
    echo "📋 Current directory exists, need to handle it properly..."
    
    # Check if it's already a git repository
    if [ -d "zsh-plugin-ah/.git" ]; then
        echo "✅ Directory is already a git repository"
        
        # Add it as submodule
        echo "🔗 Adding as submodule..."
        git submodule add https://github.com/al0xd/ah.git zsh-plugin-ah
        
    else
        echo "❌ Directory is not a git repository. Please run initial-commit.sh first."
        exit 1
    fi
else
    echo "📂 Adding submodule..."
    git submodule add https://github.com/al0xd/ah.git zsh-plugin-ah
fi

# Initialize and update submodules
echo "🔄 Initializing submodules..."
git submodule init
git submodule update

# Show submodule status
echo "📊 Submodule status:"
git submodule status

# Show .gitmodules content
echo "📋 .gitmodules content:"
cat .gitmodules

echo ""
echo "✅ Submodule added successfully!"
echo "📝 Don't forget to commit the submodule changes to main repository:"
echo "  git add .gitmodules zsh-plugin-ah"
echo "  git commit -S -m 'feat: add AH plugin as submodule'"
