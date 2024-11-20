return {
  'HiPhish/rainbow-delimiters.nvim',
  dependencies = {
    'lukas-reineke/indent-blankline.nvim',
  },
  config = function()
    -- Define highlight groups only up to a limited number of colors
    local highlight = {
      'RainbowRed',
      'RainbowYellow',
      'RainbowBlue',
      'RainbowOrange',
      'RainbowGreen',
    }
    local hooks = require 'ibl.hooks'

    -- Highlight setup hook, configured with limited depth for performance
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, 'RainbowRed', { fg = '#E06C75' })
      vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#E5C07B' })
      vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#61AFEF' })
      vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#D19A66' })
      vim.api.nvim_set_hl(0, 'RainbowGreen', { fg = '#98C379' })
    end)

    -- Conditional setup for large files
    local function is_large_file()
      return vim.fn.getfsize(vim.api.nvim_buf_get_name(0)) > 1024 * 1024 -- 1MB limit
    end

    -- Enable rainbow delimiters only for specific buffer types
    vim.api.nvim_create_autocmd('BufEnter', {
      callback = function()
        if not is_large_file() then
          vim.g.rainbow_delimiters = { highlight = highlight }
          require('ibl').setup { scope = { highlight = highlight } }
          hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
        end
      end,
    })
  end,
}
