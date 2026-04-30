return {
  {
    'gruvw/strudel.nvim',
    build = 'npm ci',
    keys = {
      { '<leader><leader>S', '', desc = 'Strudel' },
      { '<leader><leader>Sl', '<cmd>StrudelLaunch<cr>', desc = 'Launch Strudel' },
      { '<leader><leader>Sq', '<cmd>StrudelQuit<cr>', desc = 'Quit Strudel' },
      { '<leader><leader>St', '<cmd>StrudelToggle<cr>', desc = 'Toggle Strudel' },
      { '<leader><leader>Su', '<cmd>StrudelUpdate<cr>', desc = 'Update Strudel' },
      { '<leader><leader>Ss', '<cmd>StrudelStop<cr>', desc = 'Stop Strudel' },
      { '<leader><leader>Sb', '<cmd>StrudelSetBuffer<cr>', desc = 'Set Buffer Strudel' },
      { '<leader><leader>Se', '<cmd>StrudelExecute<cr>', desc = 'Execute Strudel' },
    },
    config = function()
      require('strudel').setup {
        -- Minimal configuration. Works almost as default.
        start_on_launch = true,
        sync_cursor = true, -- Cursor sync (default ON)
        report_eval_errors = true, -- Notify errors
        update_on_save = true,
      }
    end,
  },
}
