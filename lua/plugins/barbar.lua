return {

  'romgrk/barbar.nvim',
  dependencies = {
    'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
    'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
  },

  -- config = function()
  --   require('nvim-web-devicons').setup()
  -- end,
  init = function()
    vim.g.barbar_auto_setup = false

    local wk = require 'which-key'
    wk.add {
      mode = { 'n' },
      -- Move to previous/next
      { 'H', '<cmd>BufferPrevious<cr>' },
      { 'L', '<cmd>BufferNext<cr>' },
      { '<A-h>', '<cmd>BufferMovePrevious<cr>' },
      { '<A-l>', '<cmd>BufferMoveNext<cr>' },
      -- Goto buffer in position..
      { '<A-1>', '<cmd>BufferGoto 1<cr>' },
      { '<A-2>', '<cmd>BufferGoto 2<cr>' },
      { '<A-3>', '<cmd>BufferGoto 3<cr>' },
      { '<A-4>', '<cmd>BufferGoto 4<cr>' },
      { '<A-5>', '<cmd>BufferGoto 5<cr>' },
      { '<A-6>', '<cmd>BufferGoto 6<cr>' },
      { '<A-7>', '<cmd>BufferGoto 7<cr>' },
      { '<A-8>', '<cmd>BufferGoto 8<cr>' },
      { '<A-9>', '<cmd>BufferGoto 9<cr>' },
      -- Pin/unpin buffer
      { '<C-p>', '<cmd>BufferPin<cr>' },
      -- Goto pinned/unpinned buffer
      --                 :BufferGotoPinned
      --                 :BufferGotoUnpinned
      -- Close buffer
      { '<C-w>', '<Cmd>BufferClose<cr>' },
      { '<C-x>', '<Cmd>BufferRestore<cr>' },
      { '<C-p>', '<Cmd>silent! BufferPickDelete<CR>', silent = true },
    }
  end,
  opts = {
    animation = true,
    -- Automatically hide the tabline when there are this many buffers left.
    -- Set to any value >=0 to enable.
    auto_hide = false,
    -- Enable/disable current/total tabpages indicator (top right corner)
    tabpages = true,
    -- noremap = true,
    -- silent = true,
    lazy = true,
  },
  version = '^1.0.0', -- optional: only update when a new 1.x version is released
}
