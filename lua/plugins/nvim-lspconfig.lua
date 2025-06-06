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
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
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
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>lh', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- LSP capabilities の設定
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- サーバー設定
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
        -- OmniSharp の設定をserversテーブルに追加
        omnisharp = {
          cmd = vim.fn.has 'win32' == 1 and {
            vim.fn.stdpath 'data' .. '/mason/bin/omnisharp.cmd',
          } or {
            vim.fn.stdpath 'data' .. '/mason/bin/omnisharp',
          },
          root_dir = require('lspconfig.util').root_pattern('*.sln', '*.csproj', 'omnisharp.json', '.git'),
          settings = {
            omnisharp = {
              useModernNet = true,
              enableRoslynAnalyzers = true,
              enableImportCompletion = true,
              includePrerelease = false,
              -- Unity プロジェクト用の設定
              enableMsBuildLoadProjectsOnDemand = false,
              -- デバッグ情報の詳細化
              enableEditorConfigSupport = true,
              enableAnalyzersSupport = true,
            },
          },
          on_attach = function(client, bufnr)
            -- OmniSharp特有の設定
            client.server_capabilities.semanticTokensProvider = nil

            local opts = { noremap = true, silent = true, buffer = bufnr }

            -- C#専用のキーマップ
            vim.keymap.set('n', '<leader>lf', function()
              vim.lsp.buf.format { async = true }
            end, vim.tbl_extend('force', opts, { desc = 'LSP: Format Document' }))

            -- Unity固有のキーマップ
            vim.keymap.set('n', '<leader>lu', function()
              vim.notify('Unity プロジェクト用コマンドを実行中...', vim.log.levels.INFO)
              vim.cmd 'LspRestart'
            end, vim.tbl_extend('force', opts, { desc = 'LSP: Restart for Unity' }))
          end,
        },
      }

      -- Mason の設定
      require('mason').setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua',
        'clangd',
        'clang-format',
        'codelldb',
        'omnisharp', -- OmniSharpを自動インストールリストに追加
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }

      -- Clangd の個別設定（既存のまま）
      require('lspconfig').clangd.setup {
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
      require('lspconfig').gdscript.setup(gdscript_config)

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

      -- OmniSharp用の追加コマンド
      vim.api.nvim_create_user_command('OmniSharpRestart', function()
        vim.cmd 'LspStop omnisharp'
        vim.defer_fn(function()
          vim.cmd 'LspStart omnisharp'
        end, 1000)
      end, { desc = 'Restart OmniSharp LSP server' })

      vim.api.nvim_create_user_command('OmniSharpStatus', function()
        local clients = vim.lsp.get_active_clients { name = 'omnisharp' }
        if #clients > 0 then
          vim.notify('OmniSharp is running (PID: ' .. clients[1].pid .. ')', vim.log.levels.INFO)
        else
          vim.notify('OmniSharp is not running', vim.log.levels.WARN)
        end
      end, { desc = 'Check OmniSharp LSP status' })
    end,
  },
}
