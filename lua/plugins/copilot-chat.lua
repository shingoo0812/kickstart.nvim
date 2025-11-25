return {
  'CopilotC-Nvim/CopilotChat.nvim',
  branch = 'main',
  dependencies = {
    { 'zbirenbaum/copilot.lua' },
    { 'nvim-lua/plenary.nvim' },
  },
  opts = {
    debug = true,
    suggestion = {
      enabled = true,
      keymap = {
        accept = '<C-a>',
        accept_word = false,
        accept_line = false,
        next = false,
        prev = false,
        dismiss = '<C-e>',
      },
    },
    panel = { enabled = false },
    mappings = {
      complete = {
        detail = 'Use @<Tab> or /<Tab> for options.',
        insert = '<Tab>',
      },
      close = {
        normal = 'q',
        insert = '<C-c>',
      },
      reset = {
        normal = '<C-r>',
        insert = '<C-r>',
      },
      submit_prompt = {
        normal = '<CR>',
        insert = '<C-s>',
      },
      accept_diff = {
        normal = '<C-y>',
        insert = '<C-y>',
      },
      yank_diff = {
        normal = 'gy',
      },
      show_diff = {
        normal = 'gd', -- CopilotChat内でのgdマッピング
      },
      show_system_prompt = {
        normal = 'gp',
      },
      show_user_selection = {
        normal = 'gs',
      },
    },
  },
  config = function(_, opts)
    local chat = require 'CopilotChat'
    chat.setup(opts)

    -- グローバルなgdマッピング（通常のバッファ用）
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap = true, silent = true })

    -- CopilotChatバッファが開かれた時の処理
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'copilot-chat',
      callback = function(ev)
        -- このバッファ内では既にCopilotChatのmappingsが適用されているため
        -- 追加の設定は不要ですが、必要に応じてカスタマイズ可能
      end,
    })
  end,
}
