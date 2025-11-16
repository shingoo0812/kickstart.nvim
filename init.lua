--[[
=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================


--]]

vim.o.foldenable = false -- 折りたたみ有効
vim.o.foldlevel = 99 -- 全展開状態に設定
vim.o.foldlevelstart = 99 -- 起動時も全展開
vim.o.foldmethod = 'expr' -- exprで折りたたみ
vim.o.foldexpr = "v:lua.require('ufo').foldexpr()" -- UFOのfoldexprを使用
vim.o.foldcolumn = '1' -- 左側に折りたたみ列表示

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = false

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
-- vim.schedule(function()
--   vim.opt.clipboard = 'unnamedplus'
-- end)

if vim.g.vscode then
  vim.opt.clipboard = 'unnamedplus'
  vim.keymap.set('n', 'd', '"_d')
  vim.keymap.set('n', 'dd', '"_dd')
  vim.keymap.set('n', '<C-z>', '^')
  vim.keymap.set('n', '<C-e>', '$')
  vim.keymap.set('v', 'd', '"_d')
  vim.keymap.set('v', '<C-z>', '^')
  vim.keymap.set('v', '<C-e>', '$')
  vim.api.nvim_create_user_command('TestHello', function()
    print 'Hello from Neovim!'
  end, {})
  -- yとpのマッピングは削除（keybindings.jsonで処理）
  -- VSCodeのキーバインドに任せる
else
  vim.opt.clipboard = 'unnamedplus'
end

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'
vim.env.PYTHONIOENCODING = 'utf-8'

-- Autoindent
vim.opt.autoindent = true
-- vim.opt.smartindent = true
-- vim.cmd 'filetype plugin indent on'

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Set alias
vim.api.nvim_create_user_command('W', 'w', {})

-- Set Configure
require 'config.shada'
-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
---@diagnostic disable-next-line: undefined-field
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  -- 'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  {
    import = 'plugins',
  },

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to force a plugin to be loaded.
  --

  -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `config` key, the configuration only runs
  -- after the plugin has been loaded:
  --  config = function() ... end

  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin

  -- The following two comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
  -- { import = 'custom.plugins' },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
-- Read Configuration folders
local config_path = vim.fn.stdpath 'config' .. '/lua/config'
local files = vim.fn.readdir(config_path)
for _, file in ipairs(files) do
  if file:match '%.lua$' then
    require('config.' .. file:gsub('%.lua$', ''))
  end
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

-- Enable neovim to be the external editor for Godot, if the cwd has a project.godot file
if vim.fn.filereadable(vim.fn.getcwd() .. '/project.godot') == 1 then
  local addr = './godot.pipe'
  if vim.fn.has 'win32' == 1 then
    -- Windows can't pipe so use localhost. Make sure this is configured in Godot
    -- Exec Path: nvim
    -- Exec Flags: --server 127.0.0.1:6004 --remote-send "<esc>:n {file}<CR>:call cursor({line},{col})<CR>"
    addr = '127.0.0.1:6004'
  else
    addr = '127.0.0.1:6004'
  end
  vim.fn.serverstart(addr)
end

-- :messages を現在のフォルダに保存する（Windows / Linux 両対応）
vim.keymap.set('n', '<leader>m', function()
  local msgs = vim.fn.execute 'messages'
  local lines = vim.split(msgs, '\n')

  -- OSに合わせてファイルパスを作成
  local sep = package.config:sub(1, 1) -- Windowsなら "\"、Linuxなら "/"
  local logfile = vim.fn.getcwd() .. sep .. 'messages.log'

  -- 日時を区切りとして追加
  table.insert(lines, 1, '==== ' .. os.date '%Y-%m-%d %H:%M:%S' .. ' ====')

  -- ファイルに追記 ("a" フラグでappend)
  vim.fn.writefile(lines, logfile, 'a')

  print('Saved :messages to ' .. logfile)
end, { desc = 'Save :messages to file' })

