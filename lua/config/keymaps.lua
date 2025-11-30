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

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')
-- Disable Ctrl+Shift+H/J/K/L for window movement
-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`

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

-- ウィンドウ移動のキーマップ（再描画付き）
vim.keymap.set('n', '<C-h>', '<C-w>h<Cmd>redraw<CR>')
vim.keymap.set('n', '<C-j>', '<C-w>j<Cmd>redraw<CR>')
vim.keymap.set('n', '<C-k>', '<C-w>k<Cmd>redraw<CR>')
vim.keymap.set('n', '<C-l>', '<C-w>l<Cmd>redraw<CR>')

-- 手動再描画
vim.keymap.set('n', '<leader>r', '<Cmd>redraw!<CR>')

-- terminal buffer で <Esc><Esc> でノーマルモードに戻す
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
-- [[VSCode Key binding]]
if vim.g.vscode then
  vim.opt.clipboard = 'unnamedplus'
  vim.keymap.set('n', 'd', '"_d')
  vim.keymap.set('n', 'dd', '"_dd')
  vim.keymap.set('n', '<C-z>', '^')
  vim.keymap.set('n', '<C-e>', '$h')
  vim.keymap.set('v', 'd', '"_d')
  vim.keymap.set('v', '<C-z>', '^')
  vim.keymap.set('v', '<C-e>', '$h')
  -- yとpのマッピングは削除（keybindings.jsonで処理）
  -- VSCodeのキーバインドに任せる
else
  vim.opt.clipboard = 'unnamedplus'
end

-- Custom Keymaps
local wk = require 'which-key'
wk.add {
  {
    mode = { 'n' },
    { 'd', '"_d' },
    { '<Esc>', '<cmd>nohlsearch<CR>', 'Clear Highlight' },
    { ']w', '/^$/<CR>', desc = 'Next Blank Line' },
    { '[w', '?^$<CR>', desc = 'Previous Blank Line' },
    { '<leader><leader>x', '<cmd>source %<cr>' },
    { '<leader>f', '', desc = 'File' },
    { '<leader>w', '', desc = 'Vimwiki' },
    { '<leader>q', '<cmd>confirm qall<cr>', desc = 'Quit Window' },
    { '<leader>Q', '<cmd>confirm qall<cr>', desc = 'Exit Neovim' },
    { ':Q', '<cmd>confirm qall<cr>', desc = 'Exit Neovim' },
    { '<C-S>', '<cmd>silent! update! | redraw<cr>', desc = 'Force write' },
    { '<esc>', '<cmd>nohlsearch<cr>' },
    {
      {
        '<leader>fp',
        function()
          local path = vim.fn.expand '%:p'
          print(path)
          vim.fn.setreg('+', path)
        end,
        desc = 'Copy File Path to Clipboard',
      },
    },
    -- { '<leader>g', '', desc = 'Diagnostics' },
    -- { '<leader>gf', '<cmd>lua vim.diagnostic.open_float()<cr>', desc = 'Show Diagnostics Float' },
    -- { '<leader>gl', '<cmd>lua vim.diagnostic.setloclist()<cr>', desc = 'Diagnostics List' },
    -- Pane
    { '<A-.>', ':vertical resize 150<cr>', desc = 'resize pane' },
    { "<A-'>", ':vertical resize +2<cr>', desc = 'resize pane to left' },
    { '<A-;>', ':vertical resize -2<cr>', desc = 'resize pane to right' },
    { '<A-[>', ':resize -2<cr>gc', desc = 'resize pane to up' },
    { '<A-/>', ':resize +2<cr>gc', desc = 'resize pane to down' },
    { '<A-=>', ':sv<cr>', desc = 'Sprit Virtical Pane' },
    -- Copilot
    -- { '<leader>k', '', desc = 'Copilot' },
    -- { '<C-[>', ':Copilot suggestion<cr>gc', desc = 'Copilot suggestion' },
    -- { '<leader>kc', '<cmd>CopilotChat<cr>', desc = 'CopilotChat Open' },
    -- { '<leader>kx', '<cmd>CopilotChatClose<cr>', desc = 'CopilotChat Close' },
    -- { '<leader>kf', '<cmd>CopilotChatFix<cr>', desc = 'CopilotChatFix Open' },
    -- { '<leader>ke', '<cmd>Copilot enable<cr>', desc = 'Copilot Enable' },
    -- { '<leader>kd', '<cmd>Copilot disable<cr>', desc = 'Copilot Disable' },
    -- { '<leader>ks', '<cmd>Copilot suggestion<cr>', desc = 'Copilot Suggestion' },
    --Move Line
    { '<C-a>', 'ggVG' },
    { '<A-j>', '<cmd>m .+1<cr>==', desc = 'Move line down' },
    { '<A-k>', '<cmd>m .-2<cr>==', desc = 'Move line up' },
    { '<C-z>', '^', desc = 'Move to head' },
    { '<C-e>', '$', desc = 'Move to end' },
    { '<leader>fc', '<cmd>BufferClose<cr>', desc = 'Buffer Close' },
    -- { '<leader>fo', '<cmd>e ' .. vim.fn.expand '%:p:h' .. '<cr>', desc = 'Open Current File Location' },
    {
      '<leader>fo',
      function()
        local current_path = vim.fn.expand '%:p:h'

        -- neo-treeを強制的にロード
        local ok, neotree_command = pcall(require, 'neo-tree.command')
        if not ok then
          -- ロードできない場合はvimコマンドで試行
          vim.cmd 'Neotree show'
          vim.schedule(function()
            vim.cmd('Neotree dir=' .. vim.fn.fnameescape(current_path))
          end)
          return
        end

        -- Neotreeを開く/パスを変更
        neotree_command.execute {
          action = 'show',
          dir = current_path,
        }
      end,
      desc = 'Open Current File Location(Neotree)',
    },
    { '<leader>fv', '<cmd>e ' .. vim.fn.fnamemodify(vim.env.MYVIMRC, ':p:h') .. '<cr>', desc = 'Open Nvim Conf Location' },
    { '<leader>fw', '<cmd>e ' .. vim.fn.fnamemodify(vim.env.PROFILE, ':p:h') .. '<cr>', desc = 'Open Windows Profile Location' },
    -- Move focus window
    { '<leader>trp', '<cmd>Pantran<cr>', desc = 'Launch Pantran for translation' },
  },
  {
    mode = { 'i' },
    { 'jk', '<esc>', desc = 'Normal Mode' },
    { '<C-o>', '<esc>o', desc = 'Go to normal mode, create new line' },
    { '<C-z>', '<esc>^i', desc = 'Move to head' },
    { '<C-e>', '<esc>$i<Right>', desc = 'Move to end' },
    { '<C-h>', '<Left>', desc = 'Move to left' },
    { '<C-j>', '<Down>', desc = 'Move to down' },
    { '<C-k>', '<Up>', desc = 'Move to up' },
    { '<C-l>', '<Right>', desc = 'Move to right' },
  },
  {
    mode = { 'v' },
    { 'd', '"_d' },
    { ']w', '/^$/<CR>', desc = 'Next Blank Line' },
    { '[w', '?^$<CR>', desc = 'Previous Blank Line' },
    { '<C-z>', '^', desc = 'Move to head' },
    { '<C-e>', '$', desc = 'Move to end' },
    { '<A-j>', ":m '>+1<cr>gv=gv", mode = 'v', desc = 'Move selection down' },
    { '<A-k>', ":m '<-2<cr>gv=gv", mode = 'v', desc = 'Move selection up' },
  },
  {
    mode = { 'x' },
  },
}
