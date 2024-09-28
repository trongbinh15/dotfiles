-- with an optional config
return {
  "gaelph/logsitter.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("logsitter").setup({
      path_format = "default",
      prefix = "[LS] ->",
      separator = "->",
    })
    vim.api.nvim_set_keymap("n", "<leader>c,", "<cmd>Logsitter<CR>", { noremap = true, silent = true })
  end,
}
