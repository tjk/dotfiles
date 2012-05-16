#!/bin/bash

# git clone https://github.com/tjeezy/home.git
# assume git is installed

# move dotfiles
files=(".vimrc" ".vimerc" ".aliases" ".gitignore" ".gitconfig")
for file in ${files[@]}
do
  ln -vs `pwd`/$file $HOME/$file
done

# vim setup
# -- vundle
mkdir -p $HOME/.vim/bundle
git clone https://github.com/gmarik/vundle.git $HOME/.vim/bundle/vundle
vim +BundleInstall +qall
# -- swap directory
mkdir -p $HOME/.vim/swap
