local M = { "biome", "prettier", "eslint" }
return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      javascript = M,
      typescript = M,
      javascriptreact = M,
      typescriptreact = M,
    },
  },
}
