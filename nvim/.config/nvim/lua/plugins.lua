-- https://github.com/wbthomason/packer.nvim#bootstrapping
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  Packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

local packer = require('packer')

packer.startup(function(use)
  use { 'wbthomason/packer.nvim' }
  use { 'lewis6991/impatient.nvim' }
  use { 
    'williamboman/nvim-lsp-installer',
    after = 'nvim-lspconfig',
    event = 'BufWinEnter',
    config = function()
      require('plugins/lsp-installer')
    end,
  }
  use { 
    'neovim/nvim-lspconfig',
    config = function()
      require('plugins/lsp')
    end,
  }
  use {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v2.x',
    requires = {
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    config = function()
      require('plugins/neo-tree')
    end,
  }
  use { 
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      require('lualine').setup({})
    end,
  }
  use { 
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    config = function() 
      require('plugins.cmp')
    end,
  }
  use { 
    'hrsh7th/cmp-nvim-lsp',
    after = "nvim-cmp",
  }
  use {
    'hrsh7th/cmp-buffer',
    after = 'nvim-cmp',
  }
  use {
    'hrsh7th/cmp-path',
    after = 'nvim-cmp',
  }
  use { 'hrsh7th/cmp-cmdline' }
  use { 'L3MON4D3/LuaSnip' }
  use {
    'saadparwaiz1/cmp_luasnip',
    after = 'nvim-cmp',
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('plugins/treesitter')
    end,
  }
  use { 
    'p00f/nvim-ts-rainbow',
    after = 'nvim-treesitter',
  }
  use { 
    'windwp/nvim-ts-autotag',
    after = 'nvim-treesitter',
  }
  use { 
    'JoosepAlviste/nvim-ts-context-commentstring',
    after = 'nvim-treesitter',
  }
  use { 'altercation/vim-colors-solarized' }
  use { 'simrat39/symbols-outline.nvim' }
  use { 
    'jose-elias-alvarez/null-ls.nvim',
    event = { 'BufRead', 'BufNewFile' },
  }
  use { 'b0o/schemastore.nvim' }
  use { 
    'lewis6991/gitsigns.nvim',
    event = { "BufRead", "BufNewFile" },
    config = function()
      require('gitsigns').setup({})
    end,
  }
  use { 
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim' }
  }
  use {
    ('nvim-telescope/telescope-%s-native.nvim'):format(vim.fn.has 'win32' == 1 and 'fzy' or 'fzf'),
    after = 'telescope.nvim',
    run = 'make',
    config = function()
      require('plugins.telescope')
    end,
  }
  -- TODO 'akinsho/nvim-toggleterm.lua'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if Packer_bootstrap then
    packer.sync()
  end
end)
