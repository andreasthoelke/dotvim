

" Accounts
let g:accountsGithub = ''
let g:accountsGithub = readfile( expand( '~/.accounts/github' ) )[0:0][0]

" g:accountsGithub

" Tip: Link local repo to github remote repo:
" git remote add origin https://github.com/andreasthoelke/dotfiles.git",
" git push -u origin master" `-u` add upstream tracking(!?)
" git pull --rebase origin" pull in changes from remote, put all local changes on top of it.
" 

xnoremap <silent><leader><leader>bb :<c-u>call TestVisSel()<cr>
func! TestVisSel()
  let ret = GetVisSel()
  " note that ShellReturn doesn't work with visual selection, c-u seems to esc/close the float win
  echo systemlist( "echo " . ret )[0]
endfunc
" Somet()
" GetVisSel()

" ─   Git                                                ■

" Gitsigns maps: ~/.config/nvim/plugin/utils-gitsigns.lua‖*Config

command!          Gitpush   call ShellReturn( 'git push' )
command!          Gitstatus call ShellReturn( 'git status' )
command!          Gitstatus call ShellReturn( 'git status' )
command! -range -nargs=* GitcommitQuick call GitCommitOverload(<q-args>)

" git status:
" nnoremap <leader>oG         :FzfPreviewGitStatus<cr>
nnoremap <silent><leader><leader>oG         :CocCommand fzf-preview.GitStatus<cr>
nnoremap <silent><leader><leader>gS :call ShellReturn( 'git status' )<cr>
nnoremap <silent><leader>ogS :call System_Float( 'git diff HEAD --stat' )<cr>
" nnoremap <leader>oga :call System_Float( 'git add -A -v' )<cr>
" nnoremap <silent><leader>oga :call system( 'git add -A -v' )<cr>:Git commit<cr>
" git add -A:
" nnoremap <silent><leader><leader>gA :call ShellReturn( 'git add -A -v' )<cr>
" git commit:
" git undo commit
" nnoremap <silent><leader><leader>gU :call ShellReturn( "git reset --soft HEAD~1 && git log" )<cr>
" TODO do i use this map?
" nnoremap <silent><leader><leader>gc :call ShellReturn( GitCommitCmd( input( 'Commit message: ' ) ) )<cr>
nnoremap <silent><leader><leader>gc :call GitCommitViaAider()<cr>


" COMMIT ALL maps:
" nnoremap <silent><leader><leader>gC :call ShellReturn( GitCommitAllCmd( input( 'Commit message: ' ) ) )<cr>
nnoremap <silent><leader><leader>gC :call GitCommitAll()<cr>
xnoremap <silent><leader><leader>gC :<c-u>call GitCommitAll_visSel()<cr>

nnoremap <silent><leader>oga :call GitCommitAll_withDialog()<cr>


" git push:
" nnoremap <leader><leader>gP :call ShellReturn( 'git push' )<cr>
nnoremap <silent><leader><leader>gP :call System_Float( 'git push' )<cr>
" View in Github desktop:
nnoremap <silent><leader><leader>gV :call OpenRepoInGithubDesktop( GetGitRoot() )<cr>

nnoremap <silent><leader>ogc <cmd>Git commit<cr>

" ease confirming fugitive commit window
" nnoremap ,,w :w<cr><c-w>c
nnoremap <silent><expr> ,,w (&ft=='gitcommit') ? ':w<cr><c-w>c' : ':call BufferInnerBracket()<cr>'

command! Gcwd execute 'let b:git_dir = ""' | call FugitiveDetect(getcwd()) | Git
nnoremap <silent><leader>ogg :Gcwd<cr>
" nnoremap <silent><leader>ogg :G<cr>

nnoremap <silent> <leader><leader>ga :<c-u>call Dirvish_git_add( getline('.') )<cr>
nnoremap <silent> <leader><leader>gA :<c-u>call Dirvish_git_unstage( getline('.') )<cr>

nnoremap <silent> <leader>gi :<c-u>call Dirvish_git_ignore( getline('.') )<cr>
function! Dirvish_git_add( path )
  call system( "git add " . a:path )
  call ReloadKeepView()
endfunc

function! Dirvish_git_unstage( path )
  call system( "git reset -- " . a:path )
  call ReloadKeepView()
endfunc

function! Dirvish_git_ignore( path )
  let fname = fnamemodify( a:path, ":t" )
  call system( "echo " . fname . " >> .gitignore" )
  call ReloadKeepView()
endfunc


func! GetGitRoot()
  return systemlist('git root')[0]
  " echo systemlist('git root')[0]
  " This is using a git alias: git config --global alias.root 'rev-parse --show-toplevel'
endfunc


func! OpenRepoInGithubDesktop( path )
  echo systemlist('github ' . a:path)
endfunc
" call OpenRepoInGithubDesktop( GetGitRoot() )


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


