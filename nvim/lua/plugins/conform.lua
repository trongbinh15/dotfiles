return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      -- javascript = { "smart_biome" },
      typescript = { "smart_biome" },
      javascriptreact = { "smart_biome" },
      typescriptreact = { "smart_biome" },
      json = { "smart_biome" },
      jsonc = { "smart_biome" },
    },
    formatters = {
      smart_biome = {
        inherit = false,
        command = function(_, ctx)
          local root = vim.fs.root(ctx.dirname, { ".biome.json", ".biome.jsonc", ".git" })

          if
            root
            and (vim.fn.filereadable(root .. "/biome.json") == 1 or vim.fn.filereadable(root .. "/.biome.jsonc") == 1)
          then
            return "biome"
          else
            return "prettier"
          end
        end,
        args = function(_, ctx)
          local is_biome = vim.fn.exepath("biome") ~= ""
            and (vim.fs.find({ "biome.json", ".biome.jsonc" }, { upward = true, path = ctx.dirname })[1] ~= nil)

          if is_biome then
            return { "format", "--stdin-file-path", ctx.filename }
          else
            return { "--stdin-filepath", ctx.filename }
          end
        end,
        stdin = true,
      },
    },
  },
}
