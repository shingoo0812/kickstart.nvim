return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },

  config = function()
    local harpoon = require 'harpoon'
    harpoon:setup()

    local list = harpoon:list()
    local keymap = vim.keymap.set

    -- Add file and cursor position to Harpoon list
    keymap('n', '<leader>a', function()
      local pos = vim.api.nvim_win_get_cursor(0)
      local file = vim.fn.expand '%:p'
      list:add { value = file, context = { row = pos[1], col = pos[2] } }
      print('Added mark: ' .. file .. ':' .. pos[1])
    end, { desc = 'Add file and cursor position to Harpoon' })

    -- Toggle Harpoon quick menu
    keymap('n', '<leader>hl', function()
      harpoon.ui:toggle_quick_menu(list)
    end, { desc = 'Toggle Harpoon menu' })

    -- Jump to marked position
    local function jump_to(idx)
      local item = list.items[idx]
      if item and item.value then
        vim.cmd('edit ' .. item.value)
        local row = item.context and item.context.row or 1
        vim.api.nvim_win_set_cursor(0, { row, 0 })
      end
    end

    -- Quick jump to marked items
    keymap('n', 'h1', function()
      jump_to(1)
    end)
    keymap('n', 'h2', function()
      jump_to(2)
    end)
    keymap('n', 'h3', function()
      jump_to(3)
    end)
    keymap('n', 'h4', function()
      jump_to(4)
    end)

    keymap('n', '<leader>h1', function()
      jump_to(1)
    end, { desc = 'Jump to Harpoon mark 1' })

    keymap('n', '<leader>h2', function()
      jump_to(2)
    end, { desc = 'Jump to Harpoon mark 2' })

    keymap('n', '<leader>h3', function()
      jump_to(3)
    end, { desc = 'Jump to Harpoon mark 3' })

    keymap('n', '<leader>h4', function()
      jump_to(4)
    end, { desc = 'Jump to Harpoon mark 4' })

    -- Navigate between marked items
    keymap('n', '<A-h>', function()
      list:prev()
    end)
    keymap('n', '<A-l>', function()
      list:next()
    end)
  end,
}
