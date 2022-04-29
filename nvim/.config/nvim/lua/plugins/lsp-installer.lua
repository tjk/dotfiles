-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
require('nvim-lsp-installer').setup {
  ensure_installed = {
    'gopls',
    'jsonls', -- npm i -g vscode-json-languageserver
    'solargraph',
    'sumneko_lua',
    -- 'tsserver', -- npm i -g typescript-language-server
    'volar', -- npm i -g @volar/vue-language-server
  },
}
