local telescope = require('telescope')

telescope.setup {
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		}
	},
	pickers = {
		find_files = {
			find_command = { "fd", "--type", "f", "-H" }
		},
	}
}

telescope.load_extension('fzf')

