local M = {}

-----------------------------------------------------
-- Helper Functions
-----------------------------------------------------

-- Find the root of a Python virtual environment by looking for a `.venv` folder
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
    -- Autocmd group name (for organization, can be reused)
    group = 'PyrightAutoSwitch',

    -- Event(s) that trigger this autocmd
    event = 'BufEnter',

    -- File pattern(s) to match
    pattern = '*.py',

    -- Function to run when the event matches
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
        local current_venv = current_root and (current_root .. '/.venv') or nil
        local new_venv = new_root .. '/.venv'

        if current_root ~= new_root and current_venv ~= new_venv then
          vim.notify('Pyright: Auto-switching to ' .. new_root, vim.log.levels.INFO)
          vim.lsp.stop_client(client.id, true)
          vim.defer_fn(function()
            vim.cmd 'edit'
          end, 300)
        end
      end
    end,

    -- Optional description
    desc = 'Auto-switch Pyright root directory based on project .venv',
  },

  {
    -- Highlight yanked text
    group = 'kickstart-highlight-yank',
    event = 'TextYankPost', -- Trigger after yanking text
    pattern = '*', -- Match all buffers
    callback = function()
      vim.hl.on_yank() -- Built-in function to flash yanked text
    end,
    desc = 'Highlight when yanking (copying) text',
  },

  {
    -- Automatically redraw the screen when entering a window or resizing
    group = 'RedrawOnWindowChange',
    event = { 'WinEnter', 'BufEnter', 'VimResized' }, -- Multiple events
    pattern = '*', -- Match all buffers
    callback = function()
      vim.cmd 'redraw' -- Redraw screen
    end,
    desc = 'Automatically redraw when window is entered or resized',
  },

  -- You can add more autocmds here following the same format
}

-----------------------------------------------------
-- Register autocmds
-----------------------------------------------------
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
