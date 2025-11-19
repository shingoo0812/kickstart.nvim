return {
  {
    'folke/persistence.nvim',
    event = 'BufReadPre', -- this will only start session saving when an actual file was opened
    opts = {
      -- add any custom options here
    },
    keys = {
      {
        '<leader>Ss',
        function()
          require('persistence').load()
        end,
        desc = 'Restore Session',
      },
      {
        '<leader>Sl',
        function()
          require('persistence').load { last = true }
        end,
        desc = 'Restore Last Session',
      },
      {
        '<leader>Sd',
        function()
          require('persistence').stop()
        end,
        desc = 'Dont Save Current Session',
      },
    },
    config = function()
      require('persistence').setup {

        dir = vim.fn.stdpath 'state' .. '/sessions/',
        options = { 'buffers', 'curdir', 'tabpages', 'winsize' },
      }
    end,
  },
}
