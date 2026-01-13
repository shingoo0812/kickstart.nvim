return {
  'neanias/everforest-nvim',
  version = false,
  lazy = false,
  priority = 1000, -- make sure to load this before all the other start plugins
  -- Optional; default configuration will be used if setup isn't called.
  init = function()
    vim.cmd.colorscheme 'gruvbox-material'
    -- You can configure highlights by doing something like:
    vim.cmd.hi 'Comment gui=none'
  end,
  config = function()
    require('everforest').setup {
      -- Your config here
    }
  end,
}
-- return {
--   'neanias/everforest-nvim',
--   version = false,
--   lazy = false,
--   priority = 1000, -- make sure to load this before all the other start plugins
--   init = function()
--     vim.cmd.colorscheme 'gruvbox-material'
--
--     -- 背景を透明化
--     vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
--     vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
--     vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
--     vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })
--     vim.api.nvim_set_hl(0, 'EndOfBuffer', { bg = 'none' })
--
--     -- You can configure highlights by doing something like:
--     vim.cmd.hi 'Comment gui=none'
--   end,
--   config = function()
--     require('everforest').setup {
--       -- Your config here
--     }
--   end,
-- }
