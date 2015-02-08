#!/bin/bash

dotfilesDirectory=~/.dotfiles

RESTORE='\033[0m'
yellow='\033[00;33m'

files=`ls -1 $dotfilesDirectory/symlinks`
for file in $files; do
    echo $yellow"Creating symlink for $file"$RESTORE
    ln -sf $dotfilesDirectory/symlinks/$file ~/.$file
done

echo "\nNow you have to run 'source ~/.bashrc'"

