return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      javascript = { "biome" },
      typescript = { "biome" },
      javascriptreact = { "biome" },
      typescriptreact = { "biome" },
      json = { "biome" },
      jsonc = { "biome" },
    },
    formatters = {
      biome = {
        inherit = false,
        command = "biome",
        args = { "check", "--write", "--stdin-file-path", "$FILENAME" },
        stdin = true,
      },
    },
  },
}
