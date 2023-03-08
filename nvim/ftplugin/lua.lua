local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

ls.add_snippets(nil, {
	lua = {
		s("ff", fmta([[
		function <name>(<args>)
			<body>
		end
		]], {
			name = i(1),
			args = i(2),
			body = i(0),
		}))
	},
}, {
	key = "lua-config"
})
