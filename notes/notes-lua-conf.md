
# Lua config

alias del='trash'

command! Scrlua lua require'test1'.makeScratch()

lua require'test1'.abc()

echo 'test'

echo v:lua.vim.fn.stdpath("data")







