return {
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
      { '<leader>cs', '<cmd>Trouble symbols toggle focus=false<cr>', desc = 'Symbols (Trouble)' },
      { '<leader>cl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', desc = 'LSP (Trouble)' },
      -- { '<leader>xL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
      -- { '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },
      -- { '[q', desc = 'Previous Trouble/Quickfix Item' },
      -- { ']q', desc = 'Next Trouble/Quickfix Item' },
      { '[d', desc = 'Previous Diagnostic' },
      { ']d', desc = 'Next Diagnostic' },
    },
    cmd = 'Trouble',
    opts = {},
    config = function()
      require('trouble').setup {}

      -- 診断のナビゲーション
      vim.keymap.set('n', '[q', function()
        if require('trouble').is_open() then
          require('trouble').prev { skip_groups = true, jump = true }
        else
          local ok, err = pcall(vim.cmd.cprev)
          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end, { desc = 'Previous Trouble/Quickfix Item' })

      vim.keymap.set('n', ']q', function()
        if require('trouble').is_open() then
          require('trouble').next { skip_groups = true, jump = true }
        else
          local ok, err = pcall(vim.cmd.cnext)
          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end, { desc = 'Next Trouble/Quickfix Item' })

      vim.keymap.set('n', ']d', function()
        vim.diagnostic.jump { count = 1, float = true }
      end, { desc = 'Next Diagnostic' })

      vim.keymap.set('n', '[d', function()
        vim.diagnostic.jump { count = -1, float = true }
      end, { desc = 'Previous Diagnostic' })
    end,
  },
}
