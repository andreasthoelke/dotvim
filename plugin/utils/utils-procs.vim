" utils-procs.vim - view and kill dev server processes via fzf
" :Procs  - show all matching processes, multi-select to kill

function! s:procs_kill(lines)
  for line in a:lines
    let pid = matchstr(line, '^\s*\zs\d\+')
    if !empty(pid)
      call system('kill ' . pid . ' 2>/dev/null')
      echo 'killed ' . pid
    endif
  endfor
endfunction

function! ProcsOpen()
  let patterns = 'vite|chrome-debug'
  let source = 'ps -eo pid,user,pcpu,pmem,command | head -1; ' .
        \ 'ps -eo pid,user,pcpu,pmem,command | grep -E "' . patterns . '" | grep -v grep | sort -k5'
  call fzf#run(fzf#wrap({
        \ 'source': source,
        \ 'sink*': function('s:procs_kill'),
        \ 'options': [
        \   '--multi',
        \   '--header-lines=1',
        \   '--prompt=kill> ',
        \   '--preview=echo {}',
        \   '--preview-window=up:3:wrap',
        \   '--bind=ctrl-a:select-all',
        \ ],
        \ }))
endfunction

command! Procs call ProcsOpen()
