local ts_utils = require('nvim-treesitter.ts_utils')
local get_node_text = vim.treesitter.query.get_node_text

local default_config = {
	bin = 'gotests',
	test_template = '',
	test_dir = '',
	parallel = false,
}

local run = function(setup, config)
	if config and config.dry_run then
		print("dry run " .. vim.inspect(setup))
		return
	end

	print("running " .. vim.inspect(setup))

	vim.fn.jobstart(setup, {
		stdout_buffered = true,
		on_stdout = function(_, data, _)
			print("unit tests generate " .. vim.inspect(data))
		end,
	})
end

local function get_function_name_at_cursor()
	local current_node = ts_utils.get_node_at_cursor()
	if not current_node then return { err = "no node at cursor found" } end

	local expr = current_node

	while expr do
		print(expr:type())
		if expr:type() == 'function_definition' then
			return { result = (get_node_text(expr:child(1)))[1] }
		end
		if expr:type() == 'function_declaration' then
			print('1', get_node_text(expr)[1])
			return { result = (get_node_text(expr:child(1)))[1] }
		end
		if expr:type() == 'method_declaration' then
			return { result = (get_node_text(expr:child(2)))[1] }
		end
		expr = expr:parent()
	end

	return { err = "no function found" }
end

local new_args = function(config)
	local cfg = config or default_config
	for k, v in pairs(default_config) do
		if cfg[k] == nil then
			cfg[k] = v
		end
	end

	local args = { cfg.bin }
	if cfg.parallel then
		table.insert(args, "-parallel")
	end
	if string.len(cfg.test_template) > 0 then
		table.insert(args, "-template")
		table.insert(args, cfg.test_template)
		if string.len(cfg.test_dir) > 0 then
			table.insert(args, "-template_dir")
			table.insert(args, cfg.test_dir)
		end
	end
	return args
end

local fun_test = function(config)
	local curr_function_name = get_function_name_at_cursor()

	if curr_function_name.err then
		print(curr_function_name.err)
		return
	end

	local args = new_args(config)
	local curr_file = vim.fn.expand("%")

	table.insert(args, "-only")
	table.insert(args, "^" .. curr_function_name.result .. "$")

	table.insert(args, "-w")
	table.insert(args, curr_file)

	run(args, config)
end

local all_test = function(parallel)
	-- TODO: tbd
end

local exported_test = function(parallel)
	-- TODO: tbd
end



return {
	fun_test = fun_test,
	all_test = all_test,
	exported_test = exported_test,
}
