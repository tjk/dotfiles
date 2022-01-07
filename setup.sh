#!/bin/sh -ex
stow --restow --target=$HOME git
stow --restow --target=$HOME nvim
stow --restow --target=$HOME tmux
stow --restow --target=$HOME zsh
[ ! -d $HOME/.oh-my-zsh ] && sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# TODO
echo "brew install zsh-syntax-highlighting"
