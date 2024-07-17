#!/bin/sh -ex

# Resources:
# - https://fedoramagazine.org/setting-up-the-sway-window-manager-on-fedora/
#
# - install automatic updates
# - touchpad -> scrolling -> traditional
# - accessibility -> seeing -> enable large text

sudo dnf config-manager --set-enabled google-chrome

pkgs=()
pkgs+=("alacritty")
pkgs+=("fish")
pkgs+=("eza" "fzf" "neovim" "zoxide")
pkgs+=("sway" "waybar" "rofi" "network-manager-applet")
# for controlling via sway XF86 keys
pkgs+=("brightnessctl" "pulseaudio-utils")
# XXX: cannot get this working... maybe need perms? (TODO: maybe try gammastep ?)
pkgs+=("redshift")
pkgs+=("google-chrome-stable")
# XXX: check whether golang-x-tools-gopls is included in go
pkgs+=("go" "golang-x-tools-gopls")

sudo dnf -y install ${pkgs[*]}

mkdir -p ~/.local/share/fonts
ls ~/.local/share/fonts/FiraCodeNerdFont-Regular.ttf >/dev/null 2>/dev/null || (cd ~/.local/share/fonts && curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Regular/FiraCodeNerdFont-Regular.ttf)
