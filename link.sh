#!/bin/sh -ex

test -e ~/.config/alacritty || \
  ln -sf $(pwd)/alacritty ~/.config/alacritty
test -e ~/.config/fish || \
  ln -sf $(pwd)/fish ~/.config/fish
test -e ~/.config/nvim || \
  ln -sf $(pwd)/lazynvim ~/.config/nvim
test -e ~/.config/rofi || \
  ln -sf $(pwd)/rofi ~/.config/rofi
test -e ~/.config/sway || \
  ln -sf $(pwd)/sway ~/.config/sway
test -e ~/.config/tmux || \
  ln -sf $(pwd)/tmux ~/.config/tmux
test -e ~/.config/waybar || \
  ln -sf $(pwd)/waybar ~/.config/waybar

ln -sf $(pwd)/git/config ~/.gitconfig

XDG_DATA_DIR=/usr/local/share
test -e $XDG_DATA_DIR/dark-mode.d || \
  sudo ln -sf $(pwd)/darkman/dark-mode.d $XDG_DATA_DIR/dark-mode.d
test -e $XDG_DATA_DIR/light-mode.d || \
  sudo ln -sf $(pwd)/darkman/light-mode.d $XDG_DATA_DIR/light-mode.d
test -e ~/.config/darkman/config.yaml || \
  (mkdir -p ~/.config/darkman && \
  ln -sf $(pwd)/darkman/config.yaml ~/.config/darkman/config.yaml)
