#!/bin/bash

# ----------------------------------------------------

RESTORE='\e[0m'
green='\e[00;32m'
gray='\e[00;90m'
red='\e[00;31m'

# ----------------------------------------------------

gsettings_apply() {
    local description="$1"
    local schema="$2"
    local key="$3"
    local value="$4"
    local current
    current=$(gsettings get "$schema" "$key" 2>/dev/null)
    if [ "$current" = "$value" ]; then
        echo -e "${gray}~ $description : up to date${RESTORE}"
    else
        if gsettings set "$schema" "$key" "$value"; then
            echo -e "${green}✓ $description : applied${RESTORE}"
        else
            echo -e "${red}✗ $description : failed (schema=$schema key=$key)${RESTORE}" >&2
        fi
    fi
}

gsettings_custom_keybinding() {
    local description="$1"
    local name="$2"
    local command="$3"
    local binding="$4"
    local path="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${command}/"
    local kb_schema="org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:${path}"
    local list_schema="org.gnome.settings-daemon.plugins.media-keys"

    local current_name current_command current_binding current_list
    current_name=$(gsettings get "$kb_schema" name 2>/dev/null | tr -d "'")
    current_command=$(gsettings get "$kb_schema" command 2>/dev/null | tr -d "'")
    current_binding=$(gsettings get "$kb_schema" binding 2>/dev/null | tr -d "'")
    current_list=$(gsettings get "$list_schema" custom-keybindings 2>/dev/null)

    if [ "$current_name" = "$name" ] && [ "$current_command" = "$command" ] \
        && [ "$current_binding" = "$binding" ] && [[ "$current_list" == *"$path"* ]]; then
        echo -e "${gray}~ $description : up to date${RESTORE}"
        return
    fi

    local failed=false

    gsettings set "$kb_schema" name "$name"     || failed=true
    gsettings set "$kb_schema" command "$command" || failed=true
    gsettings set "$kb_schema" binding "$binding" || failed=true

    if [[ "$current_list" != *"$path"* ]]; then
        if [ "$current_list" = "@as []" ] || [ "$current_list" = "[]" ]; then
            gsettings set "$list_schema" custom-keybindings "['$path']" || failed=true
        else
            gsettings set "$list_schema" custom-keybindings "${current_list%]}, '$path']" || failed=true
        fi
    fi

    if $failed; then
        echo -e "${red}✗ $description : failed (path=$path)${RESTORE}" >&2
    else
        echo -e "${green}✓ $description : applied${RESTORE}"
    fi
}

# ----------------------------------------------------

gsettings_apply 'Show seconds in clock' \
    org.gnome.desktop.interface clock-show-seconds true

gsettings_apply 'Alt-Tab considers all workspaces' \
    org.gnome.shell.window-switcher current-workspace-only false

# ----------------------------------------------------
# Media player keybindings
# ----------------------------------------------------

gsettings_apply 'Volume down : <Super> + <Shift> + <->' \
    org.gnome.settings-daemon.plugins.media-keys volume-down "['<Shift><Super>KP_Subtract']"

gsettings_apply 'Volume up : <Super> + <Shift> + <+>' \
    org.gnome.settings-daemon.plugins.media-keys volume-up "['<Shift><Super>KP_Add']"

gsettings_apply 'Play/pause : <Super> + <Shift> + <Pause>' \
    org.gnome.settings-daemon.plugins.media-keys play "['<Shift><Super>Pause']"

# ----------------------------------------------------
# Custom keybindings
# ----------------------------------------------------

gsettings_custom_keybinding 'Launch Emote (emoji picker) : <Ctrl> + <Alt> + E' \
    'Emote' 'emote' '<Control><Alt>e'
