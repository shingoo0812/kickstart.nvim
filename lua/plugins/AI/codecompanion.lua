-- ~/.config/nvim/lua/plugins/codecompanion.lua
return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'ravitemer/mcphub.nvim', -- 依存関係に追加
  },
  -- Fixed version to avoid breaking changes
  version = 'v17.33.0',
  config = function()
    require('codecompanion').setup {
      extensions = {
        mcphub = {
          callback = 'mcphub.extensions.codecompanion',
          opts = {
            -- MCPツールを有効化
            make_tools = true,
            -- チャットでツールを表示
            show_server_tools_in_chat = true,
            -- ツール名にmcp__プレフィックスを追加しない
            add_mcp_prefix_to_tool_names = false,
            -- ツール実行結果をチャットに表示
            show_result_in_chat = true,
            -- MCPリソースを変数として利用
            make_vars = true,
            -- MCPプロンプトをスラッシュコマンドとして追加
            make_slash_commands = true,
          },
        },
      },
    }
  end,
}
