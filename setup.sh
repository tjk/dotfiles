#!/bin/bash
#
# Assumes git is installed

# https://news.ycombinator.com/item?id=9255200
# "When accidentally running rm -f *, the command expands to -@ first, which is
# not a valid option and makes the command fail before doing any harm"
touch ~/-@
sudo touch /-@

# Move dotfiles to $HOME directory
files=(vimrc vimerc aliases gitignore gitconfig)
for file in ${files[@]}
do
  ln -vs `dirname $0`/.$file $HOME/.$file
done

# Setup VIM by running vundle
# -- vundle
mkdir -p $HOME/.vim/bundle
git clone https://github.com/gmarik/vundle.git $HOME/.vim/bundle/vundle
vim +BundleInstall +qall
# -- swap directory
mkdir -p $HOME/.vim/swap
