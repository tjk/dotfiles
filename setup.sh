#!/bin/bash
#
# Assumes git is installed

# Determine current directory
# http://stackoverflow.com/a/4774063
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

# Move dotfiles to $HOME directory
files=(vimrc aliases gitignore gitconfig)
for file in ${files[@]}
do
  rm $HOME/.$file
  ln -vs $SCRIPTPATH/.$file $HOME/.$file
done

# -- swap directory
mkdir -p $HOME/.vim/swap
