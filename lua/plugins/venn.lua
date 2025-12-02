return {
  'jbyuki/venn.nvim',
  keys = {
    {
      '<leader>v',
      function()
        ToggleVenn()
      end,
      desc = 'Toggle Venn Mode',
    },
  },
  config = function()
    function ToggleVenn()
      if vim.b.venn_enabled then
        -- === OFF ===
        vim.b.venn_enabled = false
        vim.cmd 'setlocal ve='
        vim.cmd 'mapclear <buffer>'
      else
        -- === ON ===
        vim.b.venn_enabled = true
        vim.cmd 'setlocal ve=all' -- ← これが重要！（virtualedit 設定）

        -- ノーマルモードで線を引く
        vim.keymap.set('n', 'J', '<C-v>j:VBox<CR>', { buffer = true })
        vim.keymap.set('n', 'K', '<C-v>k:VBox<CR>', { buffer = true })
        vim.keymap.set('n', 'L', '<C-v>l:VBox<CR>', { buffer = true })
        vim.keymap.set('n', 'H', '<C-v>h:VBox<CR>', { buffer = true })

        -- ビジュアル選択 → V でボックスを描く（便利ショートカット）
        vim.keymap.set('v', 'V', ':VBox<CR>', { buffer = true })
      end
    end
  end,
}
