return {
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- LuaSnip
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          'rafamadriz/friendly-snippets',
        },
        config = function()
          local ls = require 'luasnip'
          ls.config.setup {}

          -- 自作スニペット
          require('luasnip.loaders.from_lua').lazy_load {
            paths = vim.fn.stdpath 'config' .. '/lua/snippets',
          }

          -- 👇 VSCodeスニペット読み込み（超重要）
          require('luasnip.loaders.from_vscode').lazy_load()

          -- 👇 React対応（これないと効かないことある）
          ls.filetype_extend('javascript', { 'javascriptreact' })
          ls.filetype_extend('typescript', { 'typescriptreact' })
        end,
      },

      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',

      -- Copilot 本体
      {
        'zbirenbaum/copilot.lua',
        cmd = 'Copilot',
        event = 'InsertEnter',
        config = function()
          require('copilot').setup {
            suggestion = { enabled = false },
            panel = { enabled = false },
          }
        end,
      },

      -- Copilot を CMP に統合
      {
        'zbirenbaum/copilot-cmp',
        after = { 'copilot.lua' },
        config = function()
          require('copilot_cmp').setup()
        end,
      },
    },

    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        completion = { completeopt = 'menu,menuone,noinsert' },

        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-y>'] = cmp.mapping.confirm { select = true },

          -- 👇 Tabでスニペット展開もできるように改善
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.confirm { select = true }
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),

          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),

          ['<C-Space>'] = cmp.mapping.complete {},

          ['<C-l>'] = cmp.mapping(function(fallback)
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),

          ['<C-h>'] = cmp.mapping(function(fallback)
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),

          ['<C-j>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { 'i', 's' }),

          ['<C-k>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { 'i', 's' }),
        },

        formatting = {
          format = function(entry, vim_item)
            vim_item.menu = ({
              buffer = '[Buffer]',
              nvim_lsp = '[LSP]',
              path = '[Path]',
              luasnip = '[Snippet]',
              copilot = '[Copilot]',
            })[entry.source.name]
            return vim_item
          end,
        },

        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'copilot', group_index = 2 },
          { name = 'path' },
          { name = 'buffer', keyword_length = 3 },
          { name = 'obsidian' },
        },
      }
    end,
  },
}
