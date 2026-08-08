return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "f-person/git-blame.nvim" },
  opts = function(_, opts)
    local git_blame = require("gitblame")

    -- Drop root_dir and diagnostics from LazyVim's default lualine_c, keep filetype icon + pretty_path
    table.remove(opts.sections.lualine_c, 1) -- root_dir
    table.remove(opts.sections.lualine_c, 1) -- diagnostics

    -- Navic after filename
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
