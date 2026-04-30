return {
  {
    'David-Kunz/gen.nvim',
    opts = {
      model = 'qwen2.5-coder:7b', -- Example: "mistral", "llama3", etc.
      host = 'localhost',
      port = '11434', -- Ollama default port
      display_mode = 'float', -- Display results in floating window
    },
    keys = {
      {
        '<leader>o', -- Your preferred key
        ':Gen<CR>',
        desc = 'Generate with Ollama / gen.nvim',
      },
    },
  },
}
