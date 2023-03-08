local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

vim.keymap.set('i', '<c-k>', function ()
	if ls.expand_or_jumpable() then
        ls.expand_or_jump()
	end
end, { silent = true })

