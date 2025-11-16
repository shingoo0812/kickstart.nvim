return {
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('oil').setup {
        -- デフォルトのファイルエクスプローラーとして使用
        default_file_explorer = true,

        -- カラム表示の設定
        columns = {
          'icon', -- ファイルタイプアイコン
          -- 'permissions', -- パーミッション表示（必要なら有効化）
          -- 'size',        -- ファイルサイズ表示
          -- 'mtime',       -- 最終更新日時
        },

        -- バッファ設定
        buf_options = {
          buflisted = false,
          bufhidden = 'hide',
        },

        -- ウィンドウ設定
        win_options = {
          wrap = false,
          signcolumn = 'no',
          cursorcolumn = false,
          foldcolumn = '0',
          spell = false,
          list = false,
          conceallevel = 3,
          concealcursor = 'nvic',
        },

        -- 削除時の確認
        delete_to_trash = false, -- trueにするとゴミ箱に移動（要trash-cli）
        skip_confirm_for_simple_edits = false,

        -- プロンプトの設定
        prompt_save_on_select_new_entry = true,

        -- 隠しファイルの表示
        view_options = {
          show_hidden = true, -- デフォルトで隠しファイル表示
          is_hidden_file = function(name, bufnr)
            -- .git/などは常に隠す
            return vim.startswith(name, '.')
          end,
          is_always_hidden = function(name, bufnr)
            -- node_modules, __pycache__などは常に隠す
            return name == '..' or name == 'node_modules' or name == '__pycache__'
          end,
          sort = {
            { 'type', 'asc' }, -- ディレクトリを先に
            { 'name', 'asc' }, -- 名前順
          },
        },

        -- フロートウィンドウ設定（oil.nvimをフロートで開く場合）
        float = {
          padding = 2,
          max_width = 90,
          max_height = 30,
          border = 'rounded',
          win_options = {
            winblend = 0,
          },
        },

        -- プレビューウィンドウ設定
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

        -- プログレス表示
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

      -- キーマップ設定
      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
      vim.keymap.set('n', '<leader>-', '<CMD>Oil --float<CR>', { desc = 'Open parent directory in float' })

      -- oil.nvim内でのカスタムキーマップ
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
