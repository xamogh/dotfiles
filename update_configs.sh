#!/bin/bash

# Update Neovim config
cp ~/.config/nvim/init.lua ~/dotfiles/nvim-init.lua

# Update Kitty config
cp ~/.config/kitty/kitty.conf ~/dotfiles/kitty.conf

# Change to dotfiles directory
cd ~/dotfiles

# Check if there are any changes
if [[ `git status --porcelain` ]]; then
  # Changes exist, so commit them
  git add .
  git commit -m "Update configurations: $(date +%Y-%m-%d)"
  git push origin main
  echo "Configurations updated and pushed to GitHub."
else
  # No changes
  echo "No changes to configurations."
fi
