return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  lazy = false, -- Load Imediately

  config = function()
    local harpoon = require 'harpoon'
    harpoon:setup()

    local keymap = vim.keymap.set

    -- Add file to Harpoon list (末尾に追加)
    keymap('n', '<leader>ha', function()
      harpoon:list():add()
      vim.notify('Added to Harpoon: ' .. vim.fn.expand '%:t', vim.log.levels.INFO)
    end, { desc = 'Add file to Harpoon' })

    keymap('n', 'ha', function()
      harpoon:list():add()
      vim.notify('Added to Harpoon: ' .. vim.fn.expand '%:t', vim.log.levels.INFO)
    end, { desc = 'Add file to Harpoon' })

    -- Toggle Harpoon quick menu
    keymap('n', '<leader>h', function() end, { desc = 'Harpoon' })

    keymap('n', '<leader>hl', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = 'Toggle Harpoon menu' })

    -- Quick jump to marked items (h1-4でジャンプ)

    keymap('n', '<leader>hh1', function()
      harpoon:list():select(1)
    end, { desc = 'Jump to Harpoon mark 1' })

    keymap('n', '<leader>hh2', function()
      harpoon:list():select(2)
    end, { desc = 'Jump to Harpoon mark 2' })

    keymap('n', '<leader>hh3', function()
      harpoon:list():select(3)
    end, { desc = 'Jump to Harpoon mark 3' })

    keymap('n', '<leader>hh4', function()
      harpoon:list():select(4)
    end, { desc = 'Jump to Harpoon mark 4' })

    -- <leader>h1-4で特定の位置にマークをセット
    keymap('n', '<leader>h1', function()
      local list = harpoon:list()
      local current_file = vim.api.nvim_buf_get_name(0)
      list:replace_at(1, list.config.create_list_item(list.config, current_file))
      vim.notify('Set Harpoon mark 1: ' .. vim.fn.expand '%:t', vim.log.levels.INFO)
    end, { desc = 'Set Harpoon mark 1' })

    keymap('n', '<leader>h2', function()
      local list = harpoon:list()
      local current_file = vim.api.nvim_buf_get_name(0)
      list:replace_at(2, list.config.create_list_item(list.config, current_file))
      vim.notify('Set Harpoon mark 2: ' .. vim.fn.expand '%:t', vim.log.levels.INFO)
    end, { desc = 'Set Harpoon mark 2' })

    keymap('n', '<leader>h3', function()
      local list = harpoon:list()
      local current_file = vim.api.nvim_buf_get_name(0)
      list:replace_at(3, list.config.create_list_item(list.config, current_file))
      vim.notify('Set Harpoon mark 3: ' .. vim.fn.expand '%:t', vim.log.levels.INFO)
    end, { desc = 'Set Harpoon mark 3' })

    keymap('n', '<leader>h4', function()
      local list = harpoon:list()
      local current_file = vim.api.nvim_buf_get_name(0)
      list:replace_at(4, list.config.create_list_item(list.config, current_file))
      vim.notify('Set Harpoon mark 4: ' .. vim.fn.expand '%:t', vim.log.levels.INFO)
    end, { desc = 'Set Harpoon mark 4' })

    keymap('n', '<leader>h5', function()
      local list = harpoon:list()
      local current_file = vim.api.nvim_buf_get_name(0)
      list:replace_at(5, list.config.create_list_item(list.config, current_file))
      vim.notify('Set Harpoon mark 5: ' .. vim.fn.expand '%:t', vim.log.levels.INFO)
    end, { desc = 'Set Harpoon mark 5' })

    keymap('n', '<leader>h6', function()
      local list = harpoon:list()
      local current_file = vim.api.nvim_buf_get_name(0)
      list:replace_at(6, list.config.create_list_item(list.config, current_file))
      vim.notify('Set Harpoon mark 6: ' .. vim.fn.expand '%:t', vim.log.levels.INFO)
    end, { desc = 'Set Harpoon mark 6' })

    -- Navigate between marked items
    keymap('n', '<A-h>', function()
      harpoon:list():prev()
    end, { desc = 'Harpoon: Previous mark' })

    keymap('n', '<A-l>', function()
      harpoon:list():next()
    end, { desc = 'Harpoon: Next mark' })
  end,
}
