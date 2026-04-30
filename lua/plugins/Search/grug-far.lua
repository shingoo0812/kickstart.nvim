local fn = require 'config.functions'
local project_root = fn.functions.utils.get_project_root
return {
  'MagicDuck/grug-far.nvim',
  keys = {
    -- Normal mode: Regular search
    {
      '<leader>.',
      function() end,
      desc = 'GrugFar Search',
      mode = 'n',
    },

    -- Normal mode: Search & replace UI
    {
      '<leader>.r',
      function()
        require('grug-far').open {
          prefills = { paths = project_root() },
        }
      end,
      desc = 'GrugFar Replace',
      mode = 'n',
    },

    -- Visual mode: Search & replace selected text
    {
      '<leader>.v',
      function()
        require('grug-far').with_visual_selection {
          prefills = { paths = project_root() },
        }
      end,
      desc = 'Search and Replace (selection)',
      mode = 'v',
    },

    -- Normal mode: Search word under cursor
    {
      '<leader>.w',
      function()
        require('grug-far').open {
          prefills = { paths = project_root(), search = vim.fn.expand '<cword>' },
        }
      end,
      desc = 'Search and Replace (word under cursor)',
      mode = 'n',
    },
  },

  config = function()
    require('grug-far').setup {
      windowCreationCommand = 'vsplit',
      minSearchChars = 2,
      debounceMs = 500,
    }
  end,
}
