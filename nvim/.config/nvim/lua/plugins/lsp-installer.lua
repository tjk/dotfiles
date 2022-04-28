require('nvim-lsp-installer').setup {
  ensure_installed = { 
    'jsonls',
    'solargraph',
    'sumneko_lua',
    'tsserver', -- npm install -g typescript-language-server
    'volar',
  },
}
