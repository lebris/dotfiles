#!/bin/bash

dotfilesDirectory="$(pwd)"

RESTORE='\e[0m'
yellow='\e[00;33m'

do_dotfiles=false
do_config=false
do_gsettings=false

if [ $# -eq 0 ]; then
    do_dotfiles=true
    do_config=true
    do_gsettings=true
else
    for arg in "$@"; do
        case "$arg" in
            --dotfiles)  do_dotfiles=true ;;
            --config)    do_config=true ;;
            --gsettings) do_gsettings=true ;;
            *) echo "Unknown option: $arg"; exit 1 ;;
        esac
    done
fi

if $do_dotfiles; then
    files=$(ls -1 "$dotfilesDirectory/dotfiles")
    for file in $files; do
        SOURCE="$dotfilesDirectory/dotfiles/$file"
        DESTINATION=~/."$file"
        if [ ! -L "${DESTINATION}" ]; then
            echo -e "${yellow}Creating symlink for $file${RESTORE}"
            ln -sf "${SOURCE}" "${DESTINATION}"
        else
            echo -e "${yellow}Creating symlink for $file : already existing, skipping.${RESTORE}"
        fi
    done
fi

if $do_config && [ -d "$dotfilesDirectory/config" ]; then
    files=$(ls -1 "$dotfilesDirectory/config")
    for file in $files; do
        SOURCE="$dotfilesDirectory/config/$file"
        DESTINATION=~/.config/"$file"
        if [ ! -L "${DESTINATION}" ]; then
            echo -e "${yellow}Creating symlink for ~/.config/$file${RESTORE}"
            ln -s "${SOURCE}" "${DESTINATION}"
        else
            echo -e "${yellow}Creating symlink for $file : already existing, skipping.${RESTORE}"
        fi
    done
fi

if $do_gsettings; then
    ./gsettings.sh
fi

echo -e "\nNow you have to run 'source ~/.bashrc'"
