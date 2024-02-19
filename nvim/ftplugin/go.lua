local ls = require("luasnip")
local fmta = require("luasnip.extras.fmt").fmta
local buf_util = require("util.buffer").new()
local Job = require("plenary.job")

local function_node_types = {
	function_declaration = true,
	method_declaration = true,
	func_literal = true,
}

---@param node FuncReturnType
local function transform_func_return_type_to_snippet(node)
	if node.type == "error" then
		return fmta('fmt.Errorf("<text>: %w", err)', { text = ls.insert_node(1, "error") })
	end

	if node.name then
		return { ls.insert_node(1, node.name) }
	end

	return { ls.insert_node(1, "") }
end

---@class FuncReturnType
---@field type string
---@field name string

---@private
---@param func_node TSNode
---@return FuncReturnType[]
local function generate_func_return_from_node(func_node)
	local node_start, _, node_stop, _ = func_node:range()

	local query = vim.treesitter.query.parse(
		"go",
		[[
	[
		(function_declaration name: (_)
			result: [
				(parameter_list (
					parameter_declaration
					  name: (_) @param_name
					  type: (_) @param_type
				))
				(parameter_list (
					parameter_declaration
					  type: (_) @param_type
				))
				(type_identifier) @param_type
			]
		)
		(method_declaration name: (_)
			result: [
				(parameter_list (
					parameter_declaration
					  name: (_) @param_name
					  type: (_) @param_type
				))
				(parameter_list (
					parameter_declaration
					  type: (_) @param_type
				))
				(type_identifier) @param_type
			]
		)
		(func_literal
			result: [
				(parameter_list (
					parameter_declaration
					  name: (_) @param_name
					  type: (_) @param_type
				))
				(parameter_list (
					parameter_declaration
					  type: (_) @param_type
				))
				(type_identifier) @param_type
			]
		)
	]
]]
	)

	local return_nodes = {}
	local curr_node = {}

	for id, node in query:iter_captures(func_node, 0, node_start, node_stop) do
		local name = query.captures[id]

		if name == "param_name" then
			curr_node["name"] = vim.treesitter.get_node_text(node, 0)
		elseif name == "param_type" then
			curr_node["type"] = vim.treesitter.get_node_text(node, 0)

			table.insert(return_nodes, curr_node)

			curr_node = {}
		end
	end

	return return_nodes
end

---@return TSNode|nil
local function get_current_function_node()
	local bufn = vim.api.nvim_get_current_buf()
	local cursor_node = vim.treesitter.get_node({
		bufnr = bufn,
	})

	local function_node = cursor_node

	while function_node do
		if function_node_types[function_node:type()] then
			break
		end

		function_node = function_node:parent()
	end

	return function_node
end

local function get_current_function_name()
	local func_node = get_current_function_node()

	if not func_node then
		return nil
	end

	return vim.treesitter.get_node_text(func_node:child(1), 0)
end

local function create_go_return_type_snippet()
	local function_node = get_current_function_node()

	if not function_node then
		return ls.text_node("Not inside of a function")
	end

	local func_return = generate_func_return_from_node(function_node)

	if not func_return then
		return ls.text_node("Could not determine result type")
	end

	local result = {}

	for idx, node in ipairs(func_return) do
		local sn = {}

		for _, snip in ipairs(transform_func_return_type_to_snippet(node)) do
			table.insert(sn, snip)
		end

		table.insert(result, ls.snippet_node(idx, sn))

		if idx < #func_return then
			table.insert(result, ls.text_node(", "))
		end
	end

	return ls.sn(nil, result)
end

ls.add_snippets(nil, {
	go = {
		ls.snippet("ctx", { ls.text_node("context.Context") }),
		ls.snippet("ret", fmta("return <result>", { result = ls.dynamic_node(1, create_go_return_type_snippet, nil) })),
		ls.snippet(
			"efi",
			fmta(
				[[
<val>, err := <f>(<args>)
if err != nil {
	return <result>
}
<finish>
]],
				{
					val = ls.insert_node(1),
					f = ls.insert_node(2),
					args = ls.insert_node(3),
					result = ls.dynamic_node(4, create_go_return_type_snippet),
					finish = ls.insert_node(0),
				}
			)
		),
	},
}, {
	key = "go-config",
})

