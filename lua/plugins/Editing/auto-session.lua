return {
  'rmagatti/auto-session',
  opts = {
    auto_restore_enabled = true,
    auto_save_enabled = true,
    post_restore_cmds = {
      function()
        vim.defer_fn(function()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) ~= '' then
              vim.api.nvim_buf_call(buf, function()
                -- Force re-detect filetype
                vim.cmd 'filetype detect'
                -- Fire BufRead event instead of edit (safer)
                vim.cmd 'doautocmd BufRead'
              end)
            end
          end
        end, 100)
      end,
    },
  },
}
