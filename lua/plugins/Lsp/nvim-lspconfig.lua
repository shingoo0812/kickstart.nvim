local func = require 'config.functions'
local find_venv_root = func.functions.utils.find_venv_root
local detect_os = func.functions.utils.detect_os

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
      -- null-lsを削除（conform.nvimを使用）
      -- 'jose-elias-alvarez/null-ls.nvim',
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
      capabilities.textDocument.semanticTokens = nil
      capabilities.textDocument.codeLens = nil

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
                disable = { 'missing-fields', 'inject-field' },
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file('', true),
                checkThirdParty = false,
              },
              telemetry = {
                enable = false,
              },
            },
          },
          on_attach = function(client, bufnr)
            -- フォーマット機能は conform.nvim に任せる
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,
        },

        -- csharp-lsの設定
        csharp_ls = {
          -- cmdを直接上書きしてProgram Filesのdotnetを使用
          cmd = function()
            -- csharp-lsの実行ファイルパスを取得
            local csharp_ls_path = vim.fn.exepath 'csharp-ls'
            if csharp_ls_path == '' then
              -- Masonからのパスを試す
              csharp_ls_path = vim.fn.stdpath 'data' .. '/mason/bin/csharp-ls'
              if vim.fn.has 'win32' == 1 then
                csharp_ls_path = csharp_ls_path .. '.cmd'
              end
            end

            return {
              'cmd',
              '/C',
              'set',
              'DOTNET_ROOT=C:\\Program Files\\dotnet',
              '&&',
              'set',
              'PATH=C:\\Program Files\\dotnet;%PATH%',
              '&&',
              csharp_ls_path,
            }
          end,
          handlers = {
            ['textDocument/definition'] = require('csharpls_extended').handler,
            ['textDocument/typeDefinition'] = require('csharpls_extended').handler,
          },
          init_options = {
            AutomaticWorkspaceInit = true,
          },
          settings = {
            csharp = {
              inlayHints = {
                enableInlayHintsForParameters = false,
                enableInlayHintsForLiteralParameters = false,
                enableInlayHintsForIndexerParameters = false,
              },
            },
          },
        },
      }

      -- QML言語サーバーの設定
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'qml', 'qmltypes' },
        callback = function(ev)
          vim.lsp.start {
            name = 'qmlls',
            cmd = { 'qmlls' },
            root_dir = vim.fs.root(ev.buf, { '.qmlls.ini', 'qmlproject', '.git' }),
          }
        end,
      })

      -- Setup Mason and LSP servers
      require('mason').setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        -- 'stylua', -- conform.nvimで使用するため削除
        'clangd',
        'clang-format',
        'codelldb',
        'pyright',
        'csharp_ls',
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
        on_attach = function(client, bufnr)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = 0 })
          -- フォーマット機能は conform.nvim に任せる
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
        capabilities = capabilities,
      }

      -- GDScript の設定
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'gd', 'gdscript', 'gdscript3' },
        callback = function(ev)
          local port = os.getenv 'GDScript_Port' or '6005'
          local cmd

          if detect_os() == 'windows' then
            cmd = { 'ncat', 'localhost', port }
          else
            cmd = { 'nc', 'localhost', port }
          end

          vim.lsp.start {
            name = 'gdscript',
            cmd = cmd,
            root_dir = vim.fs.root(ev.buf, { 'project.godot', '.git' }),
            capabilities = capabilities,
          }
        end,
      })

      -- before_init の外でキャッシュ変数を定義
      local pyright_venv_cache = {}
      -- Python
      vim.lsp.config.pyright = {
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              -- diagnosticMode = 'workspace',
              diagnosticMode = 'openFilesOnly',
              typeCheckingMode = 'basic',
            },
          },
        },

        flags = {
          debounce_text_changes = 100,
          allow_incremental_sync = true,
          exit_timeout = 1000, -- 終了タイムアウトを延長
        },

        -- バッファ離脱時にLSPを停止しない
        -- on_exit = function(code, signal, client_id)
        --   if code == 1 and signal == 15 then
        --     return
        --   end
        -- end,
        before_init = function(params, config)
          local venv_root = find_venv_root(root_path)
          if not venv_root then
            -- print 'venvが見つからなかったため、pythonPath設定をスキップ'
            return
          end

          -- OSごとに python の場所を決める
          local python_path
          if func.functions.utils.detect_os() == 'windows' then
            python_path = venv_root .. '/Scripts/python.exe'
          else
            python_path = venv_root .. '/bin/python'
          end

          -- 存在チェック
          if vim.fn.filereadable(python_path) == 0 then
            print('python実行ファイルが見つかりません:', python_path)
            return
          end

          -- キャッシュに保存
          pyright_venv_cache[root_path] = python_path
          config.settings.python.pythonPath = python_path

          -- デバッグ用（初回のみ通知）
          vim.notify('###Pyright using Python: ' .. python_path, vim.log.levels.INFO)
        end,
      }
    end,
  },
}
