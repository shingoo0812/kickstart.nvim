return {
  'OXY2DEV/markview.nvim',
  ft = { 'markdown', 'vimwiki' },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('markview').setup {
      modes = { 'n', 'no', 'c' },
      hybrid_modes = { 'i' },
      filetypes = { 'markdown', 'vimwiki' },

      -- vimwiki 用の追加設定（必要に応じて）
      buf_ignore = {}, -- 無視するバッファパターン
    }

    -- カスタムハイライトの設定
    -- vim.api.nvim_set_hl(0, 'MarkviewHeading1', { fg = '#ff6b6b', bold = true })
    -- vim.api.nvim_set_hl(0, 'MarkviewHeading2', { fg = '#4ecdc4', bold = true })
    -- vim.api.nvim_set_hl(0, 'MarkviewHeading3', { fg = '#ffe66d', bold = true })
    vim.api.nvim_set_hl(0, 'MarkviewCode', { bg = '#2e3440' })
    vim.api.nvim_set_hl(0, 'MarkviewInlineCode', { bg = '#3b4252', fg = '#88c0d0' })
    vim.api.nvim_set_hl(0, 'MarkviewLink', { fg = '#89b4fa', underline = true })

    -- vimwiki リンク用
    vim.api.nvim_set_hl(0, 'VimwikiLink', { fg = '#89b4fa', bold = true })
    vim.api.nvim_set_hl(0, 'VimwikiLinkChar', { fg = '#6c7086' })
    -- Markdown と vimwiki ファイルで自動有効化
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'markdown', 'vimwiki' },
      callback = function()
        vim.wo.conceallevel = 2
        vim.wo.concealcursor = 'nc'

        -- バッファがロードされてから有効化
        vim.defer_fn(function()
          vim.cmd 'Markview enableAll'
        end, 100)
      end,
    })
  end,
}
