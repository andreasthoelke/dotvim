
" does not work in nvim!
function! RangerExplorer()
  exec "!ranger --choosefile=/tmp/vim_ranger_current_file " . expand("%:p:h")
  if filereadable('/tmp/vim_ranger_current_file')
    exec 'edit ' . system('cat /tmp/vim_ranger_current_file')
    call system('rm /tmp/vim_ranger_current_file')
  endif
  redraw!
endfun

" nvim terminal works!
function! OpenRanger()
  let rangerCallback = { 'name': 'ranger' }
  function! rangerCallback.on_exit(id, code)
    try
      if filereadable('/tmp/chosenfile')
        exec 'edit ' . readfile('/tmp/chosenfile')[0]
        call system('rm /tmp/chosenfile')
      endif
    endtry
  endfunction
  enew
  call termopen('ranger --choosefile=/tmp/chosenfile', rangerCallback)
  startinsert
endfunction

command! -bar RangerChooser call RangeChooser()
function! RangeChooser()
  let temp = tempname()
  " The option "--choosefiles" was added in ranger 1.5.1. Use the next line
  " with ranger 1.4.2 through 1.5.0 instead.
  "exec 'silent !ranger --choosefile=' . shellescape(temp)
  if has("gui_running")
    exec 'silent !xterm -e ranger --choosefiles=' . shellescape(temp)
  else
    exec 'silent !ranger --choosefiles=' . shellescape(temp)
  endif
  if !filereadable(temp)
    redraw!
    " Nothing to read.
    return
  endif
  let names = readfile(temp)
  if empty(names)
    redraw!
    " Nothing to open.
    return
  endif
  " Edit the first item.
  exec 'edit ' . fnameescape(names[0])
  " Add any remaning items to the arg list/buffer list.
  for name in names[1:]
    exec 'argadd ' . fnameescape(name)
  endfor
  redraw!
endfunction

