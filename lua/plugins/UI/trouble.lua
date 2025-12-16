return {
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      { '<leader>x', '', desc = 'Diagnostics (Trouble)' },
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
      { '<leader>xs', '<cmd>Trouble symbols toggle focus=false<cr>', desc = 'Symbols (Trouble)' },
      { '<leaderxl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', desc = 'LSP (Trouble)' },
      -- { '<leader>xL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
      -- { '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },
      -- { '[q', desc = 'Previous Trouble/Quickfix Item' },
      -- { ']q', desc = 'Next Trouble/Quickfix Item' },
      { '[d', desc = 'Previous Diagnostic' },
      { ']d', desc = 'Next Diagnostic' },
    },
    cmd = 'Trouble',
    opts = {},
    config = function()
      require('trouble').setup {}
    end,
  },
}
