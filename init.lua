local opt = vim.opt
local map = vim.keymap.set

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
opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

opt.clipboard = "unnamedplus"
opt.number = true
opt.relativenumber = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.hlsearch = false
opt.incsearch = true
opt.smartcase = true
opt.autoindent = true
opt.ignorecase = true
opt.mouse = "nvi"
opt.cursorline = true
opt.wrap = false
opt.swapfile = false
opt.signcolumn = "yes" -- Reserve a space in the gutter
opt.background = "dark"
opt.termguicolors = true
opt.splitbelow = true
opt.splitright = true
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.scrolloff = 10
opt.hlsearch = true

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

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
map("n", "<leader>nh", ":nohl<CR>")

vim.diagnostic.config({ virtual_text = true })
map("n", "<leader>dK", vim.diagnostic.open_float)

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
      opts = {
        actions = {
          open_file = {
            -- quit_on_open = true,
            window_picker = {
              enable = false
            },
          },
        },
        update_focused_file = {
          enable = true,
        },
      },
      config = function(_, opts)
        require("nvim-tree").setup(opts)
        local api = require("nvim-tree.api")
        map("n", "<C-s>", api.node.open.horizontal) -- make this like fzf
        map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>")
        -- XXX unbind <C-x> ? + check vertical split
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
      opts = {
        scope = {
          show_start = false,
          show_end = false,
        },
      },
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
        "ibhagwan/fzf-lua",
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
        local fzf_lua = require("fzf-lua")
        for server, config in pairs(opts.servers) do
          config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
          lspconfig[server].setup(config)
        end
        vim.api.nvim_create_autocmd('LspAttach', {
          callback = function(ev)
            -- local client = vim.lsp.get_client_by_id(ev.data.client_id)
            local bufopts = { noremap = true, silent = true, buffer = ev.buf }
            map("n", "gD", vim.lsp.buf.declaration, bufopts)
            map("n", "gd", fzf_lua.lsp_definitions, bufopts) -- vim.lsp.buf.definition
            map("n", "gr", fzf_lua.lsp_references, bufopts) -- vim.lsp.buf.references
            map("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
            map("n", "<leader>ca", fzf_lua.lsp_code_actions, bufopts) -- vim.lsp.buf.code_action
          end
        })
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
        map("n", "<leader>f", "<cmd>FzfLua files<CR>")
        map("n", "<leader>/", "<cmd>FzfLua live_grep<CR>")
        map("n", "<leader>gs", "<cmd>FzfLua git_status<CR>")
        map("n", "<leader>q", "<cmd>FzfLua diagnostics_document<CR>")
        map("n", "<leader>Q", "<cmd>FzfLua diagnostics_workspace<CR>")
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
    -- TODO uninstall? or use once integrated with diagnostics
    -- https://github.com/wfxr/minimap.vim?tab=readme-ov-file#integrated-with-diagnostics-or-git-status-plugins
    -- {
    --   "wfxr/minimap.vim",
    --   build = "cargo install --locked code-minimap",
    --   lazy = false,
    --   cmd = { "Minimap", "MinimapClose", "MinimapToggle", "MinimapRefresh", "MinimapUpdateHighlight" },
    --   init = function()
    --     vim.g.minimap_width = 10
    --     vim.g.minimap_auto_start = true
    --     vim.g.minimap_auto_start_win_enter = true
    --   end,
    -- },
    -- TODO maybe remove this too... i just want vscode style diagnostics throughout file border
    -- {
    --   "gorbit99/codewindow.nvim",
    --   opts = {
    --     auto_enable = true,
    --     window_border = "shadow",
    --     show_cursor = false,
    --   },
    --   config = function(_, opts)
    --     local codewindow = require("codewindow")
    --     codewindow.setup(opts)
    --     codewindow.apply_default_keybinds()
    --   end,
    -- },
  },
  install = { colorscheme = { "tokyonight" } },
  -- disable automatically checking for plugin updates
  -- checker = { enabled = true },
})
