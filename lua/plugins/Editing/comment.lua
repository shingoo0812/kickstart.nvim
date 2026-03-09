return {
  'numToStr/Comment.nvim',
  config = function()
    -- Comment.nvim をセットアップ
    require('Comment').setup()

    -- which-key をロード
    local wk = require 'which-key'
    -- ✅ which-key v3: wk.add を使う
    wk.add {
      { '<C-_>', '<Plug>(comment_toggle_linewise_current)', desc = 'Comment', mode = 'n' },
      { '<C-_>', '<Plug>(comment_toggle_linewise_visual)', desc = 'Comment', mode = 'v' },
    }
  end,
}
