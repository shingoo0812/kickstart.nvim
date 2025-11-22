return {
  {
    'gruvw/strudel.nvim',
    build = 'npm ci',
    keys = {
      { '<leader><leader>s', '<cmd>StrudelLaunch<cr>', desc = 'Launch Strudel' },
      { '<leader><leader>sq', '<cmd>StrudelQuit<cr>', desc = 'Quit Strudel' },
      { '<leader><leader>st', '<cmd>StrudelToggle<cr>', desc = 'Toggle Strudel' },
      { '<leader><leader>su', '<cmd>StrudelUpdate<cr>', desc = 'Update Strudel' },
      { '<leader><leader>ss', '<cmd>StrudelStop<cr>', desc = 'Stop Strudel' },
      { '<leader><leader>sb', '<cmd>StrudelSetBuffer<cr>', desc = 'Set Buffer Strudel' },
      { '<leader><leader>se', '<cmd>StrudelExecute<cr>', desc = 'Execute Strudel' },
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
