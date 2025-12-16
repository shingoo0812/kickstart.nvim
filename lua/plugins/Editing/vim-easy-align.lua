return {
  'junegunn/vim-easy-align',
  version = '*', -- Use for stability; omit to use `main` branch for the latest features
  config = function()
    vim.api.nvim_set_keymap('x', 'ga', '<Plug>(EasyAlign)', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', 'ga', '<Plug>(EasyAlign)', { noremap = true, silent = true })
  end,
  opts = {
    lazy = true,
  },
}