-- Custom Keymaps
local wk = require 'which-key'
wk.add {
  {
    mode = { 'n' },
    { 'd', '"_d' },
    { '<leader><leader>x', '<cmd>source %<cr>' },
    { '<leader>f', '', desc = 'File' },
    { '<leader>w', '', desc = 'Vimwiki' },
    { '<leader>q', '<cmd>confirm q<cr>', desc = 'Quit Window' },
    { '<leader>Q', '<cmd>confirm qall<cr>', desc = 'Exit Neovim' },
    { '<leader>fn', '<cmd>enew<cr>', desc = 'New File' },
    { '<C-S>', '<cmd>silent! update! | redraw<cr>', desc = 'Force write' },
    { '<esc>', '<cmd>nohlsearch<cr>' },

    { '<leader>g', '', desc = 'Diagnostics' },
    { '<leader>gf', '<cmd>lua vim.diagnostic.open_float()<cr>', desc = 'Show Diagnostics Float' },
    { '<leader>gl', '<cmd>lua vim.diagnostic.setloclist()<cr>', desc = 'Diagnostics List' },
    -- Pane
    { '<A-m>', ':vertical resize +2<cr>', desc = 'resize pane to left' },
    { '<A-/>', ':vertical resize -2<cr>', desc = 'resize pane to right' },
    { '<A-,>', ':resize -2<cr>gc', desc = 'resize pane to up' },
    { '<A-.>', ':resize +2<cr>gc', desc = 'resize pane to down' },
    { '<A-->', ':vs<cr>', desc = 'Sprit Horizontal Pane' },
    { '<A-+>', ':sv<cr>', desc = 'Sprit Virtical Pane' },
    -- Copilot
    { '<leader>k', '', desc = 'Copilot' },
    { '<C-[>', ':Copilot suggestion<cr>gc', desc = 'Copilot suggestion' },
    { '<leader>kc', '<cmd>CopilotChat<cr>', desc = 'CopilotChat Open' },
    { '<leader>kx', '<cmd>CopilotChatClose<cr>', desc = 'CopilotChat Close' },
    { '<leader>kf', '<cmd>CopilotChatFix<cr>', desc = 'CopilotChatFix Open' },
    { '<leader>ke', '<cmd>Copilot enable<cr>', desc = 'Copilot Enable' },
    { '<leader>kd', '<cmd>Copilot disable<cr>', desc = 'Copilot Disable' },
    { '<leader>ks', '<cmd>Copilot suggestion<cr>', desc = 'Copilot Suggestion' },
    --Move Line
    { '<C-a>', 'ggVG' },
    { '<A-j>', '<cmd>m .+1<cr>==', desc = 'Move line down' },
    { '<A-k>', '<cmd>m .-2<cr>==', desc = 'Move line up' },
    { '<C-z>', '^', desc = 'Move to head' },
    { '<C-e>', '$', desc = 'Move to end' },
    {
      '<leader>fr',
      function()
        -- Get current_path as absolute path
        local current_path = vim.fn.expand '%:p'
        -- Input to new_name
        local new_name = vim.fn.input('New name:', vim.fn.expand '%:p:h' .. '/', 'file')

        if new_name ~= '' and new_name ~= current_path then
          -- Save as new file
          vim.cmd('saveas ' .. vim.fn.fnameescape(new_name))
          -- Delete current file
          vim.fn.delete(current_path)
          vim.cmd 'BufferClose'
          -- Open to new file
          vim.cmd('e ' .. vim.fn.fnameescape(new_name))
          vim.cmd 'Neotree close'
          vim.cmd 'Neotree show'
          print('File renamed to ' .. new_name)
        else
          print 'Renaming canceled or file name is the same.'
        end
      end,
      desc = 'File Rename',
    },
    {
      '<leader>fd',
      function()
        local current_path = vim.fn.expand '%:p'

        local confirm = vim.fn.input 'Delete file? (y/n): '

        if confirm == 'y' then
          vim.fn.delete(current_path)
          vim.cmd 'BufferClose'
          vim.cmd 'Neotree close'
          vim.cmd 'Neotree show'
          print('File deleted: ' .. current_path)
        else
          print 'File deletion canceled.'
        end
      end,
      desc = 'File Delete',
    },
    { '<leader>fc', '<cmd>BufferClose<cr>', desc = 'Buffer Close' },
    -- { '<leader>fo', '<cmd>e ' .. vim.fn.expand '%:p:h' .. '<cr>', desc = 'Open Current File Location' },
    {
      '<leader>fo',
      function()
        local current_path = vim.fn.expand '%:p:h'
        vim.cmd('Neotree dir=' .. current_path)
        vim.cmd 'Neotree show'
      end,
      desc = 'Open Current File Location(Neotree)',
    },
    { '<leader>fv', '<cmd>e ' .. vim.fn.fnamemodify(vim.env.MYVIMRC, ':p:h') .. '<cr>', desc = 'Open Nvim Conf Location' },
    { '<leader>fw', '<cmd>e ' .. vim.fn.fnamemodify(vim.env.PROFILE, ':p:h') .. '<cr>', desc = 'Open Windows Profile Location' },
    -- Move focus window
    { '<C-h>', '<C-w><C-h>', desc = 'Move focus to the left window' },
    { '<C-l>', '<C-w><C-l>', desc = 'Move focus to the right window' },
    { '<C-j>', '<C-w><C-j>', desc = 'Move focus to the lower window' },
    { '<C-k>', '<C-w><C-k>', desc = 'Move focus to the upper window' },
    { '<leader>trp', '<cmd>Pantran<cr>', desc = 'Launch Pantran for translation' },
  },
  {
    mode = { 'i' },
    { 'jk', '<esc>', desc = 'Normal Mode' },
    { '<C-o>', '<esc>o', desc = 'Go to normal mode, create new line' },
    { '<C-z>', '<esc>^', desc = 'Move to head' },
    { '<C-e>', '<esc>$', desc = 'Move to end' },
    { '<C-h>', '<Left>', desc = 'Move to left' },
    { '<C-j>', '<Down>', desc = 'Move to down' },
    { '<C-k>', '<Up>', desc = 'Move to up' },
    { '<C-l>', '<Right>', desc = 'Move to right' },
  },
  {
    mode = { 'v' },
    { 'd', '"_d' },
    { '<C-z>', '^', desc = 'Move to head' },
    { '<C-e>', '$', desc = 'Move to end' },
    { '<A-j>', ":m '>+1<cr>gv=gv", mode = 'v', desc = 'Move selection down' },
    { '<A-k>', ":m '<-2<cr>gv=gv", mode = 'v', desc = 'Move selection up' },
  },
  {
    mode = { 'x' },
  },
}
