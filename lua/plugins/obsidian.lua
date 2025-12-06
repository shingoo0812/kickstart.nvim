return {
  'epwalsh/obsidian.nvim',
  version = '*',
  lazy = false,

  dependencies = {
    'nvim-lua/plenary.nvim',
    'hrsh7th/nvim-cmp',
  },

  opts = {
    workspaces = {
      -- ★ あなたのVaultのパスを書く場所
      {
        name = 'notes',
        path = 'F:/Documents/ObsidianVault',
      },
    },

    -- デイリーノート
    daily_notes = {
      folder = 'daily',
      template = 'daily.md',
    },

    -- 補完（nvim-cmp）
    completion = {
      nvim_cmp = true, -- ★ nvim-cmp を有効化！
      min_chars = 2,
    },

    -- UI設定
    ui = { enable = true },

    -- note ID生成（好きに変更可能）
    note_id_func = function(title)
      return title:gsub(' ', '-'):lower()
    end,
  },

  -- キーマッピング
  keys = {
    { '<leader><leader>o', '', desc = 'Obsidian' },
    { '<leader><leader>oo', '<cmd>ObsidianOpen<CR>', desc = 'Obsidian: Open note' },
    { '<leader><leader>on', '<cmd>ObsidianNew<CR>', desc = 'Obsidian: New note' },
    { '<leader><leader>os', '<cmd>ObsidianSearch<CR>', desc = 'Obsidian: Search notes' },
    { '<leader><leader>ot', '<cmd>ObsidianToday<CR>', desc = 'Obsidian: Today' },
    { '<leader><leader>oy', '<cmd>ObsidianYesterday<CR>', desc = 'Obsidian: Yesterday' },
    { '<leader><leader>ol', '<cmd>ObsidianLinks<CR>', desc = 'Obsidian: Links' },
    { '<leader><leader>ob', '<cmd>ObsidianBacklinks<CR>', desc = 'Obsidian: Backlinks' },
  },
}
