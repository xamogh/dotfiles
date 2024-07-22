#!/bin/bash

mkdir -p ~/.config/nvim
mkdir -p ~/.config/kitty

cp ./nvim-init.lua ~/.config/nvim/init.lua

cp ./kitty.conf ~/.config/kitty/kitty.conf

cp ./.zshrc ~/.config/.zshrc

if ! command -v nvim &> /dev/null; then
    echo "Neovim not found. Installing Neovim..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # For Ubuntu/Debian:
        sudo apt-get update && sudo apt-get install -y neovim
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # For macOS (using Homebrew):
        brew install neovim
    else
        echo "Unsupported OS for automatic Neovim installation. Please install Neovim manually."
    fi
fi

if ! command -v kitty &> /dev/null; then
    echo "Kitty not found. Installing Kitty..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # For Ubuntu/Debian:
        sudo apt-get update && sudo apt-get install -y kitty
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # For macOS (using Homebrew):
        brew install --cask kitty
    else
        echo "Unsupported OS for automatic Kitty installation. Please install Kitty manually."
    fi
fi

echo "Configuration setup complete. Neovim and Kitty configurations are now in place."
