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

-- Switch Pyright root directory based on current Python file's .venv
function M.SwitchPyrightRoot()
  local current_buf = vim.api.nvim_get_current_buf()
  local current_file = vim.api.nvim_buf_get_name(current_buf)
  local filetype = vim.bo[current_buf].filetype

  -- Skip for non-Python files
  if filetype ~= 'python' then
    vim.notify('Not a Python file', vim.log.levels.WARN)
    return
  end

  -- Skip anonymous buffers and special buffers
  if current_file == '' or vim.bo[current_buf].buftype ~= '' then
    vim.notify('Cannot determine file path', vim.log.levels.WARN)
    return
  end

  -- Find the root directory with .venv in the current file
  local function find_venv_root(path)
    local current = vim.fn.fnamemodify(path, ':h')
    while current ~= '/' and current ~= '' and current ~= '.' do
      if vim.fn.isdirectory(current .. '/.venv') == 1 then
        return current
      end
      local parent = vim.fn.fnamemodify(current, ':h')
      if parent == current then
        break
      end
      current = parent
    end
    return nil
  end

  local function get_python_path(venv_path)
    if vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1 then
      return venv_path .. '/Scripts/python.exe'
    else
      return venv_path .. '/bin/python'
    end
  end

  local new_root = find_venv_root(current_file)
  if not new_root then
    vim.notify('No .venv found in parent directories', vim.log.levels.WARN)
    return
  end

  local new_venv_path = new_root .. '/.venv'
  local new_python_path = get_python_path(new_venv_path)

  -- pyrightクライアントを取得
  local clients = vim.lsp.get_clients { bufnr = current_buf, name = 'pyright' }

  if #clients > 0 then
    local client = clients[1]
    local current_root = client.config.root_dir
    local current_python = client.config.settings.python.pythonPath

    -- Root directoryまたはpythonPathが異なる場合
    if current_root ~= new_root or current_python ~= new_python_path then
      vim.notify(string.format('Pyright: Switching\n  Root: %s\n  Python: %s', new_root, new_python_path), vim.log.levels.INFO)

      -- 設定を更新してから再起動
      client.config.settings.python.pythonPath = new_python_path
      client.config.root_dir = new_root

      vim.lsp.stop_client(client.id)

      -- 少し待ってから新しい設定で起動
      vim.defer_fn(function()
        vim.cmd 'edit' -- バッファを再読み込みしてLSPを再アタッチ
      end, 200)
    else
      vim.notify(string.format('Already using correct configuration\n  Root: %s\n  Python: %s', current_root, current_python), vim.log.levels.INFO)
    end
  else
    vim.notify('No Pyright client attached to current buffer', vim.log.levels.WARN)
  end
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
  { name = 'SwitchPyrightRoot', func = M.SwitchPyrightRoot, nargs = 0, desc = "Switch Pyright root to match current Python file's .venv" },
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
