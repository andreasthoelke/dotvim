-- Ensure 'magenta' files use treesitter markdown syntax and settings

-- Set up the same treesitter folding settings used for markdown
vim.api.nvim_create_autocmd({"FileType"}, {
  pattern = {"magenta"},
  callback = function()
    -- Enable treesitter folding
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo.foldenable = true
    vim.wo.foldlevel = 99
    
    -- Apply any other markdown-specific settings you want to use
    -- These settings will only apply to magenta files
  end
})