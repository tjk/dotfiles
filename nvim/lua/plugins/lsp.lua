return {
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    opts = {},
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",
      "yioneko/nvim-vtsls",
      "nvim-lua/plenary.nvim",
      -- "WhoIsSethDaniel/mason-tool-installer.nvim",
      -- { "j-hui/fidget.nvim", opts = {} }, -- status updates
      -- { "folke/neodev.nvim", opts = {} }, -- lua lsp for nvim configs
      -- { "ziglang/zig.vim" },
    },
    opts = {},
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "vtsls",
          "vue_ls",
          -- "eslint",
          -- "tailwindcss",
          -- "emmet_language_server",
          "lua_ls",
          -- "hyprls",
        },
        automatic_enable = true,
        automatic_installation = false,
      })

      vim.lsp.config("vtsls", {
        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
        settings = {
          vtsls = { tsserver = { globalPlugins = {} } },
          typescript = {
            inlayHints = {
              parameterNames = { enabled = "literals" },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              enumMemberValues = { enabled = true },
            },
          },
        },
        before_init = function(_, config)
          table.insert(config.settings.vtsls.tsserver.globalPlugins, {
            name = "@vue/typescript-plugin",
            location = vim.fn.expand(
              "$MASON/packages/vue-language-server/node_modules/@vue/language-server"
            ),
            languages = { "vue" },

            configNamespace = "typescript",
            enableForWorkspaceTypeScriptVersions = true,
          })
        end,
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false

        end,
      })

      vim.lsp.config("lua_ls", {
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
        settings = {
          Lua = {
            workspace = {
              checkThirdParty = false,
            },
            completion = {
              callSnippet = "Replace",
            },
            telemetry = {
              enable = false,
            },
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })

      vim.lsp.config("gopls", {
      })

      -- TODO: gopls, clangd, ruby_lsp, rust_analyzer, yamlls, zls

      vim.api.nvim_create_autocmd("LSPAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          -- Enable completion triggered by <c-x><c-o>
          -- vim.bo[event.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          local map = function(keys, func)
            vim.keymap.set("n", keys, func, { buffer = event.buf })
          end

          local builtin = require("telescope.builtin")
          map("gd", builtin.lsp_definitions)
          map("gr", builtin.lsp_references)
          map("gt", builtin.lsp_type_definitions)
          -- map("gi", builtin.lsp_implementations)
          map("<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
        end
      })
    end,
  },
}
