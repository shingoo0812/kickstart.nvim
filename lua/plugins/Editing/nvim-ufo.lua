return {
  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    event = 'BufReadPost',
    config = function()
      -- Fold settings: start with everything open
      vim.o.foldcolumn = '1'
      vim.o.foldenable = true
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      local ufo = require 'ufo'
      ufo.setup {
        provider_selector = function(_, _, _)
          return { 'treesitter', 'indent' }
        end,
        open_fold_hl_timeout = 0,
        fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
          local newVirtText = {}
          local suffix = ('  [+%d] '):format(endLnum - lnum)
          local sufWidth = vim.fn.strdisplaywidth(suffix)
          local targetWidth = width - sufWidth
          local curWidth = 0
          for _, chunk in ipairs(virtText) do
            local chunkText = chunk[1]
            local chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if targetWidth > curWidth + chunkWidth then
              table.insert(newVirtText, { chunkText, 'UfoFoldedBlue' })
            else
              chunkText = vim.fn.strcharpart(chunkText, 0, targetWidth - curWidth)
              table.insert(newVirtText, { chunkText, 'UfoFoldedBlue' })
              break
            end
            curWidth = curWidth + chunkWidth
          end
          table.insert(newVirtText, { suffix, 'UfoFoldedEllipsis' })
          return newVirtText
        end,
      }
      -- Highlight settings
      vim.api.nvim_set_hl(0, 'UfoFoldedBlue', { fg = '#00afff', bg = 'none' })
      vim.api.nvim_set_hl(0, 'UfoFoldedEllipsis', { fg = '#ffa500', bg = 'none' })
      -- Keybindings
      -- zR/zM: Open/Close all folds
      vim.keymap.set('n', 'zR', ufo.openAllFolds, { desc = 'Open all folds' })
      vim.keymap.set('n', 'zM', ufo.closeAllFolds, { desc = 'Close all folds' })
      -- zr: Incrementally increase foldlevel (open more folds)
      vim.keymap.set('n', 'zr', function()
        local current = vim.wo.foldlevel
        vim.wo.foldlevel = current + 1
        vim.cmd 'normal! zX'
        print('Fold level: ' .. vim.wo.foldlevel)
      end, { desc = 'Increase fold level' })
      -- zm: Incrementally decrease foldlevel (close more folds)
      vim.keymap.set('n', 'zm', function()
        local current = vim.wo.foldlevel
        if current >= 99 then
          -- First zm press: start from level 3 (shows top-level folds)
          vim.wo.foldlevel = 3
        elseif current > 0 then
          vim.wo.foldlevel = current - 1
        end
        vim.cmd 'normal! zX'
        print('Fold level: ' .. vim.wo.foldlevel)
      end, { desc = 'Decrease fold level' })
      -- K: Peek folded lines or LSP hover
      vim.keymap.set('n', 'K', function()
        local winid = ufo.peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end, { desc = 'Peek fold or hover' })
    end,
  },
}
