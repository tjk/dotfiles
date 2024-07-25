#!/bin/sh
# while darkman doesn't work, poor man's version
# make sure chrome uses GTK bar

# alacritty_theme="tokyo-night-storm"

scheme=$(/usr/bin/gsettings get org.gnome.desktop.interface color-scheme)
if [ "$scheme" = "'prefer-light'" ]; then
  mode="dark"
  alacritty_theme="~/.local/share/nvim/lazy/tokyonight.nvim/extras/alacritty/tokyonight_night.toml"
else
  mode="light"
  alacritty_theme="~/.local/share/nvim/lazy/tokyonight.nvim/extras/alacritty/tokyonight_day.toml"
fi

/usr/bin/gsettings set org.gnome.desktop.interface color-scheme "prefer-$mode"

# PATH import here for waybar toggle
nvr=/home/tjk/.asdf/installs/python/3.10.5/bin/nvr
# This uses the neovim-remote python package to control other neovim instances.
# see: https://github.com/mhinz/neovim-remote
# Further, it is assumed that toggling the background in neovim is enough.
# Anything else should be handled by the set color scheme.
for server in $($nvr --serverlist); do
  $nvr --servername "$server" -cc "set background=$mode"
done

echo "import = ['$alacritty_theme']" > ~/.alacritty_theme.toml
touch ~/.config/alacritty/alacritty.toml

# notify-send --app-name="darkman" --urgency=low --icon=weather-clear-night "switching to $mode mode"
