return {
  'nosduco/remote-sshfs.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim' },
  opts = {
    -- SSHの接続設定
    connections = {
      -- 例: サーバー接続設定
      ssh_configs = {
        vim.fn.expand '$HOME' .. '/.ssh/config',
        -- 追加のSSH設定ファイルがあればここに追加
      },
      -- プリセット接続（オプション）
      -- my_server = {
      --   host = "example.com",
      --   username = "user",
      --   port = 22,
      --   remote_path = "/home/user/projects",
      -- },
    },
    -- マウント設定
    mounts = {
      base_dir = vim.fn.expand '$HOME' .. '/.sshfs/',
      unmount_on_exit = true,
    },
    -- ハンドラー設定
    handlers = {
      on_connect = {
        change_dir = true,
      },
      on_disconnect = {
        clean_mount_folders = false,
      },
    },
    -- UI設定
    ui = {
      confirm = {
        connect = true,
        change_dir = false,
      },
    },
    -- ログレベル
    log = {
      enable = false,
      truncate = false,
      types = {
        all = false,
        util = false,
        handler = false,
        sshfs = false,
      },
    },
  },
  keys = {
    {
      '<leader>rc',
      function()
        require('remote-sshfs').connect()
      end,
      desc = '[R]emote [C]onnect',
    },
    {
      '<leader>rd',
      function()
        require('remote-sshfs').disconnect()
      end,
      desc = '[R]emote [D]isconnect',
    },
    {
      '<leader>re',
      function()
        require('remote-sshfs').edit()
      end,
      desc = '[R]emote [E]dit',
    },
  },
}
