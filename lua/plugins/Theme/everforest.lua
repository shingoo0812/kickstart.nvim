return {
  'neanias/everforest-nvim',
  version = false,
  lazy = false,
  priority = 1000,

  config = function()
    vim.cmd.colorscheme 'gruvbox-material'

    -- vim.api.nvim_set_hl(0, '@variable', { fg = '#E06C75' })
    -- vim.api.nvim_set_hl(0, '@property', { fg = '#61AFEF' })
    -- vim.api.nvim_set_hl(0, '@parameter', { fg = '#E5C07B' })
    -- vim.api.nvim_set_hl(0, '@field', { fg = '#56B6C2' })
    -- vim.api.nvim_set_hl(0, '@attribute', { fg = '#D19A66' })
    -- vim.api.nvim_set_hl(0, '@keyword', { fg = '#ff0000' })
    vim.api.nvim_set_hl(0, '@variable', { fg = '#c0caf5' }) -- 変数
    vim.api.nvim_set_hl(0, '@variable.member', { fg = '#73daca' }) -- フィールド/プロパティ
    vim.api.nvim_set_hl(0, '@variable.parameter', { fg = '#e0af68' }) -- 引数
    vim.api.nvim_set_hl(0, '@property', { fg = '#73daca' }) -- プロパティ
    vim.api.nvim_set_hl(0, '@field', { fg = '#73daca' }) -- フィールド(旧)
    vim.api.nvim_set_hl(0, '@parameter', { fg = '#e0af68' }) -- 引数(旧)
    vim.api.nvim_set_hl(0, '@attribute', { fg = '#bb9af7' }) -- アトリビュート
    vim.api.nvim_set_hl(0, '@keyword', { fg = '#bb9af7' }) -- キーワード
    vim.api.nvim_set_hl(0, '@keyword.storage.type', { fg = '#bb9af7' }) -- const/let/var
    vim.api.nvim_set_hl(0, '@tag.attribute.javascript', { fg = '#bb9af7' }) -- Tokyo Night purple
    vim.api.nvim_set_hl(0, '@tag.attribute', { fg = '#bb9af7' }) -- fallback

    vim.api.nvim_set_hl(0, '@function', { fg = '#7aa2f7' }) -- 関数名
    vim.api.nvim_set_hl(0, '@string', { fg = '#9ece6a' }) -- 文字列
    vim.api.nvim_set_hl(0, '@number', { fg = '#ff9e64' }) -- 数値
    vim.api.nvim_set_hl(0, '@type', { fg = '#2ac3de' }) -- 型
    vim.api.nvim_set_hl(0, '@comment', { fg = '#565f89' }) -- コメント
    vim.cmd.hi 'Comment gui=none'
  end,
}
