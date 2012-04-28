#!/bin/bash

files=(".vimrc"
  ".vimerc" ".aliases"
  ".gitignore" ".gitconfig")

for file in ${files[@]}
do
  ln -vs `pwd`/$file $HOME/$file
done
