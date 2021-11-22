

" Accounts
let g:accountsGithub = ''
let g:accountsGithub = readfile( expand( '~/.accounts/github' ) )[0:0][0]

" Tip: Link local repo to github remote repo:
" git remote add origin https://github.com/andreasthoelke/dotfiles.git",
" git push -u origin master" `-u` add upstream tracking(!?)
" git pull --rebase origin" pull in changes from remote, put all local changes on top of it.
" another test
" 



" ─   Git                                                ■

command!          Gitpush   call ShellReturn( 'git push' )
command!          Gitstatus call ShellReturn( 'git status' )
command! -range -nargs=* GitcommitQuick call GitCommitOverload(<q-args>)
command! -nargs=* GitpublishQuick call GitPublish(<q-args>)

nnoremap <leader><leader>gs :call ShellReturn( 'git status' )<cr>
nnoremap <leader><leader>gp :call ShellReturn( 'git push' )<cr>
nnoremap <leader><leader>gP :call GitPublish( input( 'Commit message: ' ) )<cr>
vnoremap <leader><leader>gP :<c-u>call GitPublish( input( 'Commit message: ', GetVisSel() ) )<cr>
nnoremap <leader><leader>gc :call GitCommit( input( 'Commit message: ' ) )<cr>
vnoremap <leader><leader>gc :<c-u>call GitCommit( input( 'Commit message: ', GetVisSel() ) )<cr>

" Note: No quotes needed to enter multiple words
func! GitCommitOverload( ... )
  if a:0
    let message = a:1
  else
    let visText = GetVisSel()
    let message = input( 'Commit message: ', visText )
  endif
  call GitCommit( message )
endfunc

func! GitCommit( commitMessage )
  let cmd = 'git commit -a -m "' . a:commitMessage . '"'
  call ShellReturn( cmd )
endfunc

func! GitPublish( commitMessage )
  let cmd = 'git publish "' . a:commitMessage . '"'
  call ShellReturn( cmd )
endfunc
" call GitPublish( input('Commit message: ') )

" ─^  Git                                                ▲


" ─   Git Tools                                          ■

" Magit:
command! GitcommitAuthorTab   call GitMagitAuthor( 't' )
command! GitcommitAuthorSplit call GitMagitAuthor( 'v' )

func! GitMagitAuthor( win )
  if a:win == 't'
    exec 'tabe'
    exec 'MagitOnly'
  else
    exec 'Magit'
  endif
  call AttachAutosaveStopEvents()
  let g:auto_save = 0
endfunc

let g:magit_default_show_all_files = 1
let g:magit_default_fold_level = 1
" let g:magit_default_sections = ['info', 'global_help', 'commit', 'staged', 'unstaged']
let g:magit_default_sections = ['commit', 'staged', 'unstaged']

" let g:magit_git_cmd="git"
" let g:magit_git_cmd="vcsh vim"
" Fugitive does not support support just switching the command. would rather need to TODO deal with core.worktree
" let g:fugitive_git_executable="vcsh vim"

" echo FugitiveDetect('~/.config/vcsh/repo.d/vim.git/config')
" echo FugitiveDetect(expand('~/.config/vcsh/repo.d/vim.git/'))

" Z Maps Unimpaired:
" There may be muliple Magit windows. Only when the focus is on any of there Autosave should be off
" nnoremap yog :Magit<cr>:call AttachAutosaveStopEvents()<cr>:let g:auto_save = 0<cr>
" nnoremap yoG :tabe<cr>:MagitOnly<cr>:call AttachAutosaveStopEvents()<cr>:let g:auto_save = 0<cr>
nnoremap <leader>og :Magit<cr>:call AttachAutosaveStopEvents()<cr>:let g:auto_save = 0<cr>
nnoremap <leader>oG :tabe<cr>:MagitOnly<cr>:call AttachAutosaveStopEvents()<cr>:let g:auto_save = 0<cr>

" GitV => now using Flog to show a git tree
nnoremap <leader>oG :Flogsplit<cr>
" nnoremap <leader>oG :Flog<cr>
" nnoremap <leader>oG :Gitv!<cr>

let g:Gitv_CustomMappings = {
      \'update': 'r',
      \}

" Fugitive:
nnoremap <leader>Gs :Git<cr>
" autocmd BufNewFile,BufRead fugitive://* set bufhidden=delete
" Disable neovim terminal when e.g. ":Git checkout master" (experimental)
let g:fugitive_force_bang_command = 1
" Deletes hidden fugitive buffers when I hide them?
" au ag BufReadPost fugitive://* set bufhidden=delete

" ─^  Git Tools                                          ▲

" ------- Git gutter ----------------------------------

let g:gitgutter_map_keys = 0
" let g:gitgutter_git_args = '--git-dir-""'

nnoremap <leader>gg :GitGutterToggle<cr>
" Note: Gutter updates on save!

nnoremap ]c <Plug>GitGutterNextHunk
nnoremap [c <Plug>GitGutterPrevHunk
" Issue Note: does not work after buffer change? temp-fix: make a change and safe!
" alt: disable gutter, close file, open file, enable gutter → ]c should work again

" TIP: use: GitGutterUndoHunk, ..PreviewHunk
" TODO: might enable these:
" stage the hunk with <Leader>hs or
" undo it with <Leader>hu.
" TIP: this actually undos the section (hunk). this is specifically useful at
" the yellow "~", to see what was changed!
nnoremap <leader><leader>gu <Plug>GitGutterUndoHunk
" Todo: not sure how staging a hunk works..
" nnoremap <Leader>ha <Plug>GitGutterStageHunk

let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0
let g:gitgutter_enabled = 0
let g:gitgutter_diff_base = 'HEAD'

nmap <silent> ]c :GitGutterNextHunk<CR>
nmap <silent> [c :GitGutterPrevHunk<CR>
" nmap <silent> ]c :call NextHunkAllBuffers()<CR>
" nmap <silent> [c :call PrevHunkAllBuffers()<CR>
" nnoremap <expr> ]c &diff ? ']c' : ':call NextHunkAllBuffers()<CR>'
" nnoremap <expr> [c &diff ? '[c' : ':call PrevHunkAllBuffers()<CR>'

" nnoremap <expr> <C-J> &diff ? ']c' : '<C-W>j'



function! NextHunkAllBuffers()
  let line = line('.')
  GitGutterNextHunk
  if line('.') != line
    return
  endif

  let bufnr = bufnr('')
  while 1
    bnext
    if bufnr('') == bufnr
      return
    endif
    if !empty(GitGutterGetHunks())
      normal! 1G
      GitGutterNextHunk
      return
    endif
  endwhile
endfunction

function! PrevHunkAllBuffers()
  let line = line('.')
  GitGutterPrevHunk
  if line('.') != line
    return
  endif

  let bufnr = bufnr('')
  while 1
    bprevious
    if bufnr('') == bufnr
      return
    endif
    if !empty(GitGutterGetHunks())
      normal! G
      GitGutterPrevHunk
      return
    endif
  endwhile
endfunction
" ------- Git gutter ----------------------------------





