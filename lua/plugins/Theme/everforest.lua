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
    vim.api.nvim_set_hl(0, '@variable', { fg = '#c0caf5' }) -- Variable
    vim.api.nvim_set_hl(0, '@variable.member', { fg = '#73daca' }) -- Field/Property
    vim.api.nvim_set_hl(0, '@variable.parameter', { fg = '#e0af68' }) -- Argument
    vim.api.nvim_set_hl(0, '@property', { fg = '#73daca' }) -- Property
    vim.api.nvim_set_hl(0, '@field', { fg = '#73daca' }) -- Field (old)
    vim.api.nvim_set_hl(0, '@parameter', { fg = '#e0af68' }) -- Argument (old)
    vim.api.nvim_set_hl(0, '@attribute', { fg = '#bb9af7' }) -- Attribute
    vim.api.nvim_set_hl(0, '@keyword', { fg = '#bb9af7' }) -- Keyword
    vim.api.nvim_set_hl(0, '@keyword.storage.type', { fg = '#bb9af7' }) -- const/let/var
    vim.api.nvim_set_hl(0, '@tag.attribute.javascript', { fg = '#bb9af7' }) -- Tokyo Night purple
    vim.api.nvim_set_hl(0, '@tag.attribute', { fg = '#bb9af7' }) -- fallback

    vim.api.nvim_set_hl(0, '@function', { fg = '#7aa2f7' }) -- Function name
    vim.api.nvim_set_hl(0, '@string', { fg = '#9ece6a' }) -- String
    vim.api.nvim_set_hl(0, '@number', { fg = '#ff9e64' }) -- Number
    vim.api.nvim_set_hl(0, '@type', { fg = '#2ac3de' }) -- Type
    vim.api.nvim_set_hl(0, '@comment', { fg = '#565f89' }) -- Comment
    vim.cmd.hi 'Comment gui=none'
  end,
}
