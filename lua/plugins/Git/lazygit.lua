return {
  'kdheepak/lazygit.nvim',
  cmd = {
    'LazyGit',
    'LazyGitConfig',
    'LazyGitCurrentFile',
    'LazyGitFilter',
    'LazyGitFilterCurrentFile',
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  keys = {
    { '<leader>g', '', desc = 'Git & Glance' },
    {
      '<leader>gg',
      function()
        local util = require 'lspconfig.util'
        local bufpath = vim.api.nvim_buf_get_name(0)
        local root = util.root_pattern '.git'(bufpath)

        if not root or root == '' then
          root = vim.fn.getcwd()
        end

        -- Call LazyGit UI with directory specification
        require('lazygit').lazygit(root)
      end,
      desc = 'LazyGit (Open at Project Root)',
    },
  },
}
