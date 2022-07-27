local gotests = require('nvim-gotests')

vim.keymap.set('n', '<leader>gat', function() gotests.fun_test() end, {})
