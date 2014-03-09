#!/bin/bash
#
# Assumes git is installed

# Move dotfiles to $HOME directory
files=(vimrc vimerc aliases gitignore gitconfig)
for file in ${files[@]}
do
  ln -vs `pwd`/_$file $HOME/.$file
done

# Setup VIM by running vundle
# -- vundle
mkdir -p $HOME/.vim/bundle
git clone https://github.com/gmarik/vundle.git $HOME/.vim/bundle/vundle
vim +BundleInstall +qall
# -- swap directory
mkdir -p $HOME/.vim/swap
