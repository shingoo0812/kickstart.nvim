return {
  {
    'danymat/neogen',
    opts = {
      enabled = true,
      languages = {
        python = {
          template = {
            annotation_convention = 'google_docstrings', -- Google style
          },
        },
      },
    },
    keys = {
      { '<Leader>dd', '<cmd>Neogen<cr>', desc = 'Generate docs' },
    },
  },
}
