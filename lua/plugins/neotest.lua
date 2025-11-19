return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-neotest/neotest-python',
      'haydenmeade/neotest-jest',
    },
    config = function()
      -- OS 判定
      local is_windows = vim.loop.os_uname().version:match 'Windows'

      -- Detect project root
      local function find_project_root()
        local dir = vim.fn.getcwd()
        while dir do
          if vim.loop.fs_stat(dir .. '/.git') or vim.loop.fs_stat(dir .. '/pyproject.toml') then
            return dir
          end
          local parent = vim.fn.fnamemodify(dir, ':h')
          if parent == dir then
            break
          end
          dir = parent
        end
        return vim.fn.getcwd()
      end

      -- venv 自動検出
      local function find_venv_python()
        local root = find_project_root()
        local candidates
        if is_windows then
          candidates = {
            root .. '/.venv/Scripts/python.exe',
            root .. '/venv/Scripts/python.exe',
            root .. '/env/Scripts/python.exe',
          }
        else
          candidates = {
            root .. '/.venv/bin/python',
            root .. '/venv/bin/python',
            root .. '/env/bin/python',
          }
        end
        for _, path in ipairs(candidates) do
          if vim.loop.fs_stat(path) then
            return path
          end
        end
        return 'python'
      end

      -- Neotest 設定
      local neotest = require 'neotest'
      neotest.setup {
        adapters = {
          require 'neotest-python' {
            dap = { justMyCode = false },
            args = { '--collect-only' },
            runner = 'pytest',
            python = find_venv_python(),
          },
          require 'neotest-jest' {
            jestCommand = 'npm test --',
            env = { CI = true },
          },
        },
      }

      -- Key mapping
      local opts = { noremap = true, silent = true }
      vim.keymap.set('n', '<leader>tn', function()
        neotest.run.run()
      end, opts)
      vim.keymap.set('n', '<leader>tf', function()
        neotest.run.run(vim.fn.expand '%')
      end, opts)
      vim.keymap.set('n', '<leader>ts', function()
        neotest.summary.toggle()
      end, opts)
      vim.keymap.set('n', '<leader>to', function()
        neotest.output.open { enter = true }
      end, opts)
    end,
    keys = {
      {
        '<leader>tn',
        function()
          require('neotest').run.run()
        end,
        desc = 'Run nearest test',
      },
      {
        '<leader>tf',
        function()
          require('neotest').run.run(vim.fn.expand '%')
        end,
        desc = 'Run file tests',
      },
      {
        '<leader>ts',
        function()
          require('neotest').summary.toggle()
        end,
        desc = 'Toggle Neotest summary',
      },
      {
        '<leader>to',
        function()
          require('neotest').output.open { enter = true }
        end,
        desc = 'Open Neotest output',
      },
      {
        '<leader>tp',
        function()
          vim.cmd('terminal pytest ' .. vim.fn.expand '%')
        end,
        desc = 'Test with command pytest',
      },
    },
  },
}
