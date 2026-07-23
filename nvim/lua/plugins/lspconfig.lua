return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      -- Disable vtsls organize imports — biome handles it via conform
      vtsls = {
        settings = {
          typescript = {
            preferences = { organizeImports = false },
          },
          javascript = {
            preferences = { organizeImports = false },
          },
        },
      },
    },
  },
}
