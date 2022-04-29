local telescope = require('telescope')

telescope.load_extension(vim.fn.has 'win32' == 1 and 'fzy_native' or 'fzf')

vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<cr>', {})
