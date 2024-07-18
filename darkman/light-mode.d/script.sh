#!/bin/sh

gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'

# This uses the neovim-remote python package to control other neovim instances.
# see: https://github.com/mhinz/neovim-remote
# Further, it is assumed that toggling the background in neovim is enough.
# Anything else should be handled by the set color scheme.
for server in $(nvr --serverlist); do
  nvr --servername "$server" -cc 'set background=light'
done

notify-send --app-name="darkman" --urgency=low --icon=weather-clear-night "switching to light mode"
