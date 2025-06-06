-- lua/plugins/omnisharp.lua (修正版 - キーバインドを変更)
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
      -- OmniSharp-vim用のキーマップ（プレフィックス <leader>o を使用）
      local augroup = vim.api.nvim_create_augroup('omnisharp_vim_commands', { clear = true })

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'cs',
        group = augroup,
        callback = function()
          local opts = { noremap = true, silent = true, buffer = true }

          -- omnisharp-vim専用キーマップ（<leader>o プレフィックス）
          vim.keymap.set('n', '<leader>od', '<cmd>OmniSharpGotoDefinition<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Goto Definition' }))
          vim.keymap.set('n', '<leader>oD', '<cmd>OmniSharpPreviewDefinition<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Preview Definition' }))

          -- 参照検索
          vim.keymap.set('n', '<leader>or', '<cmd>OmniSharpFindUsages<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Find Usages' }))

          -- 実装ジャンプ
          vim.keymap.set(
            'n',
            '<leader>oi',
            '<cmd>OmniSharpFindImplementations<cr>',
            vim.tbl_extend('force', opts, { desc = 'OmniSharp: Find Implementations' })
          )

          -- シンボル検索
          vim.keymap.set('n', '<leader>os', '<cmd>OmniSharpFindSymbol<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Find Symbol' }))

          -- コードアクション
          vim.keymap.set('n', '<leader>oa', '<cmd>OmniSharpGetCodeActions<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Code Actions' }))
          vim.keymap.set('x', '<leader>oa', '<cmd>OmniSharpGetCodeActions<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Code Actions' }))

          -- リネーム
          vim.keymap.set('n', '<leader>oR', '<cmd>OmniSharpRename<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Rename' }))

          -- 型情報
          vim.keymap.set('n', '<leader>oh', '<cmd>OmniSharpDocumentation<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Documentation' }))
          vim.keymap.set('n', '<leader>ot', '<cmd>OmniSharpTypeLookup<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Type Lookup' }))

          -- サーバー制御
          vim.keymap.set('n', '<leader>o1', '<cmd>OmniSharpStartServer<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Start Server' }))
          vim.keymap.set('n', '<leader>oc', '<cmd>OmniSharpStopServer<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Stop Server' }))
          vim.keymap.set('n', '<leader>oX', '<cmd>OmniSharpRestartServer<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Restart Server' }))

          -- ナビゲーション
          vim.keymap.set('n', '<leader>o]', '<cmd>OmniSharpNavigateUp<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Navigate Up' }))
          vim.keymap.set('n', '<leader>o[', '<cmd>OmniSharpNavigateDown<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Navigate Down' }))

          -- デバッグ用
          vim.keymap.set('n', '<leader>oS', '<cmd>OmniSharpStatus<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Status' }))

          -- 通知
          vim.notify('OmniSharp-vim キーマップが有効になりました（<leader>o プレフィックス）', vim.log.levels.INFO)
        end,
      })

      -- OmniSharpステータス確認コマンド
      vim.api.nvim_create_user_command('OmniSharpVimStatus', function()
        vim.cmd 'OmniSharpStatus'
      end, { desc = 'Check OmniSharp-vim status' })
    end,
  },
}
