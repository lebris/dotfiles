#!/bin/bash

echo 'Show seconds in clock'
gsettings set org.gnome.desktop.interface clock-show-seconds true

echo 'Make <alt>-<tab> to consider not only the current workspace windows but all'
gsettings set org.gnome.shell.window-switcher current-workspace-only false

# ----------------------------------------------------
# Media player keybindings
# ----------------------------------------------------

echo 'Configure Volume down : <Super> + <Shift> + <->'
gsettings set org.gnome.settings-daemon.plugins.media-keys volume-down '<Shift><Super>KP_Subtract'

echo 'Configure Volume down : <Super> + <Shift> + <+>'
gsettings set org.gnome.settings-daemon.plugins.media-keys volume-up '<Shift><Super>KP_Add'

echo 'Configure Play/pause : <Super> + <Shift> + <Pause>'
gsettings set org.gnome.settings-daemon.plugins.media-keys play '<Shift><Super>Pause'
