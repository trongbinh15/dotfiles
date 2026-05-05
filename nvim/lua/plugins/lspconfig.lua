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
      -- Disable biome LSP code actions to avoid biome 2.x rule name conflicts
      -- (formatting/organizing is handled by conform CLI instead)
      biome = {
        on_attach = function(client, _)
          client.server_capabilities.codeActionProvider = false
        end,
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
        filetypes_exclude = { "markdown" },
        filetypes_include = {},
      },
    },
  },
}
