#!/bin/sh -ex

ls ~/.config/fish >/dev/null 2>/dev/null || ln -sf $(pwd)/fish ~/.config/fish
ls ~/.config/nvim >/dev/null 2>/dev/null || ln -sf $(pwd)/nvim ~/.config/nvim
ls ~/.config/sway >/dev/null 2>/dev/null || ln -sf $(pwd)/sway ~/.config/sway
