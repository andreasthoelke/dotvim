
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

nnoremap <silent><leader>th <cmd>Telescope help_tags initial_mode=insert<cr>

" nnoremap <leader>ts <cmd>Telescope sessions<cr>
nnoremap <silent><leader>tr <cmd>Telescope repo list layout_strategy=vertical<cr>
" nnoremap <leader>tr <cmd>Telescope repo list layout_strategy=horizontal<cr>
" nnoremap <leader>tb <cmd>Telescope bookmarks selected_browser=chrome<cr>

" nnoremap <leader>tp <cmd>Telescope project initial_mode=normal<cr>
" nnoremap <silent><leader>tP <cmd>Telescope repo list layout_strategy=vertical<cr>
nnoremap <silent><leader>tp :echo 'use gsp'<cr>
nnoremap <silent><leader>tP :echo 'use gsP'<cr>
" nnoremap <silent><leader>tp :call v:lua.Telesc_launch('project')<cr>
" nnoremap <silent><leader>tP :call v:lua.Telesc_launch('repo')<cr>
nnoremap <silent>gsp :call v:lua.Telesc_launch('project')<cr>
nnoremap <silent>gsP :call v:lua.Telesc_launch('repo')<cr>

" note the other "gs.." maps: ~/.config/nvim/plugin/ftype/scala.vim‖:57:3
nnoremap <silent>gsb :call v:lua.Telesc_launch('vim_bookmarks')<cr>

" Would like to have the full width just in this case to be able to read longer URLs
" nnoremap <silent>gsc <cmd>Telescope bookmarks layout_strategy=horizontal<cr>
nnoremap <silent><leader>gsc :call v:lua.Telesc_launch('bookmarks')<cr>

" nnoremap <silent>gssi :call v:lua.Telesc_launch('scaladex')<cr>

nnoremap <leader><leader>ts <cmd>Telescope highlights<cr>
nnoremap <leader><leader>tS <cmd>TSHighlightCapturesUnderCursor<cr>

" Find files using Telescope command-line sugar.
nnoremap <leader>fR <cmd>Telescope lsp_references<cr>

" not using these. new approach: ~/.config/nvim/lua/utils/general.lua‖/functionˍM.Search_files(fo
" nnoremap <leader>fs <cmd>Telescope lsp_dynamic_workspace_symbols<cr>
" nnoremap <leader>ff <cmd>Telescope find_files hidden=true<cr>
" nnoremap <leader>fo <cmd>Telescope oldfiles<cr>
" nnoremap <leader>fF <cmd>Telescope file_browser<cr>
" nnoremap <leader>fg <cmd>Telescope live_grep<cr>

nnoremap gS <cmd>Telescope spell_suggest<cr>

nnoremap ,sa <cmd>Telescope live_grep glob_pattern=*.scala<cr>

" ─   Folder search maps 2025-03                         ■
" COLLECTION search: ,cp then l p  - to set search folder
" nnoremap ,scr <cmd>Telescope live_grep search_dirs=/Users/at/Documents/Notes<cr>
nnoremap ,scr <cmd>lua require('utils.general').Search_collection_full()<cr>
nnoremap ,sch <cmd>lua require('utils.general').Search_collection_md_headers()<cr>

" AI CHATS
nnoremap <leader>sfc <cmd>lua require('utils.general').Search_in_folder('~/.local/share/nvim/parrot/chats', '# .*')<cr>
nnoremap <leader>sfC <cmd>lua require('utils.general').Search_in_folder('~/.local/share/nvim/parrot/chats', '')<cr>
nnoremap <leader>sfa <cmd>AvanteHistory<cr>

" NOTES
nnoremap <leader>sfn <cmd>lua require('utils.general').Search_in_folder('~/Documents/Notes', '# .*')<cr>
nnoremap <leader>sfN <cmd>lua require('utils.general').Search_in_folder('~/Documents/Notes', '')<cr>

" LOCAL HEADERS
nnoremap <leader>slh <cmd>lua require('utils.general').Search_in_folder('.', '─.*')<cr>
" LOCAL COMMENTS
nnoremap <leader>slc <cmd>lua require('utils.general').Search_in_folder('.')<cr>

lua << EOF
-- Create a Vim command to call this function
vim.api.nvim_create_user_command(
  'SearchFolder',
  function(opts)
    require('utils.general').Search_in_folder(opts.args)
  end,
  {
    nargs = 1,
    complete = 'dir',
    desc = 'Search file contents in a specified folder with preview'
  }
)

vim.keymap.set('n', '<leader>sfb', ':SearchFolder ~/Documents/Proj/', { noremap = true, desc = 'Search in folder' })
-- ISSUE: as of 2025-03 this is no longer revealing the neotree folder, but a dirvish folder.
-- vim.keymap.set( 'n', '<leader>fd', Ntree_find_directory )
-- vim.keymap.set( 'n', '<leader>sff', Ntree_find_directory )
EOF


" ─^  Folder search maps 2025-03                         ▲



" ─   File search maps 2025-03                           ■
" Note the regex maps are still file type dependent: 
" ~/.config/nvim/plugin/ftype/scala.vim‖*ˍˍˍRegexˍsearchˍmaps

