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
pkgs+=("sway" "waybar" "rofi")
# for controlling via sway XF86 keys
pkgs+=("brightnessctl" "pulseaudio-utils")
pkgs+=("google-chrome-stable")

sudo dnf install ${pkgs[*]}
