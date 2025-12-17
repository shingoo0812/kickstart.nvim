return {
  'ravitemer/mcphub.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  opts = function()
    local cmd
    if vim.fn.has 'win32' == 1 then
      -- Windows
      cmd = 'C:/Users/shing/AppData/Roaming/npm/mcp-hub.cmd'
    else
      -- Linux/macOS - npm global binのパスを確認
      local home = vim.fn.expand '~'
      local npm_bin = home .. '/.npm-global/bin/mcp-hub'
      if vim.fn.executable(npm_bin) == 1 then
        cmd = npm_bin
      else
        cmd = 'mcp-hub' -- PATHから検索
      end
    end
    return {
      config = vim.fn.stdpath 'config' .. '/lua/mcphub/servers.json',
      port = 37373,
      use_bundled_binary = false,
      cmd = cmd,
      ui = {
        window = {
          width = 0.85,
          height = 0.85,
          align = 'center',
          border = 'rounded',
        },
      },
      timeout = 30000,
    }
  end,
  config = function(_, opts)
    require('mcphub').setup(opts)
  end,
  cmd = { 'MCPHub' },
}
