if status is-interactive
  set -g fish_greeting
  fish_vi_key_bindings
  zoxide init --cmd cd fish | source
end
