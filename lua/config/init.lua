----------------------------------
-- General Neovim settings
----------------------------------

-- Set <Space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[Settings for UFO]]
vim.o.foldenable = true -- 折りたたみを無効化
vim.o.foldlevel = 99 -- 全展開状態に設定
vim.o.foldlevelstart = 99 -- 起動時も全展開
vim.o.foldmethod = 'expr' -- exprで折りたたみ
vim.o.foldexpr = "v:lua.require('ufo').foldexpr()" -- UFOのfoldexprを使用
vim.o.foldcolumn = '1' -- 左側に折りたたみ列表示
-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = false

-- [[ Setting options ]]
-- See `:help vim.opt`
-- Line wrapping
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.showbreak = '>>> '
-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false
-- Vimwikiディレクトリ外のmarkdownファイルをvimwikiとして扱わないようにする
vim.g.vimwiki_global_ext = 0

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

-- Windows Terminal用の描画修正
vim.opt.termguicolors = true
vim.opt.lazyredraw = false

-- 未保存のバッファを隠すことを許可（バッファ切り替え時にエラーが出ない）
vim.opt.hidden = true
-- 外部で変更されたファイルを自動で再読み込み
vim.opt.autoread = true
-- オプション: バッファ切り替え時に自動保存
vim.opt.autowrite = true
