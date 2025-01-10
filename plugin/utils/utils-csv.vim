
" Range To CSV: -----------------------------------------------------------------------
" Copies paragraph into split (of filetype=csv) using csv.vim
fun! CSVBufferFromParagraph ()
  exec 'silent normal! y}'
  exec 'vnew'
  exec 'normal! P'
  set filetype=csv
endfun
" call CSVBufferFromParagraph()
" eins,zwei,drei
" 1,23,334
" 44,6,6

" Detect CSV delimiter in paragraph using a temp csv.vim buffer
fun! FindCSVDelimiterInParagraph ()
  call CSVBufferFromParagraph()
  let l:detectedDelim = b:delimiter
  exec 'bd!'
  return l:detectedDelim
endfun
" echo FindCSVDelimiter()

" Example for automating common processes:
fun! ShowAsciiTableOfVisualSelection () range
  " This process will involve temp windows/buffers, we need this var to go back:
  let l:startWindowNr = winnr()
  " Paste the visual selection into a new split buffer
  let l:visSelLines = getline( a:firstline, a:lastline)
  exec 'vnew'
  call append( 1, l:visSelLines )
  exec 'normal dd'
  " Activate csv.vim plugin
  set filetype=csv
  exec 'normal VG'
  " Produces the Asciitable in a split below and jump to it
  exec 'CSVTabularize'
  " Copy then dispose the buffer
  let g:asciiLines = getline( 1, line('$') )
  exec 'bd!'
  " Also dispose the csv.vim buffer
  " Issue: Is this save? / Can never dispose the original buffer?
  exec 'bd!'
  " This is not needed anymore as we have closed the other wins/buffers
  exec l:startWindowNr . 'wincmd w'
  " call append(line('.'), g:asciiLines)
  call append( a:lastline, g:asciiLines)
endfun
" Example Use: Visually select the 3 CSV lines, then run
" '<,'>call ShowAsciiTableOfVisualSelection()
" eins,zwei,drei
" 1,23,334
" 44,6,6
" This will then paste this Ascii table just below the CSV lines
" ┌─────┬─────┬─────┐
" │ eins│ zwei│ drei│
" ├─────┼─────┼─────┤
" │    1│   23│  334│
" │   44│    6│   6 │
" └─────┴─────┴─────┘

" Commmands Range Args Example Usage:
" Run: '<,'>OpenRangeInExcel ','
" on this csv text:
" eins,zwei,drei
" 1,23,334
" 44,6,6
command! -range -nargs=1 OpenRangeInExcel <line1>,<line2>call OpenRangeInExcel( <args> )
fun! OpenRangeInExcel ( origDelim ) range
  " get CSV text from range in current buffer
  let l:linesCSV = getline( a:firstline, a:lastline)
  " Substitute the orig delimiter to Excels preferred one
  let l:linesExcelCSV = SubstituteInLines( l:linesCSV, a:origDelim, ';' )
  "
  let l:tmpFn = tempname() . '.csv'
  " let l:tmpFn = 'apropername1.csv'
  call writefile( l:linesExcelCSV, l:tmpFn )
  exec "silent !open " . l:tmpFn . " -a 'Microsoft Excel'"
  " call delete(l:tmpsofile)
endfun
