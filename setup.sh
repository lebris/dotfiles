#!/bin/bash

dotfilesDirectory="$(pwd)"

RESTORE='\e[0m'
green='\e[00;32m'
gray='\e[00;90m'

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
    echo -e "\n── Dotfiles ──"
    files=$(ls -1 "$dotfilesDirectory/dotfiles")
    for file in $files; do
        SOURCE="$dotfilesDirectory/dotfiles/$file"
        DESTINATION="~/.$file"
        ABSOLUTE_DESTINATION="$HOME/.$file"
        if [ ! -L "${ABSOLUTE_DESTINATION}" ]; then
            echo -e "${green}✓ ${DESTINATION} : installed${RESTORE}"
            ln -sf "${SOURCE}" "${ABSOLUTE_DESTINATION}"
        else
            echo -e "${gray}~ ${DESTINATION} : up to date${RESTORE}"
        fi
    done
fi

if $do_config && [ -d "$dotfilesDirectory/config" ]; then
    echo -e "\n── Config ──"
    files=$(ls -1 "$dotfilesDirectory/config")
    for file in $files; do
        SOURCE="$dotfilesDirectory/config/$file"
        DESTINATION="~/.config/$file"
        ABSOLUTE_DESTINATION="$HOME/.config/$file"
        if [ ! -L "${ABSOLUTE_DESTINATION}" ]; then
            echo -e "${green}✓ ${DESTINATION} : installed${RESTORE}"
            ln -s "${SOURCE}" "${ABSOLUTE_DESTINATION}"
        else
            echo -e "${gray}~ ${DESTINATION} : up to date${RESTORE}"
        fi
    done
fi

if $do_gsettings; then
    echo -e "\n── Gsettings ──"
    ./gsettings.sh
fi

echo -e "\nNow you have to run 'source ~/.bashrc'"