local function orgImports(wait_ms)
	local params = vim.lsp.util.make_range_params()
	params.context = { only = { "source.organizeImports" } }
	local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
	for _, res in pairs(result or {}) do
		for _, r in pairs(res.result or {}) do
			if r.edit then
				vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
			else
				vim.lsp.buf.execute_command(r.command)
			end
		end
	end
end

local function format()
	orgImports(1000)
	vim.lsp.buf.format()
end

local cache = {}
local test_augroups = {}

local function get_test_result_buffer()
	local cache_key = "test_result_buffer"

	local cached = cache[cache_key]

	if cached then
		return cached
	end

	local buf = vim.api.nvim_create_buf(false, true)
	local bh = buf_util.create_buffer_handler(buf)

	cache[cache_key] = bh

	return bh
end

local function is_win_visible(target_win)
	local active_wins = vim.api.nvim_tabpage_list_wins(0)
	for _, win in pairs(active_wins) do
		if win == target_win then
			return true
		end
	end

	return false
end

local function get_test_result_win()
	local cache_key = "test_result_win"

	local cached = cache[cache_key]

	if cached then
		if is_win_visible(cached) then
			return cached
		end

		if vim.api.nvim_win_is_valid(cached) then
			vim.api.nvim_win_close(cached, true)
		end
	end

	vim.cmd("vsplit")
	local win = vim.api.nvim_get_current_win()

	cache[cache_key] = win

	return win
end

local function make_job_result_handler()
	local bh = get_test_result_buffer()
	local out_wiped = false

	return function(err, text)
		vim.schedule(function()
			if not out_wiped then
				bh.wipe()
				out_wiped = true
			end

			if err then
				bh.write(err)
			else
				bh.append(text)
			end
		end)
	end
end

local function prepare_test_buf_and_win(title_text)
	local current_win = vim.api.nvim_get_current_win()
	local bh = get_test_result_buffer()
	local win = get_test_result_win()

	bh.attach_to_win(win)

	if title_text then
		bh.write(title_text)
	end

	vim.api.nvim_set_current_win(current_win)

	return bh
end

local function runTests()
	local package = vim.fn.expand("%:p:h")

	prepare_test_buf_and_win("Running tests in " .. package)
	local on_result = make_job_result_handler()

	Job:new({
		command = "go",
		args = { "test", "-failfast", package },
		on_stdout = function(err, text)
			on_result(err, text)
		end,
		on_stderr = function(err, text)
			on_result(err, text)
		end,
	}):start()
end

local function runFuncTests()
	local func_name = get_current_function_name()
	local file_name = vim.fn.expand("%:p:h")

	if not func_name then
		print("could not find current func name")
		return
	end

	local templateText = "Running test for " .. func_name .. "..."
	local bh = prepare_test_buf_and_win(templateText)
	local on_result = make_job_result_handler()

	local runJob = function()
		vim.schedule(function()
			bh.wipe()
			bh.write(templateText)

			Job:new({
				command = "go",
				args = { "test", "-run", func_name, "-count=1", file_name },
				on_stdout = function(err, text)
					on_result(err, text)
				end,
				on_stderr = function(err, text)
					on_result(err, text)
				end,
			}):start()
		end)
	end

	vim.keymap.set("n", "r", runJob, { buffer = bh.get_buffer(), silent = true })

	runJob()
end

local function getTestResults()
	prepare_test_buf_and_win()
end

local function cleanTestResults()
	local bh = get_test_result_buffer()
	bh.wipe()
	bh.write("")
end

local function closeTestResultsWindow()
	local win = get_test_result_win()
	vim.api.nvim_win_close(win, true)
end

