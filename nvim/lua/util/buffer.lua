local function new()
	local buf_util = {}

	function buf_util.create_buffer_handler(buf)
		local bh = {}

		local curr_lines = {}
		local curr_lines_count = 0
		local debug_info_cb = nil

		local function add_curr_line(text)
			table.insert(curr_lines, text)
			curr_lines_count = curr_lines_count + 1
		end

		local function wipe_curr_lines()
			curr_lines = {}

			vim.api.nvim_buf_set_lines(buf, 0, curr_lines_count, false, curr_lines)

			curr_lines_count = 0
		end

		function bh.with_debug_info(cb)
			debug_info_cb = cb
		end

		function bh.wipe()
			wipe_curr_lines()
		end

		function bh.write(text)
			if not text then
				return
			end

			curr_lines = {}

			if debug_info_cb then
				text = debug_info_cb() .. text
			end

			local lines = vim.split(text, "\n")

			bh.write_lines(lines)
		end

		function bh.write_lines(lines)
			if not lines then
				return
			end

			curr_lines = {}

			for _, line in pairs(lines) do
				add_curr_line(line)
			end

			vim.api.nvim_buf_set_lines(buf, 0, curr_lines_count, false, curr_lines)
		end

		function bh.append(text)
			if not text then
				return
			end

			if curr_lines_count == 0 and debug_info_cb then
				text = debug_info_cb() .. text
			end

			local write_from = curr_lines_count

			local lines = vim.split(text, "\n")

			for _, line in pairs(lines) do
				add_curr_line(line)
			end

			local write_to = curr_lines_count

			vim.api.nvim_buf_set_lines(buf, write_from, write_to, false, lines)
		end

		function bh.attach_to_win(win)
			vim.api.nvim_win_set_buf(win, buf)
		end

		function bh.set_filetype(ft)
			vim.api.nvim_buf_set_option(buf, "filetype", ft)
		end

		function bh.set_name(name)
			vim.api.nvim_buf_set_name(buf, name)
		end

		function bh.get_buffer()
			return buf
		end

		return bh
	end

	return buf_util
end

return {
	new = new,
	singleton = new(),
}
