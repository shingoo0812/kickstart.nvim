return {
  'uga-rosa/translate.nvim',
  config = function()
    require('translate').setup {
      default = {
        command = 'google',
        output = 'replace',
      },
    }

    vim.keymap.set('n', '<leader><leader>tj', ':Translate ja<CR>', { desc = 'Replace to Japanese' })
    vim.keymap.set('n', '<leader><leader>te', ':Translate en<CR>', { desc = 'Replace to English' })
    vim.keymap.set('v', '<leader>tre', ':Translate en<CR>', { desc = 'Replace to English' })
  end,
}
