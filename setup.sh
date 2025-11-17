#!/bin/bash

dotfilesDirectory=~/.dotfiles

RESTORE='\e[0m'
yellow='\e[00;33m'

files=`ls -1 $dotfilesDirectory/dotfiles`
for file in $files; do
    SOURCE=$dotfilesDirectory/dotfiles/$file
    DESTINATION=~/.$file
    if [ ! -L ${DESTINATION} ]; then
        echo -e $yellow"Creating symlink for $file"$RESTORE
        ln -sf ${SOURCE} ${DESTINATION}
    else
        echo -e $yellow"Creating symlink for $file : already existing, skipping."$RESTORE
    fi
done

#echo
#if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
#    echo "Installing vim's plugin manager Vundle"
#    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
#fi

if [ -d $dotfilesDirectory/config ]; then
    files=`ls -1 $dotfilesDirectory/config`

    for file in $files; do
        SOURCE=$dotfilesDirectory/config/$file
        DESTINATION=~/.config/$file
        if [ ! -L ${DESTINATION} ]; then
            echo -e $yellow"Creating symlink for ~/.config/$file"$RESTORE
            ln -s ${SOURCE} ${DESTINATION}
        else
            echo -e $yellow"Creating symlink for $file : already existing, skipping."$RESTORE
        fi
    done
fi

./gsettings.sh

echo -e "\nNow you have to run 'source ~/.bashrc'"
