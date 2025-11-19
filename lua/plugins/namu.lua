return {
  {
    'bassamsdata/namu.nvim',
    opts = {
      global = {},
      namu_symbols = { -- Specific Module options
        options = {},
      },
    },
    -- === Suggested Keymaps: ===
    keys = {
      { '<leader>n', '', desc = 'Namu' },
      { '<leader>ns', '<cmd>Namu symbols<cr>', desc = 'Namu Symbols' },
      { '<leader>nw', '<cmd>Namu workspace<cr>', desc = 'Namu Workspace' },
    },
  },
}
