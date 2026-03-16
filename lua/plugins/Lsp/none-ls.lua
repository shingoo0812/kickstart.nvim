return {
  'nvimtools/none-ls.nvim',
  enabled = true,
  opts = function(_, opts)
    -- local null_ls = require 'null-ls'
    -- opts.sources = opts.sources or {}
    -- vim.list_extend(opts.sources, {
    --   null_ls.builtins.diagnostics.glslc.with {
    --     filetypes = { 'glsl' },
    --     -- args = { '-fshader-stage=fragment', '-std=450core', '-o', '-', '$FILENAME' },
    --     -- 330core is used for three.js.
    --     args = { '-fshader-stage=fragment', '-std=330core', '-o', '-', '$FILENAME' },
    --     extra_args = { '--target-env=opengl' },
    --     filter = function(diagnostic)
    --       local msg = diagnostic.message
    --       return not msg:match 'varying deprecated'
    --         and not msg:match 'non%-opaque uniform'
    --         and not msg:match 'SPIR%-V requires location'
    --         and not msg:match 'varying.*no longer supported'
    --         and not msg:match 'non%-opaque uniform'
    --         and not msg:match 'SPIR%-V requires location'
    --         and not msg:match 'texture2D'
    --     end,
    --   },
    -- })
  end,
}
