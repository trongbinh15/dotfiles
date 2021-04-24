require('formatter').setup({
    logging = false,
    filetype = {
        typescriptreact = {
          -- prettier
         function()
            return {
              exe = "prettierd",
              args = { vim.api.nvim_buf_get_name(0) },
              stdin = true
            }
          end
      },

        scss = {
          -- prettier
         function()
            return {
              exe = "prettierd",
              args = { vim.api.nvim_buf_get_name(0) },
              stdin = true
            }
          end
      },
    --   rust = {
    --     -- Rustfmt
    --     function()
    --       return {
    --         exe = "rustfmt",
    --         args = {"--emit=stdout"},
    --         stdin = true
    --       }
    --     end
    --   },
    --   lua = {
    --       -- luafmt
    --       function()
    --         return {
    --           exe = "luafmt",
    --           args = {"--indent-count", 2, "--stdin"},
    --           stdin = true
    --         }
    --       end
    --     }
    }
})

vim.api.nvim_exec([[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.tsx,*.scss, FormatWrite
augroup END
]], true)