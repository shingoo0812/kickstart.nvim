return {
  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    event = 'BufReadPost',
    config = function()
      -- Initial state: Fully expanded
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldcolumn = '1'
      vim.o.foldenable = true

      local ufo = require 'ufo'

      ufo.setup {
        provider_selector = function(_, _, _)
          return { 'lsp', 'indent' }
        end,
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
      -- Reset all
      vim.keymap.set('n', 'zR', ufo.openAllFolds, { desc = 'Open all folds' })
      vim.keymap.set('n', 'zM', ufo.closeAllFolds, { desc = 'Close all folds' })

      -- zr: Increase global fold level (Open everything one level deeper)
      vim.keymap.set('n', 'zr', function()
        -- Directly modify the foldlevel option
        local level = vim.wo.foldlevel
        if level < 20 then -- 20 is a practical max depth for most code
          vim.wo.foldlevel = level + 1
        end
        print('Global Fold Level: ' .. vim.wo.foldlevel)
      end, { desc = 'Increase global fold level' })

      -- zm: Decrease global fold level (Close everything one level shallower)
      vim.keymap.set('n', 'zm', function()
        local level = vim.wo.foldlevel
        -- If currently at 99, start from a sensible level like 1
        if level >= 99 then
          vim.wo.foldlevel = 1
        elseif level > 0 then
          vim.wo.foldlevel = level - 1
        end
        -- closeFoldsWith is the only way to force UFO to respect the new level globally
        ufo.closeFoldsWith(vim.wo.foldlevel)
        print('Global Fold Level: ' .. vim.wo.foldlevel)
      end, { desc = 'Decrease global fold level' })

      -- k: Peek folded lines or hover
      vim.keymap.set('n', 'k', function()
        local winid = ufo.peekfoldedlinesundercursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end, { desc = 'Hover or peek folded lines' })
    end,
  },
}
