return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "f-person/git-blame.nvim" },
  opts = function(_, opts)
    local git_blame = require("gitblame")

    opts.sections.lualine_c = {}

    -- Navic after branch
    table.insert(opts.sections.lualine_c, {
      "navic",
      color_correction = "dynamic",
    })

    -- Git blame right-aligned
    opts.sections.lualine_x = opts.sections.lualine_x or {}
    table.insert(opts.sections.lualine_x, 1, {
      git_blame.get_current_blame_text,
      cond = git_blame.is_blame_text_available,
    })

    return opts
  end,
}
