return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "williamboman/mason.nvim", config = true },
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    { "j-hui/fidget.nvim", opts = {} }, -- status updates
    { "folke/neodev.nvim", opts = {} }, -- lua lsp for nvim configs
  },
  config = function()
    vim.api.nvim_create_autocmd("LSPAttach", {
      group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
      callback = function(event)
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

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

    local lspconfig = require("lspconfig")

    -- https://github.com/williamboman/mason-lspconfig.nvim/issues/371#issuecomment-2188015156
    local mason_packages = vim.fn.stdpath("data") .. "/mason/packages"
    local volar_path = mason_packages .. "/vue-language-server/node_modules/@vue/language-server"

    local servers = {
      gopls = {
        on_attach = function()
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
        end,
        settings = {
          gopls = {
            buildFlags = {"-tags=dev"},
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
            gofumpt = true,
          },
        },
      },
      -- nil_ls = {},
      lua_ls = {
        -- https://lsp-zero.netlify.app/v3.x/blog/you-might-not-need-lsp-zero.html
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            diagnostics = {
              globals = {
                "vim",
              },
            },
            workspace = {
              library = {
                vim.env.VIMRUNTIME,
              },
            },
          },
        },
      },
      ts_ls = {
        init_options = {
          plugins = {
            {
              name = "@vue/typescript-plugin",
              location = volar_path,
              languages = {"javascript", "typescript", "vue"},
            }
          },
        },
        filetypes = {
          "javascript",
          "typescript",
          "vue",
        },
      },
      volar = {
        init_options = {
          vue = {
            hybridMode = false,
          },
        },
      },
      zls = {},
    }

    require("mason").setup()

    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      "stylua", -- Used to format Lua code
    })
    require("mason-tool-installer").setup({
      ensure_installed = ensure_installed,
    })

    require("mason-lspconfig").setup({
      handlers = {
        function(server_name)
          -- https://github.com/neovim/nvim-lspconfig/pull/3232
          if server_name == "tsserver" then
            server_name = "ts_ls"
          end

          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
          lspconfig[server_name].setup(server)
        end,
      },
    })
  end,
}
