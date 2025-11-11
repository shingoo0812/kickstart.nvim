-- lua/plugins/lspconfig.lua
return {
  -- Main LSP Configuration
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'rhysd/vim-clang-format',
      { 'Decodetalkers/csharpls-extended-lsp.nvim', lazy = false },
      'nvim-lua/plenary.nvim',
      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },
      -- Allows extra capabilities provided by nvim-cmp
      'hrsh7th/cmp-nvim-lsp',
    },
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      -- LSP attach時の設定
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- C#ファイルの場合はomnisharp-vimを優先するため、LSPキーマップをスキップ
          local filetype = vim.bo[event.buf].filetype
          if filetype == 'cs' then
            vim.notify('C#ファイル: OmniSharp-vim を使用（LSPキーマップをスキップ）', vim.log.levels.INFO)
            return
          end

          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- 安全な定義ジャンプ（Telescopeを使用）
          vim.keymap.set('n', 'gd', function()
            require('telescope.builtin').lsp_definitions {
              show_line = false,
              trim_text = true,
              include_declaration = false,
            }
          end, { buffer = event.buf, desc = 'LSP: [G]oto [D]efinition' })

          -- その他のキーマップ
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Leader キーマップ
          map('<leader>l', '', 'LSP & terminal & Translate')
          map('<leader>lr', vim.lsp.buf.clear_references, 'Lsp Clear References')
          map('<leader>ld', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          map('<leader>ls', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>lw', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>lc', '<cmd>LspStop<cr>', 'Lsp Stop')
          map('<leader>l1', '<cmd>LspStart<cr>', 'Lsp Start')
          map('<leader>la', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

          -- カーソル下のハイライト機能
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- Inlay hints のトグル
          if client and client.server_capabilities.inlayHintProvider then
            map('<leader>lh', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- LSP capabilities の設定
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- サーバー設定（C#のomnisharpは除外）
      local servers = {
        clangd = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              diagnostics = {
                globals = { 'vim' },
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file('', true),
              },
            },
          },
        },
        -- omnisharp設定をコメントアウト（omnisharp-vimを優先）
        -- omnisharp = {
        --   cmd = vim.fn.has 'win32' == 1 and {
        --     vim.fn.stdpath 'data' .. '/mason/bin/omnisharp.cmd',
        --   } or {
        --     vim.fn.stdpath 'data' .. '/mason/bin/omnisharp',
        --   },
        --   root_dir = require('lspconfig.util').root_pattern('*.sln', '*.csproj', 'omnisharp.json', '.git'),
        --   settings = {
        --     omnisharp = {
        --       useModernNet = true,
        --       enableRoslynAnalyzers = true,
        --       enableImportCompletion = true,
        --       includePrerelease = false,
        --       enableMsBuildLoadProjectsOnDemand = false,
        --       enableEditorConfigSupport = true,
        --       enableAnalyzersSupport = true,
        --     },
        --   },
        --   on_attach = function(client, bufnr)
        --     client.server_capabilities.semanticTokensProvider = nil
        --     local opts = { noremap = true, silent = true, buffer = bufnr }
        --     vim.keymap.set('n', '<leader>lf', function()
        --       vim.lsp.buf.format { async = true }
        --     end, vim.tbl_extend('force', opts, { desc = 'LSP: Format Document' }))
        --     vim.keymap.set('n', '<leader>lu', function()
        --       vim.notify('Unity プロジェクト用コマンドを実行中...', vim.log.levels.INFO)
        --       vim.cmd 'LspRestart'
        --     end, vim.tbl_extend('force', opts, { desc = 'LSP: Restart for Unity' }))
        --   end,
        -- },
      }

      -- Mason の設定
      require('mason').setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua',
        'clangd',
        'clang-format',
        'codelldb',
        'pyright',
        -- omnisharpをコメントアウト（omnisharp-vimを使用するため）
        -- 'omnisharp',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            vim.lsp.config[server_name] = server
          end,
        },
      }

      -- Clangd の個別設定
      vim.lsp.config.clangd = {
        cmd = { 'C:\\Program Files\\LLVM\\bin\\clangd.exe' },
        on_attach = function()
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = 0 })
        end,
        capabilities = capabilities,
      }

      -- GDScript の設定（既存のまま）
      local gdscript_config = {
        capabilities = capabilities,
        settings = {},
      }
      if vim.fn.has 'win32' == 1 then
        gdscript_config['cmd'] = { 'ncat', 'localhost', os.getenv 'GDScript_Port' or '6005' }
      end
      vim.lsp.config.gdscript = gdscript_config

      -- Python
      vim.lsp.config.pyright = {}

      -- Unity プロジェクト用のコマンド（既存のまま）
      vim.api.nvim_create_user_command('ModifyCSProjFile', function()
        if vim.fn.has 'win32' == 1 then
          vim.fn.system 'findstr /s /i "*.csproj" | sed -i "s|C:\\|/mnt/c/|g"'
          vim.fn.system 'findstr /s /i "*.csproj" | sed -i "s|D:\\|/mnt/d/|g"'
        else
          vim.fn.system 'find . -maxdepth 2 -name "*.csproj" | xargs sed -i -e "s/C:/\\/mnt\\/c/g"'
          vim.fn.system 'find . -maxdepth 2 -name "*.csproj" | xargs sed -i -e "s/D:/\\/mnt\\/d/g"'
        end

        if vim.fn.exists ':YcmCompleter' == 1 then
          vim.cmd 'YcmCompleter ReloadSolution'
        end
      end, {})

      -- LSP用の追加コマンド（C#以外用）
      vim.api.nvim_create_user_command('LspStatus', function()
        local clients = vim.lsp.get_clients()
        if #clients > 0 then
          for _, client in ipairs(clients) do
            vim.notify(client.name .. ' is running', vim.log.levels.INFO)
          end
        else
          vim.notify('No LSP clients are running', vim.log.levels.WARN)
        end
      end, { desc = 'Check LSP status for all languages except C#' })

      -- デバッグ用コマンド
      vim.api.nvim_create_user_command('LspDebugInfo', function()
        local filetype = vim.bo.filetype
        local clients = vim.lsp.get_clients { bufnr = 0 }

        vim.notify('Current filetype: ' .. filetype, vim.log.levels.INFO)
        if #clients > 0 then
          for _, client in ipairs(clients) do
            vim.notify('Active LSP: ' .. client.name, vim.log.levels.INFO)
          end
        else
          vim.notify('No LSP attached to current buffer', vim.log.levels.WARN)
          if filetype == 'cs' then
            vim.notify('C# files use OmniSharp-vim instead of LSP', vim.log.levels.INFO)
          end
        end
      end, { desc = 'Debug LSP information for current buffer' })
    end,
  },
}
