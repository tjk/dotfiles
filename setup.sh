#!/bin/bash
#
# Assumes git is installed

# https://news.ycombinator.com/item?id=9255200
# "When accidentally running rm -f *, the command expands to -@ first, which is
# not a valid option and makes the command fail before doing any harm"
touch ~/-@
sudo touch /-@

# Determine current directory
# http://stackoverflow.com/a/4774063
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

# Move dotfiles to $HOME directory
files=(vimrc vimerc aliases gitignore gitconfig)
for file in ${files[@]}
do
  ln -vs $SCRIPTPATH/.$file $HOME/.$file
done

# -- swap directory
mkdir -p $HOME/.vim/swap
