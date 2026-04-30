return {
  {
    'antosha417/nvim-lsp-file-operations',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-tree.lua', -- Required when using nvim-tree. Not required for oil only
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

      -- Integrate capabilities for lsp-file-operations
      capabilities = require('lsp-file-operations').default_capabilities(capabilities)

      -- TypeScript configuration example (vtsls or tsserver)
      lspconfig.vtsls.setup {
        capabilities = capabilities,
      }

      -- Similarly pass capabilities to other LSPs
      -- lspconfig.eslint.setup({ capabilities = capabilities })
    end,
  },
}
