return {
  {
    'benlubas/molten-nvim',
    version = '^1.0.0',
    lazy = false, -- 起動時に読み込む
    build = ':UpdateRemotePlugins',
    init = function()
      -- Windowsでは画像表示を無効化
      vim.g.molten_image_provider = 'none'
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = false
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
    end,
    config = function()
      -- .ipynbファイルを開いたときの自動設定
      vim.api.nvim_create_autocmd('BufReadPost', {
        pattern = '*.ipynb',
        callback = function()
          -- filetypeをpythonに設定
          vim.bo.filetype = 'python'
          -- Moltenを自動初期化
          vim.schedule(function()
            vim.cmd 'MoltenInit python3'
          end)
        end,
      })

      -- キーマップはconfigで設定
      vim.keymap.set('n', '<leader>m', '', { desc = 'Molten(JupyterNotebook)' })
      vim.keymap.set('n', '<leader>mi', ':MoltenInit<CR>', { desc = 'Initialize Molten' })
      vim.keymap.set('n', '<leader>ml', ':MoltenEvaluateLine<CR>', { desc = 'Evaluate Line' })
      vim.keymap.set('n', '<leader>mr', ':MoltenReevaluateCell<CR>', { desc = 'Re-evaluate Cell' })
      vim.keymap.set('v', '<leader>mv', ':<C-u>MoltenEvaluateVisual<CR>gv', { desc = 'Evaluate Visual' })
      vim.keymap.set('n', '<leader>md', ':MoltenDelete<CR>', { desc = 'Delete Cell' })
      vim.keymap.set('n', '<leader>mo', ':MoltenHideOutput<CR>', { desc = 'Hide Output' })
      vim.keymap.set('n', '<leader>ms', ':noautocmd MoltenEnterOutput<CR>', { desc = 'Show Output' })
    end,
  },
}
