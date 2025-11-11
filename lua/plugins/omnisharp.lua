-- lua/plugins/omnisharp.lua
return {
  {
    'OmniSharp/omnisharp-vim',
    ft = 'cs',
    cmd = { 'OmniSharpStartServer', 'OmniSharpStopServer', 'OmniSharpRestartServer' },
    init = function()
      -- Scoopでインストールしたomnisharpを使用
      vim.g.OmniSharp_server_use_net6 = 1
      vim.g.OmniSharp_server_stdio = 1
      vim.g.OmniSharp_server_path = vim.fn.expand '~/scoop/apps/omnisharp/current/OmniSharp.dll'

      vim.g.OmniSharp_highlight_types = 2
      vim.g.OmniSharp_selector_ui = 'telescope'
      vim.g.OmniSharp_selector_findusages = 'telescope'
      vim.g.OmniSharp_start_without_solution = 1
    end,
    config = function()
      local augroup = vim.api.nvim_create_augroup('omnisharp_vim_override', { clear = true })

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'cs',
        group = augroup,
        callback = function()
          local opts = { noremap = true, silent = true, buffer = true }

          vim.keymap.set('n', 'gd', '<cmd>OmniSharpGotoDefinition<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Goto Definition' }))
          vim.keymap.set('n', 'gD', '<cmd>OmniSharpPreviewDefinition<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Preview Definition' }))
          vim.keymap.set('n', 'gr', '<cmd>OmniSharpFindUsages<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Find Usages' }))
          vim.keymap.set('n', 'gI', '<cmd>OmniSharpFindImplementations<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Find Implementations' }))
          vim.keymap.set('n', 'K', '<cmd>OmniSharpDocumentation<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Documentation' }))

          vim.keymap.set('n', '<leader>la', '<cmd>OmniSharpGetCodeActions<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Code Actions' }))
          vim.keymap.set('x', '<leader>la', '<cmd>OmniSharpGetCodeActions<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Code Actions' }))
          vim.keymap.set('n', '<leader>lr', '<cmd>OmniSharpRename<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Rename' }))
          vim.keymap.set('n', '<leader>ld', '<cmd>OmniSharpTypeLookup<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Type Lookup' }))
          vim.keymap.set('n', '<leader>ls', '<cmd>OmniSharpFindSymbol<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Find Symbol' }))

          vim.keymap.set('n', '<leader>l1', '<cmd>OmniSharpStartServer<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Start Server' }))
          vim.keymap.set('n', '<leader>lc', '<cmd>OmniSharpStopServer<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Stop Server' }))
          vim.keymap.set('n', '<leader>lR', '<cmd>OmniSharpRestartServer<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Restart Server' }))

          vim.keymap.set('n', '<leader>lf', function()
            vim.lsp.buf.format { async = true }
          end, vim.tbl_extend('force', opts, { desc = 'LSP: Format Document' }))

          vim.keymap.set('n', ']]', '<cmd>OmniSharpNavigateUp<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Navigate Up' }))
          vim.keymap.set('n', '[[', '<cmd>OmniSharpNavigateDown<cr>', vim.tbl_extend('force', opts, { desc = 'OmniSharp: Navigate Down' }))

          vim.notify('C#ファイル: OmniSharp-vim が標準キーを使用します', vim.log.levels.INFO)
        end,
      })

      vim.api.nvim_create_user_command('OmniSharpVimStatus', function()
        vim.cmd 'OmniSharpStatus'
      end, { desc = 'Check OmniSharp-vim status' })
    end,
  },
}
