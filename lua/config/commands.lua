local M = {}

-- function M.SaveMessage(filename)
--   local msgs = vim.fn.execute 'messages'
--   local f = io.open(filename, 'w')
--   if f then
--     f:write(msgs)
--     f:close()
--     print('Messages saved to' .. filename)
--   else
--     print('Failed to open file:' .. filename)
--   end
-- end
--
-- -- Neovim コマンド登録
-- vim.api.nvim_create_user_command('MsgLog', function(opts)
--   M.SaveMessage(opts.args)
-- end, { nargs = 1 })

return M
