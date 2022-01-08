#!/bin/sh -ex
stow --restow --target=$HOME git
stow --restow --target=$HOME nvim
stow --restow --target=$HOME tmux
stow --restow --target=$HOME zsh
[ ! -d $HOME/.oh-my-zsh ] && CHSH=no RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
command -v zsh | sudo tee -a /etc/shells
sudo chsh -s "$(command -v zsh)" "${USER}"
# TODO
echo "brew install zsh-syntax-highlighting"