" SEARCH FILES
" in cwd
nnoremap <leader>gsf <cmd>lua require('utils.general').Search_files('.', '')<cr>
" The approach here seems to fuzzy match chars, regex is not supporte?
" nnoremap gsf <cmd>lua require('utils.general').Search_files('.', '.lua')<cr>

" FREQUENT RECENT FILES
nnoremap gsf <cmd>lua require('utils.general').Search_frequent_recent_files('.', 'CWD')<cr>
nnoremap gsF <cmd>lua require('utils.general').Search_frequent_recent_files('.', '')<cr>
" previously: nnoremap <silent> go  <cmd>Telescope frecency workspace=CWD<cr>

" SEARCH FOR DIRECTORY / FOLDER names
nnoremap gsd <cmd>lua require('utils.general').Search_folders('.', '')<cr>
nnoremap gsD <cmd>lua require('utils.general').Search_file_browser('.', '')<cr>

" nnoremap <silent>gsv  :call v:lua.Telesc_launch('current_buffer_fuzzy_find')<cr>
nnoremap <silent>gsc  :call v:lua.Telesc_launch('current_buffer_fuzzy_find')<cr>
nnoremap <silent>gsg  :call v:lua.Telesc_launch('live_grep')<cr>


" ─^  File search maps 2025-03                           ▲



" ─   File search open classic map                      ──

" nnoremap ,,sr       <cmd>Telescope grep_string<cr>
" nnoremap <leader>fg <cmd>Telescope live_grep layout_strategy=vertical<cr>
" nnoremap <leader>fb <cmd>Telescope buffers<cr>
" this is now used for chrome bookmarksearch, use 'go' instead
" Telescope find_files layout_strategy=vertical

" see: ~/.config/nvim/plugin/config/telescope.vim‖*ˍˍˍFileˍsearchˍmapsˍ2025-03
" nnoremap <silent> gp         <cmd>Telescope oldfiles<cr>
" nnoremap <silent> gP         <cmd>Telescope frecency<cr>
" nnoremap <silent> g,p        <cmd>Telescope frecency workspace=CWD<cr>
nnoremap <silent> g,P        <cmd>Telescope frecency workspace=LSP<cr>
nnoremap <silent> <leader>gp :call MRU_show()<cr>

" nnoremap <silent> g,p <cmd>Telescope find_files hidden=true<cr>

" nnoremap <silent> <leader>go <cmd>Neotree show left toggle<cr>

nnoremap <silent> gb <cmd>Telescope buffers<cr>
nnoremap <silent> ,gb <cmd>Telescope file_browser<cr>

" nnoremap <silent> <leader>gs :call v:lua.require("neo-tree.command").execute({ 'action': "show", 'reveal_file': expand('%:p'), 'reveal_force_cwd': v:true })<cr>

" nnoremap <silent> <leader>gs <cmd>NvimTreeFindFile<cr><c-w>p
" nnoremap <silent> <leader>go <cmd>NvimTreeToggle<cr><c-w>p
" nnoremap <silent> <leader>go <cmd>Neotree show right toggle .<cr>


" nnoremap <silent> ,gs <cmd>NvimTreeFindFile<cr>
" nnoremap <silent> ,go <cmd>NvimTreeToggle<cr>

" nnoremap <silent> <leader>gp :<C-u>FzfHistory<CR>
" nnoremap <silent> <leader>go :<C-u>FzfBuffer<cr>

" nnoremap <silent> gp :<C-u>FzfPreviewFromResources project_mru<CR>
" nnoremap <silent> gp :<C-u>FzfPreviewProjectMrwFiles<CR>
" nnoremap <silent> gP :<C-u>FzfPreviewProjectMruFiles<CR>
" This allows to multiselect & c-q and open in *new tab* vs the above uses the current window.
" nnoremap <silent> gp :<C-u>FzfHistory<CR>
" This command uses a separate history file which should accumulate 2000 entries over time:
" nnoremap <silent> ,gp :<C-u>FzfPathsFromFile ~/.config/nvim/.vim_mru_files<CR>
" nnoremap <silent> ,,gp :<C-u>FzfPreviewOldFiles<CR>
" nnoremap <silent> ,gp :<C-u>FZFMru<CR>
" nnoremap <silent> <leader>gp :topleft MRU<CR>
" nnoremap <silent> go :<C-u>FzfBuffer<cr>
" nnoremap <silent> ,go <cmd>lua require('utils_general').fileView()<cr>
" nnoremap <silent> <leader>nf <cmd>NvimTreeFindFile<cr>
" nnoremap <silent> <leader>no <cmd>NvimTreeToggle<cr>
" nnoremap <silent> ,tt <cmd>lua require('utils_general').fileView()<cr>


" A command that calls Telesc_launch('bookmarks', { default_text = <the arg to the command> }) 
" command! -nargs=1 BMs lua Telesc_launch('bookmarks', { default_text = <args> })

command! -nargs=* BMs lua Telesc_launch('bookmarks', { default_text = <q-args> })

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



