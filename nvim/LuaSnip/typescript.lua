-- ~/.config/nvim/LuaSnip/typescript.lua
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

local snippets = {
  s("ie", t('import * as E from "fp-ts/Either";')),
  s("ite", t('import * as TE from "fp-ts/TaskEither";')),
  s("irte", t('import * as RTE from "fp-ts/ReaderTaskEither";')),
  s("ip", t('import { pipe } from "fp-ts/function";')),
  s("iopt", t('import * as O from "fp-ts/Option";')),
  s("iti", t('import invariant from "tiny-invariant";')),
}

ls.add_snippets("typescript", snippets)
ls.add_snippets("typescriptreact", snippets)
