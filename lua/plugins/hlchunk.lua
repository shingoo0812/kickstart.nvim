return {
  {
    'shellRaining/hlchunk.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('hlchunk').setup {
        chunk = {
          enable = true,
          use_treesitter = true,
          notify = false,
          max_file_lines = 2000,
        },
      }
    end,
  },
}
