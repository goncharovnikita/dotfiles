local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = {
		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<C-y>"] = cmp.config.disable,
		["<C-e>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		['<C-n>'] = function(fallback)
			if cmp.visible() then
			  cmp.select_next_item()
			else
			  fallback()
			end
		end,
		['<C-p>'] = function(fallback)
			if cmp.visible() then
			  cmp.select_prev_item()
			else
			  fallback()
			end
		end,
		["<CR>"] = cmp.mapping.confirm({ select = true })
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "nvim_lsp_signature_help" },
		{ name = 'luasnip' },
	}, {
		{ name = "buffer" },
	}),
})

cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "cmp_git" },
	}, {
		{ name = "buffer" },
	}),
})

cmp.setup.cmdline("/", {
	sources = {
		{ name = "buffer" },
	},
})

cmp.setup.cmdline(":", {
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})

