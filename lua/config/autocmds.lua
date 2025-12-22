local M = {}
-----------------------------------------------------
-- Helper Functions
-----------------------------------------------------
local func = require 'config.functions'
local find_venv_root = func.functions.utils.find_venv_root

-- 仮想環境のキャッシュ（ファイルパス → venvルートのマッピング）
local venv_cache = {}

-- 現在アクティブなPyrightのルート
local current_pyright_root = nil

-- デバウンス用のタイマー
local restart_timer = nil

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

      -- vim.notify('## BufEnter: ' .. current_file, vim.log.levels.DEBUG)

      -- 特殊なバッファタイプを除外
      local buftype = vim.bo[current_buf].buftype
      if buftype ~= '' then
        return
      end

      -- ファイル名が空の場合は除外
      if current_file == '' then
        return
      end

      -- Pythonファイルかどうかを確認
      if vim.bo[current_buf].filetype ~= 'python' then
        return
      end

      -- ファイルが実際に存在するか確認
      if vim.fn.filereadable(current_file) ~= 1 then
        return
      end

      -- キャッシュをチェック
      local cached_root = venv_cache[current_file]
      local new_root

      if cached_root then
        -- キャッシュヒット
        new_root = cached_root
        -- vim.notify('Cache hit: ' .. new_root, vim.log.levels.DEBUG)
      else
        -- キャッシュミス、新規検索
        new_root = find_venv_root(current_file)
        if new_root then
          -- キャッシュに保存
          venv_cache[current_file] = new_root
          -- vim.notify('Cache miss, found: ' .. new_root, vim.log.levels.DEBUG)
        end
      end

      if not new_root then
        return
      end

      -- 現在のPyrightルートと同じ場合はスキップ
      if current_pyright_root == new_root then
        -- vim.notify('Skipping: same venv root as current Pyright', vim.log.levels.DEBUG)
        return
      end

      local clients = vim.lsp.get_clients { bufnr = current_buf, name = 'pyright' }

      -- クライアントがない場合は起動
      if #clients == 0 then
        vim.notify('Starting Pyright with root: ' .. new_root, vim.log.levels.INFO)
        current_pyright_root = new_root
        vim.cmd 'LspStart pyright'
        return
      end

      -- いずれかのクライアントが異なるルートを持っているか確認
      local needs_restart = false
      for _, client in ipairs(clients) do
        local current_root = client.config.root_dir
        if current_root ~= new_root then
          needs_restart = true
          break
        end
      end

      if not needs_restart then
        -- vim.notify('No need to restart Pyright, root unchanged', vim.log.levels.DEBUG)
        return
      end

      -- 既存のタイマーをキャンセル（連続したBufEnterをデバウンス）
      if restart_timer then
        vim.fn.timer_stop(restart_timer)
      end

      -- 通知
      vim.notify('Pyright: Switching to ' .. new_root, vim.log.levels.INFO)

      -- すべてのPyrightクライアントを停止
      for _, client in ipairs(clients) do
        vim.lsp.stop_client(client.id, true)
      end

      -- 少し待ってから再起動
      restart_timer = vim.fn.timer_start(500, function()
        -- 新しいルートで再起動
        vim.cmd 'LspStart pyright'
        -- 現在のルートを更新
        current_pyright_root = new_root
        restart_timer = nil
      end)
    end,
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
  {
    group = 'FixObsidianMarkdownFiletype',
    event = { 'BufEnter' },
    pattern = '*',
    callback = function(args)
      local buf = args.buf
      local name = vim.api.nvim_buf_get_name(buf)

      -- .md ファイルなのに filetype が空な場合のみ補正
      if name:match '%.md$' and vim.bo[buf].filetype == '' then
        vim.bo[buf].filetype = 'markdown'
      end
    end,
    desc = 'Fix missing filetype for Obsidian markdown buffers',
  },
  -- GDScript filetype detection
  {
    group = 'GDScriptFiletype',
    event = { 'BufRead', 'BufNewFile' },
    pattern = { '*.gd', '*.gdscript', '*.gdscript3' },
    desc = 'Set filetype to gdscript for GDScript files',
    callback = function()
      vim.bo.filetype = 'gdscript'
    end,
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
