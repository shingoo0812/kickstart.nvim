return {
  'akinsho/toggleterm.nvim',
  keys = {
    { '<leader><leader>t', '', desc = 'Terminal' },
    { '<leader><leader>th', '<cmd>ToggleTerm direction=horizontal size=20<cr>', desc = 'Horizontal ToggleTerm' },
    { '<leader><leader>tv', '<cmd>ToggleTerm direction=vertical size=80<cr>', desc = 'Vertical ToggleTerm' },
  },
  config = function()
    local shell_cmd = ''
    if vim.fn.has 'win32' == 1 then
      shell_cmd = 'pwsh -NoExit -ExecutionPolicy Bypass -Command "& { . $PROFILE }"'
    else
      shell_cmd = 'zsh --login'
    end
    require('toggleterm').setup {
      start_in_insert = true,
      shade_terminals = true,
      shell = vim.fn.has 'win32' == 1 and 'pwsh' or 'zsh',
      open_mapping = false,
    }
  end,
}
