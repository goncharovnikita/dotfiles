require('onedark').setup()

function setupVscode()
    -- For light theme
    vim.g.vscode_style = "light"
    -- Enable italic comment
    vim.g.vscode_italic_comment = 1
    vim.cmd[[colorscheme vscode]]
end

