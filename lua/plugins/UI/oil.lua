return {
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('oil').setup {
        -- Use as default file explorer
        default_file_explorer = true,

        -- Column display configuration
        columns = {
          'icon', -- File type icon
          -- 'permissions', -- Permission display (enable if needed)
          -- 'size',        -- File size display
          -- 'mtime',       -- Last modified date
        },

        -- Buffer configuration
        buf_options = {
          buflisted = false,
          bufhidden = 'hide',
        },

        -- Window configuration
        win_options = {
          wrap = false,
          signcolumn = 'no',
          cursorcolumn = false,
          foldcolumn = '0',
          spell = false,
          list = false,
          conceallevel = 0,
          concealcursor = 'nvic',
        },

        -- Confirm on delete
        delete_to_trash = false, -- Set to true to move to trash (requires trash-cli)
        skip_confirm_for_simple_edits = true,

        -- Prompt configuration
        prompt_save_on_select_new_entry = true,

        -- Hidden file display
        view_options = {
          show_hidden = true, -- Show hidden files by default
          -- is_hidden_file = function(name, bufnr)
          --   -- Always hide .git/ etc.
          --   return vim.startswith(name, '.')
          -- end,
          -- is_always_hidden = function(name, bufnr)
          --   -- Always hide node_modules, __pycache__ etc.
          --   return name == '..' or name == 'node_modules' or name == '__pycache__'
          -- end,
          -- sort = {
          --   { 'type', 'asc' }, -- Directories first
          --   { 'name', 'asc' }, -- By name
          -- },
        },

        -- Float window configuration (when opening oil.nvim as float)
        float = {
          padding = 2,
          max_width = 90,
          max_height = 30,
          border = 'rounded',
          win_options = {
            winblend = 0,
          },
        },

        -- PreviewWindow configuration
        preview = {
          max_width = 0.9,
          min_width = { 40, 0.4 },
          width = nil,
          max_height = 0.9,
          min_height = { 5, 0.1 },
          height = nil,
          border = 'rounded',
          win_options = {
            winblend = 0,
          },
        },

        -- Progress display
        progress = {
          max_width = 0.9,
          min_width = { 40, 0.4 },
          width = nil,
          max_height = { 10, 0.9 },
          min_height = { 5, 0.1 },
          height = nil,
          border = 'rounded',
          minimized_border = 'none',
          win_options = {
            winblend = 0,
          },
        },
      }

      -- KeymapsConfiguration
      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
      vim.keymap.set('n', '<leader>-', '<CMD>Oil --float<CR>', { desc = 'Open parent directory in float' })

      -- Custom keymaps within oil.nvim
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'oil',
        callback = function()
          vim.keymap.set('n', '<C-p>', require('oil.actions').preview.callback, { buffer = true, desc = 'Preview file' })
          vim.keymap.set('n', '<C-r>', require('oil.actions').refresh.callback, { buffer = true, desc = 'Refresh' })
          vim.keymap.set('n', 'g?', require('oil.actions').show_help.callback, { buffer = true, desc = 'Show help' })
        end,
      })
    end,
  },
}
