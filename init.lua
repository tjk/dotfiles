local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.mouse = "nvi"
vim.opt.cursorline = true
vim.opt.swapfile = false
vim.opt.signcolumn = "yes" -- Reserve a space in the gutter
vim.opt.background = "dark"
vim.opt.termguicolors = true
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.scrolloff = 10

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

local map = vim.keymap.set
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("n", "j", "gj")
map("n", "k", "gk")
map("n", "gj", "j")
map("n", "gk", "k")
map("n", "<leader>ev", "<cmd>edit ~/.config/nvim/init.lua<CR>")
map("n", "<leader>sv", "<cmd>source ~/.config/nvim/init.lua<CR>")
map("n", "<C-h>", "<C-w>h", { noremap = true })
map("n", "<C-j>", "<C-w>j", { noremap = true })
map("n", "<C-k>", "<C-w>k", { noremap = true })
map("n", "<C-l>", "<C-w>l", { noremap = true })
map("n", "<leader>e", "<cmd>NvimTreeFocus<cr>")

require("lazy").setup({
  spec = {
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      opts = {
        -- TODO not working...
        -- style = "night",
      },
      config = function()
        vim.cmd[[colorscheme tokyonight]]
      end,
    },
    {
      "nvim-tree/nvim-tree.lua",
      version = "*",
      lazy = false,
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        require("nvim-tree").setup {}
        -- require("nvim-tree.api").tree.focus()
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter",
      branch = "master",
      lazy = false,
      build = ":TSUpdate",
      opts = {
        ensure_installed = {
          "lua",
          "typescript",
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = {
            "ruby",
          },
        },
        -- XXX check if this should be included
        -- indent = {
        --   enable = true,
        --   disable = {
        --     "ruby",
        --   },
        -- },
      },
      config = function(_, opts)
         require("nvim-treesitter.configs").setup(opts)
      end,
    },
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = true
    },
    {
      "lukas-reineke/indent-blankline.nvim",
      main = "ibl",
      ---@module "ibl"
      ---@type ibl.config
      opts = {},
    },
    {
      "saghen/blink.cmp",
      version = "1.*",
      opts = {
        completion = { documentation = { auto_show = true } },
      },
    },
    {
      "neovim/nvim-lspconfig",
      dependencies = {
        "saghen/blink.cmp",
      },
      opts = {
        servers = {
          lua_ls = {
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" },
                },
                workspace = {
                  -- Make the server aware of Neovim runtime files
                  library = vim.api.nvim_get_runtime_file("", true),
                },
              },
            },
          },
        },
      },
      config = function(_, opts)
        local lspconfig = require("lspconfig")
        for server, config in pairs(opts.servers) do
          config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
          lspconfig[server].setup(config)
        end
      end,
    },
    {
      "mason-org/mason-lspconfig.nvim",
      opts = {
        -- TODO current issue: https://github.com/mason-org/mason-lspconfig.nvim/issues/576#issuecomment-2977209530
        automatic_enable = false
      },
      dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
      },
    },
    {
      -- incredible. so much better than telescope!!
      "ibhagwan/fzf-lua",
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      -- TODO or if using mini.icons/mini.nvim
      -- dependencies = { "echasnovski/mini.icons" },
      opts = {},
      config = function()
        map("n", "<leader>f", "<cmd>FzfLua files<cr>")
        map("n", "<leader>/", "<cmd>FzfLua live_grep<cr>")
        map("n", "<leader>gs", "<cmd>FzfLua git_status<cr>")
        map("n", "<leader>q", "<cmd>FzfLua diagnostics_document<cr>")
        map("n", "<leader>Q", "<cmd>FzfLua diagnostics_workspace<cr>")
      end,
    },
    {
      -- show lsp loading status, etc.
      "j-hui/fidget.nvim",
      opts = {},
    },
    {
      "pmizio/typescript-tools.nvim",
      dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
      opts = {},
    },
  },
  install = { colorscheme = { "tokyonight" } },
  -- disable automatically checking for plugin updates
  -- checker = { enabled = true },
})
