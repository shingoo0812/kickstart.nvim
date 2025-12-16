return {
  {
    'David-Kunz/gen.nvim',
    opts = {
      model = 'qwen2.5-coder:7b', -- 例: "mistral", "llama3", など
      host = 'localhost',
      port = '11434', -- Ollama デフォルトポート
      display_mode = 'float', -- 結果を浮動ウィンドウで表示
    },
    keys = {
      {
        '<leader>o', -- 好きなキー
        ':Gen<CR>',
        desc = 'Generate with Ollama / gen.nvim',
      },
    },
  },
}
