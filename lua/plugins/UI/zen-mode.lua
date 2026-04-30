return {
  {
    'folke/zen-mode.nvim',
    cmd = 'ZenMode', -- Launch with :ZenMode
    config = function()
      require('zen-mode').setup {
        window = {
          -- Set width to 80%
          width = 0.8,
          -- Auto height
          height = 1,
          -- Center
          options = {
            number = true, -- Show line numbers
            relativenumber = false,
            cursorline = true,
            foldcolumn = '0', -- Hide fold column
            signcolumn = 'no',
          },
        },
        plugins = {
          options = {
            -- Features to disable during Zen mode
            ruler = false,
            showcmd = false,
          },
          gitsigns = { enabled = true }, -- Keep git info
          tmux = false, -- tmux integration
          twilight = { enabled = true }, -- When using with twilight.nvim
        },
        on_open = function()
          print 'Zen mode activated!'
        end,
        on_close = function()
          print 'Zen mode closed!'
        end,
      }
    end,
  },
}
