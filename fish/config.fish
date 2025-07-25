if status is-interactive
  set -g fish_greeting
  fish_vi_key_bindings
  zoxide init --cmd cd fish | source
  source ~/.asdf/asdf.fish
  fish_add_path ~/.asdf/installs/python/3.10.5/bin # add this for pip
  fish_add_path $(go env GOPATH)/bin
  fish_add_path ~/bin
  eval (keychain --eval --agents ssh -Q --quiet id_ed25519 --nogui)
  # source ~/.config/fish/conf.d/secrets.fish
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

set --export GOPATH "$HOME"
set --export PATH $(go env GOPATH)/bin $PATH

set --export PATH /home/tjk/src/github.com/emscripten-core/emsdk/upstream/emscripten $PATH
set --export PATH "$HOME/zig/zig-linux-x86_64-0.14.0/" $PATH
set --export EMSDK_QUIET 1
