return { -- Highlight, edit, and navigate code
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'python',
        'typescript',
        'go',
        'c',
        'cpp',
        'c_sharp',
        'rust',
        'javascript',
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
        use_languagetree = true, -- use async parser
      },
      indent = { enable = true, disable = { 'ruby' } },
      additional_vim_regex_highlighting = false,
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesitter-context').setup {
        enable = true, -- デフォルトで有効
        max_lines = 0, -- コンテキストを表示する最大行数、0 = 無制限
        min_window_height = 0, -- 有効にする最低ウィンドウ高さ
        line_numbers = true, -- 行番号を表示
        multiline_threshold = 20, -- 複数行のコンテキストの最大行数
        trim_scope = 'outer', -- outer/inner
        mode = 'cursor', -- 'cursor' or 'topline'
        separator = nil, -- コンテキストとコードの間の区切り
      }
    end,
  },
}