func! GitCommitAll_visSel()
  if !v:lua.Util_is_subpath( getcwd(winnr()), expand('%:p') ) 
    echo "Warn: This file is not in the repo you are committing to!" 
  endif
  let msg = input( 'Commit message: ', GetVisSel() ) 
  let cmd = GitCommitAllCmd( msg )
  echo system( cmd )
endfunc

func! GitCommitAll()
  if !v:lua.Util_is_subpath( getcwd(winnr()), expand('%:p') ) 
    echo "Warn: This file is not in the repo you are committing to!" 
  endif
  let msg = input( 'Commit message: ' ) 
  let cmd = GitCommitAllCmd( msg )
  echo system( cmd )
endfunc


" ShellReturn('git -C /Users/at/.config/nvim status')

func! GitCommitAll_withDialog()
  if !v:lua.Util_is_subpath( getcwd(winnr()), expand('%:p') ) 
    echo "Warn: This file is not in the repo you are committing to!" 
  endif
  let cwd = getcwd( winnr() )
  let cmd = 'git -C ' . cwd . ' add -A -v'
  echo system( cmd )
  exec 'Git commit'
endfunc


func! GitCommitViaAider()
  " echo system( "aider --commit" )
  " echo system( "aider --weak-model haiku --35turbo --commit" )
  " echo system( "aider --weak-model 35turbo --35turbo --commit" )
  echo system( "aider --weak-model haiku --haiku --commit" )
endfunc


func! GitCommitAllCmd( commitMessage )
  let cmd = 'git commit -a -m "' . a:commitMessage . '"'
  return cmd
endfunc

func! GitCommitCmd( commitMessage )
  let cwd = getcwd( winnr() )
  let cmd = 'git -C ' . cwd . ' commit -m "' . a:commitMessage . '"'
  return cmd
endfunc

func! GitCommitFugitive()
  exec '10new' 'Git commit'
endfunc





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

let g:magit_show_magit_mapping=''
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

" Z Maps Unimpaired
" There may be muliple Magit windows. Only when the focus is on any of there Autosave should be off
" nnoremap yog :Magit<cr>:call AttachAutosaveStopEvents()<cr>:let g:auto_save = 0<cr>
" nnoremap yoG :tabe<cr>:MagitOnly<cr>:call AttachAutosaveStopEvents()<cr>:let g:auto_save = 0<cr>
" nnoremap ,og :Magit<cr>:call AttachAutosaveStopEvents()<cr>:let g:auto_save = 0<cr>
" nnoremap <leader>oG :tabe<cr>:MagitOnly<cr>:call AttachAutosaveStopEvents()<cr>:let g:auto_save = 0<cr>

nnoremap <leader><leader>og :FzfGFiles?<cr>

" GitV => now using Flog to show a git tree
" nnoremap <leader><leader>gL :FzfPreviewGitLogs<cr>
nnoremap <leader><leader>gL :CocCommand fzf-preview.GitLogs<cr>
" nnoremap <leader><leader>gL :Flogsplit<cr>
nnoremap <leader><leader>gl :FzfCommits<cr>
nnoremap <leader><leader>ogl :FzfBCommits<cr>
" nnoremap <leader>oG :Flog<cr>
" nnoremap <leader>oG :Gitv!<cr>


" NOTE: function! Dirvish_git_add( path )
" ~/.config/nvim/plugin/file-manage.vim#/function.%20Dirvish_git_add.%20path

" nnoremap <leader><leader>ga :FzfPreviewGitActions<cr>
nnoremap <leader>,ga :CocCommand fzf-preview.GitActions<cr>
" nnoremap <leader><leader>gb :FzfPreviewGitBranches<cr>
nnoremap <leader><leader>gb :CocCommand fzf-preview.GitBranches<cr>

" nnoremap <leader><leader>gq :GitGutterQuickFix<cr>:copen<cr>

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

" nnoremap <leader><leader>gg :GitGutterToggle<cr>
" nnoremap <leader>gg :GitGutterToggle<cr>
" nnoremap <leader><leader>gg :GitGutterSignsToggle<cr>
" nnoremap <leader>gg :GitGutterSignsToggle<cr>

nnoremap <silent><leader>gg :Gitsigns toggle_signs<cr>

" nnoremap ]c <Plug>(GitGutterNextHunk)
" nnoremap [c <Plug>(GitGutterPrevHunk)
" Issue Note: does not work after buffer change? temp-fix: make a change and save!
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

let g:gitgutter_signs = 0
" let g:gitgutter_realtime = 0
" let g:gitgutter_eager = 0
" let g:gitgutter_enabled = 0

" TODO test. This may be useful as a diff?
" let g:gitgutter_diff_base = '<some commit SHA>'

nnoremap <silenet>]c :GitGutterNextHunk<cr>
nnoremap <silenet>[c :GitGutterPrevHunk<cr>

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





