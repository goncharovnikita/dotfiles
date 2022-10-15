local map = require('config.utils').map
local gotests = require('plugins.gotests')
local silent = { silent = true }
local vfn = vim.fn

local function orgImports(wait_ms)
	local params = vim.lsp.util.make_range_params()
	params.context = {only = {"source.organizeImports"}}
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
	vim.lsp.buf.formatting_sync()
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
  print(change)
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


vim.api.nvim_create_augroup("goformat", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = "goformat",
	callback = format,
	pattern = { "*.go" }
})

vim.keymap.set('n', '<leader>gfs', function() fill('fillstruct') end)
vim.keymap.set('n', '<leader>gat', function() gotests.fun_test() end)
map('n', '<leader>gtf', [[<cmd>GoTestFunc<cr>]], silent)

