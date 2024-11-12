return {
  'vimwiki/vimwiki',
  config = function()
    vim.g.vimwiki_list = {
      {
        path = '~/vimwiki/', -- vimwiki directory path
        path_html = '~/vimwiki_html/',
        syntax = 'markdown', -- Sentences to use
        ext = '.md', -- Extend files
      },
    }
  end,
  event = 'VimEnter',
}
