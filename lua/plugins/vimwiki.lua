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
    -- vimwiki ファイルを markdown として扱う
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'vimwiki',
      callback = function()
        vim.bo.filetype = 'markdown'
        vim.wo.concealcursor = 'n' -- カーソル行では常に表示
        vim.wo.wrap = false
      end,
    })
  end,
}
