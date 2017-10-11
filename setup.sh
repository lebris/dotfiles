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

echo
if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
    echo "Installing vim's plugin manager Vundle"
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

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

echo -e $yellow"Installing vim plugins"$RESTORE
vim +PluginInstall +qall

if [ -d $dotfilesDirectory/atom ]; then
    echo -e $yellow"Installing atom snippets"$RESTORE
    cp $dotfilesDirectory/atom/snippets.cson ~/.atom/snippets.cson # symlink with cygwin not supported :(
fi


echo -e $yellow"Installing bin utils"$RESTORE
if [ ! -d "~/.bin" ]; then
    mkdir -p ~/.bin
fi
for file in $(ls -1 $dotfilesDirectory/bin); do
    SOURCE=$dotfilesDirectory/bin/$file
    DESTINATION=~/.bin/$file
    if [ ! -L ${DESTINATION} ]; then
        echo -e $yellow"Creating symlink for $DESTINATION"$RESTORE
        ln -s ${SOURCE} ${DESTINATION}
    else
        echo -e $yellow"Creating symlink for $DESTINATION : already existing, skipping."$RESTORE
    fi
done

echo -e $yellow"Building docker images"$RESTORE
for DIR in $(ls --directory images/*); do
    cd ${DIR}
    make build
    cd -
done

echo -e "\nNow you have to run 'source ~/.bashrc'"
