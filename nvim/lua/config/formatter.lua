require('formatter').setup({
  filetype = {
     lua = {
      function()
        return {
          exe = "stylua",
          args = {
            "--config-path "
              .. os.getenv("XDG_CONFIG_HOME")
              .. "/stylua/stylua.toml",
            "-",
          },
          stdin = true,
        }
      end,
    },
  }
})
