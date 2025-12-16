return {
  'chentoast/marks.nvim',
  event = 'BufReadPost', -- Load on file open
  config = function()
    local marks = require 'marks'

    -- Setup marks.nvim
    marks.setup {
      default_mappings = false,
      cyclic = true,
      force_write_shada = true,
    }

    -- Jump to marks
    local keymap = vim.keymap.set

    -- Jump to exact positions
    keymap('n', '`a', '`a', { desc = 'Jump to exact position of mark a' })
    keymap('n', '`b', '`b', { desc = 'Jump to exact position of mark b' })
    keymap('n', '`c', '`c', { desc = 'Jump to exact position of mark c' })
    keymap('n', '`d', '`d', { desc = 'Jump to exact position of mark d' })
  end,
}
