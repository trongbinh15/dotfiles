-- LazyVim sets its own <C-h/j/k/l> -> <C-w>h/j/k/l window-nav keymaps in a
-- VeryLazy autocmd (lazyvim.config.keymaps), which runs AFTER this plugin's
-- config() on startup and would clobber our mappings. Defer with
-- LazyVim.on_very_lazy so ours registers (and wins) after LazyVim's defaults.
return {
  {
    "vim-herdr-navigation",
    dir = vim.fn.expand("~/dotfiles/herdr/plugins/vim-herdr-navigation"),
    lazy = false,
    config = function()
      require("lazyvim.util").on_very_lazy(function()
        dofile(vim.fn.expand("~/dotfiles/herdr/plugins/vim-herdr-navigation/editor/nvim.lua"))
      end)
    end,
  },
}
