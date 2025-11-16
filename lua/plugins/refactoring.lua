return {
  {
    'ThePrimeagen/refactoring.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-telescope/telescope.nvim',
    },
    lazy = false,

    keys = {
      {
        '<leader>r',
        function() end,
        mode = { 'n', 'x' },
        desc = 'Refactoring Menu',
      },
      {
        '<leader>rr',
        function()
          require('refactoring').select_refactor()
        end,
        mode = { 'n', 'x' },
        desc = 'Refactoring Menu',
      },

      {
        '<leader>rT',
        function()
          require('telescope').extensions.refactoring.refactors()
        end,
        mode = { 'n', 'x' },
        desc = 'Refactoring via Telescope',
      },

      {
        '<leader>rp',
        function()
          require('refactoring').debug.print_var()
        end,
        mode = { 'n', 'x' },
        desc = 'Debug: print variable',
      },

      {
        '<leader>rP',
        function()
          require('refactoring').debug.printf()
        end,
        mode = 'n',
        desc = 'Debug: printf',
      },

      {
        '<leader>rc',
        function()
          require('refactoring').debug.cleanup {}
        end,
        mode = 'n',
        desc = 'Debug: cleanup prints',
      },
    },

    config = function()
      require('refactoring').setup {
        prompt_func_return_type = {
          go = false,
          java = false,
          cpp = false,
          c = false,
          h = false,
          hpp = false,
          cxx = false,
        },
        prompt_func_param_type = {
          go = false,
          java = false,
          cpp = false,
          c = false,
          h = false,
          hpp = false,
          cxx = false,
        },
        printf_statements = {},
        print_var_statements = {},
      }
      require('telescope').load_extension 'refactoring'
    end,
  },
}
