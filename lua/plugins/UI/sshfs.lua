return {
  'nosduco/remote-sshfs.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim' },
  opts = {
    -- SSH connection configuration
    connections = {
      -- Example: Server connection configuration
      ssh_configs = {
        vim.fn.expand '$HOME' .. '/.ssh/config',
        -- Add additional SSH config files here if available
      },
      -- Preset connections (optional)
      -- my_server = {
      --   host = "example.com",
      --   username = "user",
      --   port = 22,
      --   remote_path = "/home/user/projects",
      -- },
    },
    -- Mount configuration
    mounts = {
      base_dir = vim.fn.expand '$HOME' .. '/.sshfs/',
      unmount_on_exit = true,
    },
    -- Handler configuration
    handlers = {
      on_connect = {
        change_dir = true,
      },
      on_disconnect = {
        clean_mount_folders = false,
      },
    },
    -- UIConfiguration
    ui = {
      confirm = {
        connect = true,
        change_dir = false,
      },
    },
    -- Log level
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
