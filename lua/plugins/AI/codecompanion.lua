-- ~/.config/nvim/lua/plugins/codecompanion.lua
return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    -- 'ravitemer/mcphub.nvim', -- Temporarily disabled for v17.33.0 compatibility
  },
  -- Fixed version to avoid breaking changes
  version = 'v17.33.0',
  config = function()
    require('codecompanion').setup {
      -- Temporarily disable mcphub extension
      -- extensions = {
      --   mcphub = {
      --     callback = 'mcphub.extensions.codecompanion',
      --     opts = {
      --       -- Enable MCP tools
      --       make_tools = true,
      --       -- Display tools in chat
      --       show_server_tools_in_chat = true,
      --       -- Don't add mcp__ prefix to tool names
      --       add_mcp_prefix_to_tool_names = false,
      --       -- Display tool execution results in chat
      --       show_result_in_chat = true,
      --       -- Use MCP resources as variables
      --       make_vars = true,
      --       -- Add MCP prompts as slash commands
      --       make_slash_commands = true,
      --     },
      --   },
      -- },
    }
  end,
}
