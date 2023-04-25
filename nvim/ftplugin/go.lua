local ls = require("luasnip")
local fmta = require("luasnip.extras.fmt").fmta
local buf_util = require('util.buffer')
local Job = require('plenary.job')

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local vfn = vim.fn


local function_node_types = {
	function_declaration = true,
	method_declaration = true,
	func_literal = true,
}

local get_node_text = vim.treesitter.get_node_text

local transforms = {
	int = function(_)
		return { text = "0" }
	end,
	bool = function(_)
		return { text = "false" }
	end,
	string = function(_)
		return { text = [[""]] }
	end,
	error = function(_)
		return { text = 'fmt.Errorf(" %w", err)', type = "error" }
	end,
	-- Types with a "*" mean they are pointers, so return nil
	[function(text)
		return string.find(text, "*", 1, true) ~= nil
	end] = function(_, _)
		return { text = "nil" }
	end,
}

local function transform(text)
	local condition_matches = function(condition, ...)
		if type(condition) == "string" then
			return condition == text
		else
			return condition(...)
		end
	end

	for condition, result in pairs(transforms) do
		if condition_matches(condition, text) then
			return result(text)
		end
	end

	return text
end

local function transform_text_to_snippet(node)
	if node.type == "error" then
		return fmta('fmt.Errorf("<text> :%", err)', { text = i(1, "error") })
	end

	return { t(node.text) }
end

local handlers = {
	parameter_list = function(node)
		local result = {}

		local count = node:named_child_count()
		for idx = 0, count - 1 do
			local matching_node = node:named_child(idx)
			local type_node = matching_node:field("type")[1]

			table.insert(result, transform(get_node_text(type_node, 0)))

			if idx ~= count - 1 then
				table.insert(result, { text = ", " })
			end
		end

		return result
	end,
	type_identifier = function(node)
		local text = get_node_text(node, 0)
		return { transform(text) }
	end,
}

