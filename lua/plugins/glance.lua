return {
  {
    'dnlhc/glance.nvim',
    cmd = 'Glance',
    keys = {
      { '<leader>gd', '<cmd>Glance definitions<cr>', desc = 'Glance Definitions' },
      { '<leader>gr', '<cmd>Glance references<cr>', desc = 'Glance References' },
      { '<leader>gy', '<cmd>Glance type_definitions<cr>', desc = 'Glance Type Definitions' },
      { '<leader>gm', '<cmd>Glance implementations<cr>', desc = 'Glance Implementations' },
    },
  },
}
