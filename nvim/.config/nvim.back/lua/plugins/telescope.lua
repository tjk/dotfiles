local telescope = require('telescope')

telescope.load_extension(vim.fn.has 'win32' == 1 and 'fzy_native' or 'fzf')

vim.api.nvim_set_keymap('n', '<Leader>ff', '<Cmd>Telescope find_files<CR>', {})
vim.api.nvim_set_keymap('n', '<C-p>', '<Cmd>Telescope find_files<CR>', {})
vim.api.nvim_set_keymap('n', '<Leader>fg', '<Cmd>Telescope live_grep<CR>', {})
