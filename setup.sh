#!/bin/bash

dotfilesDirectory=~/.dotfiles

RESTORE='\e[0m'
yellow='\e[00;33m'

files=`ls -1 $dotfilesDirectory/dotfiles`
for file in $files; do
    echo -e $yellow"Creating symlink for $file"$RESTORE
    ln -sf $dotfilesDirectory/dotfiles/$file ~/.$file
done

echo
if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
    echo "Installing vim's plugin manager Vundle"
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

echo -e $yellow"Installing vim plugins"$RESTORE
vim +PluginInstall +qall

if [ -d $dotfilesDirectory/atom ]; then
    echo -e $yellow"Installing atom snippets"$RESTORE
    cp $dotfilesDirectory/atom/snippets.cson ~/.atom/snippets.cson # symlink with cygwin not supported :(
fi

echo -e "\nNow you have to run 'source ~/.bashrc'"
