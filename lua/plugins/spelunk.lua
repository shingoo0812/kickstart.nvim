return {
  {
    'EvWilson/spelunk.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim', -- Optional: for enhanced fuzzy search capabilities
      'folke/snacks.nvim', -- Optional: for enhanced fuzzy search capabilities
      'ibhagwan/fzf-lua', -- Optional: for enhanced fuzzy search capabilities
      'nvim-treesitter/nvim-treesitter', -- Optional: for showing grammar context
      'nvim-lualine/lualine.nvim', -- Optional: for statusline display integration
    },
    keys = {
      { '<leader>b', '', desc = 'Spelunk Bookmark' },
      { '<leader>bt', '<cmd>SpelunkToggle<cr>', desc = 'Toggle Spelunk UI' },
      { '<leader>ba', '<cmd>SpelunkAddBookmark<cr>', desc = 'Add Bookmark' },
      { '<leader>bd', '<cmd>SpelunkDeleteBookmark<cr>', desc = 'Delete Bookmark' },
      { '<leader>bn', '<cmd>SpelunkNextBookmark<cr>', desc = 'Next Bookmark' },
      { '<leader>bp', '<cmd>SpelunkPrevBookmark<cr>', desc = 'Previous Bookmark' },
      { '<leader>bf', '<cmd>SpelunkSearchBookmarks<cr>', desc = 'Search Bookmarks' },
      { '<leader>bc', '<cmd>SpelunkSearchCurrentBookmarks<cr>', desc = 'Search Current Bookmarks' },
      { '<leader>bs', '<cmd>SpelunkSearchStacks<cr>', desc = 'Search Stacks' },
      { '<leader>bl', '<cmd>SpelunkChangeLine<cr>', desc = 'Change Line of Bookmark' },
    },
    config = function()
      require('spelunk').setup {
        {
          window_mappings = {
            -- Move the UI cursor down
            cursor_down = 'j',
            -- Move the UI cursor up
            cursor_up = 'k',
            -- Move the current bookmark down in the stack
            bookmark_down = '<C-j>',
            -- Move the current bookmark up in the stack
            bookmark_up = '<C-k>',
            -- Jump to the selected bookmark
            goto_bookmark = '<CR>',
            -- Jump to the selected bookmark in a new vertical split
            goto_bookmark_hsplit = 'x',
            -- Jump to the selected bookmark in a new horizontal split
            goto_bookmark_vsplit = 'v',
            -- Change line of selected bookmark
            change_line = 'l',
            -- Delete the selected bookmark
            delete_bookmark = 'd',
            -- Navigate to the next stack
            next_stack = '<Tab>',
            -- Navigate to the previous stack
            previous_stack = '<S-Tab>',
            -- Create a new stack
            new_stack = 'n',
            -- Delete the current stack
            delete_stack = 'D',
            -- Rename the current stack
            edit_stack = 'E',
            -- Close the UI
            close = 'q',
            -- Open the help menu
            help = 'h',
          },
          -- Flag to enable directory-scoped bookmark persistence
          enable_persist = false,
          -- Prefix for the Lualine integration
          -- (Change this if your terminal emulator lacks emoji support)
          statusline_prefix = '🔖',
          -- Set UI orientation
          -- Advanced customization: you may set your own layout provider for fine-grained control over layout
          -- See `layout.lua` for guidance on setting this up
          ---@type 'vertical' | 'horizontal' | LayoutProvider
          orientation = 'vertical',
          -- Enable to show bookmark index in status column
          enable_status_col_display = false,
          -- The character rendered before the currently selected bookmark in the UI
          cursor_character = '>',
          -- Set whether or not to persist bookmarks per git branch
          persist_by_git_branch = false,
          -- Optional provider to use to power fuzzy searching capabilities
          -- This can also be explicitly disabled
          ---@type 'native' | 'telescope' | 'snacks' | 'fzf-lua' | 'disabled'
          fuzzy_search_provider = 'native',
        },
      }
    end,
  },
}
