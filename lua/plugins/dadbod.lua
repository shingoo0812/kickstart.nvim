return {
  -- vim-dadbod: Database interface core
  {
    'tpope/vim-dadbod',
    lazy = true,
  },

  -- vim-dadbod-ui: UI drawer
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    keys = {
      { '<leader>db', '<cmd>DBUIToggle<CR>', desc = 'Open database UI' },
      { '<leader>df', '<cmd>DBUIFindBuffer<CR>', desc = 'DBUIBufferをSearch' },
      { '<leader>da', '<cmd>DBUIAddConnection<CR>', desc = 'Add DB connection' },
    },
    init = function()
      -- Data storage location
      local data_path = vim.fn.stdpath 'data'

      -- Use Nerd Fonts icons
      vim.g.db_ui_use_nerd_fonts = 1

      -- Query and data storage location
      vim.g.db_ui_save_location = data_path .. '/dadbod_ui'
      vim.g.db_ui_tmp_query_location = data_path .. '/dadbod_ui/tmp'

      -- Display database icons
      vim.g.db_ui_show_database_icon = 1

      -- Auto-execute table helpers
      vim.g.db_ui_auto_execute_table_helpers = 1

      -- Integration with nvim-notify (if installed)
      vim.g.db_ui_use_nvim_notify = 1

      -- Don't auto-execute queries on save (may cause issues with large queries)
      -- Can manually execute with <leader>S
      vim.g.db_ui_execute_on_save = 0

      -- Default query
      vim.g.db_ui_default_query = 'SELECT * FROM {table} LIMIT 100'

      -- Default number of rows in table display
      vim.g.db_ui_win_position = 'left'

      -- ===============================================
      -- Database connection configuration examples
      -- ===============================================

      -- Method 1: Dictionary format configuration
      vim.g.dbs = {
        -- PostgreSQL
        dev = 'postgresql://user:password@localhost:5432/mydb',

        -- MySQL
        mysql_local = 'mysql://root:password@localhost:3306/mydb',

        -- SQLite
        sqlite_local = 'sqlite:~/data/mydb.sqlite',
        asset_manager = 'postgresql://postgres:postgres@localhost:5432/asset_manager',
      }

      -- Method 2: List format configuration (explicitly specify name and URL)
      -- vim.g.dbs = {
      --   { name = "Development environment", url = "postgresql://user:password@localhost:5432/dev_db" },
      --   { name = "Staging", url = "postgresql://user:password@staging.example.com:5432/staging_db" },
      --   { name = "Production (read-only)", url = "postgresql://readonly:password@prod.example.com:5432/prod_db" },
      -- }

      -- Method 3: Use environment variables
      -- vim.g.dbs = {
      --   production = vim.env.DATABASE_URL,
      -- }

      -- Method 4: Per-project configuration
      -- Create .lazy.lua file in project root and configure as follows:
      -- ```lua
      -- vim.g.dbs = {
      --   project_db = "postgresql://localhost:5432/project_db"
      -- }
      -- return {}
      -- ```
    end,
  },

  -- vim-dadbod-completion: SQLCompletion
  {
    'kristijanhusak/vim-dadbod-completion',
    dependencies = 'vim-dadbod',
    ft = { 'sql', 'mysql', 'plsql' },
    lazy = true,
    init = function()
      -- Configure completion for SQL filetype
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'sql', 'mysql', 'plsql' },
        callback = function()
          local cmp = require 'cmp'

          -- Get current global sources
          local sources = vim.tbl_map(function(source)
            return { name = source.name }
          end, cmp.get_config().sources)

          -- Add vim-dadbod-completion source
          table.insert(sources, { name = 'vim-dadbod-completion' })

          -- Update completion sources for current buffer
          cmp.setup.buffer { sources = sources }
        end,
      })
    end,
  },
}
