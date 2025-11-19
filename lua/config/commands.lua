local M = {}
-----------------------------------------------------
-- Functions
-----------------------------------------------------

function M.ModifyCSProjFile()
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
end

function M.LspStatus()
  local clients = vim.lsp.get_clients()
  if #clients > 0 then
    for _, client in ipairs(clients) do
      vim.notify(client.name .. ' is running', vim.log.levels.INFO)
    end
  else
    vim.notify('No LSP clients are running', vim.log.levels.WARN)
  end
end

function M.LspDebugInfo()
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
end

function M.TestCommand()
  print 'This is a test command.'
end

-- Set alias for :w command
function M.WriteFile()
  vim.cmd 'w'
end
-----------------------------------------------------
-- Commands Table
-- Define commands with their corresponding functions and arguments
-------------------------------------------------------
M.commands = {
  { name = 'ModifyCSProjFile', func = M.ModifyCSProjFile, nargs = 0 },
  { name = 'LspStatus', func = M.LspStatus, nargs = 0, desc = 'Check LSP status for all languages except C#' },
  { name = 'LspDebugInfo', func = M.LspDebugInfo, nargs = 0, desc = 'Debug LSP information for current buffer' },
  { name = 'TestCommand', func = M.TestCommand, nargs = 0 },
  { name = 'W', func = M.WriteFile, nargs = 0, desc = 'Alias for :w command' },
}

-----------------------------------------------------
-- Setup function: auto-register all commands
-------------------------------------------------------
function M.setup()
  for _, cmd in ipairs(M.commands) do
    vim.api.nvim_create_user_command(cmd.name, cmd.func, {
      nargs = cmd.nargs,
      desc = cmd.desc,
    })
  end
end

return M
