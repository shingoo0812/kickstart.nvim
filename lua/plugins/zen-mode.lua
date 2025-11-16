return {
  {
    'folke/zen-mode.nvim',
    cmd = 'ZenMode', -- :ZenMode で起動
    config = function()
      require('zen-mode').setup {
        window = {
          -- 幅を 80% に設定
          width = 0.8,
          -- 高さを自動
          height = 1,
          -- 中央寄せ
          options = {
            number = true, -- 行番号表示
            relativenumber = false,
            cursorline = true,
            foldcolumn = '0', -- 折りたたみ列非表示
            signcolumn = 'no',
          },
        },
        plugins = {
          options = {
            -- Zen モード中に無効化したい機能
            ruler = false,
            showcmd = false,
          },
          gitsigns = { enabled = true }, -- git 情報は残す
          tmux = false, -- tmux 連携
          twilight = { enabled = true }, -- twilight.nvim と併用する場合
        },
        on_open = function()
          print 'Zen mode activated!'
        end,
        on_close = function()
          print 'Zen mode closed!'
        end,
      }
    end,
  },
}
