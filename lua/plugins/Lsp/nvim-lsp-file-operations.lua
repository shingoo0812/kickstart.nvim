return {
  {
    'antosha417/nvim-lsp-file-operations',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-tree.lua', -- nvim-treeを使う場合。oilのみなら必須ではない
    },
    config = function()
      require('lsp-file-operations').setup()
    end,
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'antosha417/nvim-lsp-file-operations' },
    config = function()
      local lspconfig = require 'lspconfig'
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      -- lsp-file-operations 用の capabilities を統合
      capabilities = require('lsp-file-operations').default_capabilities(capabilities)

      -- TypeScript の設定例 (vtsls または tsserver)
      lspconfig.vtsls.setup {
        capabilities = capabilities,
      }

      -- 他の LSP も同様に capabilities を渡して設定
      -- lspconfig.eslint.setup({ capabilities = capabilities })
    end,
  },
}
