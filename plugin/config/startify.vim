" ─   Startify Configuration                          ──

" Optional: Save custom variables in sessions
" let g:startify_session_savevars = [
"       \ 'g:TabbyTabNames',
"       \ 'TabbyTabNames',
"       \ ]

" Function to list project notes (5 most recently modified)
function! s:list_project_notes()
  " Extract project ID from current working directory
  let l:cwd = getcwd()
  let l:project_id = fnamemodify(l:cwd, ':t')

  " Build notes directory path
  let l:notes_dir = expand('~/Documents/Notes/proj/') . l:project_id

  " Check if notes directory exists
  if !isdirectory(l:notes_dir)
    return []
  endif

  " Get all markdown files in notes directory
  let l:files = globpath(l:notes_dir, '*.md', 0, 1)

  " If no files found, return empty list
  if empty(l:files)
    return []
  endif

  " Get modification times and sort by most recent
  let l:files_with_time = []
  for l:file in l:files
    let l:mtime = getftime(l:file)
    call add(l:files_with_time, {'file': l:file, 'mtime': l:mtime})
  endfor

  " Sort by modification time (newest first)
  call sort(l:files_with_time, {a, b -> b.mtime - a.mtime})

  " Limit to 5 most recent files
  let l:recent_files = l:files_with_time[0:4]

  " Build startify entries
  " Use 'path' instead of 'cmd' to enable multi-selection (v, s, t markers)
  let l:entries = []
  for l:item in l:recent_files
    let l:filename = fnamemodify(l:item.file, ':t')
    let l:entry = {
          \ 'line': l:filename,
          \ 'path': l:item.file
          \ }
    call add(l:entries, l:entry)
  endfor

  return l:entries
endfunction

" Configure startify lists
let g:startify_lists = [
      \ { 'type': function('s:list_project_notes'), 'header': ['   Project Notes'] },
      \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
      \ { 'type': 'commands',  'header': ['   Commands']       },
      \ ]

" Disable default header
let g:startify_custom_header = []

" Don't change to directory when opening file
let g:startify_change_to_dir = 0

" Session directory
let g:startify_session_dir = stdpath('data') . '/sessions'

" ─   Startify Keymaps                                ──

nnoremap <silent><leader>st :Startify<cr>
nnoremap <silent><leader>sT :tabnew<cr>:Startify<cr>
nnoremap <silent><leader><leader>st :%bdelete!<bar>Startify<cr>

" ─^  Startify Keymaps                                ▲

" ─^  Startify Configuration                          ▲
