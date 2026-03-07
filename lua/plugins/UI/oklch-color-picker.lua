return {
  'eero-lehtinen/oklch-color-picker.nvim',
  event = 'VeryLazy',
  keys = {
    {
      '<leader>cp',
      function()
        require('oklch-color-picker').pick_under_cursor()
      end,
      desc = 'Pick color',
    },
  },
  opts = {},
}
