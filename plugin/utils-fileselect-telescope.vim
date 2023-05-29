
" maps now in plugin/utils_general_maps.lua
" Focused search maps with presets/filters

" search in vim comment TAGS: in local project
" nnoremap ,st       <cmd>Telescope live_grep default_text=[A-Z]{4}:.*<cr>

" search all text in designated PATTERN: files
" nnoremap ,sp <cmd>lua require('utils_general').Search_patternfiles()<cr>

" search in COMMENTS: in select files across select projects
" nnoremap ,sc <cmd>lua require('utils_general').Search_comments()<cr>

" search in HEADERS: in select files across select projects
" nnoremap ,sh <cmd>lua require('utils_general').Search_headers()<cr>


" lua vim.g.rgx_caps_tags = [[\s[A-Z]{3,}:]]


" ─   Rgx select pickers                                ──

lua << EOF

EOF

" ~/.config/nvim/plugged/telescope.nvim/doc/telescope.txt

" nnoremap ,ss <cmd>lua require('utils_general').Rg_RegexSelect_Picker({}, vim.g.rgx_caps_tags, vim.g.glob_sct1)<cr>
" nnoremap ,ss <cmd>lua require('utils_general').Rg_RegexSelect_Picker({}, [[\s[A-Z]{3,}:]], {"-g", "**/AZioHttp/*.md", "-g", "**/BZioHttp/*.scala"})<cr>
" nnoremap ,ss <cmd>lua require('utils_general').Colors()<cr>
" nnoremap ,sg <cmd>lua require('utils_general').Colors(require("telescope.themes").get_dropdown{})<cr>


" nnoremap <leader>tg <cmd>lua my_git_bcommits()<cr>


 " (:.*List.*(\)|=))@=

nnoremap <leader>te :Telescope 

nnoremap <leader>th <cmd>Telescope help_tags initial_mode=insert<cr>
nnoremap <leader>ts <cmd>Telescope sessions<cr>
nnoremap <leader>tr <cmd>Telescope repo list layout_strategy=vertical<cr>
" nnoremap <leader>tb <cmd>Telescope bookmarks selected_browser=chrome<cr>
nnoremap <leader>tp <cmd>Telescope project<cr>
" NOTE: these map  ~/.config/nvim/help.md#/###%20telescope%20project
nnoremap <leader><leader>ts <cmd>Telescope highlights<cr>
nnoremap <leader><leader>tS <cmd>TSHighlightCapturesUnderCursor<cr>

" Find files using Telescope command-line sugar.
nnoremap <leader>fR <cmd>Telescope lsp_references<cr>

nnoremap <leader>fs <cmd>Telescope lsp_dynamic_workspace_symbols<cr>
nnoremap <leader>ff <cmd>Telescope find_files hidden=true<cr>
nnoremap <leader>fo <cmd>Telescope oldfiles<cr>
nnoremap <leader>fF <cmd>Telescope file_browser<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>

nnoremap ,sa <cmd>Telescope live_grep glob_pattern=*.scala<cr>


" nnoremap ,,sr       <cmd>Telescope grep_string<cr>
" nnoremap <leader>fg <cmd>Telescope live_grep layout_strategy=vertical<cr>
" nnoremap <leader>fb <cmd>Telescope buffers<cr>
" this is now used for chrome bookmarksearch, use 'go' instead

" nnoremap <silent> <leader>gp :<C-u>FzfHistory<CR>
nnoremap <silent> gp <cmd>Telescope oldfiles<cr>
" nnoremap <silent> <leader>go :<C-u>FzfBuffer<cr>
nnoremap <silent> go <cmd>Telescope buffers<cr>

" Using Lua functions
nnoremap <leader>tt <cmd>lua require('telescope.builtin').resume()<cr>
nnoremap <leader>tb <cmd>lua require('telescope').extensions.bookmarks.bookmarks()<cr>
nnoremap <leader>fb <cmd>lua require('telescope').extensions.bookmarks.bookmarks()<cr>
" nnoremap <leader>gp <cmd>lua require('telescope.builtin').oldfiles()<cr>
" nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
" nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
" nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
" nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

" BOOKMARKS:
" nnoremap <leader>bs <cmd>lua require('telescope').extensions.vim_bookmarks.all({ width_line=0, width_text=40, shorten_path=true })<cr>

" another rel map  ~/.config/nvim/plugin/file-manage.vim#/nnoremap%20<leader>ob%20.Telescope

" example evaluating a contatinated string as a command
" nnoremap ,sp       :exec 'Telescope live_grep glob_pattern=*+(_patterns\|utils).scala cwd=' . g:ScalaPatternsDir<cr>

" nnoremap <leader>bk <cmd>lua require('utils_general').fileViewB()<cr>

" interesting but not really my thing
" Telescope file_browser

" lua require('telescope').setup{ defaults = { layout_strategy = 'vertical', layout_config = { prompt_position = 'top', mirror = true, width = 0.95, height = 0.95 }, }, }
" Telescope find_files hidden=true layout_config={"prompt_position":"top"}
" Telescope grep_string search="gsr"


" These don't work.
" lua require('telescope').setup()
" lua require('telescope').load_extension('fzy_native')

" Not needed, as it loads lazily
" lua require'telescope.builtin'.planets{}
" lua require('telescope').load_extension('gh')

" from https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua
" --Add leader shortcuts
" vim.api.nvim_set_keymap('n', '<leader><space>', [[<cmd>lua require('telescope.builtin').buffers()<CR>]], { noremap = true, silent = true })
" vim.api.nvim_set_keymap('n', '<leader>sf', [[<cmd>lua require('telescope.builtin').find_files({previewer = false})<CR>]], { noremap = true, silent = true })
" vim.api.nvim_set_keymap('n', '<leader>sb', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]], { noremap = true, silent = true })
" vim.api.nvim_set_keymap('n', '<leader>sh', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]], { noremap = true, silent = true })
" vim.api.nvim_set_keymap('n', '<leader>st', [[<cmd>lua require('telescope.builtin').tags()<CR>]], { noremap = true, silent = true })
" vim.api.nvim_set_keymap('n', '<leader>sd', [[<cmd>lua require('telescope.builtin').grep_string()<CR>]], { noremap = true, silent = true })
" vim.api.nvim_set_keymap('n', '<leader>sp', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], { noremap = true, silent = true })
" vim.api.nvim_set_keymap('n', '<leader>so', [[<cmd>lua require('telescope.builtin').tags{ only_current_buffer = true }<CR>]], { noremap = true, silent = true })
" vim.api.nvim_set_keymap('n', '<leader>?', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]], { noremap = true, silent = true })

" echo glob('/Users/at/Documents/Server-Dev/effect-ts_zio/a_scala3/BZioHttp/*_patterns.scala')
" nnoremap ,,sR :call SearchRepo( "─.*" . GetInputStr('Search in repo: ') )<cr>
" nnoremap ,,<leader>sr :call SearchRepo( "\/\/.*" . GetInputStr('Search in repo: ') )<cr>
" nnoremap ,sh       <cmd>Telescope grep_string search=─<cr>
" nnoremap ,sn       <cmd>Telescope grep_string use_regex=1 search="[A-Z]{4}:"<cr>
" nnoremap ,sn       <cmd>Telescope grep_string use_regex=true<cr>
" nnoremap ,sn       <cmd>Telescope live_grep<cr>
" nnoremap ,sn :exec 'Telescope live_grep default_text=' . expand('<cword>')<cr>
" input('Cmd: ', GetLineFromCursor() )
" Telescope lsp_dynamic_workspace_symbols 
" nnoremap <leader>te <cmd>Telescope<cr>
" nnoremap ,sg <cmd>lua require('utils_general').Search_greparg()<cr>
" nnoremap ,ss <cmd>lua require('utils_general').Search_gs()<cr>



