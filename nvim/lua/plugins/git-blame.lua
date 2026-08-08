return {
  "f-person/git-blame.nvim",
  init = function()
    vim.g.gitblame_display_virtual_text = 0 -- Disable virtual text, use lualine_c instead
    vim.g.gitblame_date_format = "%r" -- relative time, e.g. "2 days ago"
    vim.g.gitblame_message_template = "<date> • <author> • <summary>"
  end,
}
