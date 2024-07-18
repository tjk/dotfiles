#!/bin/sh
# while darkman doesn't work, poor man's version

scheme=$(gsettings get org.gnome.desktop.interface color-scheme)
if [ "$scheme" = "'prefer-light'" ]; then
  mode="dark"
else
  mode="light"
fi

gsettings set org.gnome.desktop.interface color-scheme "prefer-$mode"

# This uses the neovim-remote python package to control other neovim instances.
# see: https://github.com/mhinz/neovim-remote
# Further, it is assumed that toggling the background in neovim is enough.
# Anything else should be handled by the set color scheme.
for server in $(nvr --serverlist); do
  nvr --servername "$server" -cc "set background=$mode"
done

echo "import = [\"~/.config/alacritty/themes/themes/gruvbox_$mode.toml\"]" > ~/.gruvbox_current.toml
touch ~/.config/alacritty/alacritty.toml

# notify-send --app-name="darkman" --urgency=low --icon=weather-clear-night "switching to $mode mode"
