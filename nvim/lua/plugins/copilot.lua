return {
  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = {
        debounce = 2000,
      },
    },
  },

  {
    "nvim-cmp",
    -- -@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, 1, {
        name = "copilot",
        group_index = 1,
        priority = -100,
      })
    end,
  },
}
