#!/bin/sh -ex

ls ~/.config/alacritty >/dev/null 2>/dev/null || ln -sf $(pwd)/alacritty ~/.config/alacritty
ls ~/.config/fish >/dev/null 2>/dev/null || ln -sf $(pwd)/fish ~/.config/fish
ls ~/.config/nvim >/dev/null 2>/dev/null || ln -sf $(pwd)/nvim ~/.config/nvim
ls ~/.config/sway >/dev/null 2>/dev/null || ln -sf $(pwd)/sway ~/.config/sway
ls ~/.config/yambar >/dev/null 2>/dev/null || ln -sf $(pwd)/yambar ~/.config/yambar