local function listTestsInFile()
	local win = prepare_test_buf_and_win("File tests:")
	local bufn = vim.api.nvim_get_current_buf()
	local root_node = vim.treesitter
		.get_node({
			bufnr = bufn,
		})
		:root()
	local query = vim.treesitter.query.parse(
		"go",
		[[
		[
			(
			 (method_declaration
			     	name: (_) @name
					parameters: (_) @params)
				(#match? @name "^Test.+")
				(#eq? @params "(t *testing.T)")
			)
			(
			 (function_declaration
			     	name: (_) @name
					parameters: (_) @params)
				(#match? @name "^Test.+")
				(#eq? @params "(t *testing.T)")
			)
		]
    ]]
	)

	vim.print(root_node)
	local func_names = {}

	for id, node, metadata in query:iter_captures(root_node, bufn) do
		local name = query.captures[id] -- name of the capture in the query
		local type = node:type() -- type of the captured node

		vim.print(name)
		vim.print(type)

		if name == "name" then
			local func_name = vim.treesitter.get_node_text(node, bufn, {
				metadata = metadata,
			})
			table.insert(func_names, func_name)
		end
	end

	win.write_lines(func_names)
end

local function runTestsOnSaveForFile()
	local fname = vim.fn.expand("%")
	local augroup_name = "go_auto_tests_" .. fname

	if test_augroups[augroup_name] then
		return
	end

	local group = vim.api.nvim_create_augroup(augroup_name, { clear = true })
	vim.api.nvim_create_autocmd({ "BufWritePost" }, {
		group = group,
		callback = function()
			runTests()
		end,
		pattern = { fname },
	})

	test_augroups[augroup_name] = group
end

local function clearTestAugroupForFile()
	local fname = vim.fn.expand("%")
	local augroup_name = "go_auto_tests_" .. fname
	local group = test_augroups[augroup_name]

	if group then
		vim.api.nvim_del_augroup_by_id(group)
		test_augroups[augroup_name] = nil
	end
end

local function clearTestAugroups()
	for name, group in pairs(test_augroups) do
		vim.api.nvim_del_augroup_by_id(group)
		test_augroups[name] = nil
	end
end

local function generateFileTests()
	local function handle_result(err, text)
		if not err then
			print(text)
		else
			print(err)
		end
	end

	local gotest_args = {
		"-w",
		"-all",
	}

	if _G.localconfig and _G.localconfig.gotests_template_dir then
		table.insert(gotest_args, "-template")
		table.insert(gotest_args, _G.localconfig.gotests_template)

		table.insert(gotest_args, "-template_dir")
		table.insert(gotest_args, _G.localconfig.gotests_template_dir)
	end

	local file = vim.fn.expand("%:p")

	table.insert(gotest_args, file)

	Job:new({
		command = "gotests",
		args = gotest_args,
		on_stdout = handle_result,
		on_stderr = handle_result,
	}):start()
end

local function generateFuncTests()
	local func_name = get_current_function_name()
	if not func_name then
		print("could not find current func name")
		return
	end

	local function handle_result(err, text)
		if not err then
			print(text)
		else
			print(err)
		end
	end

	local gotest_args = {
		"-w",
		"-only",
		func_name,
	}

	if _G.localconfig and _G.localconfig.gotests_template_dir then
		table.insert(gotest_args, "-template")
		table.insert(gotest_args, _G.localconfig.gotests_template)

		table.insert(gotest_args, "-template_dir")
		table.insert(gotest_args, _G.localconfig.gotests_template_dir)
	end

	local file = vim.fn.expand("%:p")

	table.insert(gotest_args, file)

	Job:new({
		command = "gotests",
		args = gotest_args,
		on_stdout = handle_result,
		on_stderr = handle_result,
	}):start()
end

vim.api.nvim_create_user_command("GoTest", runTests, {})
vim.api.nvim_create_user_command("GoTestFunc", runFuncTests, {})
vim.api.nvim_create_user_command("GoTestResults", getTestResults, {})
vim.api.nvim_create_user_command("GoTestResultsClean", cleanTestResults, {})

vim.api.nvim_create_augroup("goformat", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = "goformat",
	callback = format,
	pattern = { "*.go" },
})

-- Test keymaps
vim.keymap.set("n", "<leader>tt", runTests)
vim.keymap.set("n", "<leader>tf", runFuncTests)
vim.keymap.set("n", "<leader>tr", getTestResults)
vim.keymap.set("n", "<leader>tc", cleanTestResults)
vim.keymap.set("n", "<leader>to", closeTestResultsWindow)
vim.keymap.set("n", "<leader>tar", runTestsOnSaveForFile)
vim.keymap.set("n", "<leader>tao", clearTestAugroupForFile)
vim.keymap.set("n", "<leader>tac", clearTestAugroups)

vim.keymap.set("n", "<leader>lf", listTestsInFile)

vim.keymap.set("n", "<leader>gtf", generateFuncTests)
vim.keymap.set("n", "<leader>gtt", generateFileTests)
