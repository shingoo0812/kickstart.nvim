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
        -- 最小設定。ほぼデフォルトのままで動く。
        start_on_launch = true,
        sync_cursor = true, -- カーソル同期（デフォルトON）
        report_eval_errors = true, -- エラーを通知
        update_on_save = true,
      }
    end,
  },
}
