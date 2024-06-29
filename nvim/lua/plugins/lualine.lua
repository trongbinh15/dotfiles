return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function()
    local git_blame = require("gitblame")
    return {
      sections = {
        lualine_c = {
          { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available },
        },
      },
    }
  end,
}
