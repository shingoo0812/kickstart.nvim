local M = {}

-----------------------------------------------------
-- Autocmd Functions
-----------------------------------------------------

-- Pythonプロジェクト自動切り替え用のヘルパー関数
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

-----------------------------------------------------
-- Autocmds Table
-----------------------------------------------------
M.autocmds = {
  {
    group = 'PyrightAutoSwitch',
    event = 'BufEnter',
    pattern = '*.py',
    callback = function()
      local current_buf = vim.api.nvim_get_current_buf()
      local current_file = vim.api.nvim_buf_get_name(current_buf)

      if current_file == '' or vim.bo[current_buf].buftype ~= '' then
        return
      end

      local new_root = find_venv_root(current_file)
      if not new_root then
        return
      end

      local clients = vim.lsp.get_clients { bufnr = current_buf, name = 'pyright' }

      if #clients > 0 then
        local client = clients[1]
        local current_root = client.config.root_dir

        -- 仮想環境のパスを比較
        local current_venv = current_root and (current_root .. '/.venv') or nil
        local new_venv = new_root .. '/.venv'

        -- root_dir が異なるが、同じ .venv を指している場合は切り替えない
        if current_root ~= new_root and current_venv ~= new_venv then
          vim.notify('Pyright: Auto-switching to ' .. new_root, vim.log.levels.INFO)
          vim.lsp.stop_client(client.id, true)
          vim.defer_fn(function()
            vim.cmd 'edit'
          end, 300)
        end
      end
    end,
    desc = 'Auto-switch Pyright root directory based on project .venv',
  },
  {
    group = 'kickstart-highlight-yank',
    event = 'TextYankPost',
    pattern = '*',
    callback = function()
      vim.hl.on_yank()
    end,
    desc = 'Highlight when yanking (copying) text',
  },
  -- 他のautocmdをここに追加できます
}

for _, autocmd in ipairs(M.autocmds) do
  local group = autocmd.group and vim.api.nvim_create_augroup(autocmd.group, { clear = true }) or nil

  vim.api.nvim_create_autocmd(autocmd.event, {
    group = group,
    pattern = autocmd.pattern,
    callback = autocmd.callback,
    desc = autocmd.desc,
  })
end

return M
