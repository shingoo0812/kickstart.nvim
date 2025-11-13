-- lua/plugins/flash.lua
return {
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {
      labels = 'asdfghjklqwertyuiopzxcvbnm',
      search = {
        multi_window = true,
        forward = true,
        wrap = true,
      },
      jump = {
        jumplist = true,
        pos = 'start',
        history = false,
        register = false,
        nohlsearch = true,
        autojump = false,
      },
      label = {
        uppercase = true,
        rainbow = {
          enabled = false,
          shade = 5,
        },
      },
      modes = {
        char = {
          enabled = true,
          -- f/F/t/Tの機能強化
          keys = { 'f', 'F', 't', 'T' },
          jump_labels = true,
        },
      },
    },
    keys = {
      {
        's',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'Flash Jump',
      },
      {
        'S',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump {
            search = { mode = 'search', max_length = 0 },
            label = { after = { 0, 0 } },
            pattern = '^',
          }
        end,
        desc = 'Flash Line',
      },
    },
  },
}
