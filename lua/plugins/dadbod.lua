return {
  -- vim-dadbod: データベースインターフェース本体
  {
    'tpope/vim-dadbod',
    lazy = true,
  },

  -- vim-dadbod-ui: UIドロワー
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
      { '<leader>db', '<cmd>DBUIToggle<CR>', desc = 'データベースUIを開く' },
      { '<leader>df', '<cmd>DBUIFindBuffer<CR>', desc = 'DBUIバッファを検索' },
      { '<leader>da', '<cmd>DBUIAddConnection<CR>', desc = 'DB接続を追加' },
    },
    init = function()
      -- データの保存場所
      local data_path = vim.fn.stdpath 'data'

      -- Nerd Fontsのアイコンを使用
      vim.g.db_ui_use_nerd_fonts = 1

      -- クエリとデータの保存場所
      vim.g.db_ui_save_location = data_path .. '/dadbod_ui'
      vim.g.db_ui_tmp_query_location = data_path .. '/dadbod_ui/tmp'

      -- データベースアイコンを表示
      vim.g.db_ui_show_database_icon = 1

      -- テーブルヘルパーの自動実行
      vim.g.db_ui_auto_execute_table_helpers = 1

      -- nvim-notifyとの連携（インストール済みの場合）
      vim.g.db_ui_use_nvim_notify = 1

      -- 保存時にクエリを自動実行しない（大きなクエリで問題が起きる可能性があるため）
      -- <leader>S で手動実行できます
      vim.g.db_ui_execute_on_save = 0

      -- デフォルトのクエリ
      vim.g.db_ui_default_query = 'SELECT * FROM {table} LIMIT 100'

      -- Win32yank（WSL）を使用する場合
      vim.g.db_ui_use_nvim_notify = 1

      -- テーブル表示でのデフォルトの行数
      vim.g.db_ui_win_position = 'left'

      -- ===============================================
      -- データベース接続の設定例
      -- ===============================================

      -- 方法1: 辞書形式で設定
      vim.g.dbs = {
        -- PostgreSQL
        dev = 'postgresql://user:password@localhost:5432/mydb',

        -- MySQL
        mysql_local = 'mysql://root:password@localhost:3306/mydb',

        -- SQLite
        sqlite_local = 'sqlite:~/data/mydb.sqlite',

        -- MongoDB
        -- mongo = "mongodb://localhost:27017/mydb",
      }

      -- 方法2: リスト形式で設定（名前とURLを明示的に指定）
      -- vim.g.dbs = {
      --   { name = "開発環境", url = "postgresql://user:password@localhost:5432/dev_db" },
      --   { name = "ステージング", url = "postgresql://user:password@staging.example.com:5432/staging_db" },
      --   { name = "本番（読み取り専用）", url = "postgresql://readonly:password@prod.example.com:5432/prod_db" },
      -- }

      -- 方法3: 環境変数を使用
      -- vim.g.dbs = {
      --   production = vim.env.DATABASE_URL,
      -- }

      -- 方法4: プロジェクトごとの設定
      -- プロジェクトルートに .lazy.lua ファイルを作成し、以下のように設定：
      -- ```lua
      -- vim.g.dbs = {
      --   project_db = "postgresql://localhost:5432/project_db"
      -- }
      -- return {}
      -- ```
    end,
  },

  -- vim-dadbod-completion: SQL補完
  {
    'kristijanhusak/vim-dadbod-completion',
    dependencies = 'vim-dadbod',
    ft = { 'sql', 'mysql', 'plsql' },
    lazy = true,
    init = function()
      -- SQLファイルタイプで補完を設定
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'sql', 'mysql', 'plsql' },
        callback = function()
          local cmp = require 'cmp'

          -- 現在のグローバルソースを取得
          local sources = vim.tbl_map(function(source)
            return { name = source.name }
          end, cmp.get_config().sources)

          -- vim-dadbod-completionソースを追加
          table.insert(sources, { name = 'vim-dadbod-completion' })

          -- 現在のバッファに対して補完ソースを更新
          cmp.setup.buffer { sources = sources }
        end,
      })
    end,
  },
}