local function get_current_function_node(offset)
	local winn = vim.api.nvim_get_current_win()
	local bufn = vim.api.nvim_get_current_buf()
	local cl = vim.api.nvim_win_get_cursor(winn)
	local coln = cl[1] - offset
	local cursor_node = vim.treesitter.get_node({
			bufnr = bufn,
			pos = { coln, cl[2] }
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
	local func_node = get_current_function_node(0)

	if not func_node then
		return nil
	end

	return get_node_text(func_node:child(1), 0)
end

local function go_result_type()
	local function_node = get_current_function_node(0)

	if not function_node then
		function_node = get_current_function_node(4)
	end

	if not function_node then
		print "Not inside of a function"
		return t "Not inside of a function"
	end

	local query = vim.treesitter.parse_query("go",
			[[
      [
        (method_declaration result: (_) @id)
        (function_declaration result: (_) @id)
        (func_literal result: (_) @id)
      ]
    ]]
		)

	local result_types
	for _, node in query:iter_captures(function_node, 0) do
		if handlers[node:type()] then
			result_types = handlers[node:type()](node)

			break
		end
	end

	if not result_types then
		print "could not determine result type"
		return t "could not determine result type"
	end

	local result = {}
	for _, v in ipairs(result_types) do
		for _, snip in ipairs(transform_text_to_snippet(v)) do
			table.insert(result, snip)
		end
	end

	return result
end

local go_ret_vals = function()
	return ls.sn(
			nil,
			go_result_type()
		)
end

ls.add_snippets(nil, {
	go = {
		s("ve", {
			i(1, "v"), t(", err := "), i(2, "expr"),
			t({ "", "if err != nil {", "	" }),
			i(3, "cond"), t({ "", "}" })
		}),
		s("ctx", {
			t("context.Context"),
		}),
		s("ret", fmta("return <result>", { result = d(1, go_ret_vals, nil) })),
		s("efi", fmta([[
<val>, err := <f>(<args>)
if err != nil {
	return <result>
}
<finish>
]],
			{
				val = i(1),
				f = i(2),
				args = i(3),
				result = d(4, go_ret_vals),
				finish = i(0),
			}
		)
		),
	},
}, {
	key = "go-config"
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

local function insert_result(result)
	local curpos = vfn.getcurpos()
	local goto_l = string.format("goto %d", result["start"] + 1)
	vim.cmd(goto_l)
	local inserts = result.code
	inserts = vim.split(inserts, "\n")
	local change = string.format("normal! %ds%s", result["end"] - result.start, inserts[1])
	vim.cmd(change)
	vim.cmd("startinsert!")

	local curline = curpos[2]
	for i = 2, #inserts do
		print("append ", curline, inserts[i])
		vfn.append(curline, inserts[i])
		curline = curline + 1
	end

	vim.cmd("stopinsert!")
	vim.cmd("write")
	vfn.setpos(".", curpos)
	vim.defer_fn(function()
		format()
	end, 300)
end

local function fill(cmd)
	if cmd ~= "fillstruct" and cmd ~= "fillswitch" then
		error("cmd not supported ", cmd)
	end

	local file = vfn.expand("%:p")
	local line = vfn.line(".")
	local farg = string.format("-file=%s", file)
	local larg = string.format("-line=%d", line)
	local args = { cmd, farg, larg, "2>/dev/null" }

	vfn.jobstart(args, {
		on_stdout = function(_, str, _)
			if #str < 2 then
				return
			end
			local json = vfn.json_decode(str)
			if #json == 0 then
				vim.notify("reftools " .. cmd .. " finished with no result", vim.lsp.log_levels.DEBUG)
			end

			local result = json[1]
			insert_result(result)
		end,
	})
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

	vim.cmd('vsplit')
	local win = vim.api.nvim_get_current_win()

	cache[cache_key] = win

	return win
end

local function make_job_result_handler()
	local bh = get_test_result_buffer()
	local out_wiped = false

	return function(err, text)
		if not out_wiped then
			bh.wipe()
			out_wiped = true
		end

		vim.schedule(function()
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
end

local function runTests()
	local package = vim.fn.expand("%:p:h")

	prepare_test_buf_and_win("Running tests in " .. package)
	local on_result = make_job_result_handler()

	Job:new({
		command = 'go',
		args = { 'test', '-failfast', package },
		on_stdout = function(err, text)
			on_result(err, text)
		end,
		on_stderr = function(err, text)
			on_result(err, text)
		end
	}):start()
end

local function runFuncTests()
	local func_name = get_current_function_name()
	if not func_name then
		print("could not find current func name")
		return
	end

	prepare_test_buf_and_win("Running test for " .. func_name .. "...")
	local on_result = make_job_result_handler()

	Job:new({
		command = 'go',
		args = { 'test', '-run', func_name, vim.fn.expand('%:p:h') },
		on_stdout = function(err, text)
			on_result(err, text)
		end,
		on_stderr = function(err, text)
			on_result(err, text)
		end
	}):start()
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
		pattern = { fname }
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
		"-w", "-all",
	}

	if _G.localconfig and _G.localconfig.gotests_template_dir then
		table.insert(gotest_args, "-template")
		table.insert(gotest_args, _G.localconfig.gotests_template)

		table.insert(gotest_args, "-template_dir")
		table.insert(gotest_args, _G.localconfig.gotests_template_dir)
	end

	local file = vfn.expand("%:p")

	table.insert(gotest_args, file)

	Job:new({
		command = 'gotests',
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
		"-w", "-only", func_name,
	}

	if _G.localconfig and _G.localconfig.gotests_template_dir then
		table.insert(gotest_args, "-template")
		table.insert(gotest_args, _G.localconfig.gotests_template)

		table.insert(gotest_args, "-template_dir")
		table.insert(gotest_args, _G.localconfig.gotests_template_dir)
	end

	local file = vfn.expand("%:p")

	table.insert(gotest_args, file)

	Job:new({
		command = 'gotests',
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
	pattern = { "*.go" }
})

vim.keymap.set('n', '<leader>gfs', function() fill('fillstruct') end)

-- Test keymaps
vim.keymap.set('n', '<leader>tt', runTests)
vim.keymap.set('n', '<leader>tf', runFuncTests)
vim.keymap.set('n', '<leader>tr', getTestResults)
vim.keymap.set('n', '<leader>tc', cleanTestResults)
vim.keymap.set('n', '<leader>to', closeTestResultsWindow)
vim.keymap.set('n', '<leader>tar', runTestsOnSaveForFile)
vim.keymap.set('n', '<leader>tao', clearTestAugroupForFile)
vim.keymap.set('n', '<leader>tac', clearTestAugroups)

vim.keymap.set('n', '<leader>gtf', generateFuncTests)
vim.keymap.set('n', '<leader>gtt', generateFileTests)
