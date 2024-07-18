if status is-interactive
  set -g fish_greeting
  fish_vi_key_bindings
  zoxide init --cmd cd fish | source
  source ~/.asdf/asdf.fish
  # add this for pip
  fish_add_path ~/.asdf/installs/python/3.10.5/bin
end
