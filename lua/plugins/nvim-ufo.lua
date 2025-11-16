return {
  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    config = function()
      -- UFOセットアップ
      require('ufo').setup {
        provider_selector = function(_, _, _)
          return { 'lsp', 'indent' }
        end,
        fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
          local newVirtText = {}
          local suffix = ('  [+%d] '):format(endLnum - lnum)
          local sufWidth = vim.fn.strdisplaywidth(suffix)
          local targetWidth = width - sufWidth
          local curWidth = 0

          -- 折りたたまれた行の文字を青にする
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

          -- 末尾サフィックスはオレンジ
          table.insert(newVirtText, { suffix, 'UfoFoldedEllipsis' })
          return newVirtText
        end,
      }

      -- ハイライト設定
      vim.api.nvim_set_hl(0, 'UfoFoldedBlue', { fg = '#00afff', bg = 'NONE' }) -- 折りたたみテキスト
      vim.api.nvim_set_hl(0, 'UfoFoldedEllipsis', { fg = '#FFA500', bg = 'NONE' }) -- 末尾サフィックス
    end,
  },
}
