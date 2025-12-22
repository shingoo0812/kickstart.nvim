-- jupytext - .ipynbファイルを.pyとして扱う
return {
  'GCBallesteros/jupytext.nvim',
  config = function()
    require('jupytext').setup {
      style = 'percent', -- or 'hydrogen' or 'light'
      output_extension = 'py',
      force_ft = 'python',
    }

    -- マークダウンを.ipynbに変換する関数
    local function md_to_ipynb()
      local current_file = vim.fn.expand '%:p'
      local output_file = vim.fn.expand '%:p:r' .. '.ipynb'

      -- ファイルタイプをチェック
      if vim.bo.filetype ~= 'markdown' then
        vim.notify('This command only works with markdown files', vim.log.levels.ERROR)
        return
      end

      -- jupytextで変換（kernelspecを明示的に設定）
      local cmd = string.format('jupytext --to notebook --set-kernel python3 "%s" -o "%s"', current_file, output_file)
      local result = vim.fn.system(cmd)

      if vim.v.shell_error == 0 then
        vim.notify('Converted to: ' .. output_file, vim.log.levels.INFO)
        -- 変換したファイルを開くか聞く
        local choice = vim.fn.confirm('Open the converted notebook?', '&Yes\n&No', 2)
        if choice == 1 then
          -- 新しいバッファで開く（autocmdの問題を回避）
          vim.schedule(function()
            vim.cmd('edit! ' .. vim.fn.fnameescape(output_file))
          end)
        end
      else
        vim.notify('Conversion failed: ' .. result, vim.log.levels.ERROR)
      end
    end

    -- .ipynbをマークダウンに変換する関数
    local function ipynb_to_md()
      local current_file = vim.fn.expand '%:p'
      local output_file = vim.fn.expand '%:p:r' .. '.md'

      -- jupytextで変換
      local cmd = string.format('jupytext --to markdown "%s" -o "%s"', current_file, output_file)
      local result = vim.fn.system(cmd)

      if vim.v.shell_error == 0 then
        vim.notify('Converted to: ' .. output_file, vim.log.levels.INFO)
        local choice = vim.fn.confirm('Open the converted markdown?', '&Yes\n&No', 2)
        if choice == 1 then
          vim.schedule(function()
            vim.cmd('edit! ' .. vim.fn.fnameescape(output_file))
          end)
        end
      else
        vim.notify('Conversion failed: ' .. result, vim.log.levels.ERROR)
      end
    end
    -- キーマップ（markdownファイル用）
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'markdown',
      callback = function()
        vim.keymap.set('n', '<leader>j', '', { buffer = true, desc = 'Convert to Jupyter Notebook' })
      end,
    })
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'markdown',
      callback = function()
        vim.keymap.set('n', '<leader>jn', md_to_ipynb, { buffer = true, desc = 'Convert to Jupyter Notebook' })
      end,
    })

    -- キーマップ（ipynbファイル用）
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'python',
      callback = function()
        -- ipynbとして開かれているpythonファイルかチェック
        if vim.fn.expand '%:e' == 'ipynb' then
          vim.keymap.set('n', '<leader>jm', ipynb_to_md, { buffer = true, desc = 'Convert to Markdown' })
        end
      end,
    })
  end,
}
