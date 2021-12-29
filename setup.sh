#!/bin/sh -ex
stow --restow --target=$HOME git
stow --restow --target=$HOME nvim
stow --restow --target=$HOME tmux
stow --restow --target=$HOME zsh
