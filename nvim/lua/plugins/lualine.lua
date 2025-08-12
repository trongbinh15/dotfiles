return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "f-person/git-blame.nvim" },
  opts = function(_, opts)
    local git_blame = require("gitblame")

    -- Do NOT add Navic in lualine_c
    opts.sections.lualine_c = {}

    -- Git blame in center
    table.insert(opts.sections.lualine_c, {
      git_blame.get_current_blame_text,
      cond = git_blame.is_blame_text_available,
    })

    opts.sections.lualine_x = opts.sections.lualine_x or {}
    table.insert(opts.sections.lualine_x, {
      "navic",
      color_correction = "dynamic",
      navic_opts = nil,
    })

    return opts
  end,
}
