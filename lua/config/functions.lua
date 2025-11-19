
local M = {}

----------------------------------------------
-- Functions
----------------------------------------------
M.functions = {
  -- 汎用ユーティリティ系
  utils = {
    save_message = function(filename)
      local msgs = vim.fn.execute 'messages'
      local f = io.open(filename, 'w')
      if f then
        f:write(msgs)
        f:close()
        print('Messages saved to ' .. filename)
      else
        print('Failed to open file: ' .. filename)
      end
    end,

    normalize_path = function(p)
      return p:gsub('\\', '/')
    end,
    test = function()
      return 'test'
    end,
  },

  -- LSP系
  lsp = {
    check_status = function()
      local clients = vim.lsp.get_clients()
      if #clients > 0 then
        for _, client in ipairs(clients) do
          vim.notify(client.name .. ' is running', vim.log.levels.INFO)
        end
      else
        vim.notify('No LSP clients are running', vim.log.levels.WARN)
      end
    end,

    debug_info = function()
      local filetype = vim.bo.filetype
      local clients = vim.lsp.get_clients { bufnr = 0 }
      vim.notify('Current filetype: ' .. filetype, vim.log.levels.INFO)

      if #clients > 0 then
        for _, client in ipairs(clients) do
          vim.notify('Active LSP: ' .. client.name, vim.log.levels.INFO)
        end
      else
        vim.notify('No LSP attached to current buffer', vim.log.levels.WARN)
        if filetype == 'cs' then
          vim.notify('C# files use OmniSharp-vim instead of LSP', vim.log.levels.INFO)
        end
      end
    end,
  },

  -- Unity/C#系
  unity = {
    modify_csproj = function()
      if vim.fn.has 'win32' == 1 then
        vim.fn.system 'findstr /s /i "*.csproj" | sed -i "s|C:\\|/mnt/c/|g"'
        vim.fn.system 'findstr /s /i "*.csproj" | sed -i "s|D:\\|/mnt/d/|g"'
        vim.fn.system 'findstr /s /i "*.csproj" | sed -i "s|E:\\|/mnt/e/|g"'
        vim.fn.system 'findstr /s /i "*.csproj" | sed -i "s|F:\\|/mnt/f/|g"'
      else
        vim.fn.system 'find . -maxdepth 2 -name "*.csproj" | xargs sed -i -e "s/C:/\\/mnt\\/c/g"'
        vim.fn.system 'find . -maxdepth 2 -name "*.csproj" | xargs sed -i -e "s/D:/\\/mnt\\/d/g"'
        vim.fn.system 'find . -maxdepth 2 -name "*.csproj" | xargs sed -i -e "s/E:/\\/mnt\\/e/g"'
        vim.fn.system 'find . -maxdepth 2 -name "*.csproj" | xargs sed -i -e "s/F:/\\/mnt\\/f/g"'
      end

      if vim.fn.exists ':YcmCompleter' == 1 then
        vim.cmd 'YcmCompleter ReloadSolution'
      end
    end,
  },
}

----------------------------------------------
-- Commands
----------------------------------------------
M.commands = {
  -- ユーティリティ系
  {
    name = 'MsgLog',
    func = function(opts)
      M.functions.utils.save_message(opts.args)
    end,
    nargs = 1,
    desc = 'Save Vim messages to a file',
  },
  {
    name = 'normalize_path',
    func = function(opts)
      M.functions.utils.normalize_path(opts.args)
    end,
  },
  {
    name = 'test',
    func = M.functions.utils.test,
  },
  -- LSP系
  {
    name = 'LspStatus',
    func = M.functions.lsp.check_status,
    desc = 'Check LSP status for all languages except C#',
  },
  {
    name = 'LspDebugInfo',
    func = M.functions.lsp.debug_info,
    desc = 'Debug LSP information for current buffer',
  },

  -- Unity/C#系
  {
    name = 'ModifyCSProjFile',
    func = M.functions.unity.modify_csproj,
    desc = 'Fix C# project paths for WSL/Unix',
  },

  -- テスト用
  {
    name = 'TestCommand',
    func = function()
      print 'This is a test command.'
    end,
  },
}

----------------------------------------------
-- Setup
----------------------------------------------
function M.setup() end

return M
