return {
  'MagicDuck/grug-far.nvim',
  keys = {
    -- ノーマルモード：通常検索
    {
      '<leader>.',
      function()
        require('grug-far').search()
      end,
      desc = 'GrugFar Search',
      mode = 'n',
    },
    -- ノーマルモード：検索・置換 UI
    {
      '<leader>.r',
      function()
        require('grug-far').open()
      end,
      desc = 'GrugFar Replace',
      mode = 'n',
    },
    -- ビジュアルモード：選択テキストを検索・置換
    {
      '<leader>.r',
      function()
        require('grug-far').with_visual_selection()
      end,
      desc = 'Search and Replace (selection)',
      mode = 'v',
    },
    -- ノーマルモード：カーソル下の単語を検索
    {
      '<leader>.w',
      function()
        require('grug-far').open { prefills = { search = vim.fn.expand '<cword>' } }
      end,
      desc = 'Search and Replace (word under cursor)',
      mode = 'n',
    },
  },
  config = function()
    require('grug-far').setup {
      windowCreationCommand = 'vsplit', -- 縦分割で開く場合は "split"
      minSearchChars = 2,
      debounceMs = 500,
    }
  end,
}
