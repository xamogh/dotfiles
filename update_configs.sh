#!/bin/bash

cp ~/.config/nvim/init.lua ~/dotfiles/nvim-init.lua

cp ~/.config/kitty/kitty.conf ~/dotfiles/kitty.conf

cp ~/.zshrc ~/dotfiles/.zshrc

cd ~/dotfiles

if [[ `git status --porcelain` ]]; then
  git add .
  git commit -m "Update configurations: $(date +%Y-%m-%d)"
  git push origin master
  echo "Configurations updated and pushed to GitHub."
else
  echo "No changes to configurations."
fi
