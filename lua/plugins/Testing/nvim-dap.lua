return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap-python',
  },
  keys = function(_, keys)
    local dap = require 'dap'
    local dapui = require 'dapui'
    local dap_python = require 'dap-python'

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
      { '<leader>du', '<cmd>lua require("dapui").toggle()<cr>', desc = 'Toggle Dap UI' },
      { '<leader>de', ':DapTerminate<cr>', desc = 'DAP End' },
      {
        '<leader>db',
        function()
          dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'Debug: Set Breakpoint',
      },
      -- Python用のキーバインド追加
      { '<leader>dpm', dap_python.test_method, desc = 'Debug: Python Test Method' },
      { '<leader>dpc', dap_python.test_class, desc = 'Debug: Python Test Class' },
      { '<leader>dps', dap_python.debug_selection, desc = 'Debug: Python Selection', mode = 'v' },
      { '<F7>', dapui.toggle, desc = 'Debug: See last session result.' },
      unpack(keys),
    }
  end,
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'
    local dap_python = require 'dap-python'
    local neotree_width = 40

    require('mason-nvim-dap').setup {
      automatic_installation = true,
      handlers = {},
      ensure_installed = { 'debugpy' },
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

    -- ========================================
    -- Python DAP Setup - Mason's debugpy + uv venv
    -- ========================================

    -- Use Mason's debugpy Python for running the debugger
    local mason_path = vim.fn.stdpath 'data' .. '/mason/packages/debugpy/venv'
    local debugpy_python = vim.fn.has 'win32' == 1 and mason_path .. '/Scripts/python.exe' or mason_path .. '/bin/python'

    -- Setup with Mason's Python
    dap_python.setup(debugpy_python)

    -- Get project's Python (uv or standard venv) for code execution
    local function get_project_python()
      local cwd = vim.fn.getcwd()
      local paths = {
        cwd .. '\\.qtcreator\\Python_3_13_7venv\\Scripts\\python.exe', -- Windows uv/venv
        cwd .. '\\.venv\\Scripts\\python.exe', -- Windows uv/venv
        cwd .. '/.venv/bin/python', -- Linux/macOS uv/venv
        cwd .. '\\venv\\Scripts\\python.exe',
        cwd .. '/venv/bin/python',
      }
      for _, path in ipairs(paths) do
        if vim.fn.executable(path) == 1 then
          return path
        end
      end
      return nil
    end

    -- Override Python configurations to use project's Python for execution
    local project_python = get_project_python()
    if project_python then
      for _, config in pairs(dap.configurations.python) do
        config.pythonPath = project_python
      end
    end

    -- FastAPI用の設定を追加
    table.insert(dap.configurations.python, {
      type = 'python',
      request = 'launch',
      name = 'Launch FastAPI',
      program = '${workspaceFolder}/main.py',
      pythonPath = project_python,
      args = {},
      console = 'integratedTerminal',
    })

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

    -- Go debug setup
    require('dap-go').setup {
      delve = {
        detached = vim.fn.has 'win32' == 0,
      },
    }
  end,
}
