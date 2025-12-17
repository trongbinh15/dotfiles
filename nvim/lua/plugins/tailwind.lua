return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      tailwindcss = {
        filetypes_exclude = { "markdown" },
        filetypes_include = {},
        settings = {
          tailwindCSS = {
            classFunctions = { "tv", "cva" },
          },
        },
      },
    },
  },
}
