local telescope = require('telescope')
local telescope_builtin = require('telescope.builtin')

telescope.setup {
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
    }
  },
  pickers = {
    find_files = {
      find_command = { "fd", "--type", "f", "-H" }
    },
  }
}

telescope.load_extension('fzf')

local silent = { silent = true }

vim.keymap.set('n', '<C-p>', telescope_builtin.fd, silent)
vim.keymap.set('n', '<C-f>', telescope_builtin.current_buffer_fuzzy_find, silent)

vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, silent)
vim.keymap.set('n', '<leader>ff', telescope_builtin.live_grep, silent)
vim.keymap.set('n', '<leader>fj', telescope_builtin.jumplist, silent)
vim.keymap.set('n', '<leader>fc', telescope_builtin.commands, silent)
vim.keymap.set('n', '<leader>fl', telescope_builtin.loclist, silent)
vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, silent)
vim.keymap.set('n', '<leader>fd', telescope_builtin.diagnostics, silent)
vim.keymap.set('n', '<leader>fr', telescope_builtin.resume, silent)

-- Git
vim.keymap.set('n', '<leader>fg', telescope_builtin.git_branches, silent)

-- LSP
vim.keymap.set('n', '<leader>lfr', telescope_builtin.lsp_references, silent)
vim.keymap.set('n', '<leader>lfi', telescope_builtin.lsp_implementations, silent)
vim.keymap.set('n', '<leader>lfo', telescope_builtin.lsp_document_symbols, silent)
