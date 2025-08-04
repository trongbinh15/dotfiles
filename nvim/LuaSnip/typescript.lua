-- ~/.config/nvim/LuaSnip/typescript.lua
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

-- Define your snippet once
local ite = s("ite", {
  t('import * as TE from "fp-ts/TaskEither";'),
})

-- Register snippet for all relevant filetypes
ls.add_snippets("typescript", { ite })
ls.add_snippets("typescriptreact", { ite })
ls.add_snippets("javascript", { ite })
ls.add_snippets("javascriptreact", { ite })
