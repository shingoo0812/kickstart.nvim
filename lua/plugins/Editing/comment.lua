return {
  'numToStr/Comment.nvim',
  config = function()
    -- Setup Comment.nvim
    require('Comment').setup()

    -- Load which-key
    local wk = require 'which-key'
    -- ✅ which-key v3: use wk.add
    wk.add {
      { '<C-_>', '<Plug>(comment_toggle_linewise_current)', desc = 'Comment', mode = 'n' },
      { '<C-_>', '<Plug>(comment_toggle_linewise_visual)', desc = 'Comment', mode = 'v' },
    }
  end,
}
