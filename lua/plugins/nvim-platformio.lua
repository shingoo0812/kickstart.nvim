-- PlatformIOがインストールされていないため無効化
return {
  'anurag3301/nvim-platformio.lua',
  enabled = false,
  ft = { 'c', 'cpp' },
  dependencies = {
    { 'akinsho/nvim-toggleterm.lua' },
    { 'nvim-telescope/telescope.nvim' },
    { 'nvim-lua/plenary.nvim' },
  },
}
