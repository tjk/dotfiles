#!/bin/sh -ex

# Resources:
# - https://fedoramagazine.org/setting-up-the-sway-window-manager-on-fedora/
#
# - install automatic updates
# - touchpad -> scrolling -> traditional
# - accessibility -> seeing -> enable large text

pkgs=()
pkgs+=("alacritty")
pkgs+=("fish")
pkgs+=("btop" "eza" "fzf" "neovim" "zoxide")
pkgs+=("sway" "waybar" "yambar" "rofi" "network-manager-applet" "mako")
# for controlling via sway XF86 keys
pkgs+=("brightnessctl" "pulseaudio-utils")
# XXX: cannot get this working... maybe need perms? (TODO: maybe try gammastep ?)
pkgs+=("redshift")

# XXX maybe remove this if we like firefox enough
sudo dnf config-manager --set-enabled google-chrome
pkgs+=("google-chrome-stable")

# coding / tools
# XXX: check whether golang-x-tools-gopls is included in go
pkgs+=("go" "golang-x-tools-gopls")
pkgs+=("protobuf-compiler" "golang-google-protobuf")
# https://bugzilla.redhat.com/show_bug.cgi?id=1783723#c6
# for wasm_exec.js
pkgs+=("golang-misc")

sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
test -e /etc/yum.repos.d/1password.repo || sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
pkgs+=("1password")

# NOTE: slack, discord use browser for now

sudo dnf -y install ${pkgs[*]}

# fonts
mkdir -p ~/.local/share/fonts
ls ~/.local/share/fonts/FiraCodeNerdFont-Regular.ttf >/dev/null 2>/dev/null || (cd ~/.local/share/fonts && curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Regular/FiraCodeNerdFont-Regular.ttf)

# asdf
test -e ~/.asdf || git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
# mkdir -p ~/.config/fish/completions
# ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions
