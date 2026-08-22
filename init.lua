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
-- opt.winborder = "rounded"

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

-- https://github.com/vuejs/language-tools/wiki/Neovim#configuration
local vue_language_server_path = vim.fn.stdpath('data') .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = vue_language_server_path,
  languages = { 'vue' },
  configNamespace = 'typescript',
}
local tsserver_filetypes = {
  'typescript',
  'javascript',
  'javascriptreact',
  'typescriptreact',
  'vue',
}

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
        filters = {
          custom = {
            "\\.gd\\.uid$",
          },
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
          "c",
          "cpp",
          "css",
          "html",
          "lua",
          "pug",
          "typescript",
          "vue",
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = {
            "ruby",
          },
        },
        indent = {
          enable = true,
          disable = {
            "ruby",
          },
        },
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
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          snippets = {
            min_keyword_length = 2,
            score_offset = 4,
          },
          lsp = {
            min_keyword_length = 3,
            score_offset = 3,
          },
          path = {
            min_keyword_length = 3,
            score_offset = 2,
          },
          buffer = {
            min_keyword_length = 5,
            score_offset = 1,
          },
        },
      },
    },
    {
      "neovim/nvim-lspconfig",
      dependencies = {
        "saghen/blink.cmp",
        "ibhagwan/fzf-lua",
      },
      automatic_installation = true,
      opts = {
        ensure_installed = {
          "clangd",
          "gopls",
          -- "ts_ls",
          "vtsls",
          "vue_ls",
          "zls",
        },
        servers = {
          clangd = {},
          gopls = {
            settings = {
              gopls = {
                analyses = {
                  unusedparams = true,
                },
                staticcheck = true,
                gofumpt = true,
              },
            },
          },
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
          ruby_lsp = {
            init_options = {
              formatter = 'standard',
              linters = { 'standard' },
            },
          },
          vtsls = {
            filetypes = tsserver_filetypes,
            settings = {
              vtsls = {
                tsserver = {
                  globalPlugins = {
                    vue_plugin,
                  },
                },
              },
            },
          },
          -- ts_ls = {
          --   filetypes = tsserver_filetypes,
          --   init_options = {
          --     plugins = {
          --       vue_plugin,
          --     },
          --   },
          -- },
          vue_ls = {
            on_init = function(client)
              client.handlers['tsserver/request'] = function(_, result, context)
                local ts_clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'ts_ls' })
                local vtsls_clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'vtsls' })
                local clients = {}

                vim.list_extend(clients, ts_clients)
                vim.list_extend(clients, vtsls_clients)

                if #clients == 0 then
                  vim.notify('Could not find `vtsls` or `ts_ls` lsp client, `vue_ls` would not work without it.', vim.log.levels.ERROR)
                  return
                end
                local ts_client = clients[1]

                local param = unpack(result)
                local id, command, payload = unpack(param)
                ts_client:exec_cmd({
                  title = 'vue_request_forward', -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
                  command = 'typescript.tsserverRequest',
                  arguments = {
                    command,
                    payload,
                  },
                }, { bufnr = context.bufnr }, function(_, r)
                  local response = r and r.body
                  -- TODO: handle error or response nil here, e.g. logging
                  -- NOTE: Do NOT return if there's an error or no response, just return nil back to the vue_ls to prevent memory leak
                  local response_data = { { id, response } }

                  ---@diagnostic disable-next-line: param-type-mismatch
                  client:notify('tsserver/response', response_data)
                end)
              end
            end,
          },
          zls = {
            cmd = { "/home/tjk/zls/0.14.0/zls" },
            settings = {
              semantic_tokens = "partial",
              -- zig_exe_path = "/usr/bin/zig",
            },
          },
          gdscript = {
            name = "godot",
            cmd = vim.lsp.rpc.connect("127.0.0.1", 6005),
          },
        },
      },
      config = function(_, opts)
        local fzf_lua = require("fzf-lua")
        for server, config in pairs(opts.servers) do
          config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
          vim.lsp.config(server, config)
          vim.lsp.enable({server})
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
        local fzf_lua = require("fzf-lua")
        fzf_lua.register_ui_select()
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
    -- {
    --   "pmizio/typescript-tools.nvim",
    --   dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    --   opts = {},
    -- },
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
    -- {
    --   "aserowy/tmux.nvim",
    --   config = function()
    --     require("tmux").setup({
    --       copy_sync = {
    --         enable = false,
    --       },
    --     })
    --   end,
    -- },
    -- {
    --   "ziglang/zig.vim",
    -- },
  },
  install = { colorscheme = { "tokyonight" } },
  -- disable automatically checking for plugin updates
  -- checker = { enabled = true },
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    -- buf_request_sync defaults to a 1000ms timeout. Depending on your
    -- machine and codebase, you may want longer. Add an additional
    -- argument after params if you find that you have to write the file
    -- twice for changes to be saved.
    -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({async = false})
  end
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.c", "*.h" },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})
