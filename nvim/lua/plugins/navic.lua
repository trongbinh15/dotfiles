return {
  {
    "SmiteshP/nvim-navic",
    opts = function(_, opts)
      opts.icons = vim.tbl_extend("force", opts.icons, {
        Property = "> ",
      })
      return opts
    end,
  },
}
