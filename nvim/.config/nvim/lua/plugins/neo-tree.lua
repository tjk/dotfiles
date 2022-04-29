vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

vim.api.nvim_create_autocmd({ 'VimEnter' }, {
  callback = function()
    vim.api.nvim_command([[Neotree reveal]])
  end,
})

vim.api.nvim_set_keymap('n', '<Leader>p', ':Neotree toggle<CR>', {})
