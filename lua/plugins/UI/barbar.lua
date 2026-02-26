--TODO: Not work opts. Show filename only and want to hide file path.
return {
  'romgrk/barbar.nvim',
  dependencies = {
    'lewis6991/gitsigns.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  init = function()
    -- vim.g.barbar_auto_setup = false

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
    animation = true,
    auto_hide = false,
    tabpages = true,
    lazy = true,
    icons = {
      -- Configure the base icons on the bufferline.
      -- Valid options to display the buffer index and -number are `true`, 'superscript' and 'subscript'
      buffer_index = false,
      buffer_number = false,
      button = '',
      -- Enables / disables diagnostic symbols
      diagnostics = {
        [vim.diagnostic.severity.ERROR] = { enabled = true, icon = 'ﬀ' },
        [vim.diagnostic.severity.WARN] = { enabled = false },
        [vim.diagnostic.severity.INFO] = { enabled = false },
        [vim.diagnostic.severity.HINT] = { enabled = true },
      },
      gitsigns = {
        added = { enabled = true, icon = '+' },
        changed = { enabled = true, icon = '~' },
        deleted = { enabled = true, icon = '-' },
      },
      filetype = {
        -- Sets the icon's highlight group.
        -- If false, will use nvim-web-devicons colors
        custom_colors = false,

        -- Requires `nvim-web-devicons` if `true`
        enabled = true,
      },
      separator = { left = '▎', right = '' },

      -- If true, add an additional separator at the end of the buffer list
      separator_at_end = true,

      -- Configure the icons on the bufferline when modified or pinned.
      -- Supports all the base icon options.
      modified = { button = '●' },
      pinned = { button = '', filename = true },

      -- Use a preconfigured buffer appearance— can be 'default', 'powerline', or 'slanted'
      preset = 'default',

      -- Configure the icons on the bufferline based on the visibility of a buffer.
      -- Supports all the base icon options, plus `modified` and `pinned`.
      alternate = { filetype = { enabled = false } },
      current = { buffer_index = true },
      inactive = { button = '×' },
      visible = { modified = { buffer_number = false } },
    },
    -- Sets the maximum buffer name length.
    maximum_length = 30,
    -- Sets the minimum buffer name length.
    minimum_length = 0,
  },
  version = '^1.0.0',
}
