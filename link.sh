#!/bin/sh -ex

test -e ~/.config/alacritty || ln -sf $(pwd)/alacritty ~/.config/alacritty
test -e ~/.config/fish || ln -sf $(pwd)/fish ~/.config/fish
test -e ~/.config/nvim || ln -sf $(pwd)/nvim ~/.config/nvim
test -e ~/.config/sway || ln -sf $(pwd)/sway ~/.config/sway
test -e ~/.config/waybar || ln -sf $(pwd)/waybar ~/.config/waybar
