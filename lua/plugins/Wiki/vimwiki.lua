-- lua/plugins/vimwiki.lua
return {
  'vimwiki/vimwiki',
  event = 'VimEnter',
  init = function()
    vim.g.vimwiki_global_ext = 0
  end,
  config = function()
    vim.g.vimwiki_list = {
      {
        path = '~/vimwiki/',
        path_html = '~/vimwiki_html/',
        syntax = 'markdown',
        ext = '.md',
      },
    }
    vim.g.vimwiki_conceallevel = 2
    -- Treat vimwiki files as markdown
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'vimwiki',
      callback = function()
        vim.bo.filetype = 'markdown'
        vim.g.vimwiki_table_mappings = 0
        vim.wo.concealcursor = 'n' -- Always display on cursor line
        vim.wo.wrap = false
      end,
    })
  end,
}
