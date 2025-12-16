return {
  {
    'github/copilot.vim',
    event = 'InsertEnter',
    config = function()
      -- Copilot設定
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_filetypes = {
        ['*'] = false,
        ['javascript'] = true,
        ['typescript'] = true,
        ['lua'] = true,
        ['rust'] = true,
        ['c'] = true,
        ['c#'] = true,
        ['c++'] = true,
        ['go'] = true,
        ['python'] = true,
        ['sh'] = true,
        ['php'] = true,
      }
      vim.g.copilot_filetypes = {
        ['*'] = true,
      }

      -- キーマップ（nvim-cmpと競合しない）
      vim.keymap.set('i', '<C-g>', 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
        desc = 'Copilot Accept',
      })

      vim.keymap.set('i', '<C-]>', '<Plug>(copilot-dismiss)', { desc = 'Copilot Dismiss' })
      vim.keymap.set('i', '<M-]>', '<Plug>(copilot-next)', { desc = 'Copilot Next' })
      vim.keymap.set('i', '<M-[>', '<Plug>(copilot-previous)', { desc = 'Copilot Previous' })
      vim.keymap.set('i', '<C-\\>', '<Plug>(copilot-suggest)', { desc = 'Copilot Suggest' })
    end,
  },
}
