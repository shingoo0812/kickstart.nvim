return {
  'zbirenbaum/copilot-cmp',
  enabled = false,
  after = { 'copilot.lua' },
  config = function()
    require('copilot_cmp').setup()
  end,
}
