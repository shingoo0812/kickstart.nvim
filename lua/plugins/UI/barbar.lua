return {
  'romgrk/barbar.nvim',
  dependencies = {
    'lewis6991/gitsigns.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  init = function()
    vim.g.barbar_auto_setup = false

    -- LSPリクエストのキャンセルエラーを軽減
    vim.api.nvim_create_autocmd('BufLeave', {
      callback = function()
        -- バッファ切り替え時に少し待機してからLSP処理を行う
        vim.defer_fn(function() end, 10)
      end,
    })

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
      -- Close buffer
      { '<C-w>', '<Cmd>BufferClose<cr>' },
      { '<C-x>', '<Cmd>BufferRestore<cr>' },
      { '<C-p>', '<Cmd>silent! BufferPickDelete<CR>', silent = true },
    }
  end,
  opts = {
    animation = false, -- アニメーションをオフにして切り替えを高速化
    auto_hide = false,
    tabpages = true,
    lazy = true,
  },
  version = '^1.0.0',
}
