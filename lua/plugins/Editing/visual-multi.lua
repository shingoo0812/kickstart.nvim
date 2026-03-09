return {
  'mg979/vim-visual-multi',
  init = function()
    vim.g.VM_maps = {
      ['Find Under'] = '<C-d>',
      ['Find Subword Under'] = '<C-S-d>',
    }
  end,
}
