return {
  'akinsho/toggleterm.nvim',
  config = function()
    local shell_cmd = ''
    if vim.fn.has 'win32' == 1 then
      shell_cmd = 'pwsh -NoExit -ExecutionPolicy Bypass -Command "& { . $PROFILE }"'
    else
      shell_cmd = 'zsh --login'
    end
    require('toggleterm').setup {
      size = 20, -- ターミナルウィンドウの高さを指定
      open_mapping = [[<leader>tv]], -- <leader>tvでターミナルを開く
      direction = 'horizontal', -- ターミナルウィンドウの方向を指定 (horizontalで横)
      start_in_insert = true, -- 起動時に挿入モードで開始
      shade_terminals = true, -- ターミナルウィンドウのシェーディングを有効化
      shell = shell_cmd,
    }
  end,
}
