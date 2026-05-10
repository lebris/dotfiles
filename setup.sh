#!/bin/bash

dotfilesDirectory="$(pwd)"

RESTORE='\e[0m'
green='\e[00;32m'
gray='\e[00;90m'
yellow='\e[00;33m'

do_dotfiles=false
do_config=false
do_gsettings=false
dry_run=false

usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "By default everthing is installed."
    echo ""
    echo "Options:"
    echo "  --all        Install all sections."
    echo "  --dotfiles   Install dotfiles symlinks (~/.*)."
    echo "  --config     Install config symlinks (~/.config/*)."
    echo "  --gsettings  Apply gsettings."
    echo "  --dry-run    Simulate without applying any changes."
    echo "  -h, --help   Show this help message."
}

for arg in "$@"; do
    case "$arg" in
        --dotfiles)  do_dotfiles=true ;;
        --config)    do_config=true ;;
        --gsettings) do_gsettings=true ;;
        --all)       do_dotfiles=true; do_config=true; do_gsettings=true ;;
        --dry-run)   dry_run=true ;;
        --help|-h)   usage; exit 0 ;;
        *) echo "Unknown option: $arg"; echo ""; usage; exit 1 ;;
    esac
done

if ! $do_dotfiles && ! $do_config && ! $do_gsettings; then
    do_dotfiles=true
    do_config=true
    do_gsettings=true
fi

if $dry_run; then
    echo -e "${yellow}⚠️ Dry run mode - no changes will be applied ⚠️${RESTORE}"
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
            $dry_run || ln -sf "${SOURCE}" "${ABSOLUTE_DESTINATION}"
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
            $dry_run || ln -s "${SOURCE}" "${ABSOLUTE_DESTINATION}"
        else
            echo -e "${gray}~ ${DESTINATION} : up to date${RESTORE}"
        fi
    done
fi

if $do_gsettings; then
    echo -e "\n── Gsettings ──"
    $dry_run || ./gsettings.sh
fi

echo -e "\nNow you have to run 'source ~/.bashrc'"
