-- Highlight todo, notes, etc in comments
return {
  {
    'folke/todo-comments.nvim',
    enabled = true,
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons', 'ibhagwan/fzf-lua' },
    opts = { signs = false, lazy = true },
  },
}
