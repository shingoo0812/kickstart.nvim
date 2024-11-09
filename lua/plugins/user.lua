return {

  -- == Examples of Adding Plugins ==

  'andweeb/presence.nvim',
  {
    'ray-x/lsp_signature.nvim',
    event = 'BufRead',
    config = function()
      require('lsp_signature').setup()
    end,
  },

  -- == Examples of Overriding Plugins ==

  -- customize alpha options
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local alpha = require 'alpha'
      local dashboard = require 'alpha.themes.dashboard'
      dashboard.section.header.val = {
        -- '                                                     ',
        -- '                                                     ',
        -- '                                                     ',
        -- '  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ',
        -- '  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ',
        -- '  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ',
        -- '  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ',
        -- '  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ',
        -- '  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ',
        -- '                                                     ',
        -- '                                                     ',
        -- '                                                     ',

        '===================================================',
        '=  =======  ================  ====  ===============',
        '=   ======  ================  ====  ===============',
        '=    =====  ================  ====  ===============',
        '=  ==  ===  ===   ====   ===  ====  ==  ==  =  = ==',
        '=  ===  ==  ==  =  ==     ==   ==   ======        =',
        '=  ====  =  ==     ==  =  ===  ==  ===  ==  =  =  =',
        '=  =====    ==  =====  =  ===  ==  ===  ==  =  =  =',
        '=  ======   ==  =  ==  =  ====    ====  ==  =  =  =',
        '=  =======  ===   ====   ======  =====  ==  =  =  =',
        '===================================================',
        '                       _nnnn_                      ',
        '                      dGGGGMMb                     ',
        '                     @p~qp~~qMb                    ',
        '                     M|@||@) M|                    ',
        '                     @,----.JM|                    ',
        '                    JS^\\__/  qKL                   ',
        '                   dZP        qKRb                 ',
        '                  dZP          qKKb                ',
        '                 fZP            SMMb               ',
        '                 HZM            MMMM               ',
        '                 FqM            MMMM               ',
        '               __| ..        |LdS.qML              ',
        "               |    `.       | `' \\Zq              ",
        "              _)      \\.___.,|     .'              ",
        "              \\____   )MMMMMP|   .'                ",
        "                   `-'       `--' hjm              ",
      }
      dashboard.section.buttons.val = {
        dashboard.button('e', '📄 New file', ':ene <BAR> startinsert <CR>'),
        dashboard.button('f', '🔍 Find file', ':Telescope find_files<CR>'),
        dashboard.button('r', '🕒 Recently used files', ':Telescope oldfiles<CR>'),
        dashboard.button('s', '🔧 Settings', ':e $MYVIMRC<CR>'),
        dashboard.button('q', '🚪 Quit Neovim', ':qa<CR>'),
      }
      -- 設定をAlphaに適用
      alpha.setup(dashboard.config)
    end,
  },
  -- You can disable default plugins as follows:
  { 'max397574/better-escape.nvim', enabled = false },

  -- -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  -- {
  --   'L3MON4D3/LuaSnip',
  --   config = function(plugin, opts)
  --     require 'astronvim.plugins.configs.luasnip'(plugin, opts) -- include the default astronvim config that calls the setup call
  --     -- add more custom luasnip configuration such as filetype extend or custom snippets
  --     local luasnip = require 'luasnip'
  --     luasnip.filetype_extend('javascript', { 'javascriptreact' })
  --   end,
  -- },
}
