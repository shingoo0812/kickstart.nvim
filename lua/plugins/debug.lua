return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim', -- nvim-dap-ui で必要な依存関係
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'leoluz/nvim-dap-go',
  },
  keys = function(_, keys)
    local dap = require 'dap'
    local dapui = require 'dapui'
    return {
      { '<F5>', dap.continue, desc = 'Debug: Start/Continue' },
      { '<F1>', dap.step_into, desc = 'Debug: Step Into' },
      { '<F2>', dap.step_over, desc = 'Debug: Step Over' },
      { '<F3>', dap.step_out, desc = 'Debug: Step Out' },
      { '<leader>d', '', desc = 'Debug' },
      { '<leader>d1', dap.continue, desc = 'Debug: Start/Continue(F5)' },
      { '<leader>d2', dap.step_into, desc = 'Debug: Step Into(F1)' },
      { '<leader>d3', dap.step_over, desc = 'Debug: Step Over(F2)' },
      { '<leader>d4', dap.step_out, desc = 'Debug: Step Out(F3)' },
      { '<leader>dt', dap.toggle_breakpoint, desc = 'Debug: Toggle Breakpoint' },
      { '<leader>du', '<cmd>lua dapui.toggle()<cr>', desc = 'Toggle Dap UI' },
      { '<leader>de', ':DapTerminate<cr>', desc = 'DAP End' },
      {
        '<leader>db',
        function()
          dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'Debug: Set Breakpoint',
      },
      { '<F7>', dapui.toggle, desc = 'Debug: See last session result.' },
      unpack(keys),
    }
  end,
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'
    local neotree_width = 40 -- Neo-treeの幅を保持

    require('mason-nvim-dap').setup {
      automatic_installation = true,
      handlers = {},
      ensure_installed = {},
    }

    vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<F11>', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<F10>', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<F8>', dap.terminate, { desc = 'Debug: Terminate' })
    vim.keymap.set('n', '<leader>ds', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint' })

    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- DapUIの開始・終了に合わせてNeo-treeの幅を調整
    local function reset_neotree_width()
      local status_ok, _ = pcall(vim.cmd, 'Neotree close')
      if not status_ok then
        return
      end
      vim.cmd 'Neotree close'
      vim.cmd 'Neotree reveal'
      vim.cmd('vertical resize ' .. neotree_width)
    end

    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end

    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close()
      reset_neotree_width()
    end

    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close()
      reset_neotree_width()
    end

    -- Python config
    dap.adapters.python = function(cb, config)
      -- Detect virtual environment python using VIRTUAL_ENV environment variable
      local python_path
      local venv = os.getenv 'VIRTUAL_ENV'

      if venv then
        -- If VIRTUAL_ENV is set, use that
        if vim.fn.has 'win32' == 1 then
          python_path = venv .. '\\Scripts\\python.exe'
        else
          python_path = venv .. '/bin/python'
        end
      else
        -- Fallback: Check common virtual environment locations
        local cwd = vim.fn.getcwd()

        -- For Windows environment
        if vim.fn.executable(cwd .. '\\.qtcreator\\Python_3_13_7venv\\Scripts\\python.exe') == 1 then
          python_path = cwd .. '\\.qtcreator\\Python_3_13_7venv\\Scripts\\python.exe'
        elseif vim.fn.executable(cwd .. '\\venv\\Scripts\\python.exe') == 1 then
          python_path = cwd .. '\\venv\\Scripts\\python.exe'
        elseif vim.fn.executable(cwd .. '\\.venv\\Scripts\\python.exe') == 1 then
          python_path = cwd .. '\\.venv\\Scripts\\python.exe'
        -- For WSL/Linux environment
        elseif vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
          python_path = cwd .. '/venv/bin/python'
        elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
          python_path = cwd .. '/.venv/bin/python'
        else
          python_path = 'python3'
        end
      end

      cb {
        type = 'executable',
        command = python_path,
        args = { '-m', 'debugpy.adapter' },
      }
    end

    dap.configurations.python = {
      {
        type = 'python',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        console = 'integratedTerminal',
      },
      {
        type = 'python',
        request = 'launch',
        name = 'Launch FastAPI',
        program = '${workspaceFolder}/main.py',
        args = {},
        console = 'integratedTerminal',
      },
    }

    -- GDScript config
    dap.adapters.godot = {
      type = 'server',
      host = '127.0.0.1',
      port = 6006,
    }

    dap.configurations.gdscript = {
      {
        type = 'godot',
        request = 'launch',
        name = 'Launch Main Scene',
        project = '${workspaceFolder}',
      },
    }

    -- godot debug setup
    require('dap-go').setup {
      delve = {
        detached = vim.fn.has 'win32' == 0,
      },
    }
  end,
}
