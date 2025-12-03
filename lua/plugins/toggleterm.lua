return {
  'akinsho/toggleterm.nvim',
  keys = {
    { '<leader>1', '', desc = 'Terminal' },
    { '<leader>1h', '<cmd>ToggleTerm direction=horizontal size=10<cr>', desc = 'Horizontal ToggleTerm' },
    { '<leader>1v', '<cmd>ToggleTerm direction=vertical size=80<cr>', desc = 'Vertical ToggleTerm' },
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
