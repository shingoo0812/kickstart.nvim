local fn = require 'config.functions'
local git_root = fn.functions.utils.git_root

return {
  'MagicDuck/grug-far.nvim',
  keys = {
    -- ノーマルモード：通常検索
    {
      '<leader>.',
      function() end,
      desc = 'GrugFar Search',
      mode = 'n',
    },
    {
      '<leader>.s',
      function()
        require('grug-far').search {
          prefills = { paths = git_root() },
        }
      end,
      desc = 'GrugFar Search',
      mode = 'n',
    },

    -- ノーマルモード：検索・置換 UI
    {
      '<leader>.r',
      function()
        require('grug-far').open {
          prefills = { paths = git_root() },
        }
      end,
      desc = 'GrugFar Replace',
      mode = 'n',
    },

    -- ビジュアルモード：選択テキストを検索・置換
    {
      '<leader>.v',
      function()
        require('grug-far').with_visual_selection {
          prefills = { paths = git_root() },
        }
      end,
      desc = 'Search and Replace (selection)',
      mode = 'v',
    },

    -- ノーマルモード：カーソル下の単語を検索
    {
      '<leader>.w',
      function()
        require('grug-far').open {
          prefills = { paths = git_root(), search = vim.fn.expand '<cword>' },
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
