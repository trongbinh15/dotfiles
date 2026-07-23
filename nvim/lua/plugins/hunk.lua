return {
  "julienvincent/hunk.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  cmd = { "DiffEditor" },
  keys = {
    { "<leader>gH", "<cmd>DiffEditor<CR>", desc = "Hunk Diff Editor" },
  },
  config = function()
    require("hunk").setup({
      keys = {
        global = {
          quit = { "q" },
          accept = { "<leader><Cr>" },
          focus_tree = { "<leader>e" },
        },
        tree = {
          expand_node = { "l", "<Right>" },
          collapse_node = { "h", "<Left>" },
          open_file = { "<Cr>" },
          toggle_file = { "a" },
        },
        diff = {
          toggle_hunk = { "A" },
          toggle_line = { "a" },
          toggle_line_pair = { "s" },
          prev_hunk = { "[h" },
          next_hunk = { "]h" },
          toggle_focus = { "<Tab>" },
        },
      },
      ui = {
        layout = "vertical",
      },
    })
  end,
}
