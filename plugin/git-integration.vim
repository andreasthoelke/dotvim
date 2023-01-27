

" Accounts
let g:accountsGithub = ''
let g:accountsGithub = readfile( expand( '~/.accounts/github' ) )[0:0][0]

" Tip: Link local repo to github remote repo:
" git remote add origin https://github.com/andreasthoelke/dotfiles.git",
" git push -u origin master" `-u` add upstream tracking(!?)
" git pull --rebase origin" pull in changes from remote, put all local changes on top of it.
" 


" ─   Git                                                ■

command!          Gitpush   call ShellReturn( 'git push' )
command!          Gitstatus call ShellReturn( 'git status' )
command!          Gitstatus call ShellReturn( 'git status' )
command! -range -nargs=* GitcommitQuick call GitCommitOverload(<q-args>)

" git status:
" nnoremap <leader>oG         :FzfPreviewGitStatus<cr>
nnoremap <leader><leader>oG         :CocCommand fzf-preview.GitStatus<cr>
nnoremap <leader><leader>gS :call ShellReturn( 'git status' )<cr>
nnoremap <leader>ogs :call System_Float( 'git diff HEAD --stat' )<cr>
" nnoremap <leader>oga :call System_Float( 'git add -A -v' )<cr>
nnoremap <leader>oga :call system( 'git add -A -v' )<cr>:Git commit<cr>
" git add -A:
nnoremap <leader><leader>gA :call ShellReturn( 'git add -A -v' )<cr>
" git commit:
nnoremap <leader><leader>gC :call ShellReturn( GitCommitAllCmd( input( 'Commit message: ' ) ) )<cr>
nnoremap <leader><leader>gc :call ShellReturn( GitCommitCmd( input( 'Commit message: ' ) ) )<cr>
" Issue: this does not show the confirmation message in the float window:
xnoremap <leader><leader>gC :<c-u>call ShellReturn( GitCommitCmd( input( 'Commit message: ', GetVisSel() ) ) )<cr>
" git push:
nnoremap <leader><leader>gP :call ShellReturn( 'git push' )<cr>
" View in Github desktop:
nnoremap <leader><leader>gV :call OpenRepoInGithubDesktop( GetGitRoot() )<cr>

nnoremap <leader>ogc <cmd>Git commit<cr>
nnoremap geF :call ShellReturn( 'python ' . expand('%') )<cr>

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

func! GitCommitAllCmd( commitMessage )
  let cmd = 'git commit -a -m "' . a:commitMessage . '"'
  return cmd
endfunc

func! GitCommitCmd( commitMessage )
  let cmd = 'git commit -m "' . a:commitMessage . '"'
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
nnoremap ,og :Magit<cr>:call AttachAutosaveStopEvents()<cr>:let g:auto_save = 0<cr>
" nnoremap <leader>oG :tabe<cr>:MagitOnly<cr>:call AttachAutosaveStopEvents()<cr>:let g:auto_save = 0<cr>

nnoremap <leader><leader>og :FzfGFiles?<cr>

" GitV => now using Flog to show a git tree
" nnoremap <leader><leader>gL :FzfPreviewGitLogs<cr>
nnoremap <leader><leader>gL :CocCommand fzf-preview.GitLogs<cr>
" nnoremap <leader><leader>gL :Flogsplit<cr>
nnoremap <leader><leader>gl :FzfCommits<cr>
nnoremap <leader><leader>ogl :FzfCommits<cr>
" nnoremap <leader>oG :Flog<cr>
" nnoremap <leader>oG :Gitv!<cr>


" NOTE: function! Dirvish_git_add( path )
" ~/.config/nvim/plugin/file-manage.vim#/function.%20Dirvish_git_add.%20path

" nnoremap <leader><leader>ga :FzfPreviewGitActions<cr>
nnoremap <leader>,ga :CocCommand fzf-preview.GitActions<cr>
" nnoremap <leader><leader>gb :FzfPreviewGitBranches<cr>
nnoremap <leader><leader>gb :CocCommand fzf-preview.GitBranches<cr>

nnoremap <leader><leader>gq :GitGutterQuickFix<cr>:copen<cr>

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
nnoremap <leader><leader>gg :GitGutterSignsToggle<cr>
nnoremap <leader>gg :GitGutterSignsToggle<cr>

" Note: Gutter updates on save!

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

nnoremap ]c :GitGutterNextHunk<cr>
nnoremap [c :GitGutterPrevHunk<cr>

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





