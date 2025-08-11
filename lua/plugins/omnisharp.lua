-- lua/plugins/omnisharp.lua (修正版 - C#で標準キーを上書き)
return {
  {
    'OmniSharp/omnisharp-vim',
    ft = 'cs',
    cmd = { 'OmniSharpStartServer', 'OmniSharpStopServer', 'OmniSharpRestartServer' },
    build = 'dotnet tool install --global Microsoft.dotnet-omnisharp',
    init = function()
      -- OmniSharp設定
      vim.g.OmniSharp_server_stdio = 1
      vim.g.OmniSharp_highlight_types = 2
      -- セレクターをTelescopeに設定
      vim.g.OmniSharp_selector_ui = 'telescope'
      vim.g.OmniSharp_selector_findusages = 'telescope'
      -- Unity プロジェクト用の設定
      vim.g.OmniSharp_start_without_solution = 1
      -- Windows用の設定
      if vim.fn.has 'win32' == 1 then
        -- .NET Core版のOmniSharpを使用
        vim.g.OmniSharp_server_use_mono = 0
        vim.g.OmniSharp_server_use_net6 = 1
      end
    end,
    config = function()
      -- C#ファイルでomnisharp-vimが標準キーを優先使用
      local augroup = vim.api.nvim_create_augroup('omnisharp_vim_override', { clear = true })

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'cs',
        group = augroup,
        callback = function()
          local opts = { noremap = true, silent = true, buffer = true }

          -- 標準キーをomnisharp-vimで上書き（C#ファイルのみ）
          vim.keymap.set('n', 'gd', '<cmd>OmniSharpGotoDefinition<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Goto Definition' }))
          vim.keymap.set('n', 'gD', '<cmd>OmniSharpPreviewDefinition<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Preview Definition' }))

          -- 参照検索
          vim.keymap.set('n', 'gr', '<cmd>OmniSharpFindUsages<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Find Usages' }))

          -- 実装ジャンプ
          vim.keymap.set('n', 'gI', '<cmd>OmniSharpFindImplementations<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Find Implementations' }))

          -- ホバー情報
          vim.keymap.set('n', 'K', '<cmd>OmniSharpDocumentation<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Documentation' }))

          -- leader キーマップもomnisharp-vimで上書き
          vim.keymap.set('n', '<leader>la', '<cmd>OmniSharpGetCodeActions<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Code Actions' }))
          vim.keymap.set('x', '<leader>la', '<cmd>OmniSharpGetCodeActions<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Code Actions' }))

          vim.keymap.set('n', '<leader>lr', '<cmd>OmniSharpRename<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Rename' }))

          vim.keymap.set('n', '<leader>ld', '<cmd>OmniSharpTypeLookup<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Type Lookup' }))

          vim.keymap.set('n', '<leader>ls', '<cmd>OmniSharpFindSymbol<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Find Symbol' }))

          -- omnisharp-vim専用の追加キーマップ（オプション）
          vim.keymap.set('n', '<leader>l1', '<cmd>OmniSharpStartServer<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Start Server' }))
          vim.keymap.set('n', '<leader>lc', '<cmd>OmniSharpStopServer<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Stop Server' }))
          vim.keymap.set('n', '<leader>lR', '<cmd>OmniSharpRestartServer<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Restart Server' }))

          -- フォーマット（omnisharp-vimには専用コマンドがないので、LSPを使用）
          vim.keymap.set('n', '<leader>lf', function()
            vim.lsp.buf.format { async = true }
          end, vim.tbl_extend('force', opts, { desc = 'LSP: Format Document' }))

          -- ナビゲーション
          vim.keymap.set('n', ']]', '<cmd>OmniSharpNavigateUp<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Navigate Up' }))
          vim.keymap.set('n', '[[', '<cmd>OmniSharpNavigateDown<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Navigate Down' }))

          -- 通知
          vim.notify('C#ファイル: OmniSharp-vim が標準キーを使用します', vim.log.levels.INFO)
        end,
      })

      -- OmniSharpステータス確認コマンド
      vim.api.nvim_create_user_command('OmniSharpVimStatus', function()
        vim.cmd 'OmniSharpStatus'
      end, { desc = 'Check OmniSharp-vim status' })
    end,
  },
}
