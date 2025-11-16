return {
  {
    'nvim-pack/nvim-spectre',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('spectre').setup {
        color_devicons = true,
        open_cmd = 'vnew',
        live_update = false,
        -- replace_confirm = true,
        line_sep_start = '┌─────────────────────────────────────────',
        result_padding = '│  ',
        line_sep = '└─────────────────────────────────────────',
      }
    end,
    keys = {
      { '<leader>St', '<cmd>lua require("spectre").toggle()<CR>', desc = 'Toggle Spectre' },
      { '<leader>Sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', desc = 'Search current word' },
      { '<leader>Ss', '<esc><cmd>lua require("spectre").open_visual()<CR>', mode = 'v', desc = 'Search current word' },
      { '<leader>Sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', desc = 'Search on current file' },
    },
  },
}
