vim.cmd.colorscheme 'gruvbox-material'

vim.api.nvim_set_hl(0, '@variable', { fg = '#c0caf5' })
vim.api.nvim_set_hl(0, '@variable.member', { fg = '#73daca' })
vim.api.nvim_set_hl(0, '@variable.parameter', { fg = '#e0af68' })
vim.api.nvim_set_hl(0, '@property', { fg = '#73daca' })
vim.api.nvim_set_hl(0, '@field', { fg = '#73daca' })
vim.api.nvim_set_hl(0, '@parameter', { fg = '#e0af68' })
vim.api.nvim_set_hl(0, '@attribute', { fg = '#bb9af7' })
vim.api.nvim_set_hl(0, '@keyword', { fg = '#bb9af7' })
vim.api.nvim_set_hl(0, '@keyword.storage.type', { fg = '#bb9af7' })
vim.api.nvim_set_hl(0, '@tag.attribute.javascript', { fg = '#bb9af7' })
vim.api.nvim_set_hl(0, '@tag.attribute', { fg = '#bb9af7' })
vim.api.nvim_set_hl(0, '@function', { fg = '#7aa2f7' })
vim.api.nvim_set_hl(0, '@string', { fg = '#9ece6a' })
vim.api.nvim_set_hl(0, '@number', { fg = '#ff9e64' })
vim.api.nvim_set_hl(0, '@type', { fg = '#2ac3de' })
vim.api.nvim_set_hl(0, '@comment', { fg = '#565f89' })
vim.cmd.hi 'Comment gui=none'
