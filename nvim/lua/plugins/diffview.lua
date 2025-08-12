return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Open Git Diff" },
    { "<leader>gD", "<cmd>DiffviewClose<CR>", desc = "Close Git Diff" },
    { "<leader>gh", "<cmd>DiffviewFileHistory<CR>", desc = "Git File History" },
  },
  config = function()
    require("diffview").setup({
      use_icons = true,
      enhanced_diff_hl = true,
      view = {
        default = {
          layout = "diff2_horizontal",
        },
        merge_tool = {
          layout = "diff3_mixed",
          disable_diagnostics = true,
        },
      },
    })
  end,
}
