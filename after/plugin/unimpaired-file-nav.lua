vim.keymap.set("n", "]f", function()
  require("utils.file_nav").sibling_file(1)
end, { silent = true, desc = "Next sibling file" })

vim.keymap.set("n", "[f", function()
  require("utils.file_nav").sibling_file(-1)
end, { silent = true, desc = "Previous sibling file" })
