-- https://github.com/lewis6991/impatient.nvim
local impatient_ok, impatient = pcall(require, 'impatient')
if impatient_ok then
  impatient.enable_profile()
end

-- https://neovim.discourse.group/t/introducing-filetype-lua-and-a-call-for-help/1806#how-do-i-use-it-2
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

-- Disable some builtins
vim.g.loaded_gzip = 1
vim.g.loaded_man = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_shada_plugin = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = [[,]]

vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.scrolloff = 7
vim.opt.cursorline = true
vim.opt.mouse = 'nivh'
vim.opt.showmatch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smartindent = true
-- lesser known stuff...
vim.opt.lazyredraw = true

local opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', '<leader>/', ':silent nohls<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>p', ':Neotree toggle<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>ev', ':e ~/.config/nvim/init.lua<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>sv', ':source ~/.config/nvim/init.lua<CR>', opts)

-- TODO
-- noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
-- noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

vim.api.nvim_set_keymap('n', '<c-h>', '<c-w>h', opts)
vim.api.nvim_set_keymap('n', '<c-j>', '<c-w>j', opts)
vim.api.nvim_set_keymap('n', '<c-k>', '<c-w>k', opts)
vim.api.nvim_set_keymap('n', '<c-l>', '<c-w>l', opts)

vim.api.nvim_command([[colorscheme solarized]])
vim.opt.background = 'light'

require('plugins')
require('plugins/cmp')
require('plugins/lsp')
require('plugins/lsp-installer')
require('plugins/neo-tree')
require('plugins/treesitter')
