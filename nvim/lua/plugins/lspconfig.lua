return {
  "neovim/nvim-lspconfig",
  otps = {
    servers = {
      eslint = {
        settings = {
          -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
          workingDirectories = { mode = "auto" },
        },
      },
      tailwindcss = {
        settings = {

          lint = {
            cssConflict = "ignore",
          },
          experimental = {
            classRegex = {
              "tv\\(([^)]*)\\)",
            },
          },
        },
        -- exclude a filetype from the default_config
        filetypes_exclude = { "markdown" },
        -- add additional filetypes to the default_config
        filetypes_include = {},
        -- to fully override the default_config, change the below
        -- filetypes = {}
      },
    },
  },
}
