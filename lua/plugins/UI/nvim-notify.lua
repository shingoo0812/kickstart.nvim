return {
  {
    'rcarriga/nvim-notify',
    event = 'VeryLazy',
    keys = {
      {
        '<leader>dn',
        function()
          require('notify').dismiss()
        end,
        desc = 'Dismiss all notifications',
      },
      {
        '<C-c>',
        function()
          require('notify').dismiss()
        end,
        desc = 'Dismiss all notifications',
      },
      {
        '<leader>sN',
        function()
          require('telescope').extensions.notify.notify()
        end,
        desc = 'Open notification history',
      },
    },
    config = function()
      local notify = require 'notify'

      notify.setup {
        stages = 'fade', -- Animation: fade, slide, fade_in_slide_out, static
        timeout = 3000, -- Time to close(ms)
        max_height = function() -- Maximum height of notifications
          return math.floor(vim.o.lines * 0.75)
        end,
        max_width = function() -- Maximum width of notifications
          return math.floor(vim.o.columns * 0.75)
        end,
        render = 'default', -- Display Style: default, minimal, simple, compact, wrapped-compact
        background_colour = '#000000', -- Background color(Necessary for achieving transparency)
      }

      -- Override the default notification function
      vim.notify = notify
      vim.notify = function(msg, level, opts)
        opts = opts or {}
        if level == vim.log.levels.ERROR then
          opts.timeout = 10000
        end
        require 'notify'(msg, level, opts)
      end
    end,
  },
}
