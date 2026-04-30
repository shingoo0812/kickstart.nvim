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
      -- ★ Place to write your Vault path
      {
        name = 'notes',
        path = 'F:/Documents/ObsidianVault',
      },
    },

    -- Daily notes
    daily_notes = {
      folder = 'daily',
      template = 'daily.md',
    },

    -- Completion（nvim-cmp）
    completion = {
      nvim_cmp = true, -- ★ Enable nvim-cmp!
      min_chars = 2,
    },

    -- UIConfiguration
    ui = { enable = true },

    -- Note ID generation (can modify as desired)
    note_id_func = function(title)
      return title:gsub(' ', '-'):lower()
    end,
  },

  -- Key mapping
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
